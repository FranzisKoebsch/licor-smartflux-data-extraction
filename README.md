# licor-smartflux-data-extraction (R-scripts)
Automated R pipeline to extract and merge field-processed flux data (*fluxnet*, *full_output*) from half hourly `.ghg` archives into a single `.csv` file.

## Background
*LI-COR* Eddy Covariance systems provide on-site flux processing using the *EddyPro(R)* software on the *SmartFlux* module.
*SmartFlux* creates an individual `.ghg` archive for every 30 min flux averaging period. However, quality assessment pipelines and downstream analysis require a single, continuous dataset.

## How it works
The script changes the file extension from `.ghg` to `.zip`, extracts the contained flux information and merges it into a single `.csv` file. **Original `.ghg` files remain untouched** as all processing is performed on temporary copies. The script also provides a **log file** documenting missing and corrupted files and tracks whenever the file structure is changing (e.g., because sensors were added/removed). 

<p align="center">
  <img src="issues/1#issue-3780458441" alt="Flow chart extraction and merging pipeline" width="600">
  <br>
  <em>Fig 1: Workflow: Extracting and merging flux data from .ghg files</em>
</p>

## Key Features
- **Supports multiple *EddyPro(R)* output files**: Currently handles *fluxnet* files, with support for other *EddyPro(R)* output types currently in development.
- **Deep folder search**:  Discovers `.ghg` files within any nested folder structure, eliminating the need for manual file organization.
- **Robust error handling**: Gracefully skips corrupted and missing files, ensuring the script runs to completion.
- **Adaptive data structure**: Automatically aligns data, even if table structure changes (e.g., due to addition or removal of a sensor).
- **Transparent documentation:** Generates a detailed log report for any run, tracking missing and corrupted files, as well as structural file changes.
 
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
