# set parameters and define inputs

# parameters
REPAYMENT_THRESHOLD <- 26575/12
MIN_INTEREST_THRESHOLD = 26575/12
MAX_INTEREST_THRESHOLD = 47835/12
MONTHS_UNTIL_WRITEOFF = 360
RPI_ADJUSTMENT <- 0.75
STARTING_DEBT <- 45000
RPI = 0.026

# intermediate inputs
Salary <- 3500
Debt <- 45000

# A possible naming convention:
# True constants, which never change: all capitals. E.g. MAX_INTEREST_THRESHOLD
# Variable inputs, which change but in endogenous ways we define: capital first letters. E.g. Salary
# Outputs, which change in ways determined by calculations: all lower case, E.g. min_repayment
