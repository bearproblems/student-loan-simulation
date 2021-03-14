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


##### To avoid overfitting, and for simplicity, I will use the third degree polynomial.
# May revisit this in future.

# fit third degree polynomial equation for median and mean:
median_fit <- lm(median_salary ~ poly(age, 4, raw=TRUE))
mean_fit <- lm(mean_salary ~ poly(age, 4, raw=TRUE))


xx <- seq(0, 800, length=100)
plot(x=age, y=median_salary, pch=19, ylim=c(0, 3200))
lines(xx, predict(median_fit, data.frame(age=xx)), col="orange")



###### Experimental salary schedule using coefficients derived from fitting lines through ASHE values.

find_salary_schedule <- function(starting_salary = Starting_Salary, 
                                  B0 = as.numeric(median_fit$coefficients[1]), 
                                  B1 = as.numeric(median_fit$coefficients[2]),
                                  B2 = as.numeric(median_fit$coefficients[3]),
                                  B3 = as.numeric(median_fit$coefficients[4]),
                                  B4 = as.numeric(median_fit$coefficients[5]),
                                  starting_age_years = 23) {
  # for the shape of the curve, assume people start working + repaying when they turn 23 by default.
  # the only impact is on the shape of the curve / how high up their initial income climb they are when they come in.
  salary_schedule <- vector()
  
  starting_age <- starting_age_years*12
  current_age <- starting_age
  
  predicted_salary <- B0 + B1*starting_age + B2*starting_age^2 + B3*starting_age^3 + B4*starting_age^4
  salary_scalar <- starting_salary / predicted_salary
  
  for (i in 1:360) {
    salary <- salary_scalar * (B0 + B1*current_age + B2*current_age^2 + B3*current_age^3 + B4*current_age^4)
    
    salary_schedule <- c(salary_schedule, salary)
    current_age <- current_age + 1
  }
  
  return(salary_schedule) 
}
