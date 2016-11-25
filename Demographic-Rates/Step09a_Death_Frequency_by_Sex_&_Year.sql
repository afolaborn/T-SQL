USE [ADSS]
GO
IF OBJECT_ID('cfb_Site_DeathCount_bySex') IS NOT NULL
	DROP VIEW cfb_Site_DeathCount_bySex
GO
CREATE VIEW cfb_Site_DeathCount_bySex
AS
With AY AS(
	SELECT * 
	FROM  cfb_Years, cfb_PolVillage_Original
		--WHERE Years < (SELECT MAX(Years) FROM cfb_Years)
	)
SELECT		 AY.Years
			,SUM(CASE WHEN i.Gender = 'M' THEN 1 ELSE 0 END) AS MaleDeaths
			,SUM(CASE WHEN i.Gender = 'F' THEN 1 ELSE 0 END) AS FemaleDeaths
			,SUM(CASE WHEN d.ID IS NULL THEN 0 ELSE 1 END)  AS TotalDeaths
FROM Deaths d 
		JOIN Residences r ON r.Residence = d.Residence
		JOIN Individuals i ON i.ID = r.ID
		JOIN Locations l ON l.location = r.location
  RIGHT JOIN AY ON ay.Years = DATEPART(YEAR,i.DoD)
  		 AND AY.VilNo = l.Village
GROUP BY AY.Years

GO
/********************Test *******************/
SELECT *
FROM cfb_Site_DeathCount_bySex
--WHERE Years = 2008
ORDER BY Years
