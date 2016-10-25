USE ADSS
IF OBJECT_ID('cfb_Site_MidYearPop_5to19yrs') IS NOT NULL
	DROP VIEW cfb_Site_MidYearPop_5to19yrs
GO
	CREATE VIEW cfb_Site_MidYearPop_5to19yrs 
 AS
With AY AS(
	SELECT * 
	FROM  cfb_Years, cfb_PolVillage_Original
	)
SELECT   ay.Years
		,'5-19' as Age
		,SUM(CASE WHEN Gender = 'M' THEN 1 ELSE 0 END) AS MalePop
		,SUM(CASE WHEN Gender = 'F' THEN 1 ELSE 0 END) AS FemalePop
		,SUM(CASE WHEN i.Id IS NOT NULL THEN 1 ELSE 0 END) AS MidYearPop
FROM Individuals i 
		JOIN Residences r ON r.Id = i.Id
	    JOIN Locations l ON l.location = r.location		
  RIGHT JOIN AY ON AY.MidYear >= r.StartDate AND AY.MidYear < r.EndDate 
		AND i.Gender NOT IN('X','Q') 
		AND FLOOR(DATEDIFF(DAY,i.DoB,aY.MIDYEAR)/365.25) BETWEEN 5 AND 19
		AND ay.VilNo = l.Village
GROUP BY ay.Years


GO
/********************Test *******************/
SELECT *
FROM cfb_Site_MidYearPop_5to19yrs
ORDER BY Years