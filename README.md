# Community College Completion Analysis

Analysis of top certificate and associate degree programs at Florida community colleges using 2023 IPEDS data.

## Overview

This project identifies the top 5 certificate and associate degree programs at each public community college in Florida based on completion counts from the 2023 IPEDS (Integrated Postsecondary Education Data System) data.

## Data Sources

The analysis uses 2023 IPEDS data files included in the project:

- **HD2023.dta** (17.8 MB): Directory/institutional data with institution identifiers, location, control, sector, and Carnegie classifications
- **C2023_a.dta** (91.1 MB): Completions data by CIP code with award levels and completion counts

These files were originally obtained via [IPEDtaS](https://github.com/ttalVlatt/IPEDtaS), an automated tool that downloads IPEDS complete data files directly from NCES and applies variable labels. The `educationdata` R package does not yet support 2023 completions data, making this approach necessary for accessing current data.

## Requirements

### Git LFS

This repository uses [Git Large File Storage (LFS)](https://git-lfs.github.com/) to manage the large .dta data files (~109 MB total). You must have Git LFS installed before cloning:

```bash
# Install Git LFS (macOS)
brew install git-lfs

# Initialize Git LFS
git lfs install

# Clone the repository
git clone https://github.com/[your-username]/community-college-completion.git
```

### R Packages

The analysis requires the following R packages:

- `dplyr` - Data manipulation
- `haven` - Reading Stata .dta files
- `here` - Project-root-aware file paths

Install packages in R:

```r
install.packages('dplyr')
install.packages('haven')
install.packages('here')
```

## Running the Analysis

You can run the analysis using either the R Markdown document (for reports) or the standalone R script (for programmatic use):

### Option 1: R Markdown (Recommended for Reports)

1. Open the R Markdown script in RStudio:
   ```
   scripts/fl_community_college_programs.Rmd
   ```

2. Run all chunks to execute the analysis

### Option 2: R Script (Recommended for Programmatic Use)

1. Run the R script from the R console (from any directory within the project):
   ```r
   source("scripts/fl_community_college_programs.R")
   ```

2. Alternatively, run from the command line:
   ```bash
   Rscript scripts/fl_community_college_programs.R
   ```

   Note: The script uses the `here` package to automatically find the project root, so it works regardless of your current working directory.

### Analysis Steps

Both files perform the same analysis:
- Load the 2023 IPEDS data files from `data/`
- Filter for Florida public community colleges
- Filter for certificate (awlevel=2) and associate degree (awlevel=3) programs
- Identify the top 5 programs by completion count at each institution
- Create `merged_data` object with top programs across all FL community colleges

### Output Differences

- **R Markdown**: Generates formatted reports and can export results to CSV if needed
- **R Script**: Creates the `merged_data` object in your R environment for programmatic use (does not write CSV output). After running the script, you can directly inspect or manipulate the data:
  ```r
  View(merged_data)          # View the results
  summary(merged_data)       # Summarize the data
  # Use merged_data for further analysis
  ```

The `merged_data` object contains:
- Institution identifiers (unitid, opeid)
- Institution names
- CIP codes for programs
- Award levels (2=certificates, 3=associate degrees)
- Total completion counts

## Project Structure

```
community-college-completion/
├── data/                           # Data files (managed with Git LFS)
│   ├── HD2023.dta                 # IPEDS directory data
│   └── C2023_a.dta                # IPEDS completions data
├── scripts/                       # R scripts and R Markdown files
│   ├── fl_community_college_programs.Rmd  # Main analysis (R Markdown)
│   └── fl_community_college_programs.R    # Main analysis (R script)
└── README.md                      # This file
```

## Notes

- **Award Level Coding**: The 2023 IPEDS .dta files use `awlevel=2` for certificates and `awlevel=3` for associate degrees (different from prior years' coding)
- **Demographics**: The .dta files contain pre-aggregated demographic totals (ctotalt = total completers across all demographics)
- **Data Currency**: This analysis uses the most recent IPEDS data available (2023)

## Contributing

The `main` branch is protected to maintain code stability and ensure all changes are reviewed. To contribute:

1. Create a new branch: `git checkout -b feature/your-feature-name`
2. Make your changes and test thoroughly
3. Push your branch: `git push origin feature/your-feature-name`
4. Submit a pull request for review

Please follow existing code style, test with the included data files, and update CHANGELOG.md with your changes.

## Citation

If you use the IPEDS data files in this project, please cite:

Capaldi, M. J. (2024). IPEDtaS: Automagically Download Labeled .dta IPEDS Files in Stata and R (Version 0.1) [Computer software]. https://doi.org/10.5281/zenodo.13388846
