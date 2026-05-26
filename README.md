Farah Abdel-Jawad
# Somalia Public Finance Management Capstone Project - Georgetown University 
Informing Public Finance Management in Somalia: A Contingent Evaluation of Social Protection and Service-Delivery Systems

## Research Questions
RQ 1: How do citizens perceive non-governmental service delivery within their districts?
RQ 2: What is the finance management structure of clan-based social support?

## Methods
- Survey design: household-level phone survey with randomized question ordering to minimize order effects (N=882 across 4 regions).
- Data cleaning (on Stata): Dropped administrative and randomization variables not relevant to substantive analysis.
- Inverse probability weighting (on Stata):Applied IPW to correct for non-response bias. Used logistic regression to estimate the probability of survey participation as a function of gender and location, then generated weights as `1/predicted probability`. Weighted estimates produced using Stata's `svyset` and `svy:` prefix commands.
- Visualizations (R & Tableau): Produced charts in `ggplot2` and Tableau to communicate findings across key variables.

## Repository
somalia-governance-capstone/
├── cleaning/
│   ├── 01_data_cleaning.do       
│   └── 02_weighting.do   
|
└── visualizations/
    ├── 01_tax_willingness_gender.R     # Willingness to pay taxes (by gender) for gov-led services
    ├── 02_factors_clan_support.R       # Factors influencing clan giving financial support
    ├── 03_contributions_frequency.R    # Frequency of personal contributions to the clan
    ├── 04_source_financial_support.R   # Sources of financial support other than income
    ├── 05_clan_contribution_yesno.R    # Binary question if asked to contribute to clan
    |
    └── [Tableau files — linked below and in Github]

## Tableau
- Health Insurance Program (by Gender): willingness of respondents to contribute 10% of their income towards a gov-led hypothetical health insurance program
*[https://public.tableau.com/views/HealthInsuranceProgrambyGender/Sheet10?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link]*

- Willingness to Pay Taxes (by Gender): grouped bar chart comparing male and female responses
*[https://public.tableau.com/views/WillingnesstoPayTaxesbyGender/taxwillingness2?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link]*

- Does Clan Ask for Contributions (by Gender): breakdown of informal taxation by gender
*[https://public.tableau.com/views/DoesClanAskforContributionsbyGender/doyoucontribute2?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link]*


## Key Findings
- A meaningful share of respondents expressed willingness to pay taxes to support local government services, with variation by gender.
- Approximately 30% of respondents reported being asked by clan elders to make regular financial contributions.
- Among those who contribute to the clan, contributions most commonly occur on an as-needed basis.
- Close family is the most commonly reported source of supplemental financial support, followed by remittances.

## About the Data Used
The raw survey data is not included in this repository as it is private to the research team. The weighted dataset (`full_contact_weighted.csv`) is required to run the visualization scripts.
