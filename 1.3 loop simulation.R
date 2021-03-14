# before running
# run 'define_inputs' to set parameters and user inputs
# run 'basic month functions', to define key functions.

# create a monthly schedule of gross real pay.
salary_schedule <- find_salary_schedule(starting_salary = Starting_Salary, salary_growth_rate = Salary_Growth_Rate, months_until_writeoff = Months_Until_Writeoff)
  
#Setup the loop
month <- 1
debt <- Starting_Debt
debt_series <- vector()
repayment_series <- vector()
interest_series <- vector()
month_series <- vector()
  
# loop
  
while (month <= Months_Until_Writeoff) {
  
  min_repayment <- find_min_repayment(salary = salary_schedule[month])
    
  real_interest_rate <- find_real_interest_rate(salary = salary_schedule[month], RPI_adjustment = RPI_ADJUSTMENT)
    
  real_interest_growth <- find_real_interest_growth(real_interest_rate, debt)         
    
    
  #If debt plus interest >= minimum repayment, pay minimum repayment.
  #Else repay debt plus interest
  if (debt + real_interest_growth >= min_repayment) {
    actual_repayment <- min_repayment} else {
      actual_repayment <- debt + real_interest_growth
    }
    
    
  debt_series <- c(debt_series, debt) 
  repayment_series <- c(repayment_series, actual_repayment)
  interest_series <- c(interest_series, real_interest_growth)
  month_series <- c(month_series, month)
    
  debt <- debt + real_interest_growth - actual_repayment
  month <- month + 1 
}
  
results <- data.frame(cbind(month_series, debt_series, repayment_series, interest_series, salary_schedule))
rm(month_series, debt_series, repayment_series, interest_series, salary_schedule)
rm(actual_repayment, min_repayment, debt, month, real_interest_rate, real_interest_growth)

sum(results$repayment_series)



#Things to add at this point:

#1. The ability to pay back more than the minimum repayment! 
#Add a voluntary repayment schedule OR a total repayment schedule to use instead of the minimum.
#The easiest way to do this I think will be make a different function.

#2. So far I've only looked at total amount paid. But actually what matters is the repayment schedule.
#I need to find the net present value of the stream of future income payments.

#2a. One way to do this is to make a net present value function that inputs the stream of payments, 
#and a annual discount factor, and outputs the net present value of the whole thing.

#2b. Another way to do this is to say what the annual rate of return would be of paying off the loans now.
#I need to check how the maths would work...
#But this function would input your stream of payments and current debt, and say at the end of the 30 years
#you would be equally well off financially if instead of paying off your debt at the start you invested the 
#cash in a savings account with an x% real interest rate.

#Once I have both of these down, I have a key tool to consider whether paying off the loans up front are worth it.
#For me, and also for people with different starting conditions. I'd like to know how the ROI of paying off
#varies with your starting salary, with your rate of salary growth, and with your principal debt.

#3a. At the moment the salary calculator uses continuous growth. If I say 2% growth, this is a continuous rate,
#so it's actually returning not 1.02 times last year's growth, but exp(1)^0.02, which is slightly higher.
#I should either move it out of exp(1) into growth_rate^(number of periods), or find the conversion to the 
#appropriate exponential value.

#3b. At the moment I've got a nice smooth salary growth. What happens if instead the salary stays the same
#for a few years, and then jumps, and then stagnates again? To achieve this I need to move the find_salary() function 
#out of the student loan calculator and find it some other way. This is well worth looking at, since I will likely
#have this happen to my salary in the fast stream. (The other way to model this is see how much my interest will grow
#while I do four years of minimum repayments, and then see what's left for the remaining 26 years.)


#4. A further development: Put in gross and net income stats. 
#That is: look at what my total salary is, and how much I will have each month after paying income tax, and 
#national insurance... and then get the net salary stream when I pay off the whole loan really quickly
#(e.g. with half of my post-tax income), versus if I treat it as a tax.

#5. Once I have the net income vectors with repayment vs with treat-as-tax, I can see which leads to
# a higher total utility, using a linear-log function of welfare as a function of income.

#6. A potential further development of this approach: try several different repayment plans.
# Repay 100%, 2/3, 50%, 1/3, 1/4, 1/5, 15%, 10%, treat-as-tax, until it's gone. Look at lifetime
#utility in each case, and compare which outcomes come out better.
#On one hand, it's better to smooth out costs according to neoclassical theory.
#On the other hand, it's better to pay less, and slower repayment -> greater total repayment.
#Where is the crossover point?


