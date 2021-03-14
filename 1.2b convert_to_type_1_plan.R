# Convert to type 1 loan

# lower repayment threshold
REPAYMENT_THRESHOLD <- 1615
PLAN_1_NOMINAL_INTEREST <- 0.011

### Nominal interest rate
# Caution: defines 'nominal_interest_rate' as a side effect
find_nominal_interest_rate <- function(salary = Starting_Salary) {
  # meaningless calculation to avoid warning message from not using all arguments
  salary + 1
  
  nominal_interest_rate <<- PLAN_1_NOMINAL_INTEREST
  return(PLAN_1_NOMINAL_INTEREST)
}


### Real interest rate
# Caution: defines 'real_interest_rate' as a side effect

find_real_interest_rate <- function(salary = Starting_Salary, RPI_adjustment = RPI_ADJUSTMENT) {
  # meaningless calculation to avoid warning message from not using all arguments
  salary + RPI_adjustment
  
  real_interest_rate <<- PLAN_1_NOMINAL_INTEREST - RPI + RPI_adjustment*0.01
  return(real_interest_rate)
}



### A word on interest rates
# RPI + interest_over_RPI = nominal_interest_rate
# RPI - RPI_adjustment = inflation
# Therefore...
# RPI = inflation + RPI_adjustment
# nominal_interest_rate = Inflation + RPI_adjustment + interest_over_RPI

# Bring in real interest rate
# real_interest_rate = nominal_interest_rate - inflation
# real_interest_rate = RPI_adjustment + interest_over_RPI
# real_interest_rate = nominal_interest_rate - RPI + RPI_adjustment

# Beth debt 41500
# Starting salary 3500

# Plan 1
# repay 170 a month at start
# total repay: 39080 in today's money
# total time: 14 years 6 months

# Plan 2
# repay 116 a month at start
# total repay: 68261 in today's money
# total time: 25 years 8 months


# Dan debt 43000
# Starting salary 4000
# Salary growth 1.2% (default 2.2%)

# Plan 1
# repay 215 a month at start
# total repay: 40700 in today's money
# total time: 13 years 10 months

# Plan 2
# repay 161 a month at start
# total repay: 70555 in today's money
# total time: 26 years 4 months


# Dan debt 43000
# Starting salary 2700

# Plan 1
# repay 98 a month at start
# total repay: 39339 in today's money
# total time: 20 years 5 months

# Plan 2
# repay 44 a month at start
# total repay: 51588 in today's money
# total time: write-off 28k in 30 years



# Dan debt 43000
# Starting salary 2700
# Salary behaviour: derived from ASHE estimates of income curves (join curve at age 23)

# Plan 1
# repay 98 a month at start
# total repay: 440065 in today's money
# total time: 16 years 8 months

# Plan 2
# repay 44 a month at start (unchanged)
# total repay: 56439 in today's money
# total time: write off 23k after 30 years

