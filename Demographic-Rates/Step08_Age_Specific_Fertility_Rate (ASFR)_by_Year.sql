USE [ADSS]
GO
IF OBJECT_ID('cfb_Site_Birth_ASFR') IS NOT NULL
	DROP VIEW cfb_Site_Birth_ASFR
GO
CREATE VIEW cfb_Site_Birth_ASFR 
AS
WITH AY AS ( 
SELECT * 
FROM  cfb_Years ,cfb_AgeGroup
--WHERE Years < (SELECT MAX(Years) FROM cfb_Years)
)
,FemPop10_49 AS ( 
SELECT   AY.Years,AY.AgeGroup
		,SUM(CASE WHEN Gender = 'F' THEN 1 END) AS FemalePop
FROM Individuals i 
	   JOIN Residences r ON r.Id = i.Id
 RIGHT JOIN  ay ON r.StartDate <= ay.MidYear AND r.EndDate > ay.MidYear
		AND FLOOR(DATEDIFF(DAY,i.DoB,ay.MidYear)/365.25) BETWEEN AY.Start_Age AND AY.Stop_Age 
WHERE  AY.Start_Age BETWEEN 10 and 45
GROUP BY AY.Years,AY.AgeGroup
)
SELECT   AY.Years
		,AY.AgeGroup
		,SUM(CASE WHEN i.Id IS NULL THEN 0 ELSE 1 END) AS TotalBirth
		,FemalePop
		,((SUM(CASE WHEN i.Id IS NULL THEN 0 ELSE 1 END))/CAST((NULLIF(FemalePop,0)) AS decimal(7,3))) AS ASFR
FROM Births b
		JOIN Residences r ON r.residence = b.Residence
		JOIN Pregnancies p ON p.Pregnancy = b.Pregnancy
		JOIN Individuals i ON i.ID = r.ID
		JOIN Individuals im ON im.ID = p.ID 
	    JOIN Locations l ON l.location = r.location		
		JOIN AY ON AY.YYYY = YEAR(p.DeliveryDate)  
		    AND FLOOR(DATEDIFF(DAY,im.DoB,i.DoB)/365.25) BETWEEN AY.Start_Age AND AY.Stop_Age
        JOIN FemPop10_49 fp ON fp.AgeGroup = AY.AgeGroup
							AND fp.Years =  ay.Years
WHERE AY.Start_Age BETWEEN 10 and 45
AND l.Village NOT IN ('00','23','24','25','26','29','30','31','32','33','34','35')
GROUP BY AY.Years,AY.AgeGroup,FemalePop

GO
/********************Test *******************/
SELECT *
FROM cfb_Site_Birth_ASFR
ORDER BY Years
