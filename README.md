# Layoffs Data Cleaning and Exploratory Analysis

## Overview
This project involves cleaning and exploring a dataset of company layoffs. The data cleaning steps include removing duplicates, standardizing columns, handling blank or null values, and removing irrelevant columns. The analysis explores key trends such as layoffs by industry, country, and date. SQL is used to carry out these transformations and exploratory data analysis (EDA).

## Table of Contents
- [Data Cleaning](#data-cleaning)
  - [Removing Duplicates](#removing-duplicates)
  - [Standardizing the Data](#standardizing-the-data)
  - [Handling Null or Blank Values](#handling-null-or-blank-values)
  - [Removing Irrelevant Columns](#removing-irrelevant-columns)
- [Exploratory Data Analysis (EDA)](#exploratory-data-analysis-eda)
  - [Layoffs by Company](#layoffs-by-company)
  - [Layoffs by Industry](#layoffs-by-industry)
  - [Layoffs by Country](#layoffs-by-country)
  - [Layoffs by Date](#layoffs-by-date)
- [Conclusion](#conclusion)

## Data Cleaning

### Removing Duplicates
Duplicates were identified and removed based on key fields like company, location, industry, and total layoffs using SQL `ROW_NUMBER()`.

### Standardizing the Data
Company names and industry values were standardized by trimming whitespace and formatting inconsistencies. The date column was converted into a standard format for further analysis.

### Handling Null or Blank Values
Null and blank values were addressed for key columns such as `total_laid_off`, `percentage_laid_off`, and `industry`. In cases where relevant, missing values were filled by joining related rows.

### Removing Irrelevant Columns
Non-essential columns, such as the row number, were dropped to streamline the dataset for analysis.

## Exploratory Data Analysis (EDA)

### Layoffs by Company
The analysis includes identifying the companies with the highest total layoffs.

### Layoffs by Industry
An analysis was performed to find which industries were most affected by layoffs.

### Layoffs by Country
The number of layoffs per country was aggregated to understand the geographical distribution.

### Layoffs by Date
Layoffs over time were explored, with the data grouped by year and month to identify trends.

## Conclusion
This project successfully cleans and explores a dataset related to layoffs. Through SQL queries, we derive insights into which companies, industries, and countries are most affected by layoffs, as well as the timeframes in which layoffs peak.

## Usage
To run the SQL commands, a compatible database such as MySQL or PostgreSQL is required.

## License
This project is licensed under the MIT License.

