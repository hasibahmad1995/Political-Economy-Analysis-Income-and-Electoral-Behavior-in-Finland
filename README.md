# Political Economy Analysis: Income and Electoral Behavior in Finland

This project explores how municipal income levels relate to voting patterns in Finland's 2023 parliamentary elections. The analysis combines income data from 2017 with recent electoral results to understand whether economic prosperity shapes political preferences across Finnish municipalities.

## Research Question

Does income influence political party support in Finland? And do these patterns differ between metropolitan and non-metropolitan areas?

## Data

The analysis uses two datasets:
- **Municipal income data (2017)** from Statistics Finland covering 293 municipalities
- **Parliamentary election results (2023)** showing vote shares for major parties

Key parties examined: National Coalition Party (KOK), Centre Party (KESK), Finns Party (PS), Social Democrats (SDP), Greens (VIHR), Left Alliance (VAS), and Swedish People's Party (RKP).

## Methods

The project applies several statistical techniques:
- **Correlation analysis** to measure relationships between income and party support
- **T-tests and Wilcoxon rank-sum tests** to compare metropolitan vs. non-metropolitan municipalities
- **ANOVA with Tukey post-hoc tests** to examine income differences across party-dominated regions
- **Linear regression** to model how income predicts party support, with diagnostics (Breusch-Pagan and Shapiro-Wilk tests)

## Key Findings

- **Strong income divide**: Wealthier municipalities favor KOK (r = 0.58) and VIHR (r = 0.56), while lower-income areas support KESK (r = -0.62) and PS (r = -0.26)
- **Metropolitan advantage**: Metropolitan municipalities (Helsinki, Espoo, Vantaa) have significantly higher incomes than rural areas (p = 0.003)
- **Party dominance**: Municipalities where KOK dominates have average incomes €7,600 higher than KESK-dominated areas
- **Predictive power**: Income alone explains 34% of variation in KOK support—each €1,000 increase predicts a 1.1 percentage point rise in KOK votes

## Project Structure
├── Political-Economy-Analysis-Income-and-Electoral-Behavior-in-Finland.R

├── Political-Economy-Analysis-Income-and-Electoral-Behavior-in-Finland.pdf

└── README.md


## Tools Used

- **R** for statistical analysis
- **dplyr** and **tidyr** for data wrangling
- **ggplot2** for visualizations
- **car** and **lmtest** for regression diagnostics

## How to Run

1. Install required packages:
install.packages(c("dplyr", "ggplot2", "tidyr", "car", "lmtest"))


2. Download the datasets:
   - `tulot2017.csv` (municipal income data)
   - `ek2023.csv` (election results)

3. Run the script:
source("Political-Economy-Analysis-Income-and-Electoral-Behavior-in-Finland.R")


## Limitations

- Analysis uses municipal-level data rather than individual voter data
- Income data from 2017 may not perfectly reflect 2023 economic conditions
- Some outliers (especially Kauniainen with €63,000 average income) influence results
- Regression diagnostics show some deviation from normality due to extreme wealth cases

## Takeaway

Income remains a powerful dividing line in Finnish politics. Despite Finland's reputation for equality, economic prosperity strongly shapes whether municipalities lean toward market-liberal urban parties or agrarian/populist alternatives.
