USE [ADSS]
Go
IF OBJECT_ID('cfb_Site_InMigCount_bySex') IS NOT NULL
	DROP VIEW cfb_Site_InMigCount_bySex
GO
  CREATE VIEW cfb_Site_InMigCount_bySex
	AS
With AY AS(
	SELECT * 
	FROM  cfb_Years, cfb_PolVillage_Original
	--WHERE Years < (SELECT MAX(Years) FROM cfb_Years)
	)
SELECT 	 ay.Years
		,SUM(CASE WHEN Gender = 'M' THEN 1 ELSE 0 END) AS [MaleIn&Int]
		,SUM(CASE WHEN Gender = 'F' THEN 1 ELSE 0 END) AS [FemaleIn&Int]
		,SUM(CASE WHEN i.Id IS NOT NULL THEN 1 ElSE 0 END) AS [TotInMig&lntMig]	
		,SUM(CASE WHEN Gender = 'M' AND InternalMigration = 1 THEN 1 ELSE 0 END) AS MaleInMig
		,SUM(CASE WHEN Gender = 'F' AND InternalMigration = 1 THEN 1 ELSE 0 END) AS FemaleInMig
		,SUM(CASE WHEN InternalMigration = 1 THEN 1 ElSE 0 END) [TotInMig]
		,SUM(CASE WHEN Gender = 'M' AND InternalMigration = 0 THEN 1 ELSE 0 END) AS MaleIntMig
		,SUM(CASE WHEN Gender = 'F' AND InternalMigration = 0 THEN 1 ELSE 0 END) AS FemaleIntMig
		,SUM(CASE WHEN InternalMigration = 0 THEN 1 ElSE 0 END) [TotlntMig]
FROM InMigrations im 
	  JOIN Residences r ON r.Residence = im.Residence
	  JOIN Individuals i ON i.ID = r.ID
	  JOIN Locations l ON l.location = r.location
RIGHT JOIN AY ON ay.Years = DATEPART (YEAR,StartDate)
	    AND StartDate <> ISNULL(DOB,'18000101')
		AND Reason NOT IN ('DR','MS','ND','NF','NR')
	    AND i.Gender NOT IN('X','Q') 
	    AND AY.VilNo = l.Village
	    --AND Years < = (SELECT MAX(DATEPART(YEAR,StartDate)) FROM CensusRounds)-1 	
GROUP BY ay.Years

GO
/********************Test *******************/
SELECT *
FROM cfb_Site_InMigCount_bySex
--WHERE Years = 2008
ORDER BY Years
