# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.1] - 2025-11-18

### Added

- CSV output functionality to both R script and R Markdown files
- `readr` package dependency for CSV writing
- Automated saving of analysis results to `data/fl_cc_programs.csv`
- Console confirmation message showing where results were saved

### Changed

- Updated README to reflect CSV output capability in both scripts
- Updated README to include `readr` in required packages
- Updated project structure documentation to show generated output file

## [0.1.0] - 2025-10-29

### Added

- Initial R Markdown script for community college completion analysis
- Standalone R script version (`fl_community_college_programs.R`) for programmatic use
- Git LFS support for managing large IPEDS data files (.dta files)
- 2023 IPEDS data files (HD2023.dta and C2023_a.dta) included in project
- Comprehensive README.md with installation instructions, requirements, and usage guide
- Citation information for IPEDtaS tool in README
- Documentation for both R Markdown and R script execution options
- `here` package for project-root-aware file paths
- Data filtering for Florida public community colleges based on FIPS code and Carnegie classification
- Support for 2023 IPEDS award level coding (awlevel=2 for certificates, awlevel=3 for associate degrees)
- NA filtering for cipcode, awlevel, ctotalt, opeid, and instnm variables
- CIP code filtering to remove miscellaneous categories
- Analysis to identify top 5 programs by completion count at each institution
- Filter to remove rows with missing completion data after join operation
- Data fetching and merging functionality for IPEDS directory and completions data

### Changed

- Updated from 2022 to 2023 IPEDS data
- Migrated from educationdata API to IPEDtaS-downloaded .dta files for 2023 data access
- Changed data path from external IPEDtaS repository to local project data directory
- Updated award level filtering to use 2023 coding scheme (2 and 3 instead of 32 and 4)
- Renamed primary analysis file from `community_college_completion_RDD.Rmd` to `fl_community_college_programs.Rmd` for better clarity and to follow snake_case naming convention
- Improved code readability with multi-line filter statements and inline comments
- Updated all documentation references to reflect renamed file and new R script option
- Simplified project structure for better reproducibility
- Refined data cleaning logic for program-level analysis
- Improved filtering to exclude CIP code 99 (miscellaneous category)

### Removed

- External dependency on separate IPEDtaS repository
- Hardcoded user-specific file paths
- Test/debugging code chunks from R Markdown script
- Spec workflow files from version control
- Obsolete analysis output file (`top5_associates_by_college.csv`)
- Legacy R scripts from 2022 analysis (`cc-completers-corrected.R`, `cc-completers-final.R`, `check_duplicates.R`, `diagnose_data.R`)
- Temporary R session files (`.RData`, `.Rhistory`) from scripts directory

[unreleased]: https://github.com/community-college-completion/compare/v0.1.1...HEAD
[0.1.1]: https://github.com/community-college-completion/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/community-college-completion/releases/tag/v0.1.0
