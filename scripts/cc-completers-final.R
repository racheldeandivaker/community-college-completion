### Import data from 2022 (latest year available)

# Load libraries
library(httr)
library(jsonlite)
library(dplyr)

# Option to read from existing CSV instead of API
# Had issues with API in R so importing my python csv. 

USE_EXISTING_CSV <- TRUE  # Set to FALSE to fetch from API

if (USE_EXISTING_CSV) {
  cat("Reading data from existing CSV...\n")
  cc_data <- read.csv("/Users/racheldean/Documents/GitHub/florida-cc-degree-scraper/data/cc_completers_merged.csv")

  cat("\n=== Dataset Summary ===\n")
  cat(sprintf("Dimensions: %d rows x %d columns\n", nrow(cc_data), ncol(cc_data)))
  cat("\nColumn names:\n")
  print(names(cc_data))
  cat("\nFirst few rows:\n")
  print(head(cc_data))

  cat("\n✓ Data frame 'cc_data' is available in the R environment\n")
  cat("\nTo fetch fresh data from API, set USE_EXISTING_CSV <- FALSE at the top of this script\n")} 
else:
  # Fetch from API (original code below)
  cat("Fetching data from API...\n")

  # Function to fetch all pages from API
  fetch_all_pages <- function(base_url) {
    all_results <- list()
    url <- base_url
    total_count <- NULL

    while (!is.null(url)) {
      # Add user agent and timeout (5 minutes)
      response <- GET(url,
                      add_headers(`User-Agent` = "R httr"),
                      timeout(300))

      # Check for errors
      if (http_error(response)) {
        stop(sprintf("HTTP error %s: %s", status_code(response), url))
      }

      data <- fromJSON(content(response, as = "text", encoding = "UTF-8"))

      all_results <- c(all_results, list(data$results))

      if (is.null(total_count)) {
        total_count <- data$count
      }

      cat(sprintf("  Fetched %d of %d records...\n",
                  sum(sapply(all_results, nrow)), total_count))

      url <- data$`next`

      # Add small delay to avoid rate limiting
      Sys.sleep(0.5)
    }

    # Combine all results into one data frame
    do.call(rbind, all_results)
  }

  # Fetch all pages of CIP data
  cat("Fetching CIP data...\n")
  url_cip <- "https://educationdata.urban.org/api/v1/college-university/ipeds/completions-cip-6/2022/?fips=12"
  df_cip <- fetch_all_pages(url_cip)

  # Fetch Directory data
  cat("\nFetching Directory data...\n")
  url_dir <- "https://educationdata.urban.org/api/v1/college-university/ipeds/directory/2022/?fips=12"
  response <- GET(url_dir,
                  add_headers(`User-Agent` = "R httr"),
                  timeout(300))

  # Check for errors
  if (http_error(response)) {
    stop(sprintf("HTTP error %s: %s", status_code(response), url_dir))
  }

  data_dir <- fromJSON(content(response, as = "text", encoding = "UTF-8"))
  df_dir <- as.data.frame(data_dir$results)
  cat(sprintf("  Fetched %d of %d records...\n", nrow(df_dir), data_dir$count))

  # Fetch all pages of Completers data
  cat("\nFetching Completers data...\n")
  url_comp <- "https://educationdata.urban.org/api/v1/college-university/ipeds/completers/2022/?fips=12"
  df_comp <- fetch_all_pages(url_comp)

  ### Merge datasets with multiple variables for matching

  # Merge CIP with Directory on unitid and year
  df_merged <- df_cip %>%
    left_join(df_dir, by = c("unitid", "year"))
  cat(sprintf("After merging CIP + Directory: %d rows x %d columns\n", nrow(df_merged), ncol(df_merged)))

  # Merge with Completers on unitid, year, race, and sex
  df_merged <- df_merged %>%
    left_join(df_comp, by = c("unitid", "year", "race", "sex"))
  cat(sprintf("After merging with Completers: %d rows x %d columns\n", nrow(df_merged), ncol(df_merged)))

  cat(sprintf("\nMerged dataset columns (%d):\n", ncol(df_merged)))
  print(names(df_merged))

  ### Filter columns

  df_merged <- df_merged %>%
    select(unitid, year, inst_name, fips, sector, cipcode_6digit, award_level, completers)

  ### Clean and filter data

  # Filter for Florida (fips == 12) and Public, four-year (sector == 1)
  df_merged <- df_merged %>%
    filter(fips == 12 & sector == 1)

  # Filter for Associates (4) or Certificates (30, 31, 32, 33)
  df_merged <- df_merged %>%
    filter(award_level %in% c(4, 30, 31, 32, 33))

  # Create labels
  df_merged <- df_merged %>%
    mutate(
      state = "Florida",
      sector_label = "Public four-year",
      award_level_label = case_when(
        award_level == 4 ~ "Associates",
        award_level %in% c(30, 31, 32, 33) ~ "Certificate",
        TRUE ~ NA_character_
      )
    )

  cat(sprintf("\nFiltered data (%d rows):\n", nrow(df_merged)))
  print(head(df_merged, 10))

  ### Save to CSV / keep in environment

  # Create data directory if it doesn't exist
  if (!dir.exists("data")) {
    dir.create("data")
  }

  # Create final dataset
  cc_data <- df_merged

  # Save to CSV
  write.csv(cc_data, "data/cc_completers_merged.csv", row.names = FALSE)
  cat("\nSaved to data/cc_completers_merged.csv\n")

  
  
  #Analysis: 
  
  
  # Filter for Associates degrees
df_associates <- cc_data %>%
    filter(award_level == 4)
  
  # Remove invalid values (-1, -2, -3)
  df_associates <- df_associates %>%
    filter(completers >= 0)
  
  # Group by institution and CIP code, sum completers. 
  df_grouped <- df_associates %>%
    group_by(inst_name, cipcode_6digit) %>%
    summarise(total_completers = sum(completers, na.rm = TRUE)) %>%
    ungroup()
  
  # Top 5 programs per institution
  df_top5 <- df_grouped %>%
    group_by(inst_name) %>%
    arrange(desc(total_completers)) %>%
    slice_head(n = 5) %>%
    ungroup()
  
  # View results
  print(paste("Total institutions:", n_distinct(df_top5$inst_name)))
  print(paste("Total programs:", nrow(df_top5)))
  head(df_top5, 15)
  
  # Save to CSV
  write.csv(df_top5, "data/top5_associates_by_college.csv", row.names = FALSE)


#still need to push to rachel's github - will remove this!
  #cc_data <- read.csv("/Users/racheldean/Documents/GitHub/florida-cc-degree-scraper/data/cc_completers_merged.csv")
