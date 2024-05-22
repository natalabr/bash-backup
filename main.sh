#!/bin/bash

########################################
# Author: Alicja Jedynska, Natalia Brys
# Version: 2.0
# Usage: backupProgram2.sh
# Date: 21.05.2024
########################################

while true
do
    # Main menu
    tput setaf 6; echo "<<<<<Backup program>>>>>"; tput sgr0
    echo " [1] Create a backup"
    echo " [2] Delete a backup"
    echo " [3] List backups"
    echo " [4] Search in backup"
    echo " [5] Open Log File"
    echo " [6] Delete Log File"
    echo " [.] Exit"
    echo " [?] Help"
    tput setaf 6; echo "<<<<<<<<<<<<>>>>>>>>>>>>"; tput sgr0


    read -r number

    # Script variables
    log_file=logFile.txt
    script_folder=$(dirname "$0")
 
    # log function
    log ()
    {
        date=$(date '+%Y-%m-%d %H:%M:%S')
        echo "$date"" >>> " "$1">>"${log_file}"
    }

    # Create a backup option
    if [ "$number" = 1 ]; then
        # Enter source path
        echo "Enter the source path to backup:";
            log "Enter the source path to backup:";
   
        read -r source_dir

        src=2
        while [ "$src" -gt 0 ] && [ ! -d "$source_dir" ]
        do
            # Check source path
        	tput setaf 1; echo "Source path does not exist!"; tput sgr0
               log "Source path does not exist!"
        	src=$(( src-1 ))
        	echo "Enter the source path to backup:"
                    log "Enter the source path to backup:"
        	read -r source_dir
        done

        if [ ! -d "$source_dir" ]; then
            tput setaf 1; echo "Source path does not exist. Returning to menu..."; tput sgr0
                log "Source path does not exist. Returning to menu ..."
            echo ""
            sleep 1
            continue
        fi

        # Enter destination path / Create destination directory
        echo "Enter the destination path for the backup:"
            log "Enter the destination path for the backup:"
        read -r dest_dir

        if [ ! -d "$dest_dir" ]; then
            mkdir -p "$dest_dir"

            if [ ! -d "$dest_dir" ]; then
            tput setaf 1; echo "Could not create destination directory."; tput sgr0
                log "Could not create destination directory."
            sleep 1
            continue
            fi

        fi

        # Check if paths are the same
        if [ "$source_dir" = "$dest_dir" ]; then
        	tput setaf 1; echo "Source and destination paths cannot be the same."; tput sgr0
                log "Source and destination paths cannot be the same."
            echo "Returning to the menu..."
                log "Returning to the menu ..."
        	sleep 1
            continue
        fi

        # Creating backup
        echo "Creating backup of $source_dir to $dest_dir ..."
            log "Creating backup of $source_dir to $dest_dir ..."
        tar -zcf "$dest_dir/backup-$(date +%Y-%m-%d-%H%M%S).tar.gz" "$source_dir"

        # Check if backup was successful
        if [ $? = 0 ]; then
        tput setaf 2; echo "Backup was successful!"; tput sgr0
            log "Backup was successful!"
        sleep 1
        echo "Returning to menu ..."
            log "Returning to menu ..."
        sleep 1
        continue

        else
        tput setaf 1; echo "Backup has failed"; tput sgr0
            log "Backup has failed"
        sleep 1
        continue
        fi

    fi

    # Delete a backup
    if [ 2 = "$number" ]; then
        # Option to use previous backup path
        if [ -n "$dest_dir" ]; then
            echo "Do you want to use the previous backup path?"
            echo "[0] No"
            echo "[1] Yes"
            read -r delete_backup_num

            # Choose backup directory path
            if [ "$delete_backup_num" = 0 ]; then
                echo "Choose backup directory path:"
                    log "Choose backup directory path:"
                read -r dest_dir
            fi
        fi

        if [ -z "$dest_dir" ]; then
            echo "Choose backup directory path:"
                log "Choose backup directory path:"
            read -r dest_dir
        fi

        # Choose backup from list to remove by copying the text and pasting it back to the console
        if [ "$delete_backup_num" = 1 ] || [ -n "$dest_dir" ]; then

            tput setaf 1; echo "Choose a backup from the list to remove:"; tput sgr0
                log "Choose a backup from the list to remove:"
            ls -lh "$dest_dir"
            read -r rem_backup

            # List of files that will be removed
            rem_path="${dest_dir}/${rem_backup}"
            tput setaf 1; echo "This is a list of files that will be removed:"; tput sgr0
                log "This is a list of files that will be removed:"
            ls -lh "$rem_path"
            rm "$rem_path"

            # Checking if deletion was successful
            if [ $? = 0 ]; then
                tput setaf 2; echo "Backup deleted successfully"; tput sgr0
                    log "Backup deleted successfully"
                echo "Returning to menu ..."
                    log "Returning to menu ..."
                echo ""
                sleep 1
            else
                tput setaf 1; echo "Backup deletion failed"; tput sgr0
                    log "Backup deletion failed"
                echo "Returning to menu ..."
                    log "Returning to menu ..."
                echo ""
                sleep 1
            fi
        fi 
        
    fi

    # List backups option
    if [ 3 = "$number" ]; then

        while true
        do
            # Option to use previous backup path
            if [ -n "$dest_dir" ]; then
                echo "Do you want to use the previous backup path?"
                echo "[0] No"
                echo "[1] Yes"
                read -r list_previous_backups_num
            fi
            
            if [ "$list_previous_backups_num" = 0 ]; then
                echo "Choose backup directory path:"
                    log "Choose backup directory path:"
                read -r dest_dir
            fi

            # Choose backup directory path to list backups
            if [ -z "$dest_dir" ]; then
                echo "Choose backup directory path:"
                    log "Choose backup directory path:"
                read -r dest_dir
            fi

            # Return to menu
            ls -lh "$dest_dir"
            echo ""
            tput setaf 6; echo "[ ] Press any key to return to the menu"; tput sgr0
            tput setaf 1; echo "[.] Exit"; tput sgr0
            read -r list_backups_num
            log "Listing backups from folder ""$dest_dir"

            # Exiting the program
            if [ "$list_backups_num" = "." ]; then
                echo "Exiting program ..."
                    log "Exiting program ..."
                sleep 1
                exit 1

                else
                    echo "Returning to menu ..."
                        log "Returning to menu ..."
                    sleep 1
                    break
            fi
        done
    
    fi

    # Search for files in backup option
    if [ 4 = "$number" ]; then

        while true
        do
        # Search for files in backup menu
        tput setaf 3; echo "<<<<<<<<<<Search in a backup>>>>>>>>>>"; tput sgr0
        echo " [1] Search file in single backup"
        echo " [.] Return"
        echo " [?] Help"
        tput setaf 3; echo "<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>"; tput sgr0

        read -r search_num

        # Choose backup folder
        if [ "$search_num" = 1 ]; then
            echo "Choose folder that contains backup files:"
                log "Choose folder that contains backup files:"
            read -r backup_folder

            # List of available backups
            echo "Available backup files:"
                log "Available backup files:"
            for backup_file in "$backup_folder"/*.gz; do
                echo "--> $backup_file"
            done

            # Choose a backup from the list by highlighting and copying it into the console
            echo "Choose a backup:"
                log "Choose a backup:"
            read -r search_backup

            # Enter a search term f.e. of a file ending such as .txt
            echo "Enter a term you want to search:"
                log "Enter a term you want to search:"
            read -r search_term

            # List of found files and returning to the menu
            echo "Files found:"
                log "Files found:"
            tar -tf "$search_backup" | grep -i "$search_term" | while read -r line
            do
                tput setaf 2; echo "$line"; tput sgr0
                echo "Returning to menu ..."
                    log "Returning to menu ..."
                sleep 1
            done
        fi

        if [ "$search_num" = "." ]; then
            echo "Returning to menu ..."
                log "Returning to menu ..."
            sleep 1
            break
        fi

        # Help for searching in a backup
        if [ "$search_num" = "?" ]; then
            echo "------------------------------------------------------------------------------------"
            echo " (1) Search by a term in a single backup. Pay attention for correct destination path."
            tput setaf 3; echo " [.] Return to previous menu"; tput sgr0
            echo "------------------------------------------------------------------------------------"
            read -r subhelp_num
            if [ "$subhelp_num" = "." ]; then
                echo "Returning to previous menu ..."
                sleep 1
                continue
            fi
        fi
        done
    fi

    # Option for exiting the program by correct input
    if [ "." = "$number" ]; then

        while true
        do
        echo "Are you sure you want to exit the program?"
        echo "[0] No"
        echo "[1] Yes"
        read -r exit_num

            case "$exit_num" in

                0) echo "Returning to menu ..."
                    log "Returning to menu ..."
                sleep 1
                break
                ;;

                1) echo "Exiting program ..."
                    log "Exiting program ..."
                sleep 0.8
                exit 0
                ;;

                *) tput setaf 1; echo "Invalid input please use 0 or 1"; tput sgr0
                    log "Invalid input please use 0 or 1"
                sleep 0.2
                ;;
            esac
        done  
    fi

    # Option to open Log File in the current directory in the terminal
    if [ "$number" = 5 ]; then
        while true
        do
            echo "Opening Log File in terminal ..."
            echo ""
                log "Opening Log File in terminal ..."
            sleep 0.5

            cat "${script_folder}/${log_file}"

            echo ""
            tput setaf 6; echo "[ ] Press any key to return to the menu"; tput sgr0
            tput setaf 1; echo "[.] Exit"; tput sgr0
            read -r open_folder_num

            if [ "$open_folder_num" = "." ]; then
                echo "Exiting program ..."
                    log "Exiting program ..."
                sleep 1
                exit 1

                else
                    echo "Returning to menu ..."
                        log "Returning to menu ..."
                    sleep 1
                    break
            fi
        done

    fi

    # Option to delete the Log File in the current directory
    if [ "$number" = 6 ]; then
        while true
        do
        tput setaf 1; echo "Do you really want to delete the Log File?"; tput sgr0
            log "Do you really want to delete the Log File?"
        echo "[0] No"
        echo "[1] Yes"
        read -r delete_log_file

        # Cases of actions taken in deletion of the Log File
        case "$delete_log_file" in

            0) echo "Returning to menu ..."
                    log "Returning to menu ..."
                sleep 1
                break
                ;;
            
            1) echo "Deleting Log File ..."
                delete_log_file_path="${script_folder}/${log_file}"
                rm "$delete_log_file_path"
                if [ $? = 0 ]; then
                    tput setaf 2; echo "Log File deleted successfully"; tput sgr0
                    echo "Returning to menu ..."
                    echo ""
                    sleep 1
                else
                    tput setaf 1; echo "Log File deletion failed"; tput sgr0
                        log "Log File deletion failed"
                    echo "Returning to menu ..."
                        log "Returning to menu ..."
                    echo ""
                    sleep 1
                fi

                sleep 1
                break
                ;;
            
            *) tput setaf 1; echo "Invalid input! Please use 0 or 1"; tput sgr0
                    log "Invalid input. Please use 0 or 1"
                echo ""
                sleep 1
                continue
        esac

        done
    fi

    # Main help menu
    if [ "$number" = "?" ]; then
        while true
        do
            tput setaf 3; echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Help Menu >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"; tput sgr0
            echo "|>----------------------------------------------------------------------------<|"
            echo "| (1) Creates a backup using a source folder and a destination folder.         |"
            echo "|     It is important that you put in the right path.                          |"
            echo "|     Pay attention to the path executing the script!                          |"
            echo "|>----------------------------------------------------------------------------<|"
            echo "| (2) Deletes a backup using a destination path.                               |"
            echo "|>----------------------------------------------------------------------------<|"
            echo "| (3) Lists backups using a destination path.                                  |"
            echo "|>----------------------------------------------------------------------------<|"
            echo "| (4) Searches for files in a backup.                                          |"
            echo "|     Put in a destination path and a valid search term.                       |"
            echo "|>----------------------------------------------------------------------------<|"
            echo "| (5) Opens the current Log File inside the executing directory in terminal    |"
            echo "|>----------------------------------------------------------------------------<|"
            echo "| (6) Deletes either newly created Log File or old Log File in the executing   |"
            echo "|     directory.                                                               |"
            echo "|>----------------------------------------------------------------------------<|"
            echo "| (.) Exits the program with user input.                                       |"
            echo "|>----------------------------------------------------------------------------<|"
            tput setaf 6; echo "| [.] Return to menu                                                           |"; tput sgr0
            echo "|______________________________________________________________________________|"

            read -r help_num

            if [ "$help_num" = "." ]; then
                echo "Returning to menu ..."
                sleep 1
                break

                else
                    tput setaf 1; echo "Invalid input please use '.' to return"; tput sgr0
                    echo ""
                    sleep 1
            fi
        done
    fi

done
