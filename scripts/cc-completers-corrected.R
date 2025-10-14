## load libraries

library(dplyr)
library(educationdata)

# Import directory dataset
dir_data <- get_education_data(
  level = "college-university",
  source = "ipeds",
  topic = "directory",
  filters = list(year = 2022)
)

# Filter variables
dir_data <- dir_data %>%
  select(unitid, year, fips, sector)

# Import completions-cip-6 dataset
comp_data <- get_education_data(
  level = "college-university",
  source = "ipeds",
  topic = "completions-cip-6",
  filters = list(year = 2022)
)


# Filter variables
comp_data <- comp_data %>%
  select(unitid, year, fips, cipcode_6digit, award_level)

# Merge datasets using common variables
merged_data <- left_join(comp_data, dir_data, by = c("unitid", "year", "fips"))



# Filter for Florida (fips == 12) and Public institutions (sector == 1 or 4)
# Note: sector 1 = public 4-year, sector 4 = public 2-year (community colleges)
merged_data <- merged_data %>%
  filter(fips == 12 & sector %in% c(1, 4))







# Filter for Associates (4) only
df_associates <- merged_data %>%
  filter(award_level == 4)

# Remove invalid values
df_associates <- df_associates %>%
  filter(completers >= 0)

cat(sprintf("\nFiltered for Associates degrees: %d rows\n", nrow(df_associates)))

# Create final dataset
cc_data <- df_associates

# Save cleaned data
if (!dir.exists("data")) {
  dir.create("data")
}
write.csv(cc_data, "data/cc_completers_corrected.csv", row.names = FALSE)
cat("Saved to data/cc_completers_corrected.csv\n")

### Analysis: Top 5 programs per institution

# Group by institution and CIP code, sum completers
df_grouped <- cc_data %>%
  group_by(inst_name, cipcode_6digit) %>%
  summarise(total_completers = sum(completers, na.rm = TRUE), .groups = "drop")

# Top 5 programs per institution
df_top5 <- df_grouped %>%
  group_by(inst_name) %>%
  arrange(desc(total_completers)) %>%
  slice_head(n = 5) %>%
  ungroup()

# View results
cat("\n=== TOP 5 ASSOCIATES PROGRAMS PER INSTITUTION ===\n")
print(paste("Total institutions:", n_distinct(df_top5$inst_name)))
print(paste("Total programs:", nrow(df_top5)))

cat("\nSample results:\n")
print(df_top5 %>% head(20))

# Save to CSV
write.csv(df_top5, "data/top5_associates_by_college_corrected.csv", row.names = FALSE)
cat("\nSaved results to data/top5_associates_by_college_corrected.csv\n")
