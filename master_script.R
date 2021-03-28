#
# install.packages(tidyverse)
library(tidyverse)
# Once inputs are defined, produce the results table.

source("1.1 define_inputs.R")

source("1.2 basic_functions_only.R")
source("1.2b convert_to_type_1_plan.R")
source("1.2c advanced_salary_schedule.R")

source("1.3 loop simulation.R")

source("2.1 evaluating lump-sum payoff.R")



# big next developments:
# 1. make plan 1 or 2 a user input, and put an 'if' function in the master script
# 2. plot 'results' table with ggplot and nice labels
# 3. Career break input: what if you stop and have children / do something else
# 4. NPV of incomplete payoff at the start (e.g. £20,000 of £45,000)
# 5. Find more fun things to plot like IRR vs starting debt, holding all other variables equal.