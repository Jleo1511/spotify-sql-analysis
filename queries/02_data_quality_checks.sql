-- Null track names: how many, and how many are explained by podcasts/audiobooks
-- (16 rows remain unexplained by either category — open question, not yet investigated)
SELECT COUNT(*) FILTER (WHERE master_metadata_track_name IS NULL) AS null_tracks,
       COUNT(*) FILTER (WHERE episode_name IS NOT NULL) AS podcast_rows,
       COUNT(*) FILTER (WHERE audiobook_title IS NOT NULL) AS audiobook_rows,
       COUNT(*) AS total_rows
FROM audio_history;

-- Incognito mode plays: negligible (~0.1% of total), not worth filtering for
SELECT incognito_mode, COUNT(*) AS plays
FROM audio_history
GROUP BY incognito_mode
ORDER BY plays DESC;
