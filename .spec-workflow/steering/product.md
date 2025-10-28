# Product Overview

## Product Purpose
This project analyzes community college completion data for Florida institutions to identify trends in certificate and associate degree programs. It provides insights into which programs have the highest completion rates across different community colleges, helping educational researchers, policymakers, and administrators understand program performance and make data-driven decisions about resource allocation and program development.

## Target Users
**Primary Users:**
- Educational researchers analyzing community college program effectiveness
- State policymakers evaluating educational outcomes
- Community college administrators assessing program performance
- Academic program directors comparing institutional programs

**User Needs:**
- Access to clean, analyzed IPEDS completion data for Florida community colleges
- Identification of top-performing programs by institution
- Ability to compare completion rates across institutions and program types
- Reproducible data analysis pipeline for ongoing research

## Key Features

1. **Automated Data Retrieval**: Fetches completion, directory, and CIP code data from the Urban Institute's Education Data API for Florida institutions
2. **Data Cleaning and Filtering**: Processes raw IPEDS data to focus on relevant institutions (public community colleges) and award types (certificates and associate degrees)
3. **Top Program Identification**: Calculates and ranks the top 5 certificate and associate degree programs by completion numbers for each Florida community college
4. **Reproducible Analysis Pipeline**: R Markdown documents and R scripts that can be re-run with updated data years
5. **Data Export**: Generates CSV outputs for further analysis or visualization

## Business Objectives
- Provide transparent, reproducible analysis of Florida community college completion patterns
- Enable evidence-based decision-making for educational policy and resource allocation
- Support research into community college program effectiveness
- Facilitate cross-institutional comparisons of program performance
- Document methodology for replication in other states or time periods

## Success Metrics
- **Data Accuracy**: 100% of Florida public community colleges included in analysis
- **Reproducibility**: Scripts can be re-run with different years without manual intervention
- **Data Coverage**: Analysis includes all certificate (levels 30-33) and associate degree (level 4) completions
- **Output Quality**: Top 5 programs accurately identified for each institution with no data quality issues
- **Documentation**: Clear methodology that can be replicated by other researchers

## Product Principles

1. **Transparency**: All data sources, cleaning steps, and analysis methods are documented and visible in the code
2. **Reproducibility**: Analysis can be replicated by any researcher with access to the IPEDS API or exported data files
3. **Data Quality**: Filters out invalid/missing data (-1, -2, -3 codes) and focuses on meaningful completion counts
4. **Institutional Focus**: Centers analysis on public community colleges in Florida using standardized Carnegie classifications
5. **Flexibility**: Code structure allows for easy adaptation to different years, states, or award levels

## Monitoring & Visibility (if applicable)
This is a research/analysis project rather than a production system, so monitoring focuses on:

- **Data Quality Checks**: R scripts include diagnostic functions to verify data integrity and identify duplicates
- **Analysis Outputs**: Results are exported to CSV files in the `data/` directory for inspection
- **Documentation**: R Markdown reports provide PDF output with embedded analysis and visualizations
- **Version Control**: Git tracking ensures all changes to analysis methodology are documented

## Future Vision
This project establishes a foundation for ongoing community college completion research with potential for expansion.

### Potential Enhancements
- **Temporal Analysis**: Extend analysis across multiple years to identify trends over time
- **Demographic Breakdown**: Incorporate race and gender variables for equity analysis
- **Geographic Visualization**: Create maps showing program distribution across Florida regions
- **Statistical Modeling**: Implement regression discontinuity design (RDD) for causal analysis
- **Interactive Dashboards**: Build Shiny app or web dashboard for exploratory data analysis
- **Cross-State Comparison**: Expand methodology to compare Florida with other state community college systems
- **Program Taxonomy**: Link CIP codes to detailed program names and descriptions
- **Completion Rate Analysis**: Calculate completion rates (not just counts) by incorporating enrollment data
