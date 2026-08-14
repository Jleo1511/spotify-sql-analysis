-- Which devices/apps plays happened on
SELECT platform, COUNT(*) AS plays
FROM audio_history
GROUP BY platform
ORDER BY plays DESC;
