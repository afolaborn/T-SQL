USE [ADSS]
GO
IF OBJECT_ID('cfb_Site_OutMigCount_bySex') IS NOT NULL
	DROP VIEW cfb_Site_OutMigCount_bySex
GO
	CREATE VIEW cfb_Site_OutMigCount_bySex
	AS
WITH AY AS(
SELECT * 
FROM  cfb_Years, cfb_PolVillage_Original
		)
SELECT	 ay.Years
		,SUM(CASE WHEN Gender = 'M' THEN 1 ELSE 0 END) AS [TotMaleExt]
		,SUM(CASE WHEN Gender = 'F' THEN 1 ELSE 0 END) AS [TotFemaleExt]
		,SUM(CASE WHEN i.Id IS NOT NULL THEN 1 ElSE 0 END) AS [TotMigExtMig]
		,SUM(CASE WHEN Gender = 'M' AND InternalMigration = 1  THEN 1 ELSE 0 END) AS MaleOutMig
		,SUM(CASE WHEN Gender = 'F' AND InternalMigration = 1  THEN 1 ELSE 0 END) AS FemaleOutMig
		,SUM(CASE WHEN InternalMigration = 1 THEN 1 ElSE 0 END) [TotOutMig]
		,SUM(CASE WHEN Gender = 'M' AND InternalMigration = 0  THEN 1 ELSE 0 END) AS MaleExtMig
		,SUM(CASE WHEN Gender = 'F' AND InternalMigration = 0  THEN 1 ELSE 0 END) AS FemaleExtMig
		,SUM(CASE WHEN InternalMigration = 0  THEN 1 ElSE 0 END) [TotExtMig]
FROM OutMigrations m 
	  JOIN Residences r ON r.Residence = m.Residence
	  JOIN Individuals i ON i.ID = r.ID
	  JOIN Locations l ON l.location = r.location
RIGHT JOIN AY ON ay.Years = YEAR(EndDate)
		 AND i.Gender NOT IN('X','Q') 
		 AND Reason NOT IN ('DR','MS','ND','NF','NR')
		 AND AY.VilNo = l.Village
GROUP BY ay.Years

GO
/********************Test *******************/
SELECT *
FROM cfb_Site_OutMigCount_bySex
ORDER BY Years
