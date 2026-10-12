# Spotify SQL Analysis Project

## What this is
A hands-on SQL learning project analyzing my own Spotify Extended Streaming History with DuckDB, building toward a portfolio piece for SaaS CS / RevOps / data analyst job applications. Based on learnsql.com's "Spotify Wrapped with SQL" tutorial as a starting point, but going well past it — that tutorial alone is too generic to differentiate on a resume.

## Session startup (run in this order)
1. Normal terminal: `code ~/projects/spotify-sql-analysis`
2. VS Code terminal (shell prompt): `pwd`. It must end in `spotify-sql-analysis`. If not: `cd ~/projects/spotify-sql-analysis`
3. Same terminal: `duckdb spotify.duckdb`
4. At the `D` prompt, verify the data loaded: `SELECT COUNT(*) FROM audio_history;` Expected: 258107.

**Rules**
- Prompt starts with `D` (e.g. `spotify D`) = DuckDB: SQL and dot-commands only. Anything ending in `%` = shell (`cd`, `ls`, `git`, `pwd`).
- Leave DuckDB with `.quit` (no semicolon).
- SQL statements end with `;`. If the prompt looks frozen, type `;` and press enter (shell commands typed at the `D` prompt get swallowed as unfinished SQL).
- If step 4 says the table doesn't exist, you're on a blank database: DuckDB silently creates a new empty file when it can't find one. Check `pwd`, then `ls` for `spotify.duckdb`.
- The row count is the real check. The prompt name alone does not prove you're on the loaded data.
- Claude gives these startup commands at the start of every new session. Shell commands only; the write-every-query-myself rule still applies to SQL.

## My SQL level
Comfortable with SELECT, WHERE, JOIN. Still building fluency with GROUP BY/aggregates and window functions (LAG, LEAD, RANK, running totals) — treat these as active learning areas, not assumed knowledge.

## How I want you to work with me
- I want to write every query myself. Don't hand me working SQL unless I've genuinely attempted it, hit a real error, and am still stuck after trying to reason through it.
- When I make a mistake, explain the underlying SQL concept behind the error, not just the fix.
- Ask me to guess/reason through what a query or field does before confirming or correcting.
- Be direct and critical about mistakes and about whether something is actually portfolio-worthy — don't just validate what I do.

## Data
- Source: Spotify Extended Streaming History export (not the basic one) — full listening history 2014-2026
- Location: `data/Spotify Extended Streaming History/Streaming_History_Audio_*.json` (also `Streaming_History_Video_*.json`, not yet explored)
- 258,107 audio play rows total; persisted as the `audio_history` table in `spotify.duckdb` (verified 2026-10-12)
- Known data quirks:
  - 851 rows with null `master_metadata_track_name`; only 835 explained by podcast (794) + audiobook (41) — 16 unaccounted for, not yet investigated
  - `reason_start` has an empty-string value (not NULL) with 1,383 rows
  - `incognito_mode` true for only 263/258,107 rows (~0.1%) — negligible for analysis
- Key finding so far: `fwdbtn`-started plays average ~28.5s listened vs. ~2:00+ for `trackdone`/`clickrow` — suggests skip-chains, not just a generic high skip rate

## Repo conventions
- `data/` and `.DS_Store` are gitignored
- Git commit email uses GitHub's noreply address, not personal email (repo is public)
- Remote: github.com/Jleo1511/spotify-sql-analysis

## Where this is headed
1. Solidify GROUP BY/aggregates on the real dataset (in progress)
2. Window functions: rank top artist per month, running totals, session/streak detection via LAG/LEAD (gaps-and-islands)
3. Packaging/viz tool undecided — Power BI is Windows-only and hard to publish, likely something link-shareable instead. Decide once analysis is further along.
4. Lean into the extended-data fields (skip behavior, platform, session detection) rather than recreating a basic Wrapped clone.

## Ideas for later (narrative/visualization phase — not built yet)
- Skip-chain finding: fwdbtn-started plays avg ~28.5s vs ~2min for trackdone/clickrow — story is "skip-chains," not generic high skip rate
- NULL-artist data-quality catch: podcasts/audiobooks have no value in master_metadata_album_artist_name (concept doesn't apply to them); had to filter for a real "top artists" ranking — good data-cleaning narrative for the writeup
- Top artists by total hours skew bilingual: Luis Miguel, Coldplay, The Chainsmokers, Alejandro Sanz in top 4 — possible angle on Spanish vs. English listening patterns (time of day, platform, mood)
- 12-year span (2014-2026) enables real multi-year trend analysis, not a single-year snapshot

## Progress log
- Persisted raw audio history into a real DuckDB file: spotify.duckdb, table audio_history (258,107 rows, confirmed matches original JSON count)
- Built and debugged first real GROUP BY + aggregate query: top artists by total listening hours (SUM/3600000, WHERE IS NOT NULL, ORDER BY DESC, LIMIT)
- Next up: window functions (rank per month/year, running totals, session/streak detection via LAG/LEAD)

## Next action item: build a personal cheat sheet
Not for memorization — for having a trusted reference to copy patterns from
instead of recalling syntax cold every time. Two parts:

1. Session startup routine: DONE, see the "Session startup" section near the top of this file.

2. Syntax pattern reference — the *shapes*, not memorized by heart:
   - GROUP BY + aggregate: SELECT <col>, AGG(<col>) AS <alias> FROM <table>
     GROUP BY <col> ORDER BY <alias> DESC
   - Window function: <func>() OVER (PARTITION BY <col> ORDER BY <col> DESC) AS <alias>
   - Subquery to filter on a window function result: SELECT * FROM (<inner query,
     no ORDER BY/LIMIT>) AS <alias> WHERE <window_alias> = <value>

   ### GROUP BY vs window function
   - GROUP BY collapses many rows into one per group
     (my data: all plays -> one row per artist-year with total hours).
   - A window function keeps every row and adds a new column computed
     across related rows (my data: artist_rank, ranking artists within each year).
   - Chain: total per artist-year first, then rank within each year,
     then WHERE artist_rank = 1 keeps the top artist per year.
   - PARTITION BY restarts the ranking per group. Without it there is one
     ranking over all rows, so rank = 1 returns a single row.
   - ORDER BY inside OVER decides who gets rank 1. The ORDER BY at the end
     of the query is what sorts the printed output.

Root cause this addresses: most session friction has been environment
mechanics (which terminal, which folder) and syntax recall, not SQL logic
itself — he consistently reasons through the logic correctly once broken down.
