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