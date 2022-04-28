## Excess Mortality in the Age of COVID19: Data Mining for Insights into Death

### Team Members
- Julie Kirkpatrick
- Alex Melnick
- Kyle Tomlinson

### Project Description
This project is an attempt to extract useful information from country-level data regarding the (currently ongoing) COVID-19 pandemic using **excess mortality**: a measure of the number of deaths during a crisis period which exceed a population's predicted mortality rate. Datasets from the [Human Mortality Database](https://www.mortality.org) and [Our World in Data](https://ourworldindata.org/coronavirus) were merged in order to calculate excess mortality rates for countries with available data.

### Summary of Findings
#### Were excess mortality rates higher during the pandemic at a statistically significant level?
- After normalizing both pre-pandemic mortality rates and the calculated excess mortality rates during the pandemic, a clear period of excess mortality appears above a 95% confidence interval starting in 2020.
#### Could relative excess mortality rates be used to rank the success of various countries at controlling the pandemic?
- Sorting countries according to the percentage of time spent with excess mortality rates exceeding the 95% confidence interval provided a satisfactory ranking method.
#### How closely did reported COVID deaths match overall excess mortality?
- In general, excess mortality rates eclipsed reported deaths from COVID-19. Individual countries often presented massive deviations from the overall data.
#### Are stringent public health measures related to excess mortality rates?
- By setting an offset between the stringency index and excess mortality rates a pattern emerged showing some correlation between the two, though not as strongly as anticipated.
#### In the absence of testing, can the number of cases be predicted based on other, more easily measured predictors?
- Excess mortality showed some promise as a predictive tool on its own and can be improved slightly by adding other attributes, but the quality of available information complicates predictive accuracy.

### Potential Applications
- Reiteration of the importance of excess mortality as a useful metric for determining potential outcomes.
- Ranked comparisons of individual countries' ability to mitigate the effects of the pandemic provides more obvious opportunites for future research.
- General reminder that investigations in this domain are difficult; open and honest communication between governments is essential.

### Links
- [Video Demonstration](https://github.com/jkirkpatrickmath/DataMining4502/blob/main/02_ExcessMortalityintheAgeofCOVID19_Part6_Video.mp4)
  - [PDF of Video Slides](https://github.com/jkirkpatrickmath/DataMining4502/blob/main/02_ExcessMortalityintheAgeofCOVID19_Part6.pdf)
- [Final Paper](https://github.com/jkirkpatrickmath/DataMining4502/blob/main/02_ExcessMortalityintheAgeofCOVID19_Part4.pdf)
