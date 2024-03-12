-- What were the top 10 movies according to IMDB score?
WITH TopMovies AS (
    SELECT title, imdb_score
    FROM netflix.titles
    WHERE type = 'MOVIE'
    ORDER BY imdb_score DESC
    LIMIT 10
)
SELECT title, 'MOVIE' AS type, imdb_score
FROM TopMovies
WHERE imdb_score >= 8.0;

-- What were the top 10 shows according to IMDB score?
WITH TopShows AS (
    SELECT title, imdb_score
    FROM netflix.titles
    WHERE type = 'SHOW'
    ORDER BY imdb_score DESC
    LIMIT 10
)
SELECT title, 'SHOW' AS type, imdb_score
FROM TopShows
WHERE imdb_score >= 8.0;

-- What were the bottom 10 movies according to IMDB score?
SELECT title, 'MOVIE' AS type, imdb_score
FROM netflix.titles
WHERE type = 'MOVIE'
ORDER BY imdb_score ASC
LIMIT 10;

-- What were the bottom 10 shows according to IMDB score?
SELECT title, 'SHOW' AS type, imdb_score
FROM netflix.titles
WHERE type = 'SHOW'
ORDER BY imdb_score ASC
LIMIT 10;

-- What were the average IMDB and TMDB scores for shows and movies?
SELECT type, 
       ROUND(AVG(imdb_score), 2) AS avg_imdb_score,
       ROUND(AVG(tmdb_score), 2) AS avg_tmdb_score
FROM netflix.titles
GROUP BY type;

-- Count of movies and shows in each decade
SELECT CONCAT(FLOOR(release_year / 10) * 10, 's') AS decade,
       COUNT(*) AS movies_shows_count
FROM netflix.titles
WHERE release_year >= 1940
GROUP BY decade
ORDER BY decade;

-- What were the average IMDB and TMDB scores for each production country?
SELECT production_countries, 
       ROUND(AVG(imdb_score), 2) AS avg_imdb_score,
       ROUND(AVG(tmdb_score), 2) AS avg_tmdb_score
FROM netflix.titles
GROUP BY production_countries
ORDER BY avg_imdb_score DESC;

-- What were the average IMDB and TMDB scores for each age certification for shows and movies?
SELECT age_certification, 
       ROUND(AVG(imdb_score), 2) AS avg_imdb_score,
       ROUND(AVG(tmdb_score), 2) AS avg_tmdb_score
FROM netflix.titles
GROUP BY age_certification
ORDER BY avg_imdb_score DESC;

-- What were the 5 most common age certifications for movies?
SELECT age_certification, 
       COUNT(*) AS certification_count
FROM netflix.titles
WHERE type = 'Movie' 
  AND age_certification != 'N/A'
GROUP BY age_certification
ORDER BY certification_count DESC
LIMIT 5;

-- Who were the top 20 actors that appeared the most in movies/shows? 
SELECT name AS actor, 
       COUNT(*) AS number_of_appearences 
FROM netflix.credits
WHERE role = 'actor'
GROUP BY actor
ORDER BY number_of_appearences DESC
LIMIT 20;

-- Who were the top 20 directors that directed the most movies/shows? 
SELECT name AS director, 
       COUNT(*) AS number_of_appearences 
FROM netflix.credits
WHERE role = 'director'
GROUP BY director
ORDER BY number_of_appearences DESC
LIMIT 20;

-- Calculating the average runtime of movies and TV shows separately
SELECT 'Movies' AS content_type,
       ROUND(AVG(runtime), 2) AS avg_runtime_min
FROM netflix.titles
WHERE type = 'Movie'
UNION ALL
SELECT 'Show' AS content_type,
       ROUND(AVG(runtime), 2) AS avg_runtime_min
FROM netflix.titles
WHERE type = 'Show';


-- Which shows on Netflix have the most seasons?
SELECT title, 
       SUM(seasons) AS total_seasons
FROM netflix.titles 
WHERE type = 'Show'
GROUP BY title
ORDER BY total_seasons DESC
LIMIT 10;

-- Which genres had the most movies? 
SELECT genres, 
       COUNT(*) AS title_count
FROM netflix.titles 
WHERE type = 'Movie'
GROUP BY genres
ORDER BY title_count DESC
LIMIT 10;

-- Which genres had the most shows? 
SELECT genres, 
       COUNT(*) AS title_count
FROM netflix.titles 
WHERE type = 'Show'
GROUP BY genres
ORDER BY title_count DESC
LIMIT 10;



  

-- What were the total number of titles for each year? 
SELECT release_year, 
       COUNT(*) AS title_count
FROM netflix.titles 
GROUP BY release_year
ORDER BY release_year DESC;

-- Actors who have starred in the most highly rated movies or shows
SELECT c.name AS actor, 
       COUNT(*) AS num_highly_rated_titles
FROM netflix.credits AS c
JOIN netflix.titles AS t 
ON c.id = t.id
WHERE c.role = 'actor'
  AND (t.type = 'Movie' OR t.type = 'Show')
  AND t.imdb_score > 8.0
  AND t.tmdb_score > 8.0
GROUP BY c.name
ORDER BY num_highly_rated_titles DESC;




-- What were the top 3 most common genres?
SELECT genres, 
       COUNT(*) AS genre_count
FROM netflix.titles AS t
WHERE type = 'Movie'
GROUP BY genres
ORDER BY genre_count DESC
LIMIT 3;

-- Average IMDB score for leading actors/actresses in movies or shows 
SELECT c.name AS actor_actress, 
ROUND(AVG(t.imdb_score),2) AS average_imdb_score
FROM netflix.credits AS c
JOIN netflix.titles AS t 
ON c.id = t.id
WHERE c.role = 'actor' OR c.role = 'actress'
AND c.character = 'leading role'
GROUP BY c.name
ORDER BY average_imdb_score DESC;