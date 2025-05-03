-- Title: EDA_layoffs.sql
SELECT *
FROM layoffs_staging2;

-- data date scope
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- most laid off
SELECT *
FROM layoffs_staging2
ORDER BY total_laid_off DESC;


-- total laid off by company
SELECT company_name, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company_name
ORDER BY 2 DESC;


-- total laid off by industry
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


-- total laid off by country
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- total laid off by date
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- total layoffs per month, grouped by year, 
---and to ranked by  months within each year by the number of laid off
SELECT 
    EXTRACT(YEAR FROM `date`) AS `year`,
    EXTRACT(MONTH FROM `date`) AS `month`,
    SUM(total_laid_off) AS monthly_layoffs,
    RANK() OVER (
        PARTITION BY EXTRACT(YEAR FROM `date`) 
        ORDER BY SUM(total_laid_off) DESC
    ) AS month_rank
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY EXTRACT(YEAR FROM `date`), EXTRACT(MONTH FROM `date`)
ORDER BY year, month_rank;


-- total laid off by year & month, with rolling total
SELECT 
    EXTRACT(YEAR FROM `date`) AS `year`,
    EXTRACT(MONTH FROM `date`) AS `month`,
    SUM(total_laid_off) AS monthly_layoffs,
    SUM(SUM(total_laid_off)) OVER (
        PARTITION BY EXTRACT(YEAR FROM `date`) 
        ORDER BY EXTRACT(MONTH FROM `date`)
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS rolling_total
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY EXTRACT(YEAR FROM `date`), EXTRACT(MONTH FROM `date`)
ORDER BY year, month;


-- total laid off with scope
SELECT
	MIN(`DATE`),
	MAX(`DATE`),
	SUM(total_laid_off) total_laid_off
FROM layoffs_staging2
ORDER BY 1 DESC;

-- total laid off by stage
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

----top 5 companies by number of layoffs in each year
SELECT *
FROM (
    SELECT 
        company_name,
        YEAR(`date`) AS layoff_year,
        SUM(total_laid_off) AS total_laid_off,
        RANK() OVER (
            PARTITION BY YEAR(`date`)
            ORDER BY SUM(total_laid_off) DESC
        ) AS layoff_rank
    FROM layoffs_staging2
    WHERE total_laid_off IS NOT NULL
    GROUP BY YEAR(`date`), company_name
) ranked
WHERE layoff_rank <= 5
ORDER BY layoff_year, layoff_rank;

-- ----top 5 industries by number of layoffs in each year
WITH Industry_Year (industry, years, total_laid_off) AS
(
SELECT industry, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry, YEAR(`date`)
), Industry_Year_Ranked AS
(
SELECT *,
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Industry_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Industry_Year_Ranked
WHERE Ranking <= 5
;
----Which industries/stages continue raising funds despite laying off employees?
SELECT 
    industry,
    stage,
    SUM(total_laid_off) AS total_laid_off,
    SUM(funds_raised_millions) AS total_funding_raised
FROM layoffs_staging2
WHERE funds_raised_millions > 0 AND total_laid_off > 0
GROUP BY industry, stage
ORDER BY total_funding_raised DESC, total_laid_off DESC;