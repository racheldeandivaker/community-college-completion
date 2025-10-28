# Technology Stack

## Project Type
This is a **data analysis and research project** using R for statistical computing and reproducible research. The project fetches, cleans, analyzes, and reports on educational data from the IPEDS (Integrated Postsecondary Education Data System) database.

## Core Technologies

### Primary Language(s)
- **Language**: R (version agnostic, compatible with R 3.6+)
- **Runtime/Compiler**: R interpreter
- **Language-specific tools**:
  - R Markdown for literate programming and report generation
  - knitr for dynamic report compilation
  - Standard R package management system

### Key Dependencies/Libraries
- **dplyr**: Data manipulation and transformation (tidyverse ecosystem)
- **educationdata**: R client for Urban Institute's Education Data API
- **httr**: HTTP client for API requests and authentication
- **jsonlite**: JSON parsing and serialization for API responses
- **knitr**: Dynamic document generation from R Markdown
- **rmarkdown**: Document compilation framework

### Application Architecture
**Console-based Interactive Analysis** using RStudio with the following workflow:

**Execution Model**: Scripts are run interactively in the RStudio console, creating runtime R variables in the active environment. This is an **intentional design choice** for exploratory research projects where:
- Analysts need to inspect intermediate data frames and results
- Flexible exploration requires modifying queries and filters on-the-fly
- Academic research benefits from seeing each transformation step
- R Markdown documents capture the full analysis narrative with embedded code

**Data Persistence Strategy**: Since R variables are runtime-only (not persistent between sessions), the project uses:
- **CSV exports** as the primary persistence mechanism (`data/` directory)
- **R Markdown reports** that document and preserve analysis results
- **Optional caching** via `USE_EXISTING_CSV` flag to avoid re-fetching API data
- **Git version control** to track code changes and analysis evolution

**Pipeline Components**:
1. **Data Acquisition Layer**: Scripts that fetch data from the Education Data API
2. **Data Cleaning Layer**: Filtering and transformation logic to prepare analysis-ready datasets
3. **Analysis Layer**: Statistical calculations and aggregations (top programs, completion counts)
4. **Output Layer**: CSV exports and R Markdown PDF reports
5. **Diagnostic Utilities**: Helper scripts for data validation and duplicate checking

The architecture follows a **linear pipeline pattern**: Data Fetch → Clean → Transform → Analyze → Export/Report

Each script can be run independently in the console, and results are preserved through CSV files and compiled reports rather than serialized R objects (.RData files).

### Data Storage (if applicable)
- **Primary storage**: Flat CSV files in the `data/` directory
- **Caching**: Optional CSV-based caching to avoid repeated API calls (controlled by `USE_EXISTING_CSV` flag)
- **Data formats**:
  - CSV for structured tabular data exports
  - JSON for API responses (parsed to R data frames)
  - PDF for compiled analysis reports

### External Integrations (if applicable)
- **APIs**: Urban Institute Education Data API (https://educationdata.urban.org/api/v1/)
  - Endpoints: `/college-university/ipeds/completions-cip-6/`, `/directory/`, `/completers/`
  - Data source: IPEDS (Integrated Postsecondary Education Data System)
- **Protocols**: HTTP/REST with JSON responses
- **Authentication**: Public API with user-agent header (no authentication tokens required)
- **Rate Limiting**: Client-side delay (0.5s between requests) to respect API usage policies
- **Pagination**: Custom pagination handler for multi-page API responses

### Monitoring & Dashboard Technologies (if applicable)
This project uses **static reporting** rather than interactive dashboards:

- **Report Format**: PDF documents generated from R Markdown
- **Visualization**: Base R plotting or ggplot2 (if added)
- **Output Inspection**: CSV files can be opened in Excel, RStudio viewer, or imported to other tools
- **Progress Monitoring**: Console output with `cat()` statements during data fetching

## Development Environment

### Build & Development Tools
- **Build System**: R Markdown rendering via knitr
- **Package Management**: R's built-in `install.packages()` and library loading
- **Development workflow**:
  - Interactive development in RStudio or R console
  - R Markdown notebooks for iterative analysis
  - Script execution for batch processing

### Code Quality Tools
- **Static Analysis**: None currently implemented (could add lintr)
- **Formatting**: Manual code formatting following R style conventions
- **Testing Framework**: None currently implemented (could add testthat)
- **Documentation**:
  - Inline comments in R scripts
  - R Markdown documents serve as self-documenting analysis
  - README.md (currently minimal)

### Version Control & Collaboration
- **VCS**: Git
- **Repository**: GitHub (community-college-completion)
- **Branching Strategy**: Feature branches (e.g., `CC-1-use-2023-data`)
- **Code Review Process**: Not currently formalized (single researcher project)

### Dashboard Development (if applicable)
N/A - This project produces static reports rather than interactive dashboards. Future enhancement could include Shiny app development.

## Deployment & Distribution (if applicable)
- **Target Platform(s)**: Local R environment (macOS, Windows, Linux compatible)
- **Distribution Method**:
  - GitHub repository (open source or private)
  - Scripts can be cloned and run by other researchers
- **Installation Requirements**:
  - R (version 3.6 or higher recommended)
  - Required CRAN packages: dplyr, httr, jsonlite, educationdata, rmarkdown
  - LaTeX distribution (for PDF rendering via R Markdown)
- **Update Mechanism**: Git pull for code updates; `install.packages()` for dependency updates

## Technical Requirements & Constraints

### Performance Requirements
- **API Response Time**: Dependent on Urban Institute API (typically 1-5 seconds per request)
- **Data Processing**: Should handle ~10,000-50,000 completion records efficiently (< 1 minute processing time)
- **Memory Usage**: Typical data frames fit in < 500MB RAM
- **Report Generation**: PDF compilation should complete in < 2 minutes

### Compatibility Requirements
- **Platform Support**: Cross-platform (macOS, Windows, Linux) via R
- **Dependency Versions**:
  - R >= 3.6.0
  - Compatible with both R 3.x and R 4.x
- **Data API Versions**: Uses Education Data API v1 (stable endpoint)
- **Standards Compliance**: Follows tidy data principles (Wickham)

### Security & Compliance
- **Security Requirements**:
  - Public data only (IPEDS is publicly available)
  - No PII or student-level records (aggregated institutional data)
- **Compliance Standards**:
  - FERPA compliant (no individual student data)
  - Uses publicly released IPEDS aggregate data
- **Threat Model**:
  - Low risk - public data analysis
  - API rate limiting to prevent service abuse
  - No sensitive credentials stored

### Scalability & Reliability
- **Expected Load**: Single-user research scripts, occasional execution
- **Data Volume**: ~10-50K records per analysis year
- **Availability Requirements**: Not applicable (batch processing, not a service)
- **Growth Projections**:
  - Could expand to multi-year longitudinal analysis
  - Potential to scale to all states (currently Florida only)
  - May require more efficient data structures if scaling significantly

## Technical Decisions & Rationale

### Decision Log

1. **Console-based Interactive Workflow (vs. Structured R Package)**:
   - **Why**: Chosen for flexibility and exploratory research needs
   - **Rationale**:
     - Enables interactive data inspection and ad-hoc analysis
     - Faster iteration for research questions that evolve during analysis
     - Standard practice for academic statistical research
     - R Markdown provides reproducibility without package overhead
   - **Persistence Strategy**: CSV files and R Markdown reports preserve results; runtime variables are intentionally ephemeral
   - **Alternatives considered**: Formal R package with persistent functions, automated pipelines
   - **Trade-offs Accepted**:
     - Runtime variables lost between sessions (mitigated by CSV caching)
     - Requires manual script execution (acceptable for single-researcher project)
     - Less automation (but more control and transparency)
   - **When to reconsider**: If project scales to multi-user collaboration or production deployment

2. **R Language Selection**:
   - **Why**: R is the standard for educational data analysis and statistical research
   - **Alternatives considered**: Python (pandas), but R provides better integration with academic research workflows and R Markdown publishing
   - **Trade-offs**: R has steeper learning curve for non-statisticians, but superior for reproducible research

3. **educationdata Package vs Direct API Calls**:
   - **Why**: Initially used `educationdata` package for simplified API access
   - **Fallback implemented**: Direct httr/jsonlite calls when API issues occurred
   - **Current approach**: Hybrid with CSV caching option (`USE_EXISTING_CSV` flag)
   - **Rationale**: Flexibility to work offline and avoid repeated API calls during development

4. **CSV-based Data Storage**:
   - **Why**: Simplicity, portability, wide compatibility
   - **Alternatives considered**: Database (SQLite, PostgreSQL) for larger scale
   - **Trade-offs**: CSV is less efficient for large datasets but sufficient for current scope
   - **Future consideration**: Database backend if scaling to multi-state, multi-year analysis

5. **R Markdown for Reporting**:
   - **Why**: Industry standard for reproducible research, combines code and narrative
   - **Alternatives**: Separate scripts + manual report writing, Jupyter notebooks
   - **Rationale**: R Markdown ensures reproducibility and is publication-ready

6. **Manual Pagination Handling**:
   - **Why**: Urban Institute API requires pagination for large result sets
   - **Implementation**: Custom `fetch_all_pages()` function with progress tracking
   - **Trade-offs**: More code complexity but full control over rate limiting and error handling

## Known Limitations

- **Hard-coded File Paths**: Some scripts contain absolute paths (e.g., `/Users/racheldean/...`) which reduces portability
  - **Impact**: Scripts won't run on other machines without path modification
  - **Future solution**: Use relative paths and here package for path management

- **Limited Error Handling**: API calls and data processing lack comprehensive try-catch blocks
  - **Impact**: Script failures may not provide clear error messages
  - **When to address**: Before sharing code publicly or scaling to production

- **No Automated Testing**: Analysis logic is not unit-tested
  - **Impact**: Changes could introduce bugs in data cleaning/filtering logic
  - **Future solution**: Implement testthat framework for critical functions

- **Year Parameterization**: Currently analyzing 2022 data, with plans to implement year as a configurable variable
  - **Current state**: Year 2022 is specified in multiple places
  - **Planned enhancement**: Parameterize year as script argument or configuration variable to enable easy analysis of 2023 and future years
  - **Impact**: Will allow flexible multi-year analysis without code modifications

- **Single-State Focus**: Currently hardcoded to Florida (fips == 12)
  - **Impact**: Cannot easily generalize to other states
  - **Future solution**: Parameterize state selection for multi-state analysis

- **No Data Versioning**: Exported CSVs don't include timestamps or version metadata
  - **Impact**: Difficult to track when data was fetched or which API version was used
  - **Future solution**: Add metadata to outputs (date fetched, API version, script version)

- **Minimal Documentation**: README is sparse, function documentation is informal
  - **Impact**: Difficult for collaborators to understand and contribute
  - **When to address**: Before project sharing or publication
