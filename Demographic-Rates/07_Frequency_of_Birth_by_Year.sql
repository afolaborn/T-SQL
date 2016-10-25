USE [ADSS]
GO
IF OBJECT_ID('cfb_Site_Birth_Freq') IS NOT NULL
	DROP VIEW cfb_Site_Birth_Freq
GO
CREATE VIEW cfb_Site_Birth_Freq 
AS
WITH AY AS ( 
	SELECT * 
	FROM  cfb_Years, cfb_PolVillage_Original
			)
SELECT   AY.Years
		,SUM(CASE WHEN i.Gender = 'F' THEN 1 ELSE 0 END) AS FemaleBirth
		,SUM(CASE WHEN i.Gender = 'M' THEN 1 ELSE 0 END) AS MaleBirth
		,SUM(CASE WHEN i.Id IS NULL THEN 0 ELSE 1 END)   AS TotalBirth
FROM Births b
	  JOIN Residences r ON r.residence = b.Residence
	  JOIN Pregnancies p ON p.Pregnancy = b.Pregnancy
	  JOIN Individuals i ON i.ID = r.ID
	  JOIN Individuals im ON im.ID = p.ID 
	  JOIN Locations l ON l.location = r.location	  
RIGHT JOIN AY ON AY.YYYY = YEAR(p.DeliveryDate)  
		--AND Years < = (SELECT MAX(DATEPART(YEAR,StartDate)) FROM CensusRounds)-1	
		AND AY.VilNo = l.Village
GROUP BY AY.Years

GO
/********************Test *******************/
SELECT *
FROM cfb_Site_Birth_Freq
--WHERE Years = 2008
ORDER BY Years