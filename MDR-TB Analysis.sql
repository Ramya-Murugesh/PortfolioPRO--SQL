--select 
--  * 
--from 
--  [MDR-TB].[dbo].[Drug Resistant TB]
--order by 
--  YEAR;



--select 
--  * 
--from 
--  [MDR-TB].[dbo].[Treatment Success-TB]
--order by 
--  YEAR;


--Select required data to find Multi-drug resistant(MDR) TB cases
SELECT 
    mt.WHO_region, 
    mt.Year, 
    mt.[New_cases_tested_for_RR_MDR_TB] as Percentofnewcasestested, 
    mt.[Confirmed_cases_of_RR_MDR_TB] as percentofconfirmedcases, 
    mt.[Cases_started_on_MDR_TB_treatment] as numberofcasestreated, 
    ts.[Treatment_success_rate_for_patients_treated_for_MDR_TB] as numberofsuccesstreatment
FROM 
    [MDR-TB].[dbo].[Drug Resistant TB] mt 
JOIN 
    [MDR-TB].[dbo].[Treatment Success-TB] ts ON mt.WHO_region = ts.WHO_region AND mt.Year = ts.Year 
ORDER BY 
    mt.WHO_region, 
    mt.Year;


--Avg treatment success
SELECT 
    mt.WHO_region, 
    mt.Year, 
    mt.[New_cases_tested_for_RR_MDR_TB] AS Percentofnewcasestested, 
    mt.[Confirmed_cases_of_RR_MDR_TB] AS Percentofconfirmedcases, 
    mt.[Cases_started_on_MDR_TB_treatment] AS Numberofcasestreated, 
    ts.[Treatment_success_rate_for_patients_treated_for_MDR_TB] AS Numberofsuccesstreatment,
    AVG(ts.[Treatment_success_rate_for_patients_treated_for_MDR_TB]) OVER (PARTITION BY mt.WHO_region ) AS AvgTreatmentSuccessRate
FROM 
    [MDR-TB].[dbo].[Drug Resistant TB] mt 
JOIN 
    [MDR-TB].[dbo].[Treatment Success-TB] ts ON mt.WHO_region = ts.WHO_region AND mt.Year = ts.Year 
ORDER BY 
    mt.WHO_region, 
    mt.Year;


--Global values

 SELECT 
    mt.WHO_region,  
    SUM(mt.[New_cases_tested_for_RR_MDR_TB]) AS Totalcasestestedpercent, 
    SUM(mt.[Confirmed_cases_of_RR_MDR_TB]) AS TotalConfirmedcasespercent, 
    SUM(mt.[Cases_started_on_MDR_TB_treatment]) AS TotalcasesTreated, 
    SUM(ts.[Treatment_success_rate_for_patients_treated_for_MDR_TB]) AS Totalsuccessrate 
FROM 
    [MDR-TB].[dbo].[Drug Resistant TB] mt 
JOIN 
    [MDR-TB]. [dbo].[Treatment Success-TB]ts ON mt.WHO_region = ts.WHO_region AND mt.Year = ts.Year 
GROUP BY 
    mt.WHO_region 
ORDER BY 
    mt.WHO_region;

	--Global Percentage of cases treated

SELECT 
    mt.WHO_region,  
    SUM(TRY_CAST(mt.[New_cases_tested_for_RR_MDR_TB] AS float)) AS Totalcasestested, 
    SUM(mt.[Confirmed_cases_of_RR_MDR_TB]) AS TotalConfirmedcases, 
    SUM(mt.[Cases_started_on_MDR_TB_treatment]) AS TotalcasesTreated, 
    SUM(ts.[Treatment_success_rate_for_patients_treated_for_MDR_TB]) AS Totalsuccessrate,
	ROUND(SUM(ts.[Treatment_success_rate_for_patients_treated_for_MDR_TB]*1.0)/NULLIF(SUM(mt.[Cases_started_on_MDR_TB_treatment]) ,0),2) AS Averagesuccessrate
FROM 
    [MDR-TB].[dbo].[Drug Resistant TB] mt 
JOIN 
    [MDR-TB]. [dbo].[Treatment Success-TB]ts ON mt.WHO_region = ts.WHO_region AND mt.Year = ts.Year 
GROUP BY 
    mt.WHO_region 
ORDER BY 
    Averagesuccessrate desc;

--Treatment Success rates by year

 
 SELECT 
    Year, 
    AVG(Treatment_success_rate_for_patients_treated_for_MDR_TB) AS AvgSuccessRate
FROM 
    [MDR-TB].[dbo].[Treatment Success-TB]
GROUP BY 
    Year
ORDER BY 
    Year;

--Regional Comparison

SELECT 
  WHO_region,
  AVG(Treatment_success_rate_for_patients_treated_for_MDR_TB) AS AvgSuccessRate
FROM
  [MDR-TB].[dbo].[Treatment Success-TB]
GROUP BY 
    WHO_region;




