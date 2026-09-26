-- UFE Basketball Stats — schema
-- Design notes:
--   * player_game_stats holds one row per player per game, with NULL stat
--     columns for DNP players (never 0 — a DNP is not "played and scored 0").
--   * players are deduplicated by (name, team) so the same person across
--     multiple games/seasons is one row, enabling season averages.
--   * jersey numbers are NOT a stable player identifier across seasons
--     (players change numbers), so player identity keys off name, not no.
--   * season is derived from game date at query time (or stored explicitly
--     if you want to handle non-calendar seasons like "2025-2026").

CREATE TABLE teams (
    team_id     SERIAL PRIMARY KEY,
    team_name   TEXT NOT NULL UNIQUE,      -- "СЭЗИС", "МУИС ШОНХОРУУД"
    team_code   TEXT                        -- "UFE", "NUM" (short code from sheet)
);

CREATE TABLE players (
    player_id   SERIAL PRIMARY KEY,
    team_id     INT NOT NULL REFERENCES teams(team_id),
    name        TEXT NOT NULL,              -- Cyrillic full name as printed
    UNIQUE (team_id, name)
);

CREATE TABLE games (
    game_id         SERIAL PRIMARY KEY,
    game_no         TEXT UNIQUE,            -- FIBA sheet's "Game no." field
    game_date       DATE NOT NULL,
    season          TEXT NOT NULL,          -- e.g. '2025-2026' — set at load time
    competition     TEXT,                   -- "MCBA FINAL" etc.
    venue           TEXT,
    home_team_id    INT NOT NULL REFERENCES teams(team_id),
    away_team_id    INT NOT NULL REFERENCES teams(team_id),
    home_score      INT NOT NULL,
    away_score      INT NOT NULL,
    home_q_scores   INT[],                  -- [12,19,23,17] running or per-quarter, pick one convention and stay consistent
    away_q_scores   INT[],
    source_image_path TEXT,                 -- keep a pointer to the original upload for audit/re-parse
    UNIQUE (home_team_id, away_team_id, game_date)
);

CREATE TABLE player_game_stats (
    stat_id         SERIAL PRIMARY KEY,
    game_id         INT NOT NULL REFERENCES games(game_id) ON DELETE CASCADE,
    player_id       INT NOT NULL REFERENCES players(player_id),
    jersey_no       INT,                    -- as worn THAT game (not a stable identity key)
    started         BOOLEAN NOT NULL DEFAULT FALSE,
    dnp             BOOLEAN NOT NULL DEFAULT FALSE,
    minutes_played  INTERVAL,               -- store "13:56" as an interval, NULL if DNP

    fg_m INT, fg_a INT, fg_pct NUMERIC(5,1),
    fg2_m INT, fg2_a INT, fg2_pct NUMERIC(5,1),
    fg3_m INT, fg3_a INT, fg3_pct NUMERIC(5,1),
    ft_m INT, ft_a INT, ft_pct NUMERIC(5,1),

    reb_o INT, reb_d INT, reb_tot INT,
    ast INT, "to" INT, stl INT, blk INT,
    pf_committed INT, pf_drawn INT,
    plus_minus INT,
    pts INT,

    UNIQUE (game_id, player_id)
);

CREATE TABLE team_game_totals (
    game_id  INT NOT NULL REFERENCES games(game_id) ON DELETE CASCADE,
    team_id  INT NOT NULL REFERENCES teams(team_id),
    fg_m INT, fg_a INT, fg_pct NUMERIC(5,1),
    fg2_m INT, fg2_a INT, fg2_pct NUMERIC(5,1),
    fg3_m INT, fg3_a INT, fg3_pct NUMERIC(5,1),
    ft_m INT, ft_a INT, ft_pct NUMERIC(5,1),
    reb_o INT, reb_d INT, reb_tot INT,
    ast INT, "to" INT, stl INT, blk INT,
    pf_committed INT, pf_drawn INT,
    pts INT,
    points_from_turnovers INT,
    points_in_paint INT,
    biggest_lead INT,
    biggest_run TEXT,
    PRIMARY KEY (game_id, team_id)
);

-- ============================================================
-- Example season-aggregation queries this schema makes trivial
-- ============================================================

-- Player season averages (excludes DNP games automatically since
-- those rows simply won't exist / or will have NULL pts, so AVG skips them)
-- SELECT p.name,
--        COUNT(*) FILTER (WHERE NOT s.dnp) AS games_played,
--        ROUND(AVG(s.pts) FILTER (WHERE NOT s.dnp), 1) AS ppg,
--        ROUND(AVG(s.reb_tot) FILTER (WHERE NOT s.dnp), 1) AS rpg,
--        ROUND(AVG(s.ast) FILTER (WHERE NOT s.dnp), 1) AS apg
-- FROM player_game_stats s
-- JOIN players p ON p.player_id = s.player_id
-- JOIN games g ON g.game_id = s.game_id
-- WHERE g.season = '2025-2026'
-- GROUP BY p.name
-- ORDER BY ppg DESC;

-- Team shooting trend across the season
-- SELECT g.game_date, t.fg3_pct
-- FROM team_game_totals t
-- JOIN games g ON g.game_id = t.game_id
-- JOIN teams tm ON tm.team_id = t.team_id
-- WHERE tm.team_name = 'СЭЗИС'
-- ORDER BY g.game_date;
