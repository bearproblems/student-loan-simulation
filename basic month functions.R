# very unfinished. Issues outstanding:
# 1. what do we need to pass as arguments: everything we use, or only some things? Can define parameters earlier and then use functions.
# 2. Is it better to write functions that return outputs, or that assign values to variables as 'side effects'?


# parameters
repayment_threshold <- 26575/12
salary <- 3500
min_interest_threshold = 26575/12
max_interest_threshold = 47835/12
RPI = 0.026
debt <- 45000

#### Turning these into functions

### minimum repayments
# input salary and repyament_threshold, defines min_repayment

find_min_repayment <- function(pay = salary, threshold = repayment_threshold) {
  if (pay >= repayment_threshold) {
    min_repayment <<- 0.09*(pay - repayment_threshold)
  } else {min_repayment <<- 0}
}



### Nominal annual interest rate


find_interest_rate <- function(pay = salary)
  if (pay <= min_interest_threshold) {
    nominal_annual_interest_rate <- RPI
  } else if (min_interest_threshold < salary & salary < max_interest_threshold) {
    nominal_annual_interest_rate <-  RPI + 0.03*(salary - min_interest_threshold)/(max_interest_threshold - min_interest_threshold)
  } else {
    nominal_annual_interest_rate <- RPI + 0.03
  }



# Input the s, it finds your interest rate 
find_interest_rate <- function(salary, RPI_adjustment = 0) {
  if (salary <= 2144) {
    interest_over_RPI <- 0
  } else if (2144 < salary & salary < 3859) {
    interest_over_RPI <-  0.03*(salary - 2144)/1715 
  } else {
    interest_over_RPI <- 0.03 
  }
  interest_rate <<- interest_over_RPI + RPI_adjustment*0.01
}


#Input the interest rate, calculated from find_interst_rate, and the debt, and it returns
#the interest_growth, the amount of interest you accumulate that month.
find_interest_growth <- function(interest_rate, debt) {
  interest_growth <<- debt * ((interest_rate+1)^(1/12) - 1)
}





#Another function to find the minimum_repayment as a function of salary. This one's trivial.


