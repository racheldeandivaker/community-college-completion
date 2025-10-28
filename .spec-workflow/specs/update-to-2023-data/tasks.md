# Tasks Document

## Task Status Legend
- `[ ]` = Pending (not started)
- `[-]` = In Progress (currently working on)
- `[x]` = Completed (finished and tested)

## Interactive Debugging Tasks

- [x] 1. Verify 2023 data availability for directory dataset
  - File: `scripts/community_college_completion_RDD.Rmd`
  - Test if `get_education_data()` accepts `year = 2023` for directory topic
  - Add diagnostic output to see error messages if it fails
  - Purpose: Confirm 2023 directory data is accessible before proceeding
  - _Leverage: Existing setup chunk and `educationdata` package_
  - _Requirements: 1.1, 1.2_
  - _Prompt: **Implement the task for spec update-to-2023-data. First run spec-workflow-guide to get the workflow guide then implement the task:**

    Role: R Developer with expertise in IPEDS data and the educationdata package

    Task: Test whether the `educationdata` package supports 2023 IPEDS directory data by creating a test chunk in `community_college_completion_RDD.Rmd`. Add diagnostic code to attempt importing 2023 directory data and capture any error messages. Run this chunk interactively in the RStudio console before proceeding.

    Restrictions:
    - Do not modify the existing 2022 import chunks yet
    - Do not proceed to other datasets until directory test succeeds
    - Must capture and display any error messages clearly
    - Test with minimal filters first (just year = 2023)

    Leverage:
    - Existing `get_education_data()` function calls in the current script
    - Existing setup chunk with library loading

    Requirements: This task implements Requirements 1.1 and 1.2 (Data Availability Verification)

    Success Criteria:
    - Test chunk successfully calls `get_education_data()` with year 2023
    - If successful: displays row count and confirms Florida records exist
    - If failed: displays clear error message indicating why 2023 is unavailable
    - Diagnostic output shows whether to proceed or use alternative approach

    Instructions:
    1. Before starting implementation, edit tasks.md and change this task's status from `[ ]` to `[-]`
    2. Create a new test chunk in the R Markdown document
    3. Run the chunk interactively in RStudio console
    4. Document findings in comments
    5. Only after successfully testing, edit tasks.md and change status from `[-]` to `[x]`
    6. Do NOT proceed to next task until this one is complete and marked `[x]`

- [x] 2. Verify 2023 data availability for completions-cip-6 dataset
  - File: `scripts/community_college_completion_RDD.Rmd`
  - Test if `get_education_data()` accepts `year = 2023` for completions-cip-6 topic
  - Add diagnostic output to see error messages if it fails
  - Purpose: Confirm 2023 completions data is accessible before proceeding
  - _Leverage: Existing completions import chunk_
  - _Requirements: 1.1, 1.2_
  - **OUTCOME**: 2023 completions NOT available via educationdata package, but IS available via direct NCES download
  - **SOLUTION**: Switch to IPEDtaS.R script for unified data acquisition (DRY approach)
  - _Prompt: **Implement the task for spec update-to-2023-data. First run spec-workflow-guide to get the workflow guide then implement the task:**

    Role: R Developer with expertise in IPEDS data and the educationdata package

    Task: Test whether the `educationdata` package supports 2023 IPEDS completions-cip-6 data by creating a test chunk. Add diagnostic code to attempt importing 2023 completions data and capture any error messages. Run this chunk interactively in the RStudio console.

    Restrictions:
    - Only proceed if Task 1 (directory test) was successful
    - Do not modify the existing 2022 import chunks yet
    - Must capture and display any error messages clearly
    - Test with minimal filters first (just year = 2023)

    Leverage:
    - Existing `get_education_data()` function calls for completions
    - Results from Task 1 to inform approach

    Requirements: This task implements Requirements 1.1 and 1.2 (Data Availability Verification)

    Success Criteria:
    - Test chunk successfully calls `get_education_data()` for completions-cip-6 with year 2023
    - If successful: displays row count and confirms data structure
    - If failed: displays clear error message and suggests alternatives
    - Both directory and completions 2023 data confirmed accessible

    Instructions:
    1. Edit tasks.md: change this task from `[ ]` to `[-]`
    2. Create test chunk for completions-cip-6 data
    3. Run interactively and document findings
    4. After successful testing, edit tasks.md: change from `[-]` to `[x]`
    5. Do NOT proceed until marked `[x]`

- [x] 3. Configure and run IPEDtaS to download 2023 IPEDS data files
  - File: `/Users/racheldean/Documents/GitHub/IPEDtaS/R/IPEDtaS.R`
  - Modify `selected_files` list to download: HD2023, C2023_A, C2023_B, C2023_C
  - Run IPEDtaS.R to download and process files
  - Verify .dta files created in data/ folder
  - Purpose: Acquire 2023 data using DRY principle (one unified data source)
  - _Leverage: IPEDtaS script at /Users/racheldean/Documents/GitHub/IPEDtaS/R/IPEDtaS.R_
  - _Requirements: 1.1, 1.2_
  - _Prompt: **Implement the task for spec update-to-2023-data. First run spec-workflow-guide to get the workflow guide then implement the task:**

    Role: R Developer with expertise in data schema validation and IPEDS variables

    Task: Inspect the 2023 directory data schema by displaying all column names and identifying the Carnegie classification variable. Create diagnostic code to search for cc_basic_* variables and confirm all required fields exist (unitid, year, opeid, fips, sector, inst_control, inst_name).

    Restrictions:
    - Only proceed if Tasks 1-2 are complete
    - Do not modify cleaning logic yet
    - Must identify the exact Carnegie variable name to use
    - Check for any other variable name changes

    Leverage:
    - 2023 directory data from Task 1
    - Existing variable list from 2022 cleaning chunk
    - R functions: `names()`, `grep()`, `str()`

    Requirements: This task implements Requirements 2.1, 2.2, and 2.3 (Data Schema Validation)

    Success Criteria:
    - All column names displayed and documented
    - Carnegie classification variable identified (exact name documented)
    - All required variables confirmed present or alternatives identified
    - Any schema changes documented in comments

    Instructions:
    1. Edit tasks.md: `[ ]` → `[-]`
    2. Add diagnostic code to display schema information
    3. Run interactively and document findings in comments
    4. Note Carnegie variable name for use in Task 5
    5. Edit tasks.md: `[-]` → `[x]` after completion
    6. Do NOT proceed until schema is fully documented

- [x] 4. Inspect HD2023.dta schema and identify variable names
  - **FINDINGS**: Carnegie variable = `c21basic`, Institution name = `instnm`, 340 FL institutions
  - File: `scripts/community_college_completion_RDD.Rmd`
  - Load HD2023.dta using `haven::read_dta()`
  - Use `names()` to list all column names
  - Identify Carnegie classification variable (cc_basic_20XX)
  - Verify required variables: unitid, fips, sector, control, inst_name
  - Purpose: Understand .dta file structure and variable naming
  - _Leverage: IPEDtaS downloaded files at /Users/racheldean/Documents/GitHub/IPEDtaS/data/HD2023.dta_
  - _Requirements: 2.1, 2.2, 2.3_
  - _Prompt: **Implement the task for spec update-to-2023-data. First run spec-workflow-guide to get the workflow guide then implement the task:**

    Role: R Developer with expertise in IPEDS completions data structure

    Task: Inspect the 2023 completions-cip-6 data schema by displaying all column names and verifying the `awards_6digit` variable exists. If it doesn't exist, search for alternative award/completion count variables. Confirm all other required fields exist.

    Restrictions:
    - Only proceed if Tasks 1-3 are complete
    - Do not modify cleaning logic yet
    - Must identify exact variable name for award counts
    - Check for any other variable name changes

    Leverage:
    - 2023 completions data from Task 2
    - Existing variable list from 2022 cleaning chunk
    - R functions: `names()`, `grep()`, `str()`

    Requirements: This task implements Requirements 2.1, 2.2, and 2.3 (Data Schema Validation)

    Success Criteria:
    - All column names displayed and documented
    - Awards variable confirmed or alternative identified
    - All required variables confirmed present
    - Any schema changes documented in comments

    Instructions:
    1. Edit tasks.md: `[ ]` → `[-]`
    2. Add diagnostic code to display completions schema
    3. Run interactively and document all findings
    4. Note any variable name changes for Task 6
    5. Edit tasks.md: `[-]` → `[x]` after documentation complete
    6. Do NOT proceed until schema is verified

- [x] 5. Inspect C2023_a.dta schema and verify completions variables
  - **FINDINGS**: Award count = `ctotalt`, CIP = `cipcode`, Award level = `awlevel`, Demographics pre-aggregated into columns!
  - File: `scripts/community_college_completion_RDD.Rmd`
  - Load C2023_a.dta using `haven::read_dta()`
  - Use `names()` to list all column names
  - Verify completions count variable (awards, completions, or similar)
  - Check for: unitid, cipcode, awlevel (award_level), sex, race
  - Purpose: Understand completions file structure before updating code
  - _Leverage: IPEDtaS downloaded C2023_a.dta file_
  - _Requirements: 2.1, 2.2, 2.3_
  - _Prompt: **Implement the task for spec update-to-2023-data. First run spec-workflow-guide to get the workflow guide then implement the task:**

    Role: R Developer with expertise in dplyr data manipulation and Carnegie classifications

    Task: Update the directory cleaning chunk to dynamically detect and use the correct Carnegie classification variable for 2023. Implement the code from design.md Component 2 that uses `grep()` to find cc_basic_* variables and selects the appropriate one. Test filtering logic incrementally.

    Restrictions:
    - Only proceed if Tasks 1-4 are complete and schemas documented
    - Must implement dynamic variable detection, not hardcode variable name
    - Test each filter step incrementally with row count output
    - Must maintain existing filter criteria (fips == 12, inst_control == 1, etc.)

    Leverage:
    - Carnegie variable name identified in Task 3
    - Existing clean_dir filtering logic
    - design.md Component 2 code for dynamic variable selection
    - dplyr functions: `select()`, `filter()`, `all_of()`, `.data[[]]`

    Requirements: This task implements Requirements 3.1, 3.2, and 3.3 (Data Quality Validation)

    Success Criteria:
    - Code dynamically detects Carnegie classification variable
    - Filtering produces reasonable number of Florida community colleges (>20)
    - All filter steps tested with diagnostic output showing row counts
    - No errors when running the updated chunk
    - Results stored in `clean_dir` variable as before

    Instructions:
    1. Edit tasks.md: `[ ]` → `[-]`
    2. Modify the directory cleaning chunk
    3. Add `cat()` statements to show row counts after each filter
    4. Run chunk interactively and verify results
    5. If filtering fails, debug before proceeding
    6. Edit tasks.md: `[-]` → `[x]` only after successful testing
    7. Do NOT proceed until clean_dir is working correctly

- [x] 6. Update R Markdown to load 2023 .dta files instead of API calls
  - File: `scripts/community_college_completion_RDD.Rmd`
  - Add `library(haven)` to setup chunk
  - Replace `get_education_data()` calls with `read_dta()` calls
  - Load HD2023.dta for directory data
  - Load C2023_a.dta for completions data
  - Test that data loads successfully
  - Purpose: Switch from API to local .dta files
  - _Leverage: Task 4 and 5 schema findings_
  - _Requirements: 1.1, 1.2_
  - _Prompt: **Implement the task for spec update-to-2023-data. First run spec-workflow-guide to get the workflow guide then implement the task:**

    Role: R Developer with expertise in IPEDS completions data and data validation

    Task: Update the completions cleaning chunk to work with 2023 data, implementing the incremental filtering approach from design.md Component 3. Test each filter step separately with diagnostic output showing row counts. Verify `awards_6digit` exists or use alternative variable.

    Restrictions:
    - Only proceed if Tasks 1-5 are complete
    - Must test each filter incrementally (demographics → CIP codes → award levels → awards count)
    - Must maintain existing filter criteria unless schema requires changes
    - Add diagnostic output at each filter step

    Leverage:
    - Awards variable verified in Task 4
    - Existing clean_comp filtering logic
    - design.md Component 3 incremental filtering code
    - dplyr functions: `filter()`, `select()`

    Requirements: This task implements Requirements 3.1, 3.4, 3.5, 3.6, and 3.7 (Data Quality Validation)

    Success Criteria:
    - Filtering produces reasonable number of completion records
    - Demographic filters (sex == 99, race == 99) work correctly
    - CIP code filters remove miscellaneous categories
    - Award level filters produce both associates and certificates
    - Awards count filter removes zero-completer programs
    - Diagnostic output shows row counts at each step
    - Results stored in `clean_comp` variable

    Instructions:
    1. Edit tasks.md: `[ ]` → `[-]`
    2. Modify completions cleaning chunk with incremental filtering
    3. Add `cat()` statements after each filter
    4. Run interactively and verify row counts are reasonable
    5. If filtering produces 0 rows at any step, debug before proceeding
    6. Edit tasks.md: `[-]` → `[x]` after successful testing
    7. Do NOT proceed until clean_comp is working correctly

- [x] 7. Update directory cleaning chunk with correct 2023 variable names
  - File: `scripts/community_college_completion_RDD.Rmd`
  - Update variable names based on Task 4 findings
  - Update Carnegie classification variable reference
  - Test filtering logic with diagnostic output
  - Verify Florida community colleges are captured
  - Purpose: Adapt cleaning code to .dta variable names
  - _Leverage: Task 4 schema findings_
  - _Requirements: 3.1, 3.2, 3.3_
  - _Prompt: **Implement the task for spec update-to-2023-data. First run spec-workflow-guide to get the workflow guide then implement the task:**

    Role: R Developer with expertise in data joins and data quality validation

    Task: Test the merge operation between `clean_dir` and `clean_comp` for 2023 data, implementing the diagnostic merge code from design.md Component 4. Add checks for NA values and verify the merge produces reasonable results.

    Restrictions:
    - Only proceed if Tasks 1-6 are complete and both datasets cleaned successfully
    - Must add diagnostic output before and after merge
    - Check for NA values in critical columns
    - Verify join keys match between datasets

    Leverage:
    - clean_dir and clean_comp from Tasks 5 and 6
    - Existing left_join code
    - design.md Component 4 diagnostic merge code
    - dplyr functions: `left_join()`, `summarise()`

    Requirements: This task implements Requirements 2.6 and 3.8 (Data Quality Validation)

    Success Criteria:
    - Merge completes without errors
    - Diagnostic output shows input and output row counts
    - NA checks show no unexpected missing values in key columns
    - Merged dataset contains reasonable number of rows
    - Results stored in `merged_data` variable

    Instructions:
    1. Edit tasks.md: `[ ]` → `[-]`
    2. Add diagnostic code before merge (show input row counts)
    3. Run merge with existing join keys
    4. Add diagnostic code after merge (check NAs, show output row count)
    5. Run interactively and verify merge succeeded
    6. If merge produces 0 rows or excessive NAs, debug join keys
    7. Edit tasks.md: `[-]` → `[x]` after successful merge
    8. Do NOT proceed until merge is validated

- [x] 8. Update completions cleaning chunk with correct 2023 variable names
  - File: `scripts/community_college_completion_RDD.Rmd`
  - Update variable names based on Task 5 findings
  - Update completions count variable reference
  - Test filtering logic incrementally with diagnostic output
  - Verify reasonable record counts
  - Purpose: Adapt cleaning code to .dta variable names
  - _Leverage: Task 5 schema findings_
  - _Requirements: 3.4, 3.5, 3.6, 3.7_
  - _Prompt: **Implement the task for spec update-to-2023-data. First run spec-workflow-guide to get the workflow guide then implement the task:**

    Role: R Developer with expertise in data aggregation and result validation

    Task: Test the top 5 program calculation on 2023 data, implementing diagnostic code from design.md Component 4. Verify results are reasonable by checking institution counts, program counts, and comparing to 2022 results if available.

    Restrictions:
    - Only proceed if Tasks 1-7 are complete and merge is successful
    - Must add diagnostic output showing institution counts and program counts
    - Verify no institution has more than 5 programs per award level
    - Check that results make sense (typical community college programs)

    Leverage:
    - merged_data from Task 7
    - Existing slice_max code
    - design.md Component 4 diagnostic code
    - dplyr functions: `group_by()`, `slice_max()`, `n_distinct()`

    Requirements: This task implements Requirements 3.8, 4.1, 4.2, and 4.3 (Interactive Debugging Workflow)

    Success Criteria:
    - Top 5 calculation completes without errors
    - Each institution has at most 5 programs per award level
    - Results include reasonable number of institutions
    - Programs include typical community college fields (nursing, business, health, liberal arts)
    - Diagnostic output shows institution count and total program count

    Instructions:
    1. Edit tasks.md: `[ ]` → `[-]`
    2. Run top 5 calculation with diagnostic output
    3. Verify no institution exceeds 5 programs per award level
    4. Spot-check a few institutions to ensure results are reasonable
    5. If results seem wrong, investigate merged_data before proceeding
    6. Edit tasks.md: `[-]` → `[x]` after validation
    7. Do NOT proceed until results are validated

- [x] 9. Test merge and top 5 calculation with 2023 data
  - File: `scripts/community_college_completion_RDD.Rmd`
  - Test merge operation with diagnostic output
  - Run top 5 calculation
  - Verify results are reasonable
  - Compare to 2022 results for validation
  - Purpose: Ensure analysis produces valid 2023 results
  - _Leverage: Updated cleaning code from Tasks 7-8_
  - _Requirements: 3.8, 4.1, 4.2, 4.3_
  - _Prompt: **Implement the task for spec update-to-2023-data. First run spec-workflow-guide to get the workflow guide then implement the task:**

    Role: R Markdown Developer with expertise in parameterization and reproducible research

    Task: Parameterize the year throughout the R Markdown document by creating a YEAR variable and using it consistently in all `get_education_data()` calls. Update narrative text to reference the year dynamically. Update document metadata.

    Restrictions:
    - Only proceed if Tasks 1-8 are complete and all chunks working
    - Must use YEAR variable in all data import calls
    - Update narrative text that mentions specific year
    - Update YAML header date if appropriate

    Leverage:
    - Working 2023 import code from previous tasks
    - Existing get_education_data() calls
    - R Markdown YAML header
    - Inline R code: `r YEAR`

    Requirements: This task implements Requirements 5.1, 5.2, 5.3, 5.4, and 5.5 (Year Parameterization)

    Success Criteria:
    - YEAR variable defined at top of document
    - All data imports use `year = YEAR` filter
    - Narrative text references year dynamically (using inline R code)
    - Document title/metadata reflects 2023
    - Changing YEAR variable would update entire analysis

    Instructions:
    1. Edit tasks.md: `[ ]` → `[-]`
    2. Add `YEAR <- 2023` after setup chunk
    3. Replace all `year = 2022` with `year = YEAR`
    4. Update narrative text to use inline R: `r YEAR`
    5. Update YAML header if needed
    6. Re-run all chunks to verify parameterization works
    7. Edit tasks.md: `[-]` → `[x]` after testing
    8. Do NOT proceed until parameterization is complete

- [x] 10. Update narrative text and finalize document
  - File: `scripts/community_college_completion_RDD.Rmd`
  - Remove test chunks from Tasks 1-2
  - Update narrative text to reference 2023 data
  - Update YAML header date
  - Add comments documenting IPEDtaS approach
  - Knit document to PDF to verify
  - Purpose: Finalize production-ready 2023 analysis
  - _Leverage: Completed 2023 analysis from Tasks 4-9_
  - _Requirements: All requirements_
  - _Prompt: **Implement the task for spec update-to-2023-data. First run spec-workflow-guide to get the workflow guide then implement the task:**

    Role: R Markdown Developer with expertise in documentation and code cleanup

    Task: Clean up the R Markdown document by removing temporary test chunks, streamlining diagnostic output, and ensuring the narrative text is clear and professional. Document any schema changes or design decisions in comments for future reference.

    Restrictions:
    - Only proceed if all Tasks 1-9 are complete
    - Keep useful diagnostic output (row counts after major operations)
    - Remove verbose test chunks that were only for debugging
    - Ensure document can knit to PDF successfully
    - Maintain reproducibility

    Leverage:
    - All completed chunks from Tasks 1-9
    - Existing R Markdown narrative structure
    - Comments documenting Carnegie variable selection, etc.

    Requirements: This task ensures all requirements are met and document is production-ready

    Success Criteria:
    - Document has clean structure without test/debug chunks
    - Narrative text is clear and documents the 2023 analysis
    - Essential diagnostic output preserved (helpful for future debugging)
    - Comments document schema changes (Carnegie variable, etc.)
    - Document knits to PDF without errors
    - Analysis produces valid, reasonable results

    Instructions:
    1. Edit tasks.md: `[ ]` → `[-]`
    2. Review entire document for cleanup opportunities
    3. Remove temporary test chunks from Tasks 1-2
    4. Streamline diagnostic output
    5. Ensure narrative flows well
    6. Add clarifying comments where needed
    7. Knit document to PDF and verify success
    8. Edit tasks.md: `[-]` → `[x]` after final testing
    9. This is the final task - document should be production-ready
