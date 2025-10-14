# Check for duplicate/cross-joined data

library(dplyr)

# Load the data
cc_data <- read.csv("/Users/racheldean/Documents/GitHub/florida-cc-degree-scraper/data/cc_completers_merged.csv")

cat("=== Investigating data duplication ===\n\n")

# Look at Broward for two different CIP codes
broward_cip1 <- cc_data %>%
  filter(inst_name == "Broward College", cipcode_6digit == 99, award_level == 4) %>%
  arrange(completers) %>%
  select(inst_name, cipcode_6digit, completers)

broward_cip2 <- cc_data %>%
  filter(inst_name == "Broward College", cipcode_6digit == 110103, award_level == 4) %>%
  arrange(completers) %>%
  select(inst_name, cipcode_6digit, completers)

cat("Completers for CIP 99:\n")
print(broward_cip1$completers)

cat("\nCompleters for CIP 110103:\n")
print(broward_cip2$completers)

cat("\nAre they identical?", identical(broward_cip1$completers, broward_cip2$completers), "\n")

# Check the raw CSV structure - what columns exist?
cat("\n=== Checking if race/sex columns were lost ===\n")
cat("Columns in cc_data:\n")
print(names(cc_data))

# Try to identify if there's a pattern
cat("\n=== Checking for potential key issues ===\n")
cat("Do we have race column?", "race" %in% names(cc_data), "\n")
cat("Do we have sex column?", "sex" %in% names(cc_data), "\n")

# Check what the original merger likely looked like
cat("\n=== Hypothesis: The merge created a Cartesian product ===\n")
cat("This happens when CIP data doesn't have demographic breakdowns\n")
cat("but Completers data does, causing each CIP to match ALL demographic rows\n\n")

# The solution: We need to use the source data correctly
cat("=== SOLUTION ===\n")
cat("The completers data in the CSV appears to be incorrectly merged.\n")
cat("We need to:\n")
cat("1. Go back to the CIP dataset which HAS completers by CIP code\n")
cat("2. NOT merge with the 'Completers' endpoint which has demographic breakdowns\n")
cat("3. Or, if we DO want demographics, we need to keep race/sex columns and aggregate properly\n")
