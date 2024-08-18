-- Data Cleaning project

-- step 1 : Remove Duplicates

-- step 2 : Standardize the Data

-- step 3 : Null values or Blank values

-- step 4 : Remove any columns Or Rows

SELECT *
FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY
 company, industry, total_laid_off, percentage_laid_off,`date`) AS row_numb
FROM layoffs_staging;

-- Show Duplicated Data
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY
company, location ,industry, total_laid_off, percentage_laid_off,`date`, stage, 
country, funds_raised_millions) AS row_numb
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_numb > 1
;


-- Test Upper Code

SELECT *
FROM layoffs_staging
WHERE company = 'Yahoo'
;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  -- add row_numb
  `row_numb` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



SELECT *
FROM layoffs_staging2;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY
company, location ,industry, total_laid_off, percentage_laid_off,`date`, stage, 
country, funds_raised_millions) AS row_numb
FROM layoffs_staging;


SELECT *
FROM layoffs_staging2
WHERE row_numb > 1;

DELETE 
FROM layoffs_staging2
WHERE row_numb > 1;


-- standardizing data

SELECT company, TRIM(company)
FROM layoffs_staging2
;


UPDATE layoffs_staging2
SET company = TRIM(company)
;


SELECT DISTINCT industry
FROM layoffs_staging2
;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%'
;


UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'
;

SELECT DISTINCT industry
FROM layoffs_staging2
;


SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;


SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'
;


SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;


UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%'
;

SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE (`date`, '%m/%d/%y')
;


ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE 
;

SELECT *
FROM layoffs_staging2;

-- STEP 3

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';


SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb'
;


SELECT *
FROM layoffs_staging2 AS t1
INNER JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry= '' )
AND t2.industry IS NOT NULL
;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = ''
;


UPDATE layoffs_staging2 AS t1
INNER JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL )
AND t2.industry IS NOT NULL
;



SELECT *
FROM layoffs_staging2
WHERE industry IS NULL;


SELECT*
FROM layoffs_staging2
WHERE company LIKE 'Bally%'
;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_numb
;