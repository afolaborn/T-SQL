USE ADSS
GO
IF OBJECT_ID('cfb_Site_HouseholdFreq') IS NOT NULL
	DROP VIEW cfb_Site_HouseholdFreq
GO
CREATE VIEW cfb_Site_HouseholdFreq
AS
WITH AY AS (
	SELECT * 
	FROM  cfb_Years, cfb_PolVillage_Original
	)
SELECT AY.Years
	  ,COUNT(DISTINCT h.Household) AS HouseholdCnt
FROM  Households h 
	  JOIN Locations l ON l.Location = h.Location
      JOIN AY ON AY.MidYear >= HHEstablished AND AY.MidYear < HHDisolved
	   AND AY.VilNo=l.PoliticalVillage
GROUP BY ay.Years


GO
/********************Test *******************/
SELECT *
FROM cfb_Site_HouseholdFreq
--WHERE Years = 2008
ORDER BY  Years

