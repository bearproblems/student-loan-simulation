# very unfinished. Issues outstanding:
# 1. what do we need to pass as arguments: everything we use, or only some things? Can define parameters earlier and then use functions. 
#     Possible answer: Include as arguments the variables we expect to change each time we run the function. don't include parameters.
# 2. Is it better to write functions that return outputs, or that assign values to variables as 'side effects'?
#     Answer: It's better to return outputs explicitly.
# 3. parameter names in capitals; variable names in lower case, as a convention. Also allows more intuitive argument names as lowercase version of parameter names


# A possible naming convention:
# True constants, which never change: all capitals. E.g. MAX_INTEREST_THRESHOLD
# Variable inputs, which change but in endogenous ways we define: capital first letters. E.g. Salary
# Outputs, which change in ways determined by calculations: all lower case, E.g. min_repayment



# parameters
REPAYMENT_THRESHOLD <- 26575/12
SALARY <- 3500
MIN_INTEREST_THRESHOLD = 26575/12
MAX_INTEREST_THRESHOLD = 47835/12
RPI = 0.026
DEBT <- 45000

#### Turning these into functions

### minimum repayments
# input salary and repyament_threshold, defines min_repayment

find_min_repayment <- function(salary = SALARY, repayment_threshold = REPAYMENT_THRESHOLD) {
  if (salary >= repayment_threshold) {
    min_repayment <- 0.09*(salary - repayment_threshold)
  } else {min_repayment <- 0}
  return(min_repayment)
}



### Nominal annual interest rate


find_interest_rate <- function(salary = SALARY) {
  if (salary <= MIN_INTEREST_THRESHOLD) {
    interest_rate <- RPI
  } else if (MIN_INTEREST_THRESHOLD < salary & salary < MAX_INTEREST_THRESHOLD) {
    interest_rate <-  RPI + 0.03*(salary - MIN_INTEREST_THRESHOLD)/(MAX_INTEREST_THRESHOLD - MIN_INTEREST_THRESHOLD)
  } else {
    interest_rate <- RPI + 0.03 }
    return(interest_rate)
  }





# Input the interest rate, calculated from find_interst_rate, and the debt, and it returns
# the interest_growth, the amount of interest you accumulate that month.
find_interest_growth <- function(interest_rate = nominal_annual_interest_rate, debt = DEBT) {
  interest_growth <- debt * ((interest_rate + 1)^(1/12) - 1)
  return(interest_growth)
}





### Run the functions
min_repayment <- find_min_repayment()
nominal_annual_interest_rate <- find_interest_rate()
interest_growth <- find_interest_growth()


