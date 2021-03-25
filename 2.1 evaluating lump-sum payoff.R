# 2.1 Evaluating paying off.

# start simple and build up. Create a suite, or 'dashboard' of measures saying how good paying it off is as a tool.
# I can also design these more broadly in a modular way.
# All of 1 is a module that produces the 'results' table.

# 2. takes results table.
# assumptions: the investment is a lump-sum payment, size = Starting_Debt
# This generates a cashflow series = 'repayment_series'. 
# If the starting debt is fully paid off, the repayment series no longer has to be paid; 
# so it can be thought of as the returns of paying the lump sum at the start.


### Evaluating a lump-sum payoff as a poential investment:
# Measures that start simple, and get more sophisticated.

# 1: total real repayments, not future discounted (which the lump sum avoids)
# 2: Starting_Debt - total real repayments: how much you save (or lose) in today's money by repaying it all now
# 3: months until paid in full (or never repaid)

# 4: Payback period (or never paid back): how long it takes until the original investment is repaid
# 5: Net Present Value: future discounted value of cashflow minus initial outlay, with discount rate i (which may reflect return on alternate investments; so can use return of alternatives as discount rates)
# 6: Internal Rate of Return: the discount rate that reduces the NPV of the investment to zero. (and can compare this to IRR of alternatives)

## measures 1, 2 and 5 can be put as absolute values, but also as a percentage of Starting_Debt


evaluate_lump_sum <- function() {
### 1. total real repayments

#starting debt
Starting_Debt

# total real repayments
total_real_repayments <- sum(results$repayment_series)

# total real repayments, as a proportion of Starting_Debt
lump_sum_payment_proportion <- Starting_Debt / sum(results$repayment_series)

### 2. Starting_Debt - total real repayments.
# If you pay up front what effect does it have on total repayments
lump_sum_money_saved <- sum(results$repayment_series) - Starting_Debt


### 3. months until paid off in full
# final month where debt is larger than zero
months_until_paid_off <- which(results$debt_series > 0) %>% max() 
years_until_paid_off <- months_until_paid_off / 12


### 4. Payback period: when is the first month when sum of repayments >= Starting_Debt
payback_binary <- cumsum(results$repayment_series) >= Starting_Debt
if(max(payback_binary == 1)) {
  payback_month <- min(which(payback_binary))
} else {
  payback_month <- NaN
}

payback_year <- payback_month / 12



### 5. Net Present Value
# NPV = sum((cashflow at time t)/(1 + discount rate)^time t)
# cashflow at time t = results$repayment_series[t]
# discount rate = e.g. 0.5%
# time = results$month, with first repayment on month = 1


find_npv <- function(annual_discount_rate = -0.05, repayments = results$repayment_series) {
  monthly_discount_rate <- (1 + annual_discount_rate)^(1/12) -1
  
  future_discount_series <- (1 + monthly_discount_rate) ^ (0:(Months_Until_Writeoff-1))
  
  net_present_value <- sum(repayments * future_discount_series) - Starting_Debt
  return(net_present_value)
}


### Internal Rate of Return
# what discount rate is needed to make net present value = 0?
# IRR = - discount rate, where NPV = 0
find_npv_table <- function() {
  discounts_vector <- -0.0001 * seq(1:3000) + 0.15
  npv_vector <- sapply(discounts_vector, find_npv)
  
  npv_table <<- data.frame(cbind("discount rate" = discounts_vector, 
                                 "NPV" = npv_vector))
}


find_IRR <- function() {
  find_npv_table()
  IRR <- -head(npv_table$discount.rate[npv_table$NPV <= 0], 1)
  return(IRR)
}


find_IRR2 <- function() {
  find_npv_table()
  index <- which(npv_table$NPV <= 0) %>% min()
  IRR <- -npv_table$discount.rate[index]
  return(IRR)
}








find_npv_table()
find_IRR()






##### Gather all these results into a nice tibble
lump_sum_summary <- tibble(
  category = c("starting debt", "total real repayments", "years until debt cleared",
               "lump sum as proportion of real repayments avoided", 
               "real savings from lump sum",
               "years until lump sum breaks even",
               "net present value (5% discount rate)",
               "net present value (4% discount rate)",
               "net present value (3% discount rate)",
               "net present value (2% discount rate)",
               "net present value (1% discount rate)",
               "internal rate of return"
               ),
  value = c(Starting_Debt, total_real_repayments, years_until_paid_off,
            lump_sum_payment_proportion, lump_sum_money_saved, payback_year,
            find_npv(-0.05), find_npv(-0.04), find_npv(-0.03), find_npv(-0.02), find_npv(-0.01), 
            find_IRR())
)

lump_sum_summary$value[1:11] <- lump_sum_summary$value[1:11] %>% round(4)

return(lump_sum_summary)
}

lump_sum_summary <- evaluate_lump_sum()

### Potential development: instead of paying off in one go, generalise to different repayment patterns
# Use formulas with a payment each month (which also gets future discounted)
# Then, separately, generate series of monthly payments, e.g. pay 20% of gross pay until it's gone.
# modify the loop or make a modified version of the loop to accommodate a different repayment schedule.
# Calculate suite of measures for this circumstance as well.