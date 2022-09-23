create database Friends;
use Friends;
SELECT 
    *
FROM
    Friends.Infos1
; 
-- remove space from column name 
alter table Friends.Infos1
rename column `Episode Number` to Episode_number; 

-- check for duplicates 
SELECT 
    Episode_Title, COUNT(Episode_Title)
FROM
    Friends.Infos1
GROUP BY Episode_Title
HAVING COUNT(Episode_Title) > 1;

-- rename duplicate episodes ( double episodes) 

With Dups As
    (
    Select episode_number, episode_title
        , Row_Number() Over ( Partition By episode_title Order By episode_number ) As Rnk
    From Friends.infos1
    )
select * from Dups;
Select D.episode_title + Case
                When D.Rnk > 1 Then ':part' + cast(D.Rnk as char) 
                Else ''
                End As episode_title
From Dups As D;

-- 1. total number of seasons 
SELECT 
    COUNT(DISTINCT (Season)) as Seasons
FROM
    Friends.Infos1; 
-- 2. total number of episodes
SELECT 
    COUNT(episode_title) as Episodes
FROM
    Friends.Infos1; 
    
-- 4. average rating
SELECT 
    ROUND(AVG(stars), 1) AS Stars
FROM
    Friends.Infos1;
-- 5. total number of votes 
SELECT 
    SUM(votes) AS Votes
FROM
    Friends.Infos1; 
-- 6. total nb of directors 
SELECT 
    COUNT(DISTINCT (director)) AS Directors
FROM
    Friends.Infos1; 
-- 7. average episode duration
SELECT 
    ROUND(AVG(duration)) AS Average_duration
FROM
    Friends.Infos1;
-- 8. popular characters  (python) 
-- 9. top rated episodes of all time 
SELECT 
    *
FROM
    Friends.Infos1
ORDER BY stars DESC
LIMIT 5;
-- 10. bottom rated episodes 
SELECT 
    *
FROM
    Friends.Infos1
ORDER BY stars
LIMIT 5;
-- 11. Rating of episodes with Emily 
SELECT 
    stars, summary
FROM
    Friends.Infos1
WHERE
    Summary LIKE '%emily%'
ORDER BY stars;
-- 12. Average rating + votes by season 
SELECT 
    Season,
    ROUND(AVG(stars), 1) AS Rating,
    ROUND(AVG(votes)) AS Votes
FROM
    Friends.Infos1
GROUP BY season
ORDER BY season; 
-- 13. Average Rating by director + nb of episodes
SELECT 
    Director,
    ROUND(AVG(stars), 1) AS Rating,
    ROUND(AVG(votes)) AS Votes
FROM
    Friends.Infos1
GROUP BY Director; 

-- 14. top directors by rating 
SELECT 
    Director,
    ROUND(AVG(stars), 1) AS Rating,
    COUNT(episode_title) AS Episodes
FROM
    Friends.Infos1
GROUP BY Director
HAVING Episodes > 5
ORDER BY Rating DESC
LIMIT 5
; 
drop table if exists characters;
-- 15. average rating by featuring actors 
SELECT 
    'Joey', ROUND(AVG(stars), 1) AS Rating
FROM
    Friends.Infos1
WHERE
    Summary LIKE '%joey%' 
UNION ALL SELECT 
    'Phoebe', ROUND(AVG(stars), 1)
FROM
    Friends.Infos1
WHERE
    Summary LIKE '%phoebe%' 
UNION ALL SELECT 
    'Rachel', ROUND(AVG(stars), 1)
FROM
    Friends.Infos1
WHERE
    Summary LIKE '%rachel%' 
UNION ALL SELECT 
    'Monica', ROUND(AVG(stars), 1)
FROM
    Friends.Infos1
WHERE
    Summary LIKE '%monica%' 
UNION ALL SELECT 
    'Chandler', ROUND(AVG(stars), 1)
FROM
    Friends.Infos1
WHERE
    Summary LIKE '%chandler%' 
UNION ALL SELECT 
    'Ross', ROUND(AVG(stars), 1)
FROM
    Friends.Infos1
WHERE
    Summary LIKE '%ross%' 
UNION ALL SELECT 
    'the gang', ROUND(AVG(stars), 1)
FROM
    Friends.Infos1
WHERE
    Summary LIKE '%the gang%'
;

-- correlation betwwen views and ratings 
SELECT 
    A.season,
    A.episode_number,
    A.Episode_title,
    A.stars,
    A.votes,
    B.air_date,
    B.us_views_millions
FROM
    Friends.infos1 A
        JOIN
    Friends.infos2 B ON A.season = B.season
        AND A.episode_number = B.episode;

-- get the sentiments in the top 5 episodes  

SELECT 
    A.season,
    A.episode_number,
    A.stars,
    A.episode_title,
    B.emotion
FROM
    Friends.infos1 A
        JOIN
    Friends.sentiment B ON A.season = B.season
        AND A.episode_number = B.episode
;




