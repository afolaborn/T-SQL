USE ADSS
GO
IF OBJECT_ID('cfb_Site_MidYearPop_bySex_AgeGRoup_Current_Defacto') IS NOT NULL
	DROP VIEW cfb_Site_MidYearPop_bySex_AgeGRoup_Current_Defacto
GO
CREATE VIEW cfb_Site_MidYearPop_bySex_AgeGRoup_Current_Defacto
AS
WITH rs AS (
SELECT YEAR(ObservationDate) AS Year 
       ,Id , rs.ResMonths, rs.ResStatus
	   ,ROW_NUMBER()over (PARTITION by YEAR(ObservationDate),Id ORDER BY ObservationDate DESC )Rnk
FROM ResidentStatus rs
	 JOIN Observations o ON o.Observation=rs.Observation
WHERE YEAR(ObservationDate)=2015
)--115762
,AY AS ( 
	SELECT * 
	FROM  cfb_Years, cfb_AgeGroup, cfb_PolVillage_Current
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
WHERE i.Id IN (SELECT Id FROM rs WHERE Rnk=1)		
GROUP BY AY.Years,AY.AgeGroup, Ordered

GO
/********************Test *******************/
SELECT *
FROM cfb_Site_MidYearPop_bySex_AgeGRoup_Current_Defacto
WHERE Years = 2015 --AND Ordered BETWEEN 4 AND 17
ORDER BY Years, Ordered