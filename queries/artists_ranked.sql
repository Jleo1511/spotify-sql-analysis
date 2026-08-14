SELECT *
          FROM (
              SELECT master_metadata_album_artist_name,
                     SUM(ms_played) / 3600000 AS hours_played,
                     EXTRACT(YEAR FROM ts) AS year,
                     RANK() OVER (PARTITION BY EXTRACT(YEAR FROM ts) ORDER BY hours_played DESC) AS artist_rank
              FROM audio_history
              WHERE master_metadata_album_artist_name IS NOT NULL
              GROUP BY master_metadata_album_artist_name, EXTRACT(YEAR FROM ts)
          ) AS ranked
          WHERE artist_rank = 1
          ORDER BY year;