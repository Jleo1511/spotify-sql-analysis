-- Top 15 artists by total listening hours
-- Filters out NULL artist rows (podcasts/audiobooks don't populate this field)
SELECT master_metadata_album_artist_name, SUM(ms_played) / 3600000 AS hours_played
FROM audio_history
WHERE master_metadata_album_artist_name IS NOT NULL
GROUP BY master_metadata_album_artist_name
ORDER BY hours_played DESC
LIMIT 15;