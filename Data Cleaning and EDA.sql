-- Data Cleaning

SELECT * 
FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * 
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- 1. Removing Duplicates

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location, industry, total_laid_off,percentage_laid_off, `date`) AS row_num 
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location, industry, total_laid_off,percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num 
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location, industry, total_laid_off,percentage_laid_off, `date`) AS row_num 
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 0;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;

-- 2. Standardizing the Data

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT country
FROM layoffs_staging2;

SELECT `date`
FROM layoffs_staging2; 

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')
WHERE `date` IS NOT NULL AND `date` != 'None';

UPDATE layoffs_staging2
SET `date` = NULL
WHERE `date` = 'None';

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- 3. Blank or Null Values

SELECT *
FROM layoffs_staging2
WHERE total_laid_off = 'None' AND percentage_laid_off = 'None';

SELECT *
FROM layoffs_staging2
WHERE industry = 'None' OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT *
FROM layoffs_staging2 t1 JOIN layoffs_staging2 t2 ON t1.company = t2.company AND t1.location = t2.location
WHERE t1.industry = '' AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 
SET industry = NULL 
WHERE industry = '';

UPDATE layoffs_staging2 t1 JOIN layoffs_staging2 t2 ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

DELETE 
FROM layoffs_staging2
WHERE total_laid_off = 'None' AND percentage_laid_off = 'None';

-- 4. Remove Irrelavant Columns

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


-- Exploratory Data Analysis

SELECT * 
FROM layoffs_staging2;

SET SQL_SAFE_UPDATES = 0;

UPDATE layoffs_staging2 
SET total_laid_off = NULL 
WHERE total_laid_off = 'None';

ALTER TABLE layoffs_staging2
MODIFY COLUMN total_laid_off INT;
 
SELECT MAX(total_laid_off)
FROM layoffs_staging2;

UPDATE layoffs_staging2 
SET percentage_laid_off = NULL 
WHERE percentage_laid_off = 'None';

SELECT MAX(percentage_laid_off)
FROM layoffs_staging2;

UPDATE layoffs_staging2 
SET funds_raised_millions = NULL 
WHERE funds_raised_millions = 'None';

ALTER TABLE layoffs_staging2
MODIFY COLUMN funds_raised_millions INT;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`, 1, 7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1;

WITH Rolling_total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1
)
SELECT `Month`, total_off, SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_total;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
), Company_Year_Rank AS
( SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_year
WHERE years IS NOT NULL )
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;
