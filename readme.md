# Bash Backup 

This project provides a simple Bash script to automate the process of backing up files and directories. The script creates compressed archive files of the specified source directory and stores them in a destination directory, with each backup uniquely named by timestamp.

## Features
- Compresses files and folders into `.tar.gz` archives
- Stores backups in a designated destination directory
- Automatically names backup files with the current date and time
- Logs backup operations to a log file

## Project Structure
```
main.sh           # Main backup script
logFile.txt       # Log file for backup operations
src/              # Source directory to be backed up
	src_file.txt
	src_folder/
		src_folder_file.txt
dest/             # Destination directory for backup archives
readme.md         # Project documentation
```

## Usage

1. **Configure Source and Destination**
	 - Place the files and folders you want to back up in the `src/` directory.
	 - Ensure the `dest/` directory exists for storing backup archives.

2. **Run the Backup Script**
	 - Open a terminal and navigate to the project directory.
	 - Execute the script:
		 ```bash
		 bash main.sh
		 ```
	 - The script will create a compressed backup of the `src/` directory in the `dest/` folder and log the operation in `logFile.txt`.

## Requirements
- Bash shell (Linux, macOS, or Windows with WSL/Git Bash)
- `tar` and `gzip` utilities