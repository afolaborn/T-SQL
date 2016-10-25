USE ADSS
IF OBJECT_ID('cfb_Site_MidYearPop_bySex') IS NOT NULL
	DROP VIEW cfb_Site_MidYearPop_bySex
GO
	CREATE VIEW cfb_Site_MidYearPop_bySex AS
WITH AY AS(
	SELECT * 
	FROM  cfb_Years, cfb_PolVillage_Original
	)
SELECT   ay.Years
		,SUM(CASE WHEN Gender = 'M' THEN 1 ELSE 0 END) AS MalePop
		,SUM(CASE WHEN Gender = 'F' THEN 1 ELSE 0 END) AS FemalePop
		,SUM(CASE WHEN i.Id IS NOT NULL THEN 1 ELSE 0 END) AS MidYearPop
FROM Individuals i 
		JOIN Residences r ON r.Id = i.Id
	    JOIN Locations l ON l.location = r.location
  RIGHT JOIN AY ON AY.MidYear >= r.StartDate AND AY.MidYear < r.EndDate
  	   AND ay.VilNo = l.Village 
		--AND i.Gender NOT IN('X','Q') 
GROUP BY ay.Years 

GO
/********************Test *******************/
SELECT *
FROM cfb_Site_MidYearPop_bySex
--WHERE Years in (1992,1998,2004,2010)
ORDER BY Years
--WHERE Years = 2008


