-- What triggers each play to start
SELECT reason_start, COUNT(*) AS plays
FROM audio_history
GROUP BY reason_start
ORDER BY plays DESC;

-- The actual finding: fwdbtn-started plays average ~28.5s listened,
-- vs. ~2min for trackdone/clickrow — suggests skip-chains, not generic high skip rate
SELECT reason_start, COUNT(*) AS plays, AVG(ms_played) AS avg_ms_played
FROM audio_history
GROUP BY reason_start
ORDER BY plays DESC;
