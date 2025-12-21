# licor-smartflux-data-extraction (R-scripts)
R scripts to extract field-processed flux information (*fluxnet*, *full_output*) from half hourly `.ghg` archives and to merge them into a single consolidated `.csv` file.

## Background
*LI-COR* Eddy Covariance systems provide on-site flux-processing using the *EddyPro(R)* software on the *SmartFlux* module.
*SmartFlux* creates an individual `.ghg` archive for every 30 min flux averaging period. However, quality assessment pipelines and downstream analysis require a single, continuous dataset.

## How it works
The script changes the file extension from `.ghg` to `.zip`, extracts the contained flux information and merges it into a consolidated `.csv` file. **Original `.ghg` files remain untouched** as all processing is performed on copies.

## Key Features
- **Handles multiple formats**: Scripts are available for common `EddyPro` output types: *fluxnet* and *full_output*.
- **Robust processing**: Capable of handling changing file formats (e.g., varying column numbers in flux files).
 
## Dependencies
 - **data.table**: Barrett T, Dowle M, Srinivasan A, Gorecki J, Chirico M,  Hocking T, Schwendinger B, Krylov I (2025). _data.table: Extension of data.frame_. R package version 1.17.8.<br>
 *Note: The script includes an auto-install routine for the required repositories. If a package is not found on your system, it will be installed automatically.*

## Input File Format
The script adheres with the common SmartFlux data storage convention to organize `.ghg` files in monthly subfolders.
**The user must point the `input_dir` to the parent folder containing the monthly subfolders.** 

### Example Structure:
```
input_dir/
├── 01/
│   ├── 2025-01-24T103000_AIU-2640.ghg
│   └── 2025-01-24T110000_AIU-2640.ghg
├── 02/
    ├── 2025-02-24T103000_AIU-2640.ghg
    └── 2025-02-24T103000_AIU-2640.ghg
```

## How to use
- Open `licor_extraction_script.R` in *RStudio*.
- **Configuration**: Adjust the directories in section 1 `USER SETTINGS`.
- **Run**: Execute the script. The rest of the process is fully automated.
