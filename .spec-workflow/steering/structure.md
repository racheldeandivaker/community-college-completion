# Project Structure

## Directory Organization

```
community-college-completion/
├── scripts/                # All R analysis scripts and R Markdown reports
│   ├── *.R                # R scripts for data processing and analysis
│   └── *.Rmd              # R Markdown documents for reproducible reports
├── data/                  # CSV data files (exports and cached API data)
│   └── *.csv             # Processed datasets and analysis outputs
├── .spec-workflow/        # Specification workflow management
│   ├── templates/        # Document templates
│   └── steering/         # Steering documents (this document)
├── .git/                  # Git version control
├── .gitignore            # Git ignore patterns
└── README.md             # Project overview

Structure Pattern: **Flat organization by artifact type**
- Scripts organized in a single directory (no subdirectories)
- Data outputs in a dedicated directory
- Simple structure suitable for small-to-medium research projects
```

## Naming Conventions

### Files
- **R Scripts**: `snake_case`, e.g., `cc_completers_final.R`, `check_duplicates.R`
- **R Markdown**: `snake_case`, e.g., `community_college_completion_rdd.Rmd`
- **Data Files**: `snake_case` with descriptive names, e.g., `top5_associates_by_college.csv`
- **Versioning**: Descriptive suffixes for iterations, e.g., `cc_completers_final.R` vs `cc_completers_corrected.R`

**Note**: Some existing files use kebab-case (hyphens) like `cc-completers-final.R`. Going forward, all new files should use `snake_case` (underscores only). Consider renaming existing files to maintain consistency.

### Code
- **Variables**: `snake_case` (R convention)
  - Data frames: `df_associates`, `cc_data`, `merged_data`
  - Filtered subsets: `clean_dir`, `clean_comp`, `broward_cip1`
- **Functions**: `snake_case` with verb prefixes (R convention)
  - Custom functions: `fetch_all_pages()`
  - Base R: `read.csv()`, `write.csv()`
- **Constants**: `UPPER_SNAKE_CASE`
  - Configuration flags: `USE_EXISTING_CSV`
- **Column Names**: `snake_case`
  - Example: `inst_name`, `cipcode_6digit`, `total_completers`

## Import Patterns

### Import Order
R scripts follow this standard structure:

1. **Package Loading** (using `library()`)
   ```r
   library(dplyr)
   library(educationdata)
   library(httr)
   library(jsonlite)
   ```

2. **Configuration Variables** (if applicable)
   ```r
   USE_EXISTING_CSV <- TRUE
   ```

3. **Data Loading/API Calls**
   ```r
   cc_data <- read.csv("path/to/data.csv")
   # OR
   df_cip <- fetch_all_pages(url_cip)
   ```

4. **Analysis Code**

### Module/Package Organization
- **External dependencies**: CRAN packages loaded at script start
- **No custom packages**: Project uses scripts, not an R package structure
- **Absolute paths**: Currently uses absolute file paths (to be refactored to relative)
- **Dependency strategy**: Minimal dependencies (core tidyverse + educationdata API client)

## Code Structure Patterns

### Script Organization
Standard pattern for R analysis scripts:

1. **Header Comments** (optional, more common in diagnostic scripts)
2. **Library Imports**
   ```r
   library(dplyr)
   library(educationdata)
   ```
3. **Configuration Variables**
   ```r
   USE_EXISTING_CSV <- TRUE
   ```
4. **Function Definitions** (if any)
   ```r
   fetch_all_pages <- function(base_url) { ... }
   ```
5. **Data Loading**
   ```r
   cc_data <- read.csv("data/cc_completers_merged.csv")
   ```
6. **Data Processing Pipeline** (using dplyr chains)
   ```r
   df_associates <- cc_data %>%
     filter(award_level == 4) %>%
     filter(completers >= 0) %>%
     group_by(inst_name, cipcode_6digit) %>%
     summarise(total_completers = sum(completers))
   ```
7. **Analysis/Aggregation**
8. **Output/Export**
   ```r
   write.csv(df_top5, "data/top5_associates_by_college.csv", row.names = FALSE)
   ```
9. **Console Output** (using `cat()` for progress/diagnostics)

### R Markdown Organization
R Markdown documents (`.Rmd`) follow this structure:

1. **YAML Header** (metadata)
   ```yaml
   ---
   title: "Analysis Title"
   author: "Rachel Dean Divaker"
   date: "2025-10-14"
   output: pdf_document
   ---
   ```
2. **Setup Chunk** (package installation and loading)
3. **Narrative Sections** (Markdown text explaining analysis)
4. **Code Chunks** (R code with results)
5. **Integrated Output** (tables, plots, inline results)

### Function/Method Organization
```
Pattern for custom functions:
1. Parameter validation/setup
2. Initialize variables (lists, counters)
3. Main logic (loops, API calls)
4. Progress reporting (cat() statements)
5. Return result
```

Example from `fetch_all_pages()`:
```r
fetch_all_pages <- function(base_url) {
  all_results <- list()           # Initialize
  url <- base_url
  total_count <- NULL

  while (!is.null(url)) {         # Main logic
    response <- GET(url, ...)
    data <- fromJSON(...)
    all_results <- c(all_results, list(data$results))

    cat(sprintf("Fetched %d of %d...\n", ...))  # Progress reporting
    url <- data$`next`
    Sys.sleep(0.5)                # Rate limiting
  }

  do.call(rbind, all_results)     # Return combined result
}
```

## Code Organization Principles

1. **Single Purpose Per Script**: Each R script has a clear goal:
   - `cc-completers-final.R`: Main data acquisition and analysis pipeline
   - `check_duplicates.R`: Diagnose data quality issues
   - `diagnose_data.R`: Investigate data structure
   - `community_college_completion_RDD.Rmd`: Final reproducible report

2. **Pipeline-Based Processing**: Use dplyr pipelines (`%>%`) for data transformations
   - Readable step-by-step data transformations
   - Each step documented with inline comments
   - Easy to debug by examining intermediate results

3. **Exploratory Flexibility**: Scripts designed for interactive console execution
   - Intermediate variables retained for inspection
   - `cat()` statements provide runtime visibility
   - Diagnostic scripts for data validation

4. **Reproducibility**: R Markdown captures complete analysis workflow
   - Code + narrative + results in single document
   - Knits to PDF for sharing
   - Documents assumptions and methodology

## Module Boundaries

### Script Types and Purposes

**Core Analysis Scripts**:
- `cc-completers-final.R` - Main data pipeline (API → cleaning → analysis → export)
- `cc-completers-corrected.R` - Alternative/updated analysis version
- Should contain: Data fetching, cleaning, primary analysis, CSV export

**Report Generation**:
- `community_college_completion_RDD.Rmd` - Reproducible research document
- Should contain: Full analysis narrative, embedded code, visualizations
- Output: PDF reports for distribution

**Diagnostic Utilities**:
- `check_duplicates.R` - Data quality diagnostics
- `diagnose_data.R` - Data structure investigation
- Should contain: Exploratory queries, validation checks, diagnostic output
- Purpose: One-off troubleshooting, not production pipeline

**Data Artifacts**:
- `data/` directory - CSV exports only
- No R workspace files (`.RData`, `.rds`) - intentional design choice
- CSV ensures portability and transparency

### Dependency Direction
```
[R Markdown Reports] → [Core Analysis Scripts] → [External API]
        ↓                      ↓
    [PDF Output]          [CSV Data Files]
                               ↑
                    [Diagnostic Scripts]
```

**Rules**:
- Reports can source() core scripts if needed (currently standalone)
- Diagnostic scripts read from data/ but don't modify core pipeline
- No circular dependencies

## Code Size Guidelines

**Current Project Guidelines** (flexible for research project):

- **Script Size**:
  - Target: < 200 lines for main analysis scripts
  - Current: `cc-completers-final.R` is ~190 lines (appropriate)
  - Diagnostic scripts: 50-75 lines (appropriate for focused diagnostics)
  - **Guideline**: Split scripts when exceeding 250 lines or serving multiple purposes

- **Function Size**:
  - Target: < 50 lines per function
  - Current: `fetch_all_pages()` is ~30 lines (appropriate)
  - **Guideline**: Extract helper functions when exceeding 50 lines

- **Pipeline Complexity**:
  - Dplyr chains: Keep to 3-7 steps for readability
  - Use intermediate variables for complex multi-step transformations
  - Example:
    ```r
    # Good: Clear intermediate steps
    clean_data <- raw_data %>% filter(...) %>% select(...)
    grouped_data <- clean_data %>% group_by(...) %>% summarise(...)

    # Avoid: Too many chained operations at once
    result <- raw_data %>% step1 %>% step2 %>% step3 %>% step4 %>% step5 %>% step6 %>% step7
    ```

- **Nesting Depth**:
  - Maximum 3 levels of nesting (if/loop/if)
  - Use early returns to reduce nesting

## Dashboard/Monitoring Structure

**Not Applicable** - This project uses static analysis and reporting rather than interactive dashboards.

**Future Consideration**: If implementing a Shiny dashboard, would follow this structure:
```
scripts/
└── shiny-dashboard/
    ├── app.R              # Shiny app entry point
    ├── ui.R               # UI components
    ├── server.R           # Server logic
    └── utils.R            # Helper functions
```

## Documentation Standards

### Inline Documentation
- **Complex Logic**: Use inline comments to explain "why", not "what"
  ```r
  # Filter for Associates (4) or Certificates (30, 31, 32, 33)
  df_merged <- df_merged %>%
    filter(award_level %in% c(4, 30, 31, 32, 33))
  ```

- **Diagnostic Output**: Use `cat()` statements to document console workflow
  ```r
  cat("=== Investigating data duplication ===\n\n")
  cat(sprintf("Total rows: %d\n", nrow(cc_data)))
  ```

- **Section Headers**: Use comment blocks to separate major sections
  ```r
  ### Import data from 2022 (latest year available)

  ### Clean and filter data

  ### Analysis: Top 5 programs per institution
  ```

### File-Level Documentation
- **R Scripts**: Header comments explaining purpose (currently minimal, should be enhanced)
- **R Markdown**: YAML header + introductory text explaining analysis goals
- **README.md**: Currently minimal (1 line) - should be expanded to include:
  - Project overview
  - Dependencies/installation
  - Usage instructions
  - Data sources

### Function Documentation
- **Custom Functions**: Should include roxygen-style comments (currently informal)
  ```r
  # Ideal future state:
  #' Fetch all pages from API
  #'
  #' @param base_url The starting URL for the API endpoint
  #' @return A data frame with all results combined
  fetch_all_pages <- function(base_url) { ... }
  ```

### Known Documentation Gaps (to address):
- README.md needs expansion
- Scripts lack header comments
- Function documentation is informal
- No CHANGELOG or version history

### Documentation Best Practices for This Project:
1. **R Markdown is the primary documentation**: Narrative analysis captures methodology
2. **Console output documents workflow**: `cat()` statements create audit trail
3. **Git commit messages**: Track analysis evolution
4. **CSV filenames**: Should be self-documenting (e.g., `top5_associates_by_college.csv`)
