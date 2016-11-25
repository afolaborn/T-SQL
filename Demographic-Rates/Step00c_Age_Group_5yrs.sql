USE ADSS
GO
IF OBJECT_ID('cfb_AgeGroup') IS NOT NULL
	DROP VIEW cfb_AgeGroup
GO
CREATE VIEW cfb_AgeGroup 
	AS
WITH A AS
      (
		SELECT CAST(0.00 AS decimal(5,2)) AS Start_Age
            ,CAST(4 AS decimal(5,2)) AS Stop_Age
				,0 AS Recursion
		UNION
		SELECT CAST(5 AS decimal(5,2))
				,CAST(9 AS decimal(5,2))
				,2
		UNION
		SELECT CAST(95 AS decimal(5,2))
				,CAST(130 AS decimal(5,2))
				,20
		UNION ALL
		SELECT CAST(Start_Age + 5 AS decimal(5,2))
                  ,CAST(Stop_Age + 5 AS decimal(5,2))
                  ,Recursion = 2
		FROM A
		WHERE A.Stop_Age <= 95.00 - 5.00 
			AND Start_Age%5.00 = 0.00 AND Start_Age <> 0.00 
      )
SELECT CASE WHEN Start_Age = 95 THEN '95+'
			   WHEN Start_Age = 0  AND Stop_Age = 0 THEN '0'
				ELSE REPLACE(CAST(Start_Age AS varchar(10)),'.00','') + '-' + REPLACE(CAST(Stop_Age AS varchar(10)),'.00','') END AS AgeGroup
,Start_Age,Stop_Age,ROW_NUMBER() OVER(ORDER BY Start_Age) AS Ordered
FROM A 

GO
/********************Test *******************/
SELECT *
FROM cfb_AgeGroup
