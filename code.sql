-- Use Database
USE BUDT702_Project_0501_01;
-- Business transactions, in WH-questions, to implement mission objectives.
-- What years of Full - time MBA had an employment rate greater than or equal to
90%?
GO
GO
DROP VIEW IF EXISTS Year_EmploymentRate_view
CREATE VIEW Year_EmploymentRate_view AS
SELECT y.facYear AS 'Year', y.facEmploymentRate AS 'Employment Rate'
FROM YearlyRankingFactors y
WHERE y.facEmploymentRate >= 90
AND y.prgId = (SELECT p.prgId FROM Program p WHERE p.prgName = 'Full-Time
MBA')
GO
SELECT *
FROM Year_EmploymentRate_view;
-- What is the program and its department with the highest average starting salary
in 2022?
GO
GO
DROP VIEW IF EXISTS Program_HighestAverageSalary_view
CREATE VIEW Program_HighestAverageSalary_view AS
SELECT TOP 1 p.prgName AS 'Program Name', d.depName AS 'Department Name'
FROM Program p
JOIN AcademicDepartment d ON p.depId = d.depId
JOIN YearlyRankingFactors y ON p.prgId = y.prgId
WHERE y.facYear = '2022'
ORDER BY y.facAvgStartSalary DESC
GO
SELECT *
FROM Program_HighestAverageSalary_view;
-- List all programs rankings by a website and try to analyze trend across years
GO
GO
DROP VIEW IF EXISTS Programs_Ranking_view
CREATE VIEW Programs_Ranking_view AS
SELECT p.prgName AS 'Program Name', y.facYear AS 'Year', r.rank
FROM Program p
JOIN YearlyRankingFactors y ON p.prgId = y.prgId
JOIN Ranks r ON y.prgId = r.prgId AND y.facYear = r.facYear
JOIN RankingWebsite w ON r.webId = w.webId
WHERE w.webName = 'US News'
GROUP BY p.prgName, y.facYear, r.rank
GO
SELECT *
FROM Programs_Ranking_view;
-- What is the return on investment for each program during 2022? (ROI = Employment
rate * average starting salary * 10 / tuition fee * program length in years)
GO
GO
DROP VIEW IF EXISTS Return_Inv_view
CREATE VIEW Return_Inv_view AS
SELECT p.prgName AS 'Program Name',
CAST((y.facEmploymentRate * y.facAvgStartSalary * 10) /
(y.facTuitionFees * p.prgDuration) AS DECIMAL(10,2)) AS 'Return on
Investment'
FROM Program p
JOIN YearlyRankingFactors y ON p.prgId = y.prgId
WHERE y.facYear = '2022'
GO
SELECT *
FROM Return_Inv_view;
