# set parameters and define inputs

# Inputs: define specific conditions for some person.
Starting_Debt <-  42000 # 45000
Starting_Salary <- 3600 # 3000
Months_Until_Writeoff <- 360 # 360

# parameters: define general conditions to do with the state of the world.
# note: RPI = AVERAGE RPI, in the long run: not now.
REPAYMENT_THRESHOLD <- 26575/12
MIN_INTEREST_THRESHOLD <- 26575/12
MAX_INTEREST_THRESHOLD <- 47835/12
RPI <- 0.026
RPI_ADJUSTMENT <- 0.65

# Depreciated: only used for old, inferior salary model
Salary_Growth_Rate <- 0.012


# Naming convention:
# "Parameters": Global values to do with the state of the world, which never change and are the same for many people: all capitals. E.g. MAX_INTEREST_THRESHOLD
# "Inputs": User specific conditions that will be different for each person, but don't change as the simulation runs: first letter of each word capitalised, E.g. Starting_Salary
# Variable inputs, which change but in endogenous ways we define: capital first letters. E.g. Salary
# Intermediate inputs and outputs, which change in ways determined by calculations: all lower case, E.g. real_interest_growth
