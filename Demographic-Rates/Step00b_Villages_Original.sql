USE [ADSS]
GO
IF OBJECT_ID('cfb_PolVillage_Original') IS NOT NULL
	DROP VIEW cfb_PolVillage_Original
GO
CREATE VIEW cfb_PolVillage_Original 
	AS
	SELECT DISTINCT l.PoliticalVillage AS VilNo
		   ,V.Name AS Village
FROM Locations l
JOIN Villages v  ON l.PoliticalVillage=v.Village
WHERE l.Village NOT IN ('00','23','24','25','26','29','30','31','32','33','34','35','38')
GO
SELECT *
FROM cfb_PolVillage_Original
ORDER BY VilNo
