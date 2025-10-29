# ============================================================================
# Top Five Certificates and Associate Degrees across FL Community Colleges
# ============================================================================
# Author: Rachel Dean Divaker
# Date: 2025-10-28
#
# Description:
# This script analyzes community college completion data for Florida
# institutions to identify the top 5 certificate and associate degree programs
# at each public community college based on completion counts from the 2023
# IPEDS (Integrated Postsecondary Education Data System) data.

# Data Source:
# 2023 IPEDS data files (HD2023.dta and C2023_a.dta) obtained via IPEDtaS
# (https://github.com/ttalVlatt/IPEDtaS), which automates downloading and
# labeling IPEDS data directly from NCES.
# ============================================================================

# ============================================================================
# Setup and Configuration
# ============================================================================

# Load required libraries
library(dplyr)
library(haven)
library(here)    # For project-root-aware file paths

# Set up data paths (relative to project root)
# The here package automatically finds the project root directory
# Data files are stored in the project's data/ directory
DATA_PATH <- here("data")

# ============================================================================
# Data Import
# ============================================================================

# Importing and cleaning data from directory and program completions using
# 2023 IPEDS data.

# Variable Notes:
# - Directory data: institution name: instnm, carnegie classification: c21basic, institution control: control
# - Completions data: award level : awlevel, cipcode_6digit: cipcode, awards_6digit: ctotalt
# - Award level codes in 2023 .dta files: awlevel=2 (At least one-year certificates),
#   awlevel=3 (associate degrees)
# - Demographics: ctotalt: total completers

# Import directory dataset from HD2023.dta
dir_data <- read_dta(file.path(DATA_PATH, "HD2023.dta"))

cat(sprintf("Loaded directory data: %d institutions\n", nrow(dir_data)))

# Import completions-cip-6 dataset from C2023_a.dta
comp_data <- read_dta(file.path(DATA_PATH, "C2023_a.dta"))

cat(sprintf("Loaded completions data: %d records\n", nrow(comp_data)))

# ============================================================================
# Data Cleaning
# ============================================================================

# Cleaning data: filtering for Florida community colleges and
# certificate and associate degree programs.

# Directory data
# Select and filter variables

clean_dir <- dir_data %>%
  select(unitid, opeid, fips, sector, control, c21basic, instnm) %>%
  filter(
    fips == 12,              # Florida only
    !is.na(opeid),           # Remove missing OPEID
    opeid != "-2",           # Valid OPEID (exclude -2)
    control == 1,            # Public institutions only
    (c21basic >= 1 & c21basic <= 8) | c21basic == 14 | c21basic == 23,  # Community college Carnegie classifications
    !is.na(instnm)          # Remove missing institution names
  )

cat(sprintf("Filtered directory: %d Florida community colleges\n", nrow(clean_dir)))

# CIP
# Select and filter variables
# Variable name updates for .dta files: award_level: awlevel, cipcode_6digit: cipcode, awards_6digit: ctotalt
# Note: Demographics pre-aggregated in .dta files - using ctotalt (total completers, all demographics)

# awlevel: 2 = certificates 
# awlevel: 3 = associate degrees
# ctotalt: total completers
# cipcode: CIP code for program, removing 99 (miscellaneous category)

clean_comp <- comp_data %>%
  select(unitid, cipcode, awlevel, ctotalt) %>%
  filter(
    !is.na(cipcode),         # Remove missing CIP codes
    !is.na(awlevel),         # Remove missing award levels
    !is.na(ctotalt),         # Remove missing completion counts
    cipcode > 0,             # Valid CIP codes only
    cipcode != 99,           # Exclude miscellaneous category
    awlevel %in% c(2, 3),    # Certificates (2) and associate degrees (3) only
    ctotalt > 0              # Programs with completions only
  )

cat(sprintf("Filtered completions: %d program records\n", nrow(clean_comp)))

# ============================================================================
# Analysis: Merge and Rank Top Programs
# ============================================================================

# Merging Directory and CIPcode data and getting top five certificate and
# associate programs at each FL community college

merged_data <- left_join(clean_dir, clean_comp, by = "unitid") %>%
  filter(!is.na(awlevel), !is.na(ctotalt), !is.na(cipcode)) %>%  # Remove rows with missing completion data
  group_by(opeid, awlevel) %>%
  slice_max(order_by = ctotalt, n = 5, with_ties = TRUE)

cat(sprintf("Merged data: %d top programs\n", nrow(merged_data)))
cat(sprintf("Institutions represented: %d\n", n_distinct(merged_data$opeid)))

##### END SCRIPT #####
