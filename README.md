# licor-smartflux-data-extraction (R-scripts)
Automated R pipeline to extract and merge field-processed flux data (*fluxnet*, *full_output*) from half hourly `.ghg` archives into a single `.csv` file.

## Background
*LI-COR* Eddy Covariance systems provide on-site flux processing using the *EddyPro(R)* software on the *SmartFlux* module.
*SmartFlux* creates an individual `.ghg` archive for every 30 min flux averaging period. However, quality assessment pipelines and downstream analysis require a single, continuous dataset.

## How it works
The script changes the file extension from `.ghg` to `.zip`, extracts the contained flux information and merges it into a single `.csv` file. **Original `.ghg` files remain untouched** as all processing is performed on temporary copies. The script also provides a **log file** documenting missing and corrupted files and tracks whenever the file structure is changing (e.g., because sensors were added/removed). 

## Key Features
- **Supports multiple *EddyPro(R)* output files**: Currently handles *fluxnet* files, with support for other *EddyPro(R)* output types currently in development.
- **Deep folder search**:  Discovers `.ghg` files within any nested folder structure, eliminating the need for manual file organization.
- **Robust error handling**: Gracefully skips corrupted and missing files, ensuring the script runs to completion.
- **Adaptive data structure**: Automatically aligns data, even if table structure changes (e.g., due to addition or removal of a sensor).
- **Transparent documentation:** Generates a detailed log report for any run, tracking missing and corrupted files, as well as structural file changes.

<p align="center">
  <img src="https://private-user-images.githubusercontent.com/249960569/531844480-dcffc86e-641e-4ad3-8695-a664842518de.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3Njc1OTg3ODUsIm5iZiI6MTc2NzU5ODQ4NSwicGF0aCI6Ii8yNDk5NjA1NjkvNTMxODQ0NDgwLWRjZmZjODZlLTY0MWUtNGFkMy04Njk1LWE2NjQ4NDI1MThkZS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwMTA1JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDEwNVQwNzM0NDVaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0yYTg0MDJkMGFmOWViOGM3YjU2MWExNzY2NGI2MGZjZDcyZTdkYjBkZWQ5OTc5ODJhYWQ3YTRhNzZmZDY2NDljJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.75xM7xOMBvQeNXdtPyg5hYxqWyrfcJem_qE51nB5kLE" alt="Flow chart extraction and merging pipeline" width="350">
    <br>
  <em>Fig 1: Workflow: Extracting and merging flux data from .ghg files</em>
</p>
<p align="center">
   <img src="https://private-user-images.githubusercontent.com/249960569/531858800-dc79771d-07b5-4edb-9395-0a49a2f385f2.jpg?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3Njc2MDE2ODIsIm5iZiI6MTc2NzYwMTM4MiwicGF0aCI6Ii8yNDk5NjA1NjkvNTMxODU4ODAwLWRjNzk3NzFkLTA3YjUtNGVkYi05Mzk1LTBhNDlhMmYzODVmMi5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwMTA1JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDEwNVQwODIzMDJaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1jZjNiMmVjZTBmNTg1YjE5ZDcxZThhNjk5MzUzZDI3ODFmN2Q3NjExYjgwYjJmNmZlYzY2MWYxYWJiMDc5MWIyJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.tiGgkbGzGfU2aLvrP1MOALVoqB-xD3105_ZUH3M7Znw" alt="Screenshot Log Report" width="300">
       <br>
  <em>Fig 2: Log report with a list of missing (and corrupted) files along with changes in data structure</em>
</p>

## Dependencies
 - **data.table**: Barrett T, Dowle M, Srinivasan A, Gorecki J, Chirico M,  Hocking T, Schwendinger B, Krylov I (2025). _data.table: Extension of data.frame_. R package version 1.17.8.<br>
 *Note: The script includes an auto-install routine and  for the required repositories. If a package is not found on your system, it will be installed automatically.*

## Input File Format
*EddyPro(R)* `.ghg` archives. The script performs a recursive file search, meaning that it finds all `.ghg` files in the `ìnput_dir`, whether they are lying plain in the root folder or tucked away in sub-directories.
While the common *SmartFlux* convention organizes `.ghg` files in monthly subfolders, the script is flexible to work with any nested folder structure. 
**Set `input_dir` to the top-level directory containing the data you wish to process.** 

## How to use
- Open `ExtractFluxnetFromGHG.R` in *RStudio*.
- **Configuration**: Adjust the directories in section 1 `USER SETTINGS`.
- **Run**: Execute the script. The rest of the process is fully automated.
