"""
Load an extracted game JSON (from extract_game.py) into the Postgres schema
defined in schema.sql. Handles variable roster sizes and DNP players.
"""
import json


def minutes_to_interval(min_str):
    """'13:56' -> '13 minutes 56 seconds', None stays None (DNP)."""
    if min_str is None:
        return None
    m, s = min_str.split(":")
    return f"'{int(m)} minutes {int(s)} seconds'"


def sql_val(v):
    if v is None:
        return "NULL"
    if isinstance(v, bool):
        return "TRUE" if v else "FALSE"
    if isinstance(v, str):
        return "'" + v.replace("'", "''") + "'"
    return str(v)


def build_inserts(data: dict, season: str, source_image_path: str) -> list[str]:
    stmts = []
    team_ids = {}  # team_name -> placeholder var name for this script's purposes

    for team in data["teams"]:
        stmts.append(
            f"INSERT INTO teams (team_name, team_code) VALUES "
            f"({sql_val(team['team_name'])}, {sql_val(team['team_code'])}) "
            f"ON CONFLICT (team_name) DO NOTHING;"
        )
        team_ids[team["team_name"]] = team["team_name"]  # resolved by name at insert time via subquery

    meta = data["game_meta"]
    home_team = next(t for t in data["teams"] if t["is_home"])
    away_team = next(t for t in data["teams"] if not t["is_home"])

    stmts.append(f"""
INSERT INTO games (game_no, game_date, season, competition, venue,
                    home_team_id, away_team_id, home_score, away_score,
                    home_q_scores, away_q_scores, source_image_path)
VALUES (
    {sql_val(meta['game_no'])}, {sql_val(meta['date'])}, {sql_val(season)},
    {sql_val(meta['competition'])}, {sql_val(meta['venue'])},
    (SELECT team_id FROM teams WHERE team_name = {sql_val(home_team['team_name'])}),
    (SELECT team_id FROM teams WHERE team_name = {sql_val(away_team['team_name'])}),
    {meta['final_score']['home']}, {meta['final_score']['away']},
    ARRAY{meta['quarter_scores']['home']}, ARRAY{meta['quarter_scores']['away']},
    {sql_val(source_image_path)}
) RETURNING game_id;""".strip())

    for team in data["teams"]:
        for p in team["players"]:
            stmts.append(
                f"INSERT INTO players (team_id, name) VALUES "
                f"((SELECT team_id FROM teams WHERE team_name = {sql_val(team['team_name'])}), "
                f"{sql_val(p['name'])}) ON CONFLICT (team_id, name) DO NOTHING;"
            )

        for p in team["players"]:
            min_interval = minutes_to_interval(p["min"])
            stmts.append(f"""
INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = {sql_val(team['team_name'])}) AND name = {sql_val(p['name'])}),
    {sql_val(p['no'])}, {sql_val(p['started'])}, {sql_val(p['dnp'])}, {min_interval or 'NULL'},
    {sql_val(p['fg_m'])}, {sql_val(p['fg_a'])}, {sql_val(p['fg_pct'])},
    {sql_val(p['fg2_m'])}, {sql_val(p['fg2_a'])}, {sql_val(p['fg2_pct'])},
    {sql_val(p['fg3_m'])}, {sql_val(p['fg3_a'])}, {sql_val(p['fg3_pct'])},
    {sql_val(p['ft_m'])}, {sql_val(p['ft_a'])}, {sql_val(p['ft_pct'])},
    {sql_val(p['reb_o'])}, {sql_val(p['reb_d'])}, {sql_val(p['reb_tot'])},
    {sql_val(p['ast'])}, {sql_val(p['to'])}, {sql_val(p['stl'])}, {sql_val(p['blk'])},
    {sql_val(p['pf_committed'])}, {sql_val(p['pf_drawn'])}, {sql_val(p['plus_minus'])}, {sql_val(p['pts'])}
);""".strip())

        t = team["team_totals"]
        x = team["extra"]
        stmts.append(f"""
INSERT INTO team_game_totals (
    game_id, team_id, fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, pts, points_from_turnovers, points_in_paint, biggest_lead, biggest_run
) VALUES (
    :game_id, (SELECT team_id FROM teams WHERE team_name = {sql_val(team['team_name'])}),
    {t['fg_m']}, {t['fg_a']}, {t['fg_pct']}, {t['fg2_m']}, {t['fg2_a']}, {t['fg2_pct']},
    {t['fg3_m']}, {t['fg3_a']}, {t['fg3_pct']}, {t['ft_m']}, {t['ft_a']}, {t['ft_pct']},
    {t['reb_o']}, {t['reb_d']}, {t['reb_tot']}, {t['ast']}, {t['to']}, {t['stl']}, {t['blk']},
    {t['pf_committed']}, {t['pf_drawn']}, {t['pts']},
    {x['points_from_turnovers']}, {x['points_in_paint']}, {x['biggest_lead']}, {sql_val(x['biggest_run'])}
);""".strip())

    return stmts


if __name__ == "__main__":
    with open("manual_validation.json") as f:
        data = json.load(f)
    stmts = build_inserts(data, season="2025-2026", source_image_path="uploads/2026041503.png")
    print(f"-- Generated {len(stmts)} statements\n")
    for s in stmts:
        print(s)
        print()
