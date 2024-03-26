use call_center;
/*combine the tables*/
(SELECT 
    ccd.*, cccd.city, cccd.state, cccd.yob
FROM
    call_center_data ccd
        JOIN
    call_center_customer_data cccd ON ccd.id = cccd.id);
    
    
/*Agents who responded in timely manner*/
SELECT 
    agent_id, response_time,count(*) as num_calls
FROM
    call_center_data
WHERE
    response_time IN ('Below SLA' , 'Within SLA')
GROUP BY agent_id,response_time
ORDER BY num_calls Desc;

SELECT DISTINCT
    (agent_id), response_time
FROM
    call_center_data
ORDER BY agent_id;


SELECT 
    agent_id, response_time,count(*) as num_calls
FROM
    call_center_data
WHERE
    response_time = 'Above SLA'
GROUP BY agent_id,response_time
ORDER BY num_calls Desc;
    
SELECT 
    COUNT(DISTINCT (agent_id)), response_time
FROM
    call_center_data
WHERE
    response_time IN ('Below SLA' , 'Within SLA')
GROUP BY response_time;
    
SELECT 
    COUNT(DISTINCT (agent_id)), response_time
FROM
    call_center_data
WHERE
    response_time = 'Above SLA';


    


/*No. of records for each response time*/

SELECT 
    'Below SLA' AS response_time, COUNT(*) AS num_records
FROM
    call_center_data
WHERE
    response_time = 'Below SLA' 
UNION ALL SELECT 
    'Within SLA' AS response_time, COUNT(*) AS num_records
FROM
    call_center_data
WHERE
    response_time = 'Within SLA' 
UNION ALL SELECT 
    'Above SLA' AS response_time, COUNT(*) AS num_records
FROM
    call_center_data
WHERE
    response_time = 'Above SLA';


/*csat_score for agents with Above SLA response time*/    

SELECT DISTINCT
    (agent_id), csat_score, response_time
FROM
    call_center_data
WHERE
    response_time = 'Above SLA'
ORDER BY agent_id;


/*Loyal Customers and their states*/


SELECT 
    ccd.customer_name,
    ccd.call_center,
    cccd.city,
    cccd.state,
    cccd.yob
FROM
    call_center_data ccd
        JOIN
    call_center_customer_data cccd ON ccd.id = cccd.id
WHERE
    cccd.yob > 5
ORDER BY cccd.yob DESC;

/*(SELECT 
    ccd.*, cccd.city, cccd.state, cccd.yob
FROM
    call_center_data ccd
        JOIN
    call_center_customer_data cccd ON ccd.id = cccd.id);*/

SELECT 
    call_center, sentiment, csat_score, response_time
FROM
    call_center_data
WHERE
    csat_score > 5
        AND response_time = 'Below SLA'
        OR response_time = 'Within SLA'
        AND sentiment IN ('Neutral' , 'Positive', 'Very Positive');

/*Call centers with no scat_score*/

SELECT 
    call_center, sentiment, csat_score, response_time
FROM
    call_center_data
WHERE
    (csat_score = '' OR csat_score IS NULL)
        AND response_time IN ('Below SLA' , 'Within SLA')
        AND sentiment IN ('Neutral' , 'Positive', 'Very Positive')
ORDER BY response_time;

/*Total No. of call centers with no csat_score*/

SELECT 
    COUNT(*)
FROM
    call_center_data
WHERE
    csat_score = '' OR csat_score IS NULL;

/*Call center wise details*/

SELECT 
    call_center, COUNT(*) AS num_of_empty_csat
FROM
    call_center_data
WHERE
    csat_score = '' OR csat_score IS NULL
GROUP BY call_center
ORDER BY num_of_empty_csat DESC;
    
    
/*No. of call centers who performed well but has no csat_score*/

SELECT 
    COUNT(*)
FROM
    call_center_data
WHERE
    (csat_score = '' OR csat_score IS NULL)
        AND response_time IN ('Below SLA' , 'Within SLA')
        AND sentiment IN ('Neutral' , 'Positive', 'Very Positive');
 
/*Call center wise details--- */
 
SELECT 
    call_center, COUNT(*) AS num_of_empty_csat
FROM
    call_center_data
WHERE
    (csat_score = '' OR csat_score IS NULL)
        AND response_time IN ('Below SLA' , 'Within SLA')
        AND sentiment IN ('Neutral' , 'Positive', 'Very Positive')
GROUP BY call_center
ORDER BY num_of_empty_csat DESC;

/*Average Customer Satisfaction Score*/

SELECT 
    call_center,
    AVG(CAST(csat_score AS DECIMAL)) AS avg_csat_score
FROM
    call_center_data
GROUP BY call_center;

/*Number of calls for each response time*/

SELECT 
    call_center, response_time, COUNT(*) AS num_calls
FROM
    call_center_data
GROUP BY call_center , response_time;

/*NO. of calls for Call centers that performed well based on response time*/

SELECT 
    call_center, response_time, COUNT(*) AS num_calls
FROM
    call_center_data
WHERE
    response_time IN ('Below SLA' , 'Within SLA')
GROUP BY response_time , call_center
ORDER BY num_calls DESC;

/*Based on Sentiment*/

SELECT 
    call_center, sentiment, COUNT(*) AS num_calls
FROM
    call_center_data
GROUP BY call_center , sentiment;

/*Count of calls with good performance -call center wise*/

SELECT 
    call_center, sentiment, COUNT(*) AS num_calls
FROM
    call_center_data
WHERE
    sentiment IN ('Neutral' , 'Positive', 'Very Positive')
GROUP BY call_center , sentiment
ORDER BY num_calls DESC;

/*Count of calls based on sentiment -channel wise*/

SELECT 
    channel, sentiment, COUNT(*) AS num_calls
FROM
    call_center_data
WHERE
    sentiment IN ('Neutral' , 'Positive', 'Very Positive')
GROUP BY channel , sentiment
ORDER BY num_calls DESC;

/*Channel wise average csat_score*/

SELECT 
    channel, AVG(CAST(csat_score AS DECIMAL)) AS avg_csat_score
FROM
    call_center_data
WHERE
    csat_score != ''
        AND csat_score IS NOT NULL
GROUP BY channel
ORDER BY avg_csat_score DESC;

/*Call center wise*/

SELECT 
    call_center,
    AVG(CAST(csat_score AS DECIMAL)) AS avg_csat_score
FROM
    call_center_data
WHERE
    csat_score != ''
        AND csat_score IS NOT NULL
GROUP BY call_center
ORDER BY avg_csat_score DESC;


/*Average call duration in each call centers*/

SELECT 
    call_center,
    AVG(`call duration in minutes`) AS avg_call_duration
FROM
    call_center_data
GROUP BY call_center
ORDER BY avg_call_duration DESC;

/*Customers feelings*/

SELECT 
    sentiment, COUNT(*) AS num_customers
FROM
    call_center_data
GROUP BY sentiment
ORDER BY num_customers DESC;

/*Call center wise*/

SELECT 
    call_center, sentiment, COUNT(*) AS num_customers
FROM
    call_center_data
GROUP BY sentiment , call_center
ORDER BY call_center , num_customers DESC;













