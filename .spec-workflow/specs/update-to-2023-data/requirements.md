# Requirements Document

## Introduction

This specification addresses the need to update the Florida community college completion analysis from 2022 IPEDS data to 2023 IPEDS data. The current script (`community_college_completion_RDD.Rmd`) successfully fetches and analyzes 2022 data using the `educationdata` R package but fails when the year is changed to 2023. This update is critical for keeping the analysis current and relevant for 2024-2025 policy decisions.

This will be an **interactive debugging specification** where each task requires testing and validation before proceeding to the next, as the root cause of the failure is unknown and may involve:
- The `educationdata` package not supporting 2023 data yet
- Carnegie classification variable name changes (e.g., `cc_basic_2021` → `cc_basic_2023`)
- Variable name changes in the 2023 dataset (e.g., `awards_6digit` availability)
- Different data availability or schema modifications in IPEDS 2023

## Alignment with Product Vision

This feature directly supports the Product Vision outlined in `.spec-workflow/steering/product.md`:

- **Reproducibility**: Enables the analysis pipeline to work with the latest available year (2023) without manual intervention
- **Flexibility**: Addresses the Product Principle that "Code structure allows for easy adaptation to different years"
- **Success Metrics**: Maintains the goal that "Scripts can be re-run with different years without manual intervention"
- **Future Vision - Temporal Analysis**: Establishes foundation for multi-year trend analysis by successfully implementing year parameterization
- **Data Coverage**: Ensures analysis includes the most current completion data available from IPEDS

## Requirements

### Requirement 1: Data Availability Verification

**User Story:** As an educational researcher, I want to verify that 2023 IPEDS data is available via the `educationdata` package or alternative methods, so that I can update my analysis to the most current year.

#### Acceptance Criteria

1. WHEN checking the `educationdata` package documentation THEN we SHALL determine if 2023 data is supported
2. WHEN calling `get_education_data()` with year 2023 THEN it SHALL either succeed or provide clear error messages
3. IF the `educationdata` package does not support 2023 THEN alternative methods (direct API calls) SHALL be identified
4. WHEN testing directory data for 2023 THEN the call SHALL return Florida institutional records
5. WHEN testing completions-cip-6 data for 2023 THEN the call SHALL return program completion records
6. IF 2023 data is not available at all THEN the requirement SHALL document this and adjust expectations

### Requirement 2: Data Schema Validation

**User Story:** As an educational researcher, I want to verify that all required variables exist in the 2023 dataset, so that my analysis logic (joins, filters, aggregations) continues to work correctly.

#### Acceptance Criteria

1. WHEN 2023 completions-cip-6 data is fetched THEN the following variables SHALL be present:
   - `unitid`, `year`, `fips`, `cipcode_6digit`, `award_level`, `awards_6digit`, `sex`, `race`
2. WHEN 2023 directory data is fetched THEN the following variables SHALL be present:
   - `unitid`, `year`, `opeid`, `fips`, `sector`, `inst_control`, `inst_name`
3. WHEN 2023 directory data is fetched THEN a Carnegie classification variable SHALL be identified (e.g., `cc_basic_2021`, `cc_basic_2023`, or similar)
4. IF the Carnegie classification variable name has changed THEN the script SHALL be updated to use the new name
5. IF any other variable names have changed THEN the script SHALL be updated accordingly
6. WHEN datasets are merged on join keys THEN the merge SHALL succeed without errors

### Requirement 3: Data Quality Validation

**User Story:** As an educational researcher, I want to ensure the 2023 data contains valid Florida community college records, so that my analysis produces accurate and meaningful results.

#### Acceptance Criteria

1. WHEN data is filtered for Florida (fips == 12) THEN the result SHALL contain records
2. WHEN data is filtered for public institutions (inst_control == 1) THEN the result SHALL contain Florida public colleges
3. WHEN data is filtered using Carnegie classification THEN the result SHALL contain community colleges (not universities)
4. WHEN data is filtered for sex == 99 and race == 99 THEN the result SHALL contain total counts (not demographic breakdowns)
5. WHEN data is filtered for award levels (4, 32) THEN the result SHALL contain associate degrees and certificates
6. WHEN `cipcode_6digit` is filtered to exclude 99 THEN miscellaneous categories SHALL be removed
7. WHEN `awards_6digit > 0` filter is applied THEN only programs with completers SHALL remain
8. WHEN top 5 programs are calculated per `opeid` and `award_level` THEN each institution SHALL have meaningful results

### Requirement 4: Interactive Debugging Workflow

**User Story:** As an educational researcher with limited R debugging experience, I want each update to be tested incrementally, so that I can identify and fix issues at each step rather than encountering multiple failures at once.

#### Acceptance Criteria

1. WHEN each task is implemented THEN it SHALL be tested immediately before proceeding
2. WHEN an API call is updated THEN the response SHALL be inspected for structure and content
3. WHEN a data merge is performed THEN row counts and column availability SHALL be verified
4. WHEN filters are applied THEN resulting record counts SHALL be checked for reasonableness
5. IF any step fails THEN debugging information SHALL be provided before moving to the next task
6. WHEN the full pipeline completes THEN the output SHALL be compared to 2022 results for validation

### Requirement 5: Year Parameterization

**User Story:** As an educational researcher, I want the year to be easily configurable in one place, so that future updates to 2024 and beyond require minimal code changes.

#### Acceptance Criteria

1. WHEN the script is updated THEN a single `YEAR` variable SHALL control all `get_education_data()` calls
2. WHEN the `YEAR` variable is changed THEN both directory and completions-cip-6 filters SHALL use the new year
3. IF Carnegie classification variables are year-specific THEN the appropriate variable SHALL be selected based on the year
4. WHEN the R Markdown document is knit THEN the output SHALL clearly indicate which year was analyzed
5. WHEN the analysis completes THEN results SHALL be validated for reasonableness

## Non-Functional Requirements

### Code Architecture and Modularity
- **Single Responsibility Principle**: Data import, data cleaning, and analysis logic remain in separate R Markdown chunks
- **R Markdown Structure**: Continue using narrative text with embedded code chunks for reproducibility
- **Minimal Changes**: Modifications should focus on year parameterization and variable name updates only
- **Clear Error Handling**: `get_education_data()` calls should be tested incrementally with informative output

### Performance
- `get_education_data()` calls should complete within reasonable timeframes (< 5 minutes total for both datasets)
- Data processing should handle 2023 dataset size efficiently (expected to be similar to 2022)
- R Markdown knitting to PDF should complete without memory issues

### Reliability
- Each code chunk should be tested incrementally before knitting the full document
- Data validation checks should catch schema mismatches before merging datasets
- Error messages from `educationdata` package should be captured and interpreted

### Usability
- R Markdown narrative text should be updated to reflect the correct year
- Comments should clearly document any variable name changes or workarounds
- The document should be self-documenting with explanations of filtering logic
