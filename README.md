# Analysing Data From the Friends TV Show      

This analysis of the the Friends TV Show dataset provides some insights on the rating trends in all 236 episodes. The goal is to find answers on what really made a good Friends episode. Being a big fan of the show myself, I had my own preferences in terms of episodes. It was interesting to dive deep into the data and discover whether people shared the same preferences and whether there are hidden trends behind those choices.

## Insights 

 In order to feed our curiosity about what really effects the ratings in the show. We tried to provide some answers to different questions : 
 - What are the top rated episodes of all? Top episodes per season?   
 - Who were the most successful directors in the show?  
 - Which seasons had the most votes and best ratings?
 - Does the presence of certain emotions or a certain character influence the ratings? 
 - Is there a relationship between the number of votes and the ratings? i.e. does more votes lead to better ratings? 

## Steps

 1. Gathering data : the dataset was collected from Kaggle and Github and joined at a certain step of our project. 
 2. Data wrangling : handling duplicates  and column names using **mySQL** 
 3.  Data Querying and Exploring: using **mySQL** 
 4.  Data Visualisation: Exporting data and Visualising it using **Tableau public**  
## Dataset 
Our data-set contains information  (236 records) about Friends episodes, including IMDB ratings from two different data sources: 

 1. The friends dataset from [Kaggle](https://www.kaggle.com/datasets/rezaghari/friends-series-dataset?select=friends_episodes_v3.csv) which contains information about episodes : 

| Year_of_production | Season  | Episode_number | Episode_title | Duration | Summary | Director | Stars | Votes | 
|--|--|--|--|--|--|--|--|--|

 2. The Friends emotion dataset which provides emotions with every dialogue for each episode. This dataset was from the [Tidy Tuesday Challenge on Github](https://github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-09-08/readme.md )

| season  | episode | scene | utterance | emotion | 
|--|--|--|--|--|
## Sample  SQL Queries 
All queries [here.](https://github.com/aouataf-djillani/Friends-TV-Show-Analysis/blob/master/source/Exploring.sql) 

**EDA :**
 - Remove space from column name 
```sql
alter table Friends.Infos1
rename column `Episode Number` to Episode_number; 
 - Find duplicates 
```sql
SELECT 
    Episode_Title, COUNT(Episode_Title)
FROM
    Friends.Infos1
GROUP BY Episode_Title
HAVING COUNT(Episode_Title) > 1;
```sql
SELECT 
    Industry, COUNT(Industry) AS num_postings
FROM
    job_postings
GROUP BY Industry
ORDER BY num_postings DESC
LIMIT 15;  
```
 - Rename duplicate episodes ( double episodes) 
```sql
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
```
**Queries**
 - Average rating
```sql
SELECT 
    ROUND(AVG(stars), 1) AS Stars
FROM
    Friends.Infos1;
```
 - Total number of seasons
```sql
SELECT 
    COUNT(DISTINCT (Season)) as Seasons
FROM
    Friends.Infos1; 
```
 - Top rated episodes of all time 
```sql
SELECT 
    *
FROM
    Friends.Infos1
ORDER BY stars DESC
LIMIT 4;
```
 -  Average rating + votes by season 
```sql
SELECT 
    Season,
    ROUND(AVG(stars), 1) AS Rating,
    ROUND(AVG(votes)) AS Votes
FROM
    Friends.Infos1
GROUP BY season
ORDER BY season; 
```
 -  Top directors by rating
```sql
SELECT 
    Director,
    ROUND(AVG(stars), 1) AS Rating,
    COUNT(episode_title) AS Episodes
FROM
    Friends.Infos1
GROUP BY Director
HAVING Episodes > 5
ORDER BY Rating DESC
LIMIT 4
; 
```
 - Average rating by featuring actors 
```sql
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
```
 - In-demand programming languages in this field 
```sql
SELECT 
    CASE
        WHEN Requirements LIKE '%Python%' THEN 'Python'
        WHEN Requirements LIKE '% R %' THEN 'R'
        WHEN Requirements LIKE '%sql%' THEN 'sql'
        WHEN Requirements LIKE '%NoSql%' THEN 'NoSql'
        ELSE 'Not specified'
    END AS programming_tools,
    COUNT(*)
FROM
    job_postings
GROUP BY (CASE
    WHEN Requirements LIKE '%Python%' THEN 'Python'
    WHEN Requirements LIKE '% R %' THEN 'R'
    WHEN Requirements LIKE '%sql%' THEN 'sql'
    WHEN Requirements LIKE '%NoSql%' THEN 'NoSql'
    ELSE 'Not specified'
END);
```
 - Most popular job titles on LinkedIn 
```sql
SELECT 
    Title, COUNT(Title)
FROM
    job_postings
GROUP BY title
ORDER BY COUNT(Title) DESC
LIMIT 15;
```
## Results 
![Dashboard (2)](https://user-images.githubusercontent.com/54501663/191886379-6757d372-1620-419b-aa10-f5665a30b5ef.png)

 The result of our analysis shows that there is positive correlation between the number of votes and ratings. 
 
 Peoples tend to prefer Episodes that are:
 - Produced by Kevin Bright, James Burrow, Peter Benerz and Michael Lembeck ;
 - Feature the whole gang ( episodes featuring Joey and Phoebe were the least favourite which is strange) ;
 - Sentiments do impact the rating as sad episodes are the least favoured for instance.   
 
 

 


