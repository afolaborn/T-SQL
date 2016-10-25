USE [ADSS]
GO
IF OBJECT_ID('[cfb_Site_DeathCount_bySexAge]') IS NOT NULL
	DROP VIEW [cfb_Site_DeathCount_bySexAge]
GO
CREATE VIEW [cfb_Site_DeathCount_bySexAge]
AS
With AY AS(
	SELECT * 
	FROM  cfb_Years, cfb_PolVillage_Original
	)
SELECT		 AY.Years
			,FLOOR(DATEDIFF(DAY,i.DoB, i.DoD)/365.25)as Age
			,SUM(CASE WHEN i.Gender = 'M' THEN 1 ELSE 0 END) AS MaleDeaths
			,SUM(CASE WHEN i.Gender = 'F' THEN 1 ELSE 0 END) AS FemaleDeaths
			,SUM(CASE WHEN d.ID IS NULL THEN 0 ELSE 1 END)  AS TotalDeaths
FROM Deaths d 
		JOIN Residences r ON r.Residence = d.Residence
		JOIN Individuals i ON i.ID = r.ID
		JOIN Locations l ON l.Location = r.Location
  RIGHT JOIN AY ON ay.Years = DATEPART(YEAR,i.DoD)
		AND AY.VilNo = l.Village
		    --AND	Years < = (SELECT MAX(DATEPART(YEAR,StartDate)) FROM CensusRounds)-1	
GROUP BY AY.Years
		,FLOOR(DATEDIFF(DAY,i.DoB, i.DoD)/365.25)

GO

select *
from [cfb_Site_DeathCount_bySexAge]
ORDER By Years, Age
