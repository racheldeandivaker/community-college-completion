# Tasks Document

## Task Status Legend
- `[ ]` = Pending (not started)
- `[-]` = In Progress (currently working on)
- `[x]` = Completed (finished and tested)

## Interactive Debugging Tasks

- [ ] 1. Verify 2023 data availability for directory dataset
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

- [ ] 2. Verify 2023 data availability for completions-cip-6 dataset
  - File: `scripts/community_college_completion_RDD.Rmd`
  - Test if `get_education_data()` accepts `year = 2023` for completions-cip-6 topic
  - Add diagnostic output to see error messages if it fails
  - Purpose: Confirm 2023 completions data is accessible before proceeding
  - _Leverage: Existing completions import chunk_
  - _Requirements: 1.1, 1.2_
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

- [ ] 3. Inspect 2023 directory data schema and identify Carnegie classification variable
  - File: `scripts/community_college_completion_RDD.Rmd`
  - Use `names()` to list all column names in 2023 directory data
  - Identify Carnegie classification variable (cc_basic_2021, cc_basic_2023, or other)
  - Check if all required variables exist
  - Purpose: Understand schema changes before updating cleaning logic
  - _Leverage: Existing directory cleaning chunk_
  - _Requirements: 2.1, 2.2, 2.3_
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

- [ ] 4. Inspect 2023 completions-cip-6 data schema and verify awards_6digit variable
  - File: `scripts/community_college_completion_RDD.Rmd`
  - Use `names()` to list all column names in 2023 completions data
  - Verify `awards_6digit` variable exists or identify alternative
  - Check all required variables (unitid, year, fips, cipcode_6digit, award_level, sex, race)
  - Purpose: Understand schema changes before updating cleaning logic
  - _Leverage: Existing completions cleaning chunk_
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

- [ ] 5. Update directory cleaning chunk to work with 2023 data
  - File: `scripts/community_college_completion_RDD.Rmd` (directory cleaning chunk)
  - Update Carnegie classification variable name based on Task 3 findings
  - Implement dynamic variable selection (cc_basic_2023 vs cc_basic_2021)
  - Test filtering logic with 2023 data
  - Verify Florida community colleges are present
  - Purpose: Adapt directory cleaning to 2023 schema
  - _Leverage: Existing clean_dir code and design.md Component 2_
  - _Requirements: 3.1, 3.2, 3.3_
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

- [ ] 6. Update completions cleaning chunk to work with 2023 data
  - File: `scripts/community_college_completion_RDD.Rmd` (completions cleaning chunk)
  - Verify `awards_6digit` variable or use alternative identified in Task 4
  - Update variable names if any changed
  - Test filtering logic with 2023 data incrementally
  - Verify reasonable record counts at each step
  - Purpose: Adapt completions cleaning to 2023 schema
  - _Leverage: Existing clean_comp code and design.md Component 3_
  - _Requirements: 3.1, 3.4, 3.5, 3.6, 3.7_
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

- [ ] 7. Test merge and verify join keys work with 2023 data
  - File: `scripts/community_college_completion_RDD.Rmd` (merge chunk)
  - Test `left_join()` on 2023 data using existing join keys
  - Add diagnostic output to check for NA values and row counts
  - Verify merge produces expected results
  - Purpose: Ensure merge logic works with 2023 data
  - _Leverage: Existing merge code and design.md Component 4_
  - _Requirements: 2.6, 3.8_
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

- [ ] 8. Test top 5 calculation and validate results
  - File: `scripts/community_college_completion_RDD.Rmd` (analysis chunk)
  - Run `slice_max()` operation on 2023 merged data
  - Add diagnostic output to verify each institution has results
  - Compare 2023 results to 2022 for reasonableness
  - Purpose: Ensure analysis logic produces valid results
  - _Leverage: Existing top5 calculation code and design.md Component 4_
  - _Requirements: 3.8, 4.1, 4.2, 4.3_
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

- [ ] 9. Parameterize year throughout the document
  - File: `scripts/community_college_completion_RDD.Rmd`
  - Create `YEAR <- 2023` variable at top of document (after setup chunk)
  - Replace all hardcoded `year = 2022` with `year = YEAR`
  - Update narrative text to reference the year dynamically
  - Update R Markdown title/date to reflect 2023
  - Purpose: Make future year updates easy
  - _Leverage: Existing get_education_data calls_
  - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_
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

- [ ] 10. Clean up test/diagnostic code and finalize document
  - File: `scripts/community_college_completion_RDD.Rmd`
  - Remove or comment out intermediate test chunks from Tasks 1-2
  - Keep essential diagnostic output (row counts) but remove verbose debugging
  - Ensure narrative text flows well and documents the analysis
  - Add comments documenting schema changes and design decisions
  - Purpose: Prepare clean, production-ready R Markdown document
  - _Leverage: Completed 2023 analysis from previous tasks_
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
