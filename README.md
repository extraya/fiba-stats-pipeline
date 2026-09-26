# FIBA Stat Sheet → Automated Basketball Analytics

Turns an official FIBA game stat sheet image into a structured database, an
auto-generated game report, and season-level player/team analytics — no
manual data entry.

**Why this exists:** I was the analyst for the СЭЗИС (UFE) basketball team
during the 2023–2024 season, manually converting FIBA official stat sheets
into CSV/SQL for game and season reports. That manual process didn't scale
and the files were eventually lost. This project rebuilds it as an automated
pipeline: upload a stat sheet image, get a structured game report and season
stats back, with nothing typed by hand.

## What it does

1. **Extract** — a stat sheet image is parsed via Claude's vision API into
   structured JSON (players, shooting splits, rebounds, assists, etc.),
   correctly handling rosters that vary game to game (DNP players, different
   bench sizes) rather than assuming a fixed row count.
2. **Validate** — before anything is written to the database, each team's
   player point totals are summed and checked against the sheet's official
   team total. A mismatch (a misread digit, a skipped row) is rejected with
   the specific discrepancy, rather than silently storing bad data.
3. **Store** — validated data is written to PostgreSQL in a schema built for
   season-level querying: `games`, `teams`, `players`, `player_game_stats`,
   `team_game_totals`.
4. **Report** — a per-game report renders straight from the stored data:
   full box score, quarter-by-quarter scoring, and calculated advanced stats
   (effective FG%, true shooting%, assist-to-turnover ratio) that aren't on
   the original sheet.
5. **Aggregate** — a season view rolls games up into player leaderboards and
   game-by-game trend charts, with DNP games correctly excluded from
   averages rather than counted as a zero.

## Sample output — MCBA Final, МУИС ШОНХОРУУД vs СЭЗИС (71–77)

The game report surfaces a finding the raw sheet doesn't: **СЭЗИС won
despite a lower effective FG% (44.9% vs 48.5%)**. True shooting% — which
credits free-throw efficiency — tells the real story: СЭЗИС shot 37 free
throws to МУИС's 19 and finished with the higher true shooting% (51.1% vs
48.4%), backed by cleaner ball control (1.00 assist-to-turnover ratio vs
0.59).

That's the kind of "so what," not just "what," a stat sheet alone doesn't
give you.

## Stack

| Layer | Tool |
|---|---|
| Extraction | Claude Vision API (Anthropic) |
| Backend | FastAPI, Python |
| Database | PostgreSQL |
| Reports | HTML/CSS/JS (no framework — kept dependency-free for a fast, portable report) |
| Deploy | Render (API) + static hosting (reports) |

## Project structure

```
backend/
  extract_game.py     # image -> structured JSON via Claude Vision
  load_game.py         # JSON -> SQL insert generation (reference; main.py does this via asyncpg directly)
  main.py               # FastAPI app: /games/upload, /games/{id}, /seasons/{season}/players
  schema.sql             # Postgres schema + example season-aggregate queries
  requirements.txt
docs/
  upload.html          # drag-and-drop upload UI, calls the backend directly
  game_report.html      # single-game report (box score, quarter scoring, advanced stats)
  season_view.html      # season leaderboard + trend charts
samples/
  sample_extracted_game.json     # real extracted output from the MCBA Final game
  sample_generated_inserts.sql   # what load_game.py produces from that sample
```

## Running it locally

```bash
cd backend
pip install -r requirements.txt
export ANTHROPIC_API_KEY=your_key_here
export DATABASE_URL=postgresql://user:pass@host/dbname
psql $DATABASE_URL -f schema.sql
uvicorn main:app --reload
```

Then open `docs/upload.html` in a browser (backend defaults to
`http://localhost:8000` — override with `window.API_BASE_URL` if different).

## Data integrity note

The season view currently includes one real, extracted game (МУИС vs СЭЗИС,
15 Apr 2026) alongside four synthetic sample games, generated with random
variance around real player performances purely to demonstrate the season
view with a fuller game log. This is flagged directly in the page itself —
real games replace the synthetic ones automatically as they're uploaded
through the pipeline.

## What I'd build next

- Upload UI (drag-and-drop image → live report)
- Multi-season comparison view
- Player detail pages (career-to-date across seasons)