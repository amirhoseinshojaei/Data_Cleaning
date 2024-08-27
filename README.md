# Data Cleaning Project

<img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRIn6p_Svb0wSiLnOMNdgDNkylGYIEt-F35jw&s"></img>

This project focuses on cleaning a dataset related to layoffs. The goal is to prepare the data for further analysis by removing duplicates, standardizing values, handling nulls, and removing unnecessary columns or rows.

## Steps Involved

### Step 1: Remove Duplicates

1. **Create a Staging Table:**
   - A staging table (`layoffs_staging`) is created to work with a copy of the original dataset (`layoffs`).

2. **Identify Duplicates:**
   - Duplicates are identified using a `ROW_NUMBER()` function based on key fields such as company, location, industry, total laid off, percentage laid off, and date.

3. **Remove Duplicates:**
   - Rows identified as duplicates are removed.

### Step 2: Standardize the Data

1. **Trim Whitespaces:**
   - Whitespaces from fields such as `company`, `industry`, and `country` are trimmed.

2. **Standardize Industry and Location Names:**
   - Common names and formats are applied to fields like `industry` and `country` for consistency.
   - For example, various forms of `Crypto` are standardized to `Crypto`.

3. **Date Standardization:**
   - The date format is standardized and the data type of the `date` field is modified to `DATE`.

### Step 3: Handle Null or Blank Values

1. **Identify and Fill Nulls:**
   - Identify records where critical fields (`total_laid_off`, `percentage_laid_off`, `industry`) are null or blank.
   - Industry values are filled in based on matching records.

2. **Remove Records with Unresolvable Nulls:**
   - Records with critical fields that remain null after attempts to fill them are removed.

### Step 4: Remove Unnecessary Columns or Rows

1. **Drop Unused Columns:**
   - The `row_numb` column, used to manage duplicates, is dropped after duplicates are removed.

## SQL Code Snippets

### Remove Duplicates
```sql
WITH duplicate_cte AS (
    SELECT *,
    ROW_NUMBER() OVER(PARTITION BY
    company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, 
    country, funds_raised_millions) AS row_numb
    FROM layoffs_staging
)
DELETE 
FROM layoffs_staging2
WHERE row_numb > 1;

