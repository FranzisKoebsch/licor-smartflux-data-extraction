# licor-smartflux-data-extraction (R-scripts)
R scripts to extract field-processed flux information (*fluxnet*, *full_output*) from half hourly `.ghg` archives and to merge them into a single consolidated `.csv` file.

## Background
*LI-COR* Eddy Covariance systems provide on-site flux-processing using the *EddyPro(R)* software on the *SmartFlux* module.
*SmartFlux* creates an individual `.ghg` archive for every 30 min flux averaging period. However, quality assessment pipelines and downstream analysis require a single, continuous dataset.

## How it works
The script changes the file extension from `.ghg` to `.zip`, extracts the contained flux information and merges it into a consolidated `.csv` file. **Original `.ghg` files remain untouched** as all processing is performed on copies.

## Key Features
- **Handles multiple flux files**: Available for several common `EddyPro` output types: *fluxnet* and *full_output*.
- **Structure-agnostic**:  Flexible to work with any nested folder structure.
- **Robust processing**: Capable of handling changing file formats (e.g., varying column numbers in flux files).
 
## Dependencies
 - **data.table**: Barrett T, Dowle M, Srinivasan A, Gorecki J, Chirico M,  Hocking T, Schwendinger B, Krylov I (2025). _data.table: Extension of data.frame_. R package version 1.17.8.<br>
 *Note: The script includes an auto-install routine for the required repositories. If a package is not found on your system, it will be installed automatically.*

## Input File Format
The script performs a recursive file search, meaning that it finds all .ghg files in the `ìnput_dir`, whether they are lying plain in the root folder or tucked away in sub-directories.
While the common SmartFlux convention organizes `.ghg` files in monthly subfolders, the script is flexible to work with any nested folder structure. 
**Set `input_dir` to the top-level directory containing the data you wish to process.** 

## How to use
- Open `licor_extraction_script.R` in *RStudio*.
- **Configuration**: Adjust the directories in section 1 `USER SETTINGS`.
- **Run**: Execute the script. The rest of the process is fully automated.
