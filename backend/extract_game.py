"""
FIBA official stat sheet image -> structured JSON extractor.

Handles variable roster sizes (some players DNP, benches differ in length)
by never assuming a fixed row count -- the schema is a list of players per
team, and the model is instructed to include EVERY row it sees, DNP or not.

Usage:
    python extract_game.py path/to/stat_sheet.png > game.json
"""
import base64
import json
import sys
import urllib.request

EXTRACTION_PROMPT = """You are parsing an official FIBA basketball game statistics
sheet (Mongolian language, FIBA Europe Stats Suite template). Extract ALL data into
the exact JSON schema below. Important rules:

- Include EVERY player row for both teams, even "DNP" (did not play) rows -- set
  numeric fields to null for DNP players, not zero.
- Roster length varies game to game -- do not assume a fixed number of players.
- "started" is true if the player's name has a "*" prefix in the No. column.
- Preserve Mongolian Cyrillic names exactly as written.
- Quarter scores in "Scoring by 5 minute intervals" are CUMULATIVE running totals
  as printed (do not convert to per-quarter deltas) -- store them exactly as shown.
- If a field is blank/not applicable (e.g. Team/Coach row has no Min or shooting
  stats), use null.
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


def extract(image_path: str) -> dict:
    with open(image_path, "rb") as f:
        img_b64 = base64.b64encode(f.read()).decode("utf-8")

    media_type = "image/png" if image_path.lower().endswith("png") else "image/jpeg"

    body = json.dumps({
        "model": "claude-sonnet-5",
        "max_tokens": 4000,
        "messages": [{
            "role": "user",
            "content": [
                {"type": "image", "source": {"type": "base64", "media_type": media_type, "data": img_b64}},
                {"type": "text", "text": EXTRACTION_PROMPT},
            ],
        }],
    }).encode("utf-8")

    req = urllib.request.Request(
        "https://api.anthropic.com/v1/messages",
        data=body,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(req) as resp:
        data = json.loads(resp.read())

    text = "".join(block["text"] for block in data["content"] if block["type"] == "text")
    text = text.strip().removeprefix("```json").removeprefix("```").removesuffix("```").strip()
    return json.loads(text)


if __name__ == "__main__":
    result = extract(sys.argv[1])
    print(json.dumps(result, ensure_ascii=False, indent=2))
