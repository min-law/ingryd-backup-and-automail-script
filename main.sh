#!/bin/bash

# Creates a unique report file each time the script is ran
reportFile="$HOME/week6_scripts/lawrence-akinboye-reports-$(date +%s)-$(date +%T).txt"

# Always append all echos to the report file before the actual echo
numberLine=1;
function handleEchoAndReport() {
        msg=$1
        isQuite=$2

        if [[ -z $msg ]]; then
                echo "$numberLine: .." >> $reportFile
        else
                echo "$numberLine: $msg  -> ($(date +%H:%M:%S))" >> $reportFile
        fi

        if [[ -z $isQuite ]]; then
                echo $msg
        fi

        let numberLine++;
}

# Get the current time in seconds
NOW_SECONDS=$(date +%s)

# Create variables for the backup directory and the source backup directory
BACKUP_DIR="$HOME/backup"
SOURCE_BACKUP_DIR="$HOME/ingrydDocs"
TEMP_BACKUP_DIR="$SOURCE_BACKUP_DIR/important-files"

# Create a backup directory if it does not exist
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Creating $BACKUP_DIR"
    mkdir "$BACKUP_DIR"
fi
# - Make the temporary backup directory
mkdir -p "$TEMP_BACKUP_DIR"

#  Create file inside the backup directory to store the last backup time if it does not exist
if [ ! -f "$BACKUP_DIR/last_backup.txt" ]; then
    echo "Creating $BACKUP_DIR/last_backup.txt"
    echo "$(date -d "2023-11-15 08:00:00" +%s)" > "$BACKUP_DIR/last_backup.txt"
fi


# read the last backup time from the file
BACKUP_TIME=$(cat "$BACKUP_DIR/last_backup.txt")



# - Copy all the files from the source directory $SOURCE_BACKUP_DIR to the backup directory
# Find files modified after the backup time
# NOTE this find assumes all Important files have "imp" in their name E.g. "important-file.txt", "imp-file.txt", etc.
find "$SOURCE_BACKUP_DIR" -type f -name "*imp*" -newermt "@$BACKUP_TIME" -exec cp {} "$TEMP_BACKUP_DIR" \;


# If the files in the source directory have not changed since the last backup, skip the backup
if [ -z "$(ls -A $TEMP_BACKUP_DIR)" ]; then
    echo "No files to backup!!"

    echo "Cleaning up..."
    sleep 1
    # - delete the temporary backup directory
    rm -rf "$TEMP_BACKUP_DIR"
    echo "Backing up done!!"

else

    # Update the last backup time
    echo "$NOW_SECONDS" > "$BACKUP_DIR/last_backup.txt"
    BACKUP_TIME=$(cat "$BACKUP_DIR/last_backup.txt")

    # Compress the backup directory from the temporary backup directory with the current time as the name
    echo "Compressing the backup directory..."
    tar -czf "$BACKUP_DIR/backup-$BACKUP_TIME.tar.gz" "$TEMP_BACKUP_DIR"

    echo "Cleaning up..."
    sleep 1
    # - delete the temporary backup directory
    rm -rf "$TEMP_BACKUP_DIR"
    echo "Backing up done!!"

fi

echo "DONE WITH One 💯..."
# PRE-REQUISITES for Question 2
# I have used the following commands to install the required packages
# sudo apt-get install sysstat
# sudo apt-get install ifstat

# The above commands will install the required packages


# Function to get CPU usage
get_cpu_usage() {
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
    # The Above command will return the CPU usage in percentage
    printf "%-20s%-20s\n" "CPU Usage:" "$cpu_usage%"
    # The above command will print the CPU usage in percentage
}

# Function to get memory usage
get_memory_usage() {
    memory_info=$(free -m | awk 'NR==2{printf "Used: %s MB, Free: %s MB", $3, $4}')
    # The above command will return the memory usage in MB
    printf "%-20s%-20s\n" "Memory Usage:" "$memory_info"
    # The above command will print the memory usage in MB
}

# Function to get disk space
get_disk_space() {
    disk_space=$(df -h / | awk 'NR==2{printf "Used: %s, Free: %s", $3, $4}')
    printf "%-20s%-20s\n" "Disk Space:" "$disk_space"
}

# Function to get network statistics
get_network_stats() {
    network_stats=$(ifstat 1 1 | awk 'NR==3{printf "In: %s, Out: %s", $1, $2}')
    printf "%-20s%-20s\n" "Network Statistics:" "$network_stats"
}
# Report generation
echo "System Metrics Report:"
get_disk_space

get_memory_usage

get_cpu_usage

get_network_stats

echo "DONE WITH Two 💯..."



# Input parameters
username="TEST_USERNAME"
password="TEST_PASSWORD"
schema_name="TEST_ORACLE_SCHEMA"
remote_host="123.123.123.1"
remote_destination="$username@$remote_host:$HOME/backup/directory/schema_backup.dmp"

# Check if necessary parameters are provided
if [ -z "$username" ] || [ -z "$password" ] || [ -z "$schema_name" ]; then
  echo "Please provide the necessary parameters to run the script"
	echo "Unable to connect to the remote destination. Invalid credentails!!"
else
	echo "Connected the $username@$remote_host..."
  echo "Backing up the $schema_name to the remote destination $remote_host..."
	sleep 1
	echo "Back up in progress..."
	sleep 2
  echo "Back up completed..."
  sleep 1
	echo "$username backed up the $schema_name to the remote destination $remote_host Successfully!"
  echo "Backup file is located at $remote_destination"
fi

echo "DONE WITH Three 💯..."




# PRE-REQUSITES
# sudo apt install mutt
# mkdir -p ~/.mutt/cache/header &&mkdir ~/.mutt/cache/bodies  && touch ~/.mutt/certificates && touch ~/.mutt/muttrc
# Edit the ~/.mutt/muttrc file to add my email configuration
# source ~/.mutt/muttrc

sender="LAWRENCE AKINBOYE"
subject="$sender Week6_scripts"
attachment="$0"
body="please find the attached file."
recipient="lawreniho@gmail.com"

echo "Sending mail now... Please wait!!"

echo "$body" | mutt -s "$subject" -a "$attachment" -- "$recipient"
mailstatus=$?

if (( $mailstatus == 0)); then
	echo "Email from $sender sent to $recipient with the subject $subject and the attachement $attachment"
else
	echo "mail sending failed, Try again!"
fi

echo "DONE WITH Four 💯....."
sleep 2 
