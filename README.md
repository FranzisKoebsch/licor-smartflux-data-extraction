# licor-smartflux-data-extraction
Extracts field-processed flux information (fluxnet, full_output) from half hourly .ghg archives and merges them into a single consolidated csv file

**Background**
LI-COR Eddy Covariance systems provide on-site flux-processing using the EddyPro(R) software on the SmartFlux module.
SmartFlux creates an individual .ghg archive for every 30 min flux averaging period. However, quality assessment pipelines and downstream analysis require a single, continuous dataset.

**How it works**
The script treats .ghg archives as compressed .zip archives, extracts the contained flux information and merges it into a consolidated csv file

**Key Features**
- Handles multiple formats: Scripts are available for common EddyPro output types: fluxnet and full_output.
- Robust processing: Capable of handling changing file formats (e.g., varying column numbers in flux files).
 
