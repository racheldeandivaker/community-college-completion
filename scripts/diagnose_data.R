# Diagnostic script to investigate data structure

library(dplyr)

# Load the data
cc_data <- read.csv("/Users/racheldean/Documents/GitHub/florida-cc-degree-scraper/data/cc_completers_merged.csv")

cat("=== Initial Data Structure ===\n")
cat(sprintf("Total rows: %d\n", nrow(cc_data)))
cat(sprintf("Total columns: %d\n", ncol(cc_data)))

# Filter for Associates degrees
df_associates <- cc_data %>%
  filter(award_level == 4)

cat(sprintf("\nAfter filtering for Associates (award_level == 4): %d rows\n", nrow(df_associates)))

# Remove invalid values
df_associates <- df_associates %>%
  filter(completers >= 0)

cat(sprintf("After removing invalid completers (<0): %d rows\n", nrow(df_associates)))

# Look at one institution in detail
cat("\n=== Examining Broward College ===\n")
broward <- df_associates %>%
  filter(inst_name == "Broward College") %>%
  arrange(cipcode_6digit, desc(completers))

cat(sprintf("Total rows for Broward College: %d\n", nrow(broward)))
cat("\nUnique CIP codes at Broward:\n")
print(unique(broward$cipcode_6digit))

cat("\nSample of Broward data (first 20 rows):\n")
print(head(broward %>% select(inst_name, cipcode_6digit, completers), 20))

cat("\n=== Checking for additional grouping variables ===\n")
cat("Columns in dataset:\n")
print(names(df_associates))

# Check if there are race/sex variables that need grouping
cat("\n=== Examining unique values in key columns ===\n")
for (col in names(df_associates)) {
  unique_count <- length(unique(df_associates[[col]]))
  if (unique_count < 50) {  # Only show columns with reasonable unique counts
    cat(sprintf("%s: %d unique values\n", col, unique_count))
  }
}

# Let's see the structure more clearly
cat("\n=== Looking at one CIP code for Broward ===\n")
broward_one_cip <- df_associates %>%
  filter(inst_name == "Broward College", cipcode_6digit == 110103)

cat(sprintf("Rows for Broward College, CIP 110103: %d\n", nrow(broward_one_cip)))
print(broward_one_cip %>% select(inst_name, cipcode_6digit, completers))

cat("\n=== Testing the grouping operation ===\n")
df_grouped <- df_associates %>%
  group_by(inst_name, cipcode_6digit) %>%
  summarise(
    total_completers = sum(completers, na.rm = TRUE),
    n_rows = n()
  ) %>%
  ungroup()

cat("\nGrouped data for Broward College (top 10):\n")
print(df_grouped %>%
  filter(inst_name == "Broward College") %>%
  arrange(desc(total_completers)) %>%
  head(10))
