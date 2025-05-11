select *
from user_profiles;

select *
from viewership;

select *
from user_profiles as u
left join viewership as v on 
u.UserID = v.UserID
union 
select * from user_profiles as u
right join viewership as v on u.UserID = v.UserID;

select age,
case
	when age between 1 and 12 then 'kids'
    when age between 13 and 19 then 'teenager'
    when age between 20 and 35 then 'youth'
    when age between 36 and 50 then 'adult'
    when age between 51 and 65 then 'mature adult'
    when age > 65 then 'retired'
    else 'not applicable'
    End as 'age_distrubition'
from user_profiles;
    
Select *
from user_profiles;

select province, count(*) as view_count
from user_profiles
group by province;


select *
from viewership;



Select channel2, count(*) as channel_count
From viewership
Group by channel2;

SELECT 
    channel2,
    recorddate2,
    COUNT(*) AS view_count
FROM viewership
GROUP BY channel2, recorddate2
ORDER BY channel2, recorddate2 DESC;


select age, province, channel2,
CASE
	when age between 1 and 12 then 'kids'
    when age between 13 and 19 then 'teenager'
    when age between 20 and 35 then 'youth'
    when age between 36 and 50 then 'adult'
    when age between 51 and 65 then 'mature adult'
    when age > 65 then 'retired'
    Else 'unknown'
    END AS 'age_group',
from user_profiles,
join viewership on user_profiles.userID = viewership.userID
group by age_group, province, channel2
order by age_group;



SELECT province, channel2,
    CASE
        WHEN age BETWEEN 1 AND 12 THEN 'kids'
        WHEN age BETWEEN 13 AND 19 THEN 'teenager'
        WHEN age BETWEEN 20 AND 35 THEN 'youth'
        WHEN age BETWEEN 36 AND 50 THEN 'adult'
        WHEN age BETWEEN 51 AND 65 THEN 'mature adult'
        WHEN age > 65 THEN 'retired'
        ELSE 'unknown'
    END AS age_group,
    COUNT(*) AS view_count
FROM user_profiles
JOIN viewership ON user_profiles.userID = viewership.userID
GROUP BY age_group, province, channel2
ORDER BY age_group, view_count DESC;



SELECT 
    province, 
    channel2,
    CASE
        WHEN age BETWEEN 1 AND 12 THEN 'kids'
        WHEN age BETWEEN 13 AND 19 THEN 'teenager'
        WHEN age BETWEEN 20 AND 35 THEN 'youth'
        WHEN age BETWEEN 36 AND 50 THEN 'adult'
        WHEN age BETWEEN 51 AND 65 THEN 'mature adult'
        WHEN age > 65 THEN 'retired'
        ELSE 'unknown'
    END AS age_group,
    COUNT(*) AS view_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY province), 2) AS percentage
FROM 
    user_profiles
JOIN 
    viewership ON user_profiles.userID = viewership.userID
GROUP BY 
    province, 
    channel2,
    age_group
ORDER BY 
    province,
    age_group, 
    view_count DESC;
    
    
    SELECT 
    province,
    channel2,
    CASE
        WHEN age BETWEEN 1 AND 12 THEN 'kids'
        WHEN age BETWEEN 13 AND 19 THEN 'teenager'
        /* other age groups */
    END AS age_group,
    EXTRACT(HOUR FROM recorddate2) AS hour_of_day,
    COUNT(*) AS view_count
FROM 
    user_profiles
JOIN 
    viewership ON user_profiles.userID = viewership.userID
GROUP BY 
    province, 
    channel2,
    age_group,
    hour_of_day
ORDER BY 
    province,
    age_group,
    hour_of_day;
    
    
    WITH ranked_channels AS (
    SELECT 
        province,
        channel2,
        age_group,
        view_count,
        RANK() OVER (PARTITION BY province, age_group ORDER BY view_count DESC) AS rank
    FROM (
        SELECT 
            province,
            channel2,
            CASE
                WHEN age BETWEEN 1 AND 12 THEN 'kids'
                /* other age groups */
            END AS age_group,
            COUNT(*) AS view_count
        FROM 
            user_profiles
        JOIN 
            viewership ON user_profiles.userID = viewership.userID
        GROUP BY 
            province, channel2, age_group
    ) AS base_data
)
SELECT * FROM ranked_channels WHERE rank <= 5;


SELECT 
    province,
    channel2,
    age_group,
    AVG(duration) AS avg_duration,
SELECT 
        province,
        channel2,
        CASE
            WHEN age BETWEEN 1 AND 12 THEN 'kids'
            /* other age groups */
        END AS age_group,
        duration/60 AS duration_minutes  -- assuming duration is in seconds
    FROM 
        user_profiles
    JOIN 
        viewership ON user_profiles.userID = viewership.userID
) AS data
GROUP BY 
    province, channel2, age_group
ORDER BY 
    province, age_group, avg_duration DESC;



SELECT 
    province, 
    channel2,
    age_group,
    COUNT(*) AS view_count
FROM 
    user_profiles
JOIN 
    viewership ON user_profiles.userID = viewership.userID
WHERE 
    view_time BETWEEN '2024-01-01' AND '2024-03-31'  -- Q1 2024
GROUP BY 
    province, channel2, age_group
ORDER BY 
    view_count DESC;
    
    
    