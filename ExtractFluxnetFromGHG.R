# ==============================================================================
# Project:    LI-COR SmartFlux Data Extraction - Fluxnet Files
# Purpose:    Extract and merge Fluxnet files from LI-COR's half-hourly .ghg archives into a single CSV file
# Author:     Franziska Koebsch
# Date:       2025-12-31
# Repository: https://github.com/FranzisKoebsch/licor-smartflux-data-extraction/tree/main
# License:    MIT
# ==============================================================================
# --- 0. Dependency Check ---
required_packages <- c("data.table")
for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    message(paste("Package", pkg, "not found. Installing..."))
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

# ==============================================================================
# --- 1. USER SETTINGS ---
# ==============================================================================
input_dir   <- "path/to/fluxfiles"        # Path to the top-level directory containing the .ghg files (the script scans all subfolders recursively)
output_dir  <- "path/to/output/directory" # Output Path for the final .csv file, containing the consolidated data
output_name <- "csvname"                  # Name of the final .csv file
# ==============================================================================

# --- 2. Check and Create Directories  ---

if (input_dir == "" || !exists("input_dir")) {
  stop("'input_dir' is not defined! /nPlease provide the path to your .ghg data in the User Settings")
}

if (output_dir == "" || !exists("output_dir")) {
  stop("'output_dir' is not defined! /nPlease provide the output path for the final .csv file in the User Settings")
}

if(!dir.exists(output_dir)) dir.create(output_dir)

# in output_dir create a temporary subdirectory to convert the ghg files
temp_dir <- paste(output_dir, "temp", sep="/")
if(!dir.exists(temp_dir)) dir.create(temp_dir)

# if missing: add '.csv' file extension to output_name
if (!grepl("//.csv$", output_name, ignore.case = TRUE)) {
  output_name <- paste0(output_name, ".csv")
}

# ==============================================================================
# --- 3. Extract Data  ---
ghg_files <- list.files(input_dir, pattern = "\\.ghg$", recursive = TRUE, full.names = TRUE, include.dirs = TRUE)

if(length(ghg_files) == 0) {
  stop("No .ghg files found in: ", normalizePath(input_dir, winslash="/"))
} else {
  message(paste("Found", length(ghg_files), "ghg files. Starting extraction..."))
}

all_data_list <- vector("list", length(ghg_files))
failed_files <- c()
extracted_files <- 0
missing_files <- c()

for(i in seq_along(ghg_files)){ 
  
  current_ghg <- ghg_files[i]
  # Convert from .ghg to zip archive 
  # Conversion is performed on file copies in a temporary directory
  invisible(file.copy(current_ghg, temp_dir))
  temp_file <- paste(temp_dir, basename(current_ghg), sep="/")
  zip_filename <- paste0(unlist(strsplit(basename(current_ghg), split=".ghg")), ".zip")
  zip_dir <- paste(temp_dir, zip_filename, sep="/")
  invisible(file.rename(temp_file, zip_dir))
  
  # Unzip and extract Fluxnet file
  temp_data <- tryCatch({
    
    zip_contents <- unzip(zip_dir, list = TRUE)
    target_file <- zip_contents[grep("fluxnet", zip_contents$Name),]$Name[1]
    
    # Extract Fluxnet file 
    if(!is.na(target_file)) {
      extracted_file <- unzip(zipfile = zip_dir, files = target_file, exdir=temp_dir)
      fread(extracted_file, fill = TRUE)
    }
  }, # tryCatch() option for failed files
  error = function(e) {
    message(paste("Skipping file due to error in:", basename(ghg_files[i])))
    failed_files <<- c(failed_files, basename(ghg_files[i]))
    return(NULL) 
  }
  )
  # if Fluxnet file is available 
  if(!is.null(temp_data)) {
    all_data_list[[i]] <- temp_data
    extracted_files <- extracted_files + 1
    # Status message
    print(paste("Extracted ", basename(extracted_file)[1]))
  }
  else{print(paste("No Fluxnet file found in", basename(current_ghg)))
    missing_files <- c(missing_files, basename(ghg_files[i]))}
  
  # Clean up temporary files
  remove_files <- list.files(temp_dir, full.names = TRUE)
  unlink(remove_files, recursive = TRUE)
  
}

# ==============================================================================
# --- 4. Compose Data and Store as CSV ---
# Bind by matching column names, fills empty columns with NA
all_data_list <- all_data_list[which(sapply(all_data_list, Negate(is.null)))]
if(length(all_data_list) >0){
  final_data <- rbindlist(all_data_list, fill = TRUE, use.names = TRUE)
  
  # Write consolidated data into final csv file
  write.csv(final_data, paste(output_dir, output_name, sep="/"))
} else{message("No Fluxnet files found in GHG archives. No .csv created.")}

# --- 5. Log Report  ---
# Track modifications in file structure
column_identical <- sapply(1:(length(all_data_list)-1), function(x) {
  setequal(names(all_data_list[[x]]), names(all_data_list[[x+1]]))})

column_change_log <- vector("list", sum(column_identical==F))

ind <- 1
for (j in which(column_identical==F)){
  column_change_log[[ind]]$ghg <- basename(ghg_files[[j+1]])
  if( length(setdiff(names(all_data_list[[j]]), names(all_data_list[[j+1]]))) > 0) {
    column_change_log[[ind]]$columns_removed <-  setdiff(names(all_data_list[[j]]), names(all_data_list[[j+1]])) 
  }
  if( length(setdiff(names(all_data_list[[j+1]]), names(all_data_list[[j]]))) > 0) {
    column_change_log[[ind]]$columns_added <-  setdiff(names(all_data_list[[j+1]]), names(all_data_list[[j]])) 
  }
  ind <- ind +1
}
# Build file structure part for log report
text_change_log <-c() 
for(j in seq_along(column_change_log)){
  text_change_log <- paste0(text_change_log, "\n", column_change_log[[j]]$ghg)
  if(!is.null(column_change_log[[j]]$columns_added)){
    text_change_log <- paste0(text_change_log, "\nColumns added: ", paste(column_change_log[[j]]$columns_added, collapse=", "))}
  if(!is.null(column_change_log[[j]]$columns_removed)){
    text_change_log <- paste0(text_change_log, "\nColumns removed: ", paste(column_change_log[[j]]$columns_removed, collapse=", "))}
}

# Log Report
log_report <- c(
  "################### DATA EXTRACTION REPORT ###################",  
  paste0("Date: ", round(Sys.time(), units="mins")),
  paste0("Output File: ", paste(output_dir, output_name, sep="/")),
  paste0("Found GHG files: ", length(ghg_files)),
  paste0("Extracted ", "fluxnet ", "files: ", extracted_files),
  paste0("Missing ", "fluxnet ", "files: ", length(missing_files)),
  paste0("Corrupted ", "fluxnet ", "files: ", length(failed_files)),
  "_____________________________________________________________",
  if(length(missing_files)>0) {paste0("Missing ", "fluxnet ", "files: ", missing_files)},
  "_____________________________________________________________",
  if(length(failed_files)>0) {paste0("Corrupted ", "fluxnet ", "files: ", failes_files)},
  "_____________________________________________________________",
  "Changes in File Structure",
  if(length(column_change_log[[1]])==0) {"None"}
  else{text_change_log}
)

writeLines(log_report, paste0(output_dir, "/", sub(".csv", "", output_name), "_processing_log.txt"))
