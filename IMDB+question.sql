USE imdb;


/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) AS no_rows_movie
FROM movie;
-- There are 7997 rows in movie table 

SELECT COUNT(*) AS no_rows_genre
from genre;
-- There are 14662 rows in genre table 

SELECT COUNT(*) AS no_rows_director_mapping
from director_mapping;
-- There are 3867 rows in director_mapping table

SELECT COUNT(*) AS no_rows_role_mapping
from role_mapping;
-- There are 15615 rows in role_mapping table

SELECT COUNT(*) AS no_rows_names
from names;
-- There are 25735 rows in names table

SELECT COUNT(*) AS no_rows_ratings
from ratings;
-- There are 7997 rows in ratings table



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select 
	sum(case when title is null then 1 else 0 end) as title,
	sum(case when year is null then 1 else 0 end) as year,
    sum(case when date_published is null then 1 else 0 end) as date_published,
    sum(case when duration is null then 1 else 0 end) as duration,
    sum(case when country is null then 1 else 0 end) as country,
    sum(case when worlwide_gross_income is null then 1 else 0 end) as worlwide_gross_income,
    sum(case when languages is null then 1 else 0 end) as languages,
    sum(case when production_company is null then 1 else 0 end) as production_company
from movie;

-- The following four columns of the movie table have null values:
-- country, worlwide_gross_income, languages, production_company  







-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- First Part 
select year as Year, count(id) as number_of_movies 
from movie
group by Year
order by Year;

-- Second Part 
select month(date_published) as month_num, count(id) as number_of_movies
from movie
group by month_num
order by month_num;




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select country, count(id) as number_of_movies
from movie
where country = 'USA' or country = 'India'
group by country;

-- Inida produced 1007 movies and USA produced 2260 movies in the year 2019 








/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct(genre) 
from genre;









/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select genre, count(id) as number_of_movies
from 
movie as m
inner join 
genre as g
on m.id = g.movie_id
group by genre
order by number_of_movies DESC;

-- The Drama genre had the highest number of movies produced overall. 







/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

select count(movie_id) as number_of_movies
from
(
select movie_id, count(movie_id) as number_of_genres
from genre
group by movie_id
) as temp
where number_of_genres = 1;

-- There are 3289 movies which has only one genre associated with them 


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select genre, avg(duration) as avg_duration
from 
movie as m
inner join 
genre as g
on m.id = g.movie_id
group by genre
order by avg_duration ASC;








/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select genre,
count(id) as number_of_movies,
rank() over(order by number_of_movies desc) as genre_rank
from 
movie as m
inner join 
genre as g
on m.id = g.movie_id
group by genre
order by genre_rank;


-- Thriller movies are ranked 3 among all genres in terms of number of movies 






/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select 
min(avg_rating) as min_avg_rating, 
max(avg_rating) as max_avg_rating,
min(total_votes) as min_total_votes,
max(total_votes) as max_total_votes,
min(median_rating) as min_median_rating,
max(median_rating) as max_median_rating
from ratings;




    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

select 
title, 
avg_rating,
dense_rank() over(order by avg_rating DESC) as movie_rank
from 
movie as m
inner join 
ratings as r
on m.id = r.movie_id
limit 10;






/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

select median_rating, count(movie_id) as movie_count
from ratings
group by median_rating
order by median_rating;








/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

select 
production_company, 
count(movie_id) as movie_count,
rank() over(order by movie_count desc) as prod_company_rank
from 
movie as m
inner join 
ratings as r
on m.id = r.movie_id
where r.avg_rating > 8
group by production_company
order by prod_company_rank;

-- National Theatre Live and Dream Warrior Pictures has the most number of hit movies 




-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select 
genre, 
count(id) as movie_count

from 
genre as g
inner join 
movie as m
on g.movie_id = m.id
inner join 
ratings as r
on m.id = r.movie_id
where 
m.year = 2017 
and 
m.country = 'USA'
and
r.total_votes > 1000
group by g.genre
order by movie_count desc;






-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
select 
title,
avg_rating,
genre
from
movie as m
inner join 
ratings as r
on m.id = r.movie_id
inner join 
genre as g
on r.movie_id = g.movie_id

where 
lower(m.title) like 'the%' 
and
r.avg_rating > 8
order by avg_rating;






-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select count(id) as number_of_movies
from 
movie as m
inner join
ratings as r
on m.id = r.movie_id

where 
m.date_published between '2018-04-01' and '2019-04-1'
and
r.median_rating = 8;

-- Of the between 1 April 2018 and 1 April 2019, 361 were given a median rating of 8








-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select country, sum(total_votes) as total_votes 
from 
movie as m
inner join
ratings as r
on m.id = r.movie_id
where m.country = 'Germany' or m.country = 'Italy'
group by m.country;





-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select 
	sum(case when name is null then 1 else 0 end) as name_nulls,
	sum(case when height is null then 1 else 0 end) as height_nulls,
    sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
    sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_nulls
from names;







/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Part 1: Finding the top 3 genres 
select genre, count(g.movie_id) as number_of_movies
from 
genre as g
inner join 
ratings as r
on g.movie_id = r.movie_id
where r.avg_rating > 8
group by genre
order by number_of_movies DESC
limit 3;
-- Drama, Action and Comedy are the top three genres 

-- Part 2: Finding the top 3 directors for the top 3 genres
select name, count(t.id) as number_of_movies
from
(
select id, avg_rating, genre
from 
movie as m
inner join ratings as r
on m.id = r.movie_id
inner join
genre as g
on r.movie_id = g.movie_id
where r.avg_rating > 8 and g.genre in ('Drama', 'Action', 'Comedy')
) as t
inner join 
director_mapping as dm
on t.id = dm.movie_id
inner join 
names as n
on dm.name_id = n.id
group by name
order by number_of_movies DESC;
-- James Mangold is top director with the most number of movies in top 3 genres 

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select name, count(t.id) as movie_count
from 
(
select id, median_rating
from 
movie as m
inner join
ratings as r
on m.id = r.movie_id
where r.median_rating >= 8
) as t
inner join 
role_mapping as rm
on t.id = rm.movie_id
inner join 
names as n
on rm.name_id = n.id
where rm.category = 'Actor'
group by name
order by movie_count desc;




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company, 
sum(total_votes) as vote_count,
rank() over(order by vote_count DESC) as prod_comp_rank
from 
movie as m
inner join 
ratings as r
on m.id = r.movie_id
group by production_company
order by vote_count DESC
limit 3;

 -- The top three production houses based on the number of votes received by the movies they have produced are the following:
 -- Marvel Studios, Twentieth Century Fox, Warner Bros 






/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


select name as actor_name, sum(total_votes) as total_votes, count(t.id) as movie_count, round(avg(avg_rating),2) as actor_avg_rating,
rank() over(order by actor_avg_rating DESC) as actor_rank
from
(
select id, languages
from movie
where country = 'India' 
) as t
inner join 
ratings as r
on t.id = r.movie_id
inner join 
role_mapping as rm
on r.movie_id = rm.movie_id
inner join 
names as n
on rm.name_id = n.id
where rm.category = 'Actor'
group by actor_name
having movie_count >= 5
order by actor_rank, total_votes DESC;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select name as actress_name, sum(total_votes) as total_votes, count(t.id) as movie_count, round(avg(avg_rating), 2) as actress_avg_rating,
dense_rank() over(order by actress_avg_rating DESC) as actress_rank
from
(
select id, languages
from movie
where country = 'India' 
) as t
inner join 
ratings as r
on t.id = r.movie_id
inner join 
role_mapping as rm
on r.movie_id = rm.movie_id
inner join 
names as n
on rm.name_id = n.id
where rm.category = 'Actress' and t.languages = 'Hindi'
group by actress_name
having movie_count >= 3
order by actress_rank, total_votes DESC;








/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

select 
case
	when avg_rating > 8 then 'Superhit Movies'
    when avg_rating between 7 and 8 then 'Hit Movies'
    when avg_rating between 5 and 7 then 'One-time watch movies'
    else 'Flop movies'
end as ranking,
count(id) as number_of_movies
from    
(
select id
from 
movie as m
inner join
genre as g
on m.id = g.movie_id
where g.genre like '%Thriller%'
) as t
inner join 
ratings as r
on t.id = r.movie_id
group by ranking
order by number_of_movies DESC;



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
select genre, round(avg(duration), 2) as avg_duration, sum(duration) over(order by id) as running_total_duration, 
round(avg(duration) over(order by id rows between 2 preceding and current row), 2) as moving_avg_duration
from movie as m
inner join
genre as g
on m.id = g.movie_id
group by genre
order by running_total_duration;







-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- Part 1: Finding the top 3 genres
select genre, count(id) as number_of_movies
from
movie as m
inner join 
genre as g
on m.id = g.movie_id
group by genre
order by number_of_movies DESC
limit 3;

-- The top 3 genres are Drama, Comedy and Thriller

select *
from 
(
select genre, year, title as movie_name, worlwide_gross_income,
dense_rank() over(partition by year order by worlwide_gross_income DESC) as movie_rank
from 
movie as m
inner join 
genre as g
on m.id = g.movie_id
where g.genre in ('Drama', 'Comedy', 'Thriller')
) as h
where h.movie_rank <=5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company, count(id) as movie_count,
dense_rank() over(order by movie_count DESC) as prod_comp_rank
from 
movie as m
inner join 
ratings as r
on m.id = r.movie_id
where r.median_rating >= 8 and m.languages like '%,%'
group by production_company
order by prod_comp_rank
limit 3;

-- Star Cinema and Twentieth Century Fox are the two production houses that have produced the most number of hits 




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


with actress_names as
(
	select movie_id, name_id, name
    from role_mapping as rm
    inner join names as n
    on rm.name_id = n.id
    where rm.category ='Actress'
), movie_ratings as 
(	
	select id, avg_rating, total_votes
    from movie as m
    inner join ratings as r
    on m.id = r.movie_id
	where avg_rating > 8
)

select name as actress_name,
sum(total_votes) as total_votes,
count(id) as movie_count,
avg(avg_rating) as actress_avg_rating,
dense_rank() over(order by movie_count DESC) as actress_rank

from actress_names as an
inner join movie_ratings as mr
on an.movie_id = mr.id
inner join genre as g
on mr.id = g.movie_id

where g.genre = 'Drama'
group by actress_name
order by actress_rank;


 --  The top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre are the following
 -- Denise Gough, Parvathy Thiruvothu, Amanda Lawrence 






/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

-- Movie ids and names of directors

with director_names as 
(	 
	select movie_id, name_id, name
	from director_mapping as dm
	inner join names as n
	on dm.name_id = n.id 
), movie_ratings as 
( 
	select id, duration, date_published, avg_rating, total_votes, median_rating
	from 
    movie as m
    inner join 
    ratings as r
    on m.id = r.movie_id
), movie_releases as
(
	select dm.name_id, id, date_published,
	date_published - lag(date_published) over(partition by name_id order by date_published) as days_between
	from movie as m
	inner join 
	director_mapping as dm
	on m.id = dm.movie_id
    order by name_id
)

select 
dn.name_id as director_id,
name as director_name,
count(dn.movie_id) as number_of_movies,
avg(days_between) as avg_inter_movie_days,
avg(avg_rating) as avg_rating,
sum(total_votes) as total_votes,
min(avg_rating) as min_rating,
max(avg_rating) as max_rating,
sum(duration) as total_durtaion

from 
director_names as dn
inner join movie_ratings as mr
on dn.movie_id = mr.id
inner join 
movie_releases as m_rel
on mr.id = m_rel.id
group by director_name
order by number_of_movies DESC
limit 9;
