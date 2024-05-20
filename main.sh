#!/bin/bash
#################################################
# Author: Natalia Brys, Alicja Jedynska
# Description: LB2 
# Group: 7
# Usage: Backup Program
#################################################


while true
do
    tput setaf 6; echo "<<<<<Backup program>>>>>"; tput sgr0
    echo " [1] Create a backup"
    echo " [2] Delete a backup"
    echo " [3] List backups"
    echo " [4] Search a backup"
    echo " [5] Open Log File"
    echo " [6] Delete Log File"
    echo " [.] Exit"
    echo " [?] Help"
    tput setaf 6; echo "<<<<<<<<<<<<>>>>>>>>>>>>"; tput sgr0
 
    read -r number
 
    log_file=logFile.txt
    log ()
    {
        date=$(date '+%Y-%m-%d %H:%M:%S')
        echo "$date"" >>> " "$1">>"${log_file}"
    }
 
    if [ "$number" = 1 ]; then
        echo "Enter the source path to backup:"
        read -r source_dir
 
        src=2
        while [ "$src" -gt 0 ] && [ ! -d "$source_dir" ]
        do
        		tput setaf 1; echo "Source path does not exist!"; tput sgr0
        		src=$(( src-1 ))
        		echo "Enter the source path to backup:"
        		read -r source_dir
        done
 
        if [ ! -d "$source_dir" ]; then
            tput setaf 1; echo "Source path does not exist. Returning to menu..."; tput sgr0
            echo ""
            sleep 1
            continue
        fi
 
        echo "Enter the destination path for the backup:"
        read -r dest_dir
        if [ "$source_dir" = "$dest_dir" ]; then
        		tput setaf 1; echo "Source and destination paths cannot be the same. Returning to the menu..."; tput sgr0
        		sleep 1
            continue
        fi
 
        if [ ! -d "$dest_dir" ]; then
            mkdir -p "$dest_dir"
 
            if [ ! -d "$dest_dir" ]; then
                tput setaf 1; echo "Could not create destination directory."; tput sgr0
                sleep 1
                continue
            fi
 
        fi
 
        echo "Creating backup of $source_dir to $dest_dir ..."
        tar -zcf "$dest_dir/backup-$(date +%Y-%m-%d-%H%M%S).tar.gz" "$source_dir"
 
        if [ $? = 0 ]; then
            #echo -e "\033[32m Backup was successful\033[0m"
            tput setaf 2; echo "Backup was successful!"; tput sgr0
            sleep 1
            echo "Returning to menu ..."
            sleep 1
            continue
 
        else
            tput setaf 1; echo "Backup has failed"; tput sgr0
            sleep 1
            continue
        fi
 
    fi
 
    if [ 2 = "$number" ]; then
 
        if [ -n "$dest_dir" ]; then
            echo "Do you want to use the previous backup path?"
            echo "[0] No"
            echo "[1] Yes"
            read -r delete_backup_num
 
            if [ "$delete_backup_num" = 0 ]; then
                echo "Choose backup directory path:"
                read -r dest_dir
            fi
        fi
 
        if [ -z "$dest_dir" ]; then
                echo "Choose backup directory path:"
                read -r dest_dir
        fi
 
        if [ "$delete_backup_num" = 1 ] || [ -n "$dest_dir" ]; then
 
            echo "Choose a backup from the list to remove:"
            ls -lh "$dest_dir"
            read -r rem_backup
 
            rem_path="${dest_dir}/${rem_backup}"
            echo "This is a list of files that will be removed:"
            ls -lh "$rem_path"
            rm "$rem_path"
 
            if [ $? = 0 ]; then
                tput setaf 2; echo "Backup deleted successfully"; tput sgr0
                sleep 1
            else
                tput setaf 1; echo "Backup deletion failed"; tput sgr0
                sleep 1
            fi
        fi 
    fi
 
    if [ 3 = "$number" ]; then
 
        if [ -z "$dest_dir" ]; then
            echo "Enter backup directory path:"
            read -r dest_dir
        fi
        while [ ! -d "$dest_dir" ]
        do
        		tput setaf 1; echo "Your Input is invalid. Try again:"; tput sgr0
        		read -r dest_dir
        done
        ls -lh "$dest_dir"
    fi
 
 
    if [ 4 = "$number" ]; then
 
        while true
        do
        tput setaf 3; echo "<<<<<<<<<<Search for backups>>>>>>>>>>"; tput sgr0
        echo " [1] Search file in single backup"
        echo " [2] Search file in multiple backups"
        echo " [.] Return"
        echo " [?] Help"
        tput setaf 3; echo "<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>"; tput sgr0
 
        read -r search_num
 
        if [ "$search_num" = 1 ]; then
            echo "Choose a backup:"
            read -r search_backup
            echo "Enter a term you want to search:"
            read -r search_term
 
            tar -tf "$search_backup" | grep -i "$search_term" | while read -r line
            do
                echo "File found:"
                tput setaf 2; echo "$line"; tput sgr0
                sleep 1
            done
 
        fi
 
        if [ "$search_num" = 2 ]; then
            echo "Choose a backup:"
            read -r search_backup
            echo "Enter a term you want to search:"
            read -r search_term
 
            ls $search_backup | while read -r file
            do
                tar -tf "$file" | grep -i "$search_term" | while read -r line
                do
                    echo "File found in backup $file:"
                    tput setaf 2; echo "$line"; tput sgr0
                    sleep 1
                done
            done

 
        fi
 
        if [ "$search_num" = "." ]; then
            echo "Returning to menu ..."
            sleep 1
            break
        fi
 
        if [ "$search_num" = "?" ]; then
            echo "(1) Search by a term in a single backup. Pay attention for correct destination path."
            echo "(2) Search by a term in multiple backups. Pay attention for correct destination path"
            echo "(3) Return to menu."
            tput setaf 3; echo "[.] Return to previous menu"; tput sgr0
            read -r subhelp_num
            if [ "$subhelp_num" = "." ]; then
                echo "Returning to previous menu ..."
                sleep 1
                continue
            fi
        fi
        done
    fi
 
    if [ "." = "$number" ]; then
 
        while true
        do
        echo "Are you sure you want to exit the program?
[0] No
[1] Yes"
        read -r exit_num
 
            case "$exit_num" in
 
                0) echo "Returning to menu ..."
                sleep 1
                break
                ;;
 
                1) echo "Exiting program ..."
                sleep 0.8
                exit 0
                ;;
 
                *) tput setaf 1; echo "Invalid input please use 0 or 1"; tput sgr0
                sleep 0.2
                ;;
            esac
        done  
    fi
 
    if [ "$number" = 5 ]; then
        while true
        do
            script_folder=$(dirname "$0")
 
            echo "Opening Log File in terminal ..."
            echo ""
            log "Opening Log File ..."
            sleep 0.5
 
            cat "${script_folder}/${log_file}"
 
            echo ""
            tput setaf 6; echo "[ ] Press any key to return to the menu"; tput sgr0
            tput setaf 1; echo "[.] Exit"; tput sgr0
            read -r open_folder_num
 
            if [ "$open_folder_num" = "." ]; then
                echo "Exiting program ..."
                sleep 1
                exit 1
 
                else
                    echo "Returning to menu ..."
                    sleep 1
                    break
            fi
        done
 
    fi
 
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
            echo "| (4) Searches for backups, put in a destination path and a search term.       |"
            echo "|     Option between searching in a specific backup or multiple backups.       |"
            echo "|>----------------------------------------------------------------------------<|"
            echo "| (5) Exits the program with user input.                                       |"
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