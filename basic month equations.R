# basic functions

### Minimum repayments

# It starts with humble beginnings. 
# If I earn an amount x per month, what happens to the minimum repayment?
# details taken from the government website, https://www.gov.uk/repaying-your-student-loan/what-you-pay
# Minimum repayment is 9% of salary above a threshold.

# For the 2020-2021 tax year, the thresholds are £511 a week or £2,214 a month, or £26,575 a year (before tax and other deductions). 
# They change on 6 April every year.

# This model will work on a monthly basis, so all values (repayment_threshold, salary, etc.) are monthly values.
# gross salary above which 9% repayments are made
REPAYMENT_THRESHOLD <- 26575/12

# gross salary
Salary <- 3500

#specify the minimum monthly repayment for specified salary
if (Salary >= REPAYMENT_THRESHOLD) {
  min_repayment <- 0.09*(Salary - REPAYMENT_THRESHOLD)
} else {min_repayment = 0}




### Nominal annual interest rate.

# Until the 6th April after graduation, the interest rate is RPI + 3%.
# After that, it's a sliding scale based on annual income.

# £26,575 or less: RPI
# £26,576 to £47,835: RPI + up to 3%
# Over £47,835: RPI + 3%

#Specify the interest_rate thresholds
MIN_INTEREST_THRESHOLD = 26575/12
MAX_INTEREST_THRESHOLD = 47835/12

# Specify RPI for the 2020-2021 tax year
RPI = 0.026

# find interest rate, given salary, RPI, and min and max interest thresholds
if (Salary <= MIN_INTEREST_THRESHOLD) {
  nominal_interest_rate <- RPI
} else if (MIN_INTEREST_THRESHOLD < Salary & Salary < MAX_INTEREST_THRESHOLD) {
  nominal_interest_rate <-  RPI + 0.03*(Salary - MIN_INTEREST_THRESHOLD)/(MAX_INTEREST_THRESHOLD - MIN_INTEREST_THRESHOLD)
} else {
  nominal_interest_rate <- RPI + 0.03
}


# Alternate version, finds interest over RPI and includes an optional RPI adjustment
RPI_adjustment <- 0.75

if (Salary <= MIN_INTEREST_THRESHOLD) {
  interest_over_RPI <- 0
} else if (MIN_INTEREST_THRESHOLD < Salary & Salary < MAX_INTEREST_THRESHOLD) {
  interest_over_RPI <- 0.03*(Salary - MIN_INTEREST_THRESHOLD)/(MAX_INTEREST_THRESHOLD - MIN_INTEREST_THRESHOLD)
} else {
  interest_over_RPI <- 0.03
}

real_interest_rate <<- interest_over_RPI + RPI_adjustment*0.01
real_interest_rate



### Accumulating interest
# Research briefing from the commons library suggests in 2019, average graduating debt was 40,000. https://commonslibrary.parliament.uk/research-briefings/sn01079/
# IFS research suggests £50,800. https://www.bbc.co.uk/news/education-40493658
# I will go half-way and set default debt to £45000
# set total debt. 
Debt <- 45000

# monthly interest rate != annual rate/12. If we used this, the monthly interest would compound more quickly, leading to a higher annual rate.
# instead, use (1 + annual_rate)^(1/12) - 1
monthly_nominal_interest_rate <- ((1 + nominal_interest_rate)^(1/12) - 1)
nominal_interest_growth <- Debt * monthly_nominal_interest_rate


# Alternate version, uses real_interest_rate instead of nominal_interest_rate
monthly_real_interest_rate <- ((1 + real_interest_rate)^(1/12) - 1)
real_interest_growth <- Debt * monthly_real_interest_rate

### Monthly change in debt

# Define actual monthly repayment
actual_repayment <- min_repayment

# monthly change in debt
nominal_debt_change <- nominal_interest_growth - actual_repayment
real_debt_change <- real_interest_growth - actual_repayment