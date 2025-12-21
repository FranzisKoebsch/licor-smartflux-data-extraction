# licor-smartflux-data-extraction (R-scripts)
R scripts to extract field-processed flux information (fluxnet, full_output) from half hourly .ghg archives and to merge them into a single consolidated .csv file.

**Background** <br>
LI-COR Eddy Covariance systems provide on-site flux-processing using the EddyPro(R) software on the SmartFlux module.
SmartFlux creates an individual .ghg archive for every 30 min flux averaging period. However, quality assessment pipelines and downstream analysis require a single, continuous dataset.

**How it works**<br>
The script changes the file extension from .ghg to .zip, extracts the contained flux information and merges it into a consolidated .csv file. Original .ghg files remain untouched as all processing is performed on copies.

**Key Features**<br>
- Handles multiple formats: Scripts are available for common EddyPro output types: fluxnet and full_output.
- Robust processing: Capable of handling changing file formats (e.g., varying column numbers in flux files).
 
**Dependencies**<br>
 - data.table: Barrett T, Dowle M, Srinivasan A, Gorecki J, Chirico M,  Hocking T, Schwendinger B, Krylov I (2025). _data.table: Extension of `data.frame`_. R package version 1.17.8.<br>
 *Note: The script includes an auto-install routine for the required repositories. If a package is not found on your system, it will be installed automatically.*

**Input File Format**<br>
The script adheres with the common SmartFlux data storage convention to organize.ghg files in monthly subfolders.
The user must point the 'input_dir' to the parent folder containing the monthly subfolders. 

**Example Structure:**
```text
input/
├── 2024-01/
│   ├── file1.ghg
│   └── file2.ghg
├── 2024-02/
│   ├── file3.ghg
│   └── file4.ghg
└── extra_data.ghg

**How to use**<br>
- Open licor_extraction_script.R in RStudio.
- Configuration: Adjust the directories in section 1 USER SETTINGS.
- Run: Execute the script. The rest of the process is fully automated.
