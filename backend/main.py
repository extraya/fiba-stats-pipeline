"""
FastAPI backend for the UFE basketball stats app.

Flow: POST /games/upload (image) -> extract via Claude Vision -> validate
(player pts sum == team total) -> write to Postgres -> return game_id +
report data.

Run: uvicorn main:app --reload
Requires env var ANTHROPIC_API_KEY, and DATABASE_URL (Postgres connection string).
"""
import base64
import json
import os
import uuid
from datetime import date
from pathlib import Path

import anthropic
import asyncpg
from fastapi import FastAPI, File, HTTPException, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI(title="UFE Basketball Stats API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # tighten to your frontend's origin before going live
    allow_methods=["*"],
    allow_headers=["*"],
)

UPLOAD_DIR = Path("uploads")
UPLOAD_DIR.mkdir(exist_ok=True)

anthropic_client = anthropic.Anthropic(api_key=os.environ["ANTHROPIC_API_KEY"])

EXTRACTION_PROMPT = """You are parsing an official FIBA basketball game statistics
sheet (Mongolian language, FIBA Europe Stats Suite template). Extract ALL data into
the exact JSON schema below. Important rules:

- Include EVERY player row for both teams, even "DNP" (did not play) rows -- set
  numeric fields to null for DNP players, not zero.
- Roster length varies game to game -- do not assume a fixed number of players.
- "started" is true if the player's name has a "*" prefix in the No. column.
- Preserve Mongolian Cyrillic names exactly as written.
- If a field is blank/not applicable, use null.
- Return ONLY valid JSON, no markdown fences, no commentary.

Schema:
{
  "game_meta": {
    "game_no": string, "date": "YYYY-MM-DD", "time_local": string,
    "venue": string, "competition": string,
    "final_score": {"home": int, "away": int},
    "quarter_scores": {"home": [int,int,int,int], "away": [int,int,int,int]}
  },
  "teams": [
    {
      "team_name": string, "team_code": string, "is_home": bool,
      "players": [
        {
          "no": int, "name": string, "started": bool, "min": string|null, "dnp": bool,
          "fg_m": int|null, "fg_a": int|null, "fg_pct": number|null,
          "fg2_m": int|null, "fg2_a": int|null, "fg2_pct": number|null,
          "fg3_m": int|null, "fg3_a": int|null, "fg3_pct": number|null,
          "ft_m": int|null, "ft_a": int|null, "ft_pct": number|null,
          "reb_o": int|null, "reb_d": int|null, "reb_tot": int|null,
          "ast": int|null, "to": int|null, "stl": int|null, "blk": int|null,
          "pf_committed": int|null, "pf_drawn": int|null,
          "plus_minus": int|null, "pts": int|null
        }
      ],
      "team_totals": { "fg_m": int, "fg_a": int, "fg_pct": number, "fg2_m": int,
        "fg2_a": int, "fg2_pct": number, "fg3_m": int, "fg3_a": int, "fg3_pct": number,
        "ft_m": int, "ft_a": int, "ft_pct": number, "reb_o": int, "reb_d": int,
        "reb_tot": int, "ast": int, "to": int, "stl": int, "blk": int,
        "pf_committed": int, "pf_drawn": int, "pts": int },
      "extra": {"points_from_turnovers": int, "points_in_paint": int,
        "biggest_lead": int, "biggest_run": string}
    }
  ]
}"""


class GameUploadResponse(BaseModel):
    game_id: int
    validated: bool
    validation_detail: str
    data: dict


def extract_stats(image_bytes: bytes, media_type: str) -> dict:
    img_b64 = base64.b64encode(image_bytes).decode("utf-8")
    resp = anthropic_client.messages.create(
        model="claude-sonnet-5",
        max_tokens=4000,
        messages=[{
            "role": "user",
            "content": [
                {"type": "image", "source": {"type": "base64", "media_type": media_type, "data": img_b64}},
                {"type": "text", "text": EXTRACTION_PROMPT},
            ],
        }],
    )
    text = "".join(b.text for b in resp.content if b.type == "text").strip()
    text = text.removeprefix("```json").removeprefix("```").removesuffix("```").strip()
    return json.loads(text)


def validate_extraction(data: dict) -> tuple[bool, str]:
    """Sanity check: sum of player points per team must equal the team total.
    Catches most extraction errors (missed row, misread digit) before they
    ever reach the database."""
    problems = []
    for team in data["teams"]:
        player_sum = sum(p["pts"] for p in team["players"] if p["pts"] is not None)
        team_total = team["team_totals"]["pts"]
        if player_sum != team_total:
            problems.append(
                f"{team['team_name']}: player points sum to {player_sum}, "
                f"but team total is {team_total}"
            )
    if problems:
        return False, "; ".join(problems)
    return True, "player point totals match team totals for both sides"


async def get_db() -> asyncpg.Connection:
    return await asyncpg.connect(os.environ["DATABASE_URL"])


@app.post("/games/upload", response_model=GameUploadResponse)
async def upload_game(file: UploadFile = File(...)):
    if file.content_type not in ("image/png", "image/jpeg"):
        raise HTTPException(400, "Upload a PNG or JPEG stat sheet image")

    image_bytes = await file.read()
    saved_name = f"{uuid.uuid4()}_{file.filename}"
    (UPLOAD_DIR / saved_name).write_bytes(image_bytes)

    try:
        data = extract_stats(image_bytes, file.content_type)
    except (json.JSONDecodeError, KeyError) as e:
        raise HTTPException(422, f"Could not parse stat sheet: {e}")

    is_valid, detail = validate_extraction(data)
    if not is_valid:
        # Still return the extraction so a human can review/correct it in the
        # UI, but flag it clearly rather than silently writing bad data.
        raise HTTPException(422, f"Extraction failed validation: {detail}")

    conn = await get_db()
    try:
        game_id = await write_game(conn, data, season=infer_season(data["game_meta"]["date"]),
                                    source_image_path=str(UPLOAD_DIR / saved_name))
    finally:
        await conn.close()

    return GameUploadResponse(game_id=game_id, validated=is_valid, validation_detail=detail, data=data)


def infer_season(game_date_str: str) -> str:
    """Mongolian collegiate season runs roughly Sep-May, so a game in
    Jan-Jun belongs to the season that started the previous autumn."""
    d = date.fromisoformat(game_date_str)
    return f"{d.year-1}-{d.year}" if d.month <= 6 else f"{d.year}-{d.year+1}"


async def write_game(conn: asyncpg.Connection, data: dict, season: str, source_image_path: str) -> int:
    async with conn.transaction():
        for team in data["teams"]:
            await conn.execute(
                "INSERT INTO teams (team_name, team_code) VALUES ($1, $2) "
                "ON CONFLICT (team_name) DO NOTHING",
                team["team_name"], team["team_code"],
            )

        meta = data["game_meta"]
        home = next(t for t in data["teams"] if t["is_home"])
        away = next(t for t in data["teams"] if not t["is_home"])

        game_id = await conn.fetchval(
            """
            INSERT INTO games (game_no, game_date, season, competition, venue,
                                home_team_id, away_team_id, home_score, away_score,
                                home_q_scores, away_q_scores, source_image_path)
            VALUES ($1, $2, $3, $4, $5,
                    (SELECT team_id FROM teams WHERE team_name = $6),
                    (SELECT team_id FROM teams WHERE team_name = $7),
                    $8, $9, $10, $11, $12)
            RETURNING game_id
            """,
            meta["game_no"], date.fromisoformat(meta["date"]), season,
            meta["competition"], meta["venue"],
            home["team_name"], away["team_name"],
            meta["final_score"]["home"], meta["final_score"]["away"],
            meta["quarter_scores"]["home"], meta["quarter_scores"]["away"],
            source_image_path,
        )

        for team in data["teams"]:
            for p in team["players"]:
                await conn.execute(
                    "INSERT INTO players (team_id, name) VALUES "
                    "((SELECT team_id FROM teams WHERE team_name = $1), $2) "
                    "ON CONFLICT (team_id, name) DO NOTHING",
                    team["team_name"], p["name"],
                )

            for p in team["players"]:
                player_id = await conn.fetchval(
                    "SELECT player_id FROM players WHERE team_id = "
                    "(SELECT team_id FROM teams WHERE team_name = $1) AND name = $2",
                    team["team_name"], p["name"],
                )
                minutes_interval = None
                if p["min"]:
                    m, s = p["min"].split(":")
                    minutes_interval = f"{int(m)} minutes {int(s)} seconds"

                await conn.execute(
                    """
                    INSERT INTO player_game_stats (
                        game_id, player_id, jersey_no, started, dnp, minutes_played,
                        fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
                        ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
                        pf_committed, pf_drawn, plus_minus, pts
                    ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,
                              $16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29)
                    """,
                    game_id, player_id, p["no"], p["started"], p["dnp"], minutes_interval,
                    p["fg_m"], p["fg_a"], p["fg_pct"], p["fg2_m"], p["fg2_a"], p["fg2_pct"],
                    p["fg3_m"], p["fg3_a"], p["fg3_pct"], p["ft_m"], p["ft_a"], p["ft_pct"],
                    p["reb_o"], p["reb_d"], p["reb_tot"], p["ast"], p["to"], p["stl"], p["blk"],
                    p["pf_committed"], p["pf_drawn"], p["plus_minus"], p["pts"],
                )

            t = team["team_totals"]
            x = team["extra"]
            await conn.execute(
                """
                INSERT INTO team_game_totals (
                    game_id, team_id, fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
                    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
                    pf_committed, pf_drawn, pts, points_from_turnovers, points_in_paint, biggest_lead, biggest_run
                ) VALUES ($1,(SELECT team_id FROM teams WHERE team_name=$2),$3,$4,$5,$6,$7,$8,$9,$10,$11,
                          $12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28)
                """,
                game_id, team["team_name"],
                t["fg_m"], t["fg_a"], t["fg_pct"], t["fg2_m"], t["fg2_a"], t["fg2_pct"],
                t["fg3_m"], t["fg3_a"], t["fg3_pct"], t["ft_m"], t["ft_a"], t["ft_pct"],
                t["reb_o"], t["reb_d"], t["reb_tot"], t["ast"], t["to"], t["stl"], t["blk"],
                t["pf_committed"], t["pf_drawn"], t["pts"],
                x["points_from_turnovers"], x["points_in_paint"], x["biggest_lead"], x["biggest_run"],
            )

    return game_id


@app.get("/games/{game_id}")
async def get_game(game_id: int):
    """Fetch a stored game back out in the same JSON shape the extractor
    produces, so the frontend report page can render it identically whether
    the data came fresh off an upload or from the database."""
    conn = await get_db()
    try:
        game = await conn.fetchrow(
            """
            SELECT g.*, ht.team_name AS home_name, ht.team_code AS home_code,
                   at.team_name AS away_name, at.team_code AS away_code
            FROM games g
            JOIN teams ht ON ht.team_id = g.home_team_id
            JOIN teams at ON at.team_id = g.away_team_id
            WHERE g.game_id = $1
            """,
            game_id,
        )
        if not game:
            raise HTTPException(404, "Game not found")

        players = await conn.fetch(
            """
            SELECT s.*, p.name, p.team_id
            FROM player_game_stats s
            JOIN players p ON p.player_id = s.player_id
            WHERE s.game_id = $1
            """,
            game_id,
        )
        totals = await conn.fetch(
            "SELECT * FROM team_game_totals WHERE game_id = $1", game_id
        )
        return {"game": dict(game), "players": [dict(r) for r in players], "totals": [dict(r) for r in totals]}
    finally:
        await conn.close()


@app.get("/seasons/{season}/players")
async def season_player_averages(season: str):
    """Per-player season averages -- excludes DNP rows automatically since
    those columns are NULL and AVG() skips NULLs."""
    conn = await get_db()
    try:
        rows = await conn.fetch(
            """
            SELECT p.name, t.team_name,
                   COUNT(*) FILTER (WHERE NOT s.dnp) AS games_played,
                   ROUND(AVG(s.pts) FILTER (WHERE NOT s.dnp), 1) AS ppg,
                   ROUND(AVG(s.reb_tot) FILTER (WHERE NOT s.dnp), 1) AS rpg,
                   ROUND(AVG(s.ast) FILTER (WHERE NOT s.dnp), 1) AS apg
            FROM player_game_stats s
            JOIN players p ON p.player_id = s.player_id
            JOIN teams t ON t.team_id = p.team_id
            JOIN games g ON g.game_id = s.game_id
            WHERE g.season = $1
            GROUP BY p.name, t.team_name
            HAVING COUNT(*) FILTER (WHERE NOT s.dnp) > 0
            ORDER BY ppg DESC NULLS LAST
            """,
            season,
        )
        return [dict(r) for r in rows]
    finally:
        await conn.close()
