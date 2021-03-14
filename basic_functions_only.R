# I have decided to model in real terms. I assume repayment thresholds, etc. will stay the same *in real terms*, i.e. increasing along with inflation.
# This means debt, salary, etc. Don't have to be upscaled each month by assumed inflation.
# It also means results will all be in 'real' terms, which is better because nominal results weight more recent results more heavily (as inflation increases the nominal values.)


### minimum repayments
# input salary and repyament_threshold, defines min_repayment

find_min_repayment <- function(salary = Salary, repayment_threshold = REPAYMENT_THRESHOLD) {
  if (salary >= repayment_threshold) {
    min_repayment <- 0.09*(salary - repayment_threshold)
  } else {min_repayment <- 0}
  return(min_repayment)
}


### Nominal interest rate

find_nominal_interest_rate <- function(salary = Salary) {
  if (salary <= MIN_INTEREST_THRESHOLD) {
    nominal_interest <- RPI
  } else if (MIN_INTEREST_THRESHOLD < salary & salary < MAX_INTEREST_THRESHOLD) {
    nominal_interest <-  RPI + 0.03*(salary - MIN_INTEREST_THRESHOLD)/(MAX_INTEREST_THRESHOLD - MIN_INTEREST_THRESHOLD)
  } else {
    nominal_interest <- RPI + 0.03 }
  return(nominal_interest)
}


### Real interest rate

find_real_interest_rate <- function(salary = Salary, RPI_adjustment = RPI_ADJUSTMENT) {
  if (salary <= MIN_INTEREST_THRESHOLD) {
    interest_over_RPI <- 0
  } else if (MIN_INTEREST_THRESHOLD < salary & salary < MAX_INTEREST_THRESHOLD) {
    interest_over_RPI <-  0.03*(salary - MIN_INTEREST_THRESHOLD)/(MAX_INTEREST_THRESHOLD - MIN_INTEREST_THRESHOLD)
  } else {
    interest_over_RPI <- 0.03 }
  
  real_interest_rate <<- interest_over_RPI + RPI_adjustment*0.01
  real_interest_rate
    return(real_interest_rate)
  }


# Input the interest rate, calculated from find_interst_rate, and the debt, and it returns
# the interest_growth, the amount of interest you accumulate that month.
find_nominal_interest_growth <- function(interest_rate = nominal_interest_rate, debt = Debt) {
  interest_growth <- debt * ((interest_rate + 1)^(1/12) - 1)
  return(interest_growth)
}

find_real_interest_growth <- function(interest_rate = real_interest_rate, debt = Debt) {
  interest_growth <- debt * ((interest_rate + 1)^(1/12) - 1)
  return(interest_growth)
}