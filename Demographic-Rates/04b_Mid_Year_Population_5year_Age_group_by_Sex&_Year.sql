USE ADSS
GO
IF OBJECT_ID('cfb_Site_MidYearPop_bySex_AgeGRoup') IS NOT NULL
	DROP VIEW cfb_Site_MidYearPop_bySex_AgeGRoup
GO
CREATE VIEW cfb_Site_MidYearPop_bySex_AgeGRoup
AS
WITH AY AS ( 
	SELECT * 
	FROM  cfb_Years, cfb_AgeGroup, cfb_PolVillage_Original
			)
SELECT   AY.Years
	    ,AY.Ordered
        ,AY.AgeGroup
		,SUM(CASE WHEN Gender = 'M' THEN 1 ELSE 0 END) AS MalePop
		,SUM(CASE WHEN Gender = 'F' THEN 1 ELSE 0 END) AS FemalePop
		,SUM(CASE WHEN i.Id IS NOT NULL THEN 1 ELSE 0 END) AS MidYearPop
FROM Individuals i 
	   JOIN Residences r ON r.Id = i.Id
	   JOIN Locations l ON l.location = r.location
 RIGHT JOIN AY ON ay.MidYear >= r.StartDate AND ay.MidYear < r.EndDate 
		AND FLOOR(DATEDIFF(DAY,i.DoB,ay.MidYear)/365.25) BETWEEN AY.Start_Age AND AY.Stop_Age  
		AND AY.VilNo = l.Village
GROUP BY AY.Years,AY.AgeGroup, Ordered

GO
/********************Test *******************/
SELECT *
FROM cfb_Site_MidYearPop_bySex_AgeGRoup
WHERE Years = 2015 AND Ordered BETWEEN 4 AND 17
ORDER BY Years, Ordered