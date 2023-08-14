-- Segment 1:Database - Tables, Columns, Relationships
-- Q.What are the different tables in the database and how are they connected to each other in the database?

-- Table 1: Director Mapping:

-- Connected to the Movie table through the Movie_id column.
-- Connected to the Names table through the name_id column.

-- Table 2: Genre:

-- Connected to the Movie table through the Movie_id column.

-- Table 3: Movie:

-- Connected to the Director Mapping table through the Movie_id column.
-- Connected to the Genre table through the Movie_id column.

-- Table 3: Names:

-- Connected to the Director Mapping table through the name_id column.

-- Table 4: Ratings:

-- Connected to the Movie table through the movie_id column.

-- Table 5: Role Mapping:

-- Connected to the Movie table through the movie_id column.
-- Connected to the Names table through the name_id column.

-- Q.What are the different tables in the database and how are they connected to each other in the database?
SELECT Count(*) FROM director_mapping;
-- No. of rows: 3867

SELECT Count(*) FROM genre;
-- No. of rows: 14662

SELECT Count(*) FROM  names;
-- No. of rows: 25735

SELECT Count(*) FROM  ratings;
-- No. of rows: 7997

SELECT Count(*) FROM  role_mapping;
-- No. of rows: 15615

SELECT Count(*) FROM director_mapping;
-- No. of rows: 3867

SELECT Count(*) FROM genre;
-- No. of rows: 14662

SELECT Count(*) FROM  names;
-- No. of rows: 25735

SELECT Count(*) FROM  ratings;
-- No. of rows: 7997

SELECT Count(*) FROM  role_mapping;
-- No. of rows: 15615

-- Q2. Which columns in the movie table have null values?
SELECT
(SELECT count(*) FROM movie WHERE id is NULL) as id,
(SELECT count(*) FROM movie WHERE title is NULL) as title,
(SELECT count(*) FROM movie WHERE year  is NULL) as year,
(SELECT count(*) FROM movie WHERE date_published  is NULL) as date_published,
(SELECT count(*) FROM movie WHERE duration  is NULL) as duration,
(SELECT count(*) FROM movie WHERE country  is NULL) as year, 
(SELECT count(*) FROM movie WHERE worlwide_gross_income  is NULL) as worlwide_gross_income,
(SELECT count(*) FROM movie WHERE languages  is NULL) as languages,
(SELECT count(*) FROM movie WHERE production_company  is NULL) as production_company
;

-- found null in below given columns ( count mentioned) 
-- year 20
-- worlwide_gross_income  3724
-- languages 194
-- production_company 528

--  Segment 2: Movie Release Trends
-- Q.Determine the total number of movies released each year and analyse the month-wise trend.

SELECT year,Count(title) AS NUMBER_OF_MOVIES
FROM movie
GROUP BY year;   -- Total number of movies released each year

SELECT Month(date_published) AS MONTH_NUM,Count(*) AS NUMBER_OF_MOVIES
FROM movie
GROUP BY month_num
ORDER BY month_num; --  Total number of movies released each month

--	Q. Calculate the number of movies produced in the USA or India in the year 2019.
SELECT Count(DISTINCT id) AS number_of_movies, year
FROM  movie
WHERE (country = 'India' OR country = 'USA') AND year = 2019; 
-- Number of movies produced by USA or India for the last year i.e, 2019 is "887".

-- Segment 3: Production Statistics and Genre Analysis
-- Q.Retrieve the unique list of genres present in the dataset.
SELECT DISTINCT genre FROM   genre; 

-- Q.Identify the genre with the highest number of movies produced overall.
SELECT Genre, COUNT(*) AS total_movies
FROM Genre
GROUP BY Genre
ORDER BY total_movies DESC
LIMIT 3;
-- Drama genre had the highest movies produced overall i.e, 4285.


-- Q.Determine the count of movies that belong to only one genre.
SELECT COUNT(*) AS count_movies_one_genre
FROM (
SELECT Movie_id FROM Genre
GROUP BY Movie_id
HAVING COUNT(*) = 1) AS subquery;
-- 3289 movies have exactly one genre.


-- Q.Calculate the average duration of movies in each genre. 
SELECT  genre,Round(Avg(duration),2) AS avg_duration
FROM  movie as mov
INNER JOIN genre as gen
ON  gen.movie_id = mov.id
GROUP BY genre
ORDER BY avg_duration DESC;
--  Duration of Action movies is highest with duration of 112.88 mins whereas Horror movies have least with duration 92.72 mins.


-- Q.Find the rank of the 'thriller' genre among all genres in terms of the number of movies produced.
SELECT Genre, genre_rank
FROM (SELECT Genre, RANK() OVER (ORDER BY total_movies DESC) AS genre_rank
FROM (SELECT Genre, COUNT(*) AS total_movies FROM Genre
GROUP BY Genre) AS genre_counts) AS ranked_genres
WHERE Genre = 'thriller';
-- Thriller genre has 3rd rank with 1484 movies.

-- Segment 4: Ratings Analysis and Crew Members
-- Q.Retrieve the minimum and maximum values in each column of the ratings table (except movie_id).
SELECT 
   Min(avg_rating) AS min_avg_rating,
   Max(avg_rating) AS max_avg_rating,
   Min(total_votes) AS min_total_votes,
   Max(total_votes) AS max_total_votes,
   Min(median_rating) AS min_median_rating,
   Max(median_rating) AS min_median_rating
FROM   ratings; 

-- Q.Identify the top 10 movies based on average rating
SELECT  title,avg_rating,Rank() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM  ratings AS rat
INNER JOIN movie AS mov
ON  mov.id = rat.movie_id limit 10;

-- Q.Summarise the ratings table based on the movie counts by median ratings.
SELECT median_rating,Count(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count DESC;

-- Q.Identify the production house that has produced the most number of hit movies (average rating > 8).
SELECT m.production_company, COUNT(*) AS hit_movie_count
FROM Movie m
JOIN Ratings r ON m.id = r.movie_id
WHERE r.avg_rating > 8 and m.production_company is not null
GROUP BY m.production_company
ORDER BY hit_movie_count DESC
LIMIT 1;
-- Dream Warrior Pictures and National Theatre Live production both have the most number of hit movies i.e, 3 movies with average rating > 8


-- Q.Determine the number of movies released in each genre during March 2017 in the USA with more than 1,000 votes
SELECT genre,Count(mov.id) AS movie_count
FROM movie AS mov
INNER JOIN genre AS gen
ON gen.movie_id = mov.id
INNER JOIN ratings AS rat
ON rat.movie_id = mov.id
WHERE year = 2017
	  AND Month(date_published) = 3
	  AND country LIKE '%USA%'
	  AND total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;

-- Q.Retrieve movies of each genre starting with the word 'The' and having an average rating > 8.
SELECT title, avg_rating, genre
FROM movie AS mov
INNER JOIN genre AS gen
	ON gen.movie_id = mov.id
INNER JOIN ratings AS rat
	ON rat.movie_id = mov.id
WHERE avg_rating > 8
	  AND title LIKE 'THE%'
ORDER BY avg_rating DESC;

-- Q.Determine the number of movies released in each genre during March 2017 in the USA with more than 1,000 votes.
SELECT 
   median_rating,
Count(*) AS movie_count
FROM movie AS mov INNER JOIN 
     ratings AS rat ON rat.movie_id = mov.id
WHERE median_rating = 8
	  AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;
-- There are 361 movies that released between 1 April 2018 and 1 April 2019 and were given a median rating of 8.

-- Segment 5: Crew Analysis
-- Q.Identify the columns in the names table that have null values.
select * from names;
SELECT
(SELECT count(*) FROM names WHERE id is NULL) as id,
(SELECT count(*) FROM names WHERE name is NULL) as name,
(SELECT count(*) FROM names WHERE height  is NULL) as height,
(SELECT count(*) FROM names WHERE date_of_birth  is NULL) as date_of_birth ,
(SELECT count(*) FROM names WHERE Known_for_movies  is NULL) as Known_for_movies;

-- null result
-- name                 0  
-- height 				17335
-- date_of_birth 	    13431	
-- known_for_movie		15226


-- Q.	Determine the top three directors in the top three genres with movies having an average rating > 8.
SELECT genre_subquery.Genre, director_subquery.director_name, director_subquery.movie_count
FROM(SELECT g.Genre FROM Genre g
JOIN
Movie m ON g.Movie_id = m.id
JOIN
Ratings r ON m.id = r.movie_id
WHERE r.avg_rating > 8
GROUP BY g.Genre
ORDER BY COUNT(*) DESC
LIMIT 3
) AS genre_subquery
JOIN
(SELECT g.Genre, n.name AS director_name, COUNT(*) AS movie_count,
ROW_NUMBER() OVER (PARTITION BY g.Genre ORDER BY COUNT(*) DESC) AS row_num
FROM Names n
JOIN Director_Mapping dm ON n.id = dm.name_id
JOIN Movie m ON dm.Movie_id = m.id
JOIN Genre g ON m.id = g.Movie_id
JOIN Ratings r ON m.id = r.movie_id
WHERE r.avg_rating > 8
GROUP BY g.Genre, n.name
ORDER BY g.Genre, COUNT(*) DESC
) AS director_subquery ON genre_subquery.Genre = director_subquery.Genre
WHERE director_subquery.row_num <= 3
ORDER BY genre_subquery.Genre, director_subquery.movie_count DESC;


-- Q.Find the top two actors whose movies have a median rating >= 8.
SELECT n.name, COUNT(*) AS movie_count
FROM Names n
JOIN Role_Mapping rm ON n.id = rm.name_id
JOIN Ratings r ON rm.movie_id = r.movie_id
WHERE r.median_rating >= 8
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;
-- top two actor below with movie_count 
-- Mammootty 8
-- Mohanlal	5

-- Q.Identify the top three production houses based on the number of votes received by their movies.
SELECT m.production_company, SUM(r.total_votes) AS total_votes FROM Movie m
JOIN Ratings r ON m.id = r.movie_id
GROUP BY m.production_company
ORDER BY total_votes DESC
LIMIT 3

-- Top three production houses based on the number of votes 
-- Marvel Studios, Twentieth Century Fox and Warner Bros. 

-- Q.Rank actors based on their average ratings in Indian movies released in India.
SELECT n.name AS actor_name, round(AVG(r.avg_rating), 2) AS average_rating FROM Names  n
JOIN Role_Mapping rm ON n.id = rm.name_id
JOIN Movie m ON rm.movie_id = m.id
JOIN Ratings r ON m.id = r.movie_id
WHERE m.country = 'India' 
GROUP BY n.name
ORDER BY average_rating DESC;
-- Top actor is Vijay Sethupathi

-- Q.Identify the top five actresses in Hindi movies released in India based on their average ratings.
SELECT n.name AS actress_name, round(AVG(r.avg_rating), 2) AS average_rating FROM Names n
JOIN Role_Mapping rm ON n.id = rm.name_id
JOIN Movie m ON rm.movie_id = m.id
JOIN Ratings r ON m.id = r.movie_id
WHERE m.country = 'India' AND m.languages LIKE '%Hindi%' AND rm.category = 'actress'
GROUP BY n.name
ORDER BY average_rating DESC
LIMIT 5;


-- Segment 6: Broader Understanding of Data

-- Q.Classify thriller movies based on average ratings into different categories.
SELECT m.title, r.avg_rating,
CASE
WHEN r.avg_rating >= 9 THEN 'Excellent'
WHEN r.avg_rating >= 8 THEN 'Very Good'
WHEN r.avg_rating >= 7 THEN 'Good'
WHEN r.avg_rating >= 6 THEN 'Above Average'
ELSE 'Below Average' 
END AS rating_category
FROM Movie m
JOIN Genre g ON m.id = g.Movie_id
JOIN Ratings r ON m.id = r.movie_id
WHERE g.Genre = 'thriller'
ORDER BY r.avg_rating DESC;

-- Q.analyse the genre-wise running total and moving average of the average movie duration.
SELECT genre,
       ROUND(AVG(duration),2) AS avg_duration,
       SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
       ROUND(AVG(AVG(duration)) OVER(ORDER BY genre ROWS 10 PRECEDING),2) AS moving_avg_duration
FROM movie AS m 
INNER JOIN genre AS g 
ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;

-- Q.Identify the five highest-grossing movies of each year that belong to the top three genres.
SELECT year, Genre, title, worlwide_gross_income
FROM (SELECT m.year, g.Genre, m.title, m.worlwide_gross_income,
ROW_NUMBER() OVER (PARTITION BY m.year, g.Genre ORDER BY m.worlwide_gross_income DESC) AS rank_
FROM Movie m
JOIN Genre g ON m.id = g.Movie_id
WHERE g.Genre IN (SELECT Genre FROM (SELECT Genre, COUNT(*) AS genre_count FROM Genre
GROUP BY Genre
ORDER BY genre_count DESC
LIMIT 3) AS top_genres) AND m.worlwide_gross_income IS NOT NULL) AS ranked_movies
WHERE rank_ <= 5
ORDER BY year, Genre, worlwide_gross_income DESC;

-- Q.Determine the top two production houses that have produced the highest number of hits among multilingual movies.
SELECT m.production_company, COUNT(*) AS hit_count
FROM Movie m
JOIN Ratings r ON m.id = r.movie_id
WHERE m.languages <> 'English'         -- Exclude English-only movies
AND r.avg_rating >= 8                  -- Consider hits with an average rating >= 8
AND m.production_company is not null   -- excluding null values in the Production company column
GROUP BY m.production_company
ORDER BY hit_count DESC
LIMIT 2;


-- Q.Identify the top three actresses based on the number of Super Hit movies (average rating > 8) in the drama genre.
SELECT n.name AS actress_name, COUNT(*) AS super_hit_count
FROM Names n
JOIN Role_Mapping rm ON n.id = rm.name_id
JOIN Movie m ON rm.movie_id = m.id
JOIN Ratings r ON m.id = r.movie_id
JOIN Genre g ON m.id = g.Movie_id
WHERE r.avg_rating > 8 AND g.Genre = 'drama' AND rm.category = 'actress'
GROUP BY n.name
ORDER BY super_hit_count DESC
LIMIT 3;
-- Top 3 actresses based on number of Super Hit movies
-- Parvathy Thiruvothu, Susan Brown and Amanda Lawrence 

-- Q.Retrieve details for the top nine directors based on the number of movies, including average inter-movie duration, ratings, and more.
SELECT n.name AS director_name, COUNT(DISTINCT dm.Movie_id) AS movie_count, round(AVG(m.duration), 2) AS average_duration,
round(AVG(r.avg_rating), 2) AS average_rating, MAX(r.avg_rating) AS highest_rating, MIN(r.avg_rating) AS lowest_rating
FROM Names n
JOIN Director_Mapping dm ON n.id = dm.name_id
JOIN Movie m ON dm.Movie_id = m.id
JOIN Ratings r ON m.id = r.movie_id
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 9;
