# Spotify SQL Analysis Project

## What this is
A hands-on SQL learning project analyzing my own Spotify Extended Streaming History with DuckDB, building toward a portfolio piece for SaaS CS / RevOps / data analyst job applications. Based on learnsql.com's "Spotify Wrapped with SQL" tutorial as a starting point, but going well past it — that tutorial alone is too generic to differentiate on a resume.

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
- 258,107 audio play rows total; loaded via `read_json_auto()`, no persisted table yet
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
