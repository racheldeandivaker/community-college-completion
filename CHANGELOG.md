# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-10-28

### Added

- Git LFS support for managing large IPEDS data files (.dta files)
- 2023 IPEDS data files (HD2023.dta and C2023_a.dta) included in project
- Comprehensive README.md with installation instructions, requirements, and usage guide
- Citation information for IPEDtaS tool in README
- R Markdown script for analyzing top certificate and associate degree programs
- Data filtering for Florida public community colleges
- Support for 2023 IPEDS award level coding (awlevel=2 for certificates, awlevel=3 for associate degrees)
- NA filtering for cipcode, awlevel, and ctotalt variables
- Analysis to identify top 5 programs by completion count at each institution

### Changed

- Updated from 2022 to 2023 IPEDS data
- Migrated from educationdata API to IPEDtaS-downloaded .dta files for 2023 data access
- Changed data path from external IPEDtaS repository to local project data directory
- Updated award level filtering to use 2023 coding scheme (2 and 3 instead of 32 and 4)
- Simplified project structure for better reproducibility

### Removed

- External dependency on separate IPEDtaS repository
- Hardcoded user-specific file paths
- Test/debugging code chunks from R Markdown script
- Spec workflow files from version control

## [0.1.0] - 2025-10-14

### Added

- Initial R Markdown script for community college completion analysis
- Data fetching and merging functionality for IPEDS directory and completions data
- Filtering for Florida community colleges based on FIPS code and Carnegie classification
- CIP code filtering to remove miscellaneous categories
- Top 5 associates program calculation by institution
- Local data loading for testing purposes

### Changed

- Refined data cleaning logic for program-level analysis
- Improved filtering to exclude CIP code 99 (miscellaneous category)

[unreleased]: https://github.com/community-college-completion/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/community-college-completion/compare/v0.1.0...v1.0.0
[0.1.0]: https://github.com/community-college-completion/releases/tag/v0.1.0
