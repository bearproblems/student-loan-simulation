# Option: Run this as a side script which works on all data in 'datasets' folder at once.
# Save the results of a run so we don't have to run every time?

# earnings and hours by age group
# ONS ASHE, tables 6 https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/earningsandworkinghours/datasets/agegroupashetable6
# saved in "datasets/PROV - Age Group Table 6.7a   Annual pay - Gross 2020.xls"

# Install tidyverse
# install.packages("tidyverse")
library("tidyverse")

# load data from ASHE table 6
ons_raw_salaries <- readxl::read_excel("datasets/PROV - Age Group Table 6.7a   Annual pay - Gross 2020.xls", range = "All!A3:F13")

# store the useful parts in a tibble
ons_salaries <- tibble(
  age <- unlist(ons_raw_salaries[5:9, 1]),
  median_salary <- as.numeric(unlist(ons_raw_salaries[5:9, 4])),
  mean_salary <- as.numeric(unlist(ons_raw_salaries[5:9, 6])),
)

colnames(ons_salaries) <- c("age", "median_salary", "mean_salary")


# split age bands into min, max and average, and convert to numeric
ons_salaries$age_min <- str_sub(ons_salaries$age, 1, 2) %>% as.numeric()

ons_salaries <- ons_salaries %>% mutate(age_min = str_sub(age, 1, 2) %>% as.numeric(),
                        age_max = str_sub(age, -2, -1) %>% as.numeric(),
                        age_mid = (age_max + age_min)/2,
                        age_months = age_mid*12,
                        month_median_salary = (1/12) * median_salary,
                        month_mean_salary = (1/12) * mean_salary)

age <- ons_salaries$age_months
median_salary <- ons_salaries$month_median_salary
mean_salary <- ons_salaries$month_mean_salary




##### At the risk of overfitting, I will use the fourth degree polynomial, for the best fit of the data.
# May revisit this in future.

# fit third degree polynomial equation for median and mean:
median_fit <- lm(median_salary ~ poly(age, 3, raw=TRUE))
mean_fit <- lm(mean_salary ~ poly(age, 3, raw=TRUE))

#generate range of 100 numbers starting from 0 and ending at 800
xx <- seq(0, 800, length=100)
plot(x=age, y=median_salary, pch=19, ylim=c(0, 3200))
lines(xx, predict(median_fit, data.frame(age=xx)), col="orange")

# same for mean fit
xx <- seq(0, 800, length=100)
plot(x=age, y=mean_salary, pch=19, ylim=c(0, 3200))
lines(xx, predict(mean_fit, data.frame(age=xx)), col="orange")

summary(median_fit)










###### Testing which fit to use 
##### Plot and fit a curve through the median and mean salaries
# Code for this is adapted from https://davetang.org/muse/2013/05/09/on-curve-fitting/

# make median_salary the predictor, and y the response variable
plot(x=age, y=median_salary, pch = 19)

# fit first degree polynomial equation:
fit  <- lm(median_salary ~ age)
#second degree
fit2 <- lm(median_salary ~ poly(age, 2, raw=TRUE))
#third degree
fit3 <- lm(median_salary ~ poly(age, 3, raw=TRUE))
#fourth degree
fit4 <- lm(median_salary ~ poly(age, 4, raw=TRUE))


#generate range of 50 numbers starting from 30 and ending at 160
xx <- seq(0, 800, length=100)
plot(x=age, y=median_salary, pch=19, ylim=c(0, 35000))
lines(xx, predict(fit, data.frame(age=xx)), col="red")
lines(xx, predict(fit2, data.frame(age=xx)), col="green")
lines(xx, predict(fit3, data.frame(age=xx)), col="blue")
lines(xx, predict(fit4, data.frame(age=xx)), col="orange")

summary(fit4)



##### To avoid overfitting, and for simplicity, I will use the third degree polynomial.
# May revisit this in future.

# fit third degree polynomial equation for mean and median:
mean_fit <- lm(mean_salary ~ poly(age, 3, raw=TRUE))
median_fit <- lm(median_salary ~ poly(age, 3, raw=TRUE))

#generate range of 100 numbers starting from 0 and ending at 800
xx <- seq(0, 800, length=100)
plot(x=age, y=mean_salary, pch=19, ylim=c(0, 35000))
lines(xx, predict(mean_fit, data.frame(age=xx)), col="orange")


# same for median fit
xx <- seq(0, 800, length=100)
plot(x=age, y=median_salary, pch=19, ylim=c(0, 35000))
lines(xx, predict(median_fit, data.frame(age=xx)), col="orange")

summary(median_fit)



##### Converting to a monthly salary schedule
# from age 19.5 to 54.5
# Repayment countdown starts on April after finishing uni
# For simplicity, I assume this starts at age 22.
# This is only needed to know where on the curve to fit people.

# Big assumption: Graduates follow a similar schedule to this.

# Next steps: convert from years to months
# Identify starting month (age 22)
# Extract or derive the equation from the fitted polynomial
# Use the equation to create a salary schedule
# Scale based on starting salary to create salary schedule.
# Sanity-check resulting schedule is sensible
# Use resulting schedule as in the repayment simulator


##### polynomial test
# median
x = 35
y = -2.019e+05 + 2.289e+04*x -8.598e+02*x^2 + 1.443e+01 * x^3 + -9.074e-02*x^4

#mean
x = 35
y = -2.089e+05 + 2.400e+04* x + -9.204e+02* (x^2) + 1.602e+01* (x^3) + -1.047e-01* (x^4)


# While mean is arguably a better descriptor of the whole population, the median is a more typical case.
# This is all filled with assumptions, so I will take median as my salary shedule shape.












# Function defined in 'basic_functions_only'

#  Run the function to make a salary schedule
salary_schedule <- find_salary_schedule()


















#### Discussion 

# exp(1) is e. e^(number of years * growth_rate) shows the salary after it's been growing at a given constant percentage growth_rate for a given number_of_years.

#Salary Growth
# according to  https://www.instantoffices.com/blog/reports-and-research/average-uk-salary/, the average
# rate of individual salary growth after inflation is 2.2%. Obviously this will vary across professions 
#but for now I'm taking that as a reasonable guess of how fast my salary will grow from the starting salary.
# Similar results from https://www.ons.gov.uk/visualisations/dvc409/calc/index.html 
# The ONS widget says that currently inflation = 1.7% and pay growth is 4%, which implies 2.3% real growth.
# As a simple assumption I'm happy enough with this to stick to 2.2%.

# However, in practice salaries will often initially increase more quickly and then slow down.
# It could be better to fit a curve which increases quite fast then slows down, e.g. towards and asymptote.
# One option: Find average graduate starting salaries + salaries at a given years /age, and then fit a curve through these points.
# This will give a) a data-driven shape, and b) default parameter values, for the salary vector.

# Define parameters, salary vector, starting debt, etc. Before running the loop; not as part of it.