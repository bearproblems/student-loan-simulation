# I have decided to model in real terms. I assume repayment thresholds, etc. will stay the same *in real terms*, i.e. increasing along with inflation.
# This means debt, salary, etc. Don't have to be upscaled each month by assumed inflation.
# It also means results will all be in 'real' terms, which is better because nominal results weight more recent results more heavily (as inflation increases the nominal values.)


### minimum repayments
# input salary and repyament_threshold, returns min_repayment.

find_min_repayment <- function(salary = Starting_Salary, repayment_threshold = REPAYMENT_THRESHOLD) {
  if (salary >= repayment_threshold) {
    min_repayment <- 0.09*(salary - repayment_threshold)
  } else {min_repayment <- 0}
  return(min_repayment)
}


### Nominal interest rate
# Caution: defines 'nominal_interest_rate' as a side effect
find_nominal_interest_rate <- function(salary = Starting_Salary) {
  if (salary <= MIN_INTEREST_THRESHOLD) {
    nominal_interest <- RPI
  } else if (MIN_INTEREST_THRESHOLD < salary & salary < MAX_INTEREST_THRESHOLD) {
    nominal_interest <-  RPI + 0.03*(salary - MIN_INTEREST_THRESHOLD)/(MAX_INTEREST_THRESHOLD - MIN_INTEREST_THRESHOLD)
  } else {
    nominal_interest <- RPI + 0.03 }
    nominal_interest_rate <<- nominal_interest
  return(nominal_interest)
}


### Real interest rate
# Caution: defines 'real_interest_rate' as a side effect

find_real_interest_rate <- function(salary = Starting_Salary, RPI_adjustment = RPI_ADJUSTMENT) {
  if (salary <= MIN_INTEREST_THRESHOLD) {
    interest_over_RPI <- 0
  } else if (MIN_INTEREST_THRESHOLD < salary & salary < MAX_INTEREST_THRESHOLD) {
    interest_over_RPI <-  0.03*(salary - MIN_INTEREST_THRESHOLD)/(MAX_INTEREST_THRESHOLD - MIN_INTEREST_THRESHOLD)
  } else {
    interest_over_RPI <- 0.03 }
  
  real_interest_rate <<- interest_over_RPI + RPI_adjustment*0.01
    return(real_interest_rate)
  }


# Input the interest rate, calculated from find_interst_rate, and the debt, and it returns
# the interest_growth, the amount of interest you accumulate that month.
# Caution: uses 'nominal_interest_rate' as an input, which should be defined as the output of 'find_nominal_interest_rate'
find_nominal_interest_growth <- function(interest_rate = nominal_interest_rate, debt = Starting_Debt) {
  interest_growth <- debt * ((interest_rate + 1)^(1/12) - 1)
  return(interest_growth)
}
# Caution: uses 'real_interest_rate' as an input, which should be defined as the output of 'find_real_interest_rate'
find_real_interest_growth <- function(interest_rate = real_interest_rate, debt = Starting_Debt) {
  interest_growth <- debt * ((interest_rate + 1)^(1/12) - 1)
  return(interest_growth)
}


### Create a salary schedule.
# For now, assume constant compounding salary growth
# default growth rate 2.2% a year
# default 360 months / 30 years until loan writeoff

# In the future, find a better curve for a salary schedule, and define coefficients as user inputs.

find_salary_schedule <- function(starting_salary = Starting_Salary, salary_growth_rate = Salary_Growth_Rate, months_until_writeoff = Months_Until_Writeoff) {
  salary_vector = starting_salary * exp(1) ^ ((1:months_until_writeoff - 1) * ((1 + salary_growth_rate) ^ (1/12) - 1))
  return(salary_vector)
}