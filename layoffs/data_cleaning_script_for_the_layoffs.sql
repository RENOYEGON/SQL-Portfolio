--- data cleaning script for the layoffs dataset
--- First we insert data into the staging table from the original table
-- This is useful for data validation and testing before moving data to the final table.
-- It allows you to check the data in the staging table before finalizing it.


SELECT *
FROM layoffs;

-- Create Staging Table

CREATE TABLE layoffs_staging
LIKE layoffs;
SELECT *
FROM layoffs_staging;
INSERT layoffs_staging
SELECT *
FROM layoffs;
-- Check the data in the staging table
SELECT * FROM layoffs_staging;
-- Create Final Table

ALTER TABLE layoffs_staging
DROP COLUMN `Source`,
DROP COLUMN `Date Added`;

SELECT * FROM layoffs_staging;


--- Rename Columns and Modify Data Types
ALTER TABLE layoffs_staging
RENAME COLUMN `company` TO `company_name`,
RENAME COLUMN `Location HQ` TO `location`,
RENAME COLUMN `# Laid Off` TO `total_laid_off`,
RENAME COLUMN `Date` TO `date`,
RENAME COLUMN `%` TO `percentage_laid_off`,
RENAME COLUMN `Industry` TO `industry`,
RENAME COLUMN `Stage` TO `stage`,
RENAME COLUMN `$ Raised (mm)` TO `funds_raised_millions`,
RENAME COLUMN `Country` TO `country`;

ALTER TABLE layoffs_staging
MODIFY COLUMN `company_name` VARCHAR(255),
MODIFY COLUMN `location` VARCHAR(255),
MODIFY COLUMN `total_laid_off` INT,
MODIFY COLUMN `date` VARCHAR(255),
MODIFY COLUMN `percentage_laid_off` VARCHAR(255),
MODIFY COLUMN `industry` VARCHAR(255),
MODIFY COLUMN `stage` VARCHAR(255),
MODIFY COLUMN `funds_raised_millions` VARCHAR(255),
MODIFY COLUMN `country` VARCHAR(255);


-- checking duplicate values in the staging table
--🔍 Step 1: Use a CTE to tag duplicates

WITH duplicates AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY company_name, location, total_laid_off, date, industry, stage, funds_raised_millions, country
           ORDER BY row_num
         ) AS rn
  FROM layoffs_staging
)

-- 🔍 Select duplicates
SELECT *
FROM duplicates
WHERE rn > 1;

--we  ran into issues with ctes so we Create the layoffs_staging2 table with the same structure as layoffs_staging

CREATE TABLE `layoffs_staging2` (
  `company_name` VARCHAR(255) DEFAULT NULL,
  `location` VARCHAR(255) DEFAULT NULL,
  `industry` VARCHAR(255) DEFAULT NULL,
  `total_laid_off` INT DEFAULT NULL,
  `percentage_laid_off` VARCHAR(255) DEFAULT NULL,
  `date` VARCHAR(255) DEFAULT NULL,
  `stage` VARCHAR(255) DEFAULT NULL,
  `country` VARCHAR(255) DEFAULT NULL,
  `funds_raised_millions` VARCHAR(255) DEFAULT NULL,
  `row_num` INT
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoffs_staging2;
-- Insert relevant columns and add row_num for identifying duplicates
-- insert the columns and add the row_num for each row
INSERT INTO layoffs_staging2 (
  company_name, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions, row_num
)
SELECT
  company_name,
  location,
  industry,
  total_laid_off,
  percentage_laid_off,
  `date`,
  stage,
  country,
  funds_raised_millions,
  ROW_NUMBER() OVER (
    PARTITION BY company_name, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
    ORDER BY company_name 
  ) AS row_num
FROM layoffs_staging;

---check the duplicates
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;
---- Delete duplicates from the staging table
DELETE FROM layoffs_staging2
WHERE row_num > 1;


SELECT *
FROM layoffs_staging2;

-- Turn date column into date datatype

SELECT `date`
FROM layoffs_staging2;

SELECT `date`
FROM layoffs_staging2;
---convert it into a proper MySQL DATE (YYYY-MM-DD) format.
---test before updating
SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y') AS converted_date
FROM layoffs_staging2;
---Update the table with properly converted DATE values
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
--- Change the column to DATE datatype
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

-- Remove rows with no value to us; in this case, where the relevant values are NULL

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2
WHERE NOT country = 'United States';
--- Check for non-U.S. companies with "Non-U.S." in the location column
SELECT company_name, location, country
FROM layoffs_staging2
WHERE country != 'United States'
  AND LOWER(location) NOT LIKE '%non-u.s.%';
--- Add "Non-U.S." to the location for non-U.S. companies
UPDATE layoffs_staging2
SET location = CONCAT(location, ', Non-U.S.')
WHERE country != 'United States'
  AND LOWER(location) NOT LIKE '%non-u.s.%';

--- Check for NULL values in the industry column
--- If NULL, set to 'Other'
UPDATE layoffs_staging2
SET industry = 'Other'
WHERE industry IS NULL;

SELECT * FROM layoffs_staging2;
select COUNT (*) as totalnulls
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
---Check for trailing periods in the country column
SELECT *
FROM layoffs_staging2
WHERE country LIKE '%.';
---- Check for trailing periods in the country column
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;
--- update for trailing periods in the country column
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE '%.%';

--- Check for trailing periods in the company_name column
SELECT company_name, TRIM(company_name)
FROM layoffs_staging2;
---- update company_name column with trailing periods
UPDATE layoffs_staging2
SET company_name = TRIM(company_name)
WHERE company_name LIKE '%.';
---clean the trailing dot (.) from such entries
SELECT *
FROM layoffs_staging2
WHERE company_name LIKE '%.';
---updating entries with trailing dots (.) 
UPDATE layoffs_staging2
SET company_name = TRIM(TRAILING '.' FROM company_name)
WHERE company_name LIKE '%.';

SELECT funds_raised_millions
FROM layoffs_staging2
ORDER BY 1 DESC;

UPDATE layoffs_staging2
SET funds_raised_millions = NULL
WHERE funds_raised_millions = 'NULL';


--- Check for non-numeric values in the funds_raised_millions column
UPDATE layoffs_staging2
SET funds_raised_millions = REPLACE(REPLACE(funds_raised_millions, '$', ''), ',', '')
WHERE funds_raised_millions IS NOT NULL;
---Convert the column to INT datatype
ALTER TABLE layoffs_staging2
MODIFY COLUMN funds_raised_millions INT;

-- Remove Any Columns
---I'm doing analysis that requires numeric layoff counts, or
---I want to work only with complete and reliable data.

DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL 
  AND percentage_laid_off IS NOT NULL 
  AND funds_raised_millions IS NOT NULL;


DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL 
  AND percentage_laid_off IS NOT NULL 
  AND funds_raised_millions IS  NULL;
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;