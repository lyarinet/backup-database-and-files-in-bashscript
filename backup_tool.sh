#!/bin/bash

# Colors for better UI
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Simple spinner animation
spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Ask simple yes/no questions
ask_yesno() {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Function to collect backup description
get_description() {
    echo -e "\n${CYAN}Add a description for this backup (optional):${NC}"
    echo -e "${YELLOW}(Press Ctrl+D when finished)${NC}"
    echo -e "--------------------------------------------------"
    description=$(cat)
    echo -e "--------------------------------------------------"
}

# Function to create README file
create_readme() {
    local backup_path=$1
    local backup_name=$2
    local description=$3
    local readme_file="${backup_path}/README_${backup_name%.*}.txt"
    
    {
        echo "Backup Information"
        echo "================="
        echo "Date: $(date)"
        echo "Backup Name: $backup_name"
        echo "Location: $backup_path"
        echo "Size: $(du -h "${backup_path}/${backup_name}" | cut -f1)"
        echo ""
        echo "Description:"
        echo "$description"
    } > "$readme_file"
    
    echo -e "${GREEN}✓ Backup description saved to ${readme_file}${NC}"
}

# Main backup function
backup_web() {
    echo -e "\n${YELLOW}=== Web Directory Backup ===${NC}"
    
    # Ask for source directory
    read -e -p "Enter directory to backup: " source_dir
    source_dir=$(eval echo "$source_dir") # Expand ~
    
    # Validate directory
    if [ ! -d "$source_dir" ]; then
        echo -e "${RED}Error: Directory doesn't exist!${NC}"
        exit 1
    fi

    # Ask for destination
    read -e -p "Enter backup location: " dest_dir
    dest_dir=$(eval echo "$dest_dir")
    mkdir -p "$dest_dir" || {
        echo -e "${RED}Error: Can't create directory!${NC}"
        exit 1
    }

    # Set backup filename
    backup_name="web_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    read -p "Backup filename [default: $backup_name]: " custom_name
    backup_name=${custom_name:-$backup_name}

    # Get backup description
    if ask_yesno "Would you like to add a description?"; then
        get_description
    else
        description="No description provided"
    fi

    # Start backup
    echo -e "\n${BLUE}Backing up ${source_dir} to ${dest_dir}/${backup_name}${NC}"
    tar -czf "${dest_dir}/${backup_name}" -C "$source_dir" . &
    spinner
    
    # Check result
    if [ $? -eq 0 ]; then
        echo -e "\n${GREEN}✓ Backup successful!${NC}"
        echo -e "Size: $(du -h "${dest_dir}/${backup_name}" | cut -f1)"
        
        # Create README file
        create_readme "$dest_dir" "$backup_name" "$description"
    else
        echo -e "\n${RED}✗ Backup failed!${NC}"
        exit 1
    fi
}

# Database backup function
backup_db() {
    echo -e "\n${YELLOW}=== Database Backup ===${NC}"
    
    # Get DB credentials
    read -p "MySQL username: " db_user
    read -s -p "MySQL password: " db_pass
    echo ""
    read -p "MySQL host [localhost]: " db_host
    db_host=${db_host:-localhost}

    # Get database list
    echo -e "\n${BLUE}Fetching databases...${NC}"
    databases=$(mysql -h "$db_host" -u "$db_user" -p"$db_pass" -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")
    
    if [ -z "$databases" ]; then
        echo -e "${RED}No databases found!${NC}"
        return
    fi

    # Select databases
    echo -e "\nAvailable databases:"
    PS3="Select databases (space to choose, enter when done): "
    select db in $databases; do
        if [ -n "$db" ]; then
            selected_dbs+=("$db")
            echo -e "  ${GREEN}✓ Added $db${NC}"
        else
            break
        fi
    done

    if [ ${#selected_dbs[@]} -eq 0 ]; then
        echo -e "${YELLOW}No databases selected${NC}"
        return
    fi

    # Get backup description
    if ask_yesno "Would you like to add a description?"; then
        get_description
    else
        description="No description provided"
    fi

    # Backup each database
    echo -e "\n${BLUE}Backing up databases...${NC}"
    for db in "${selected_dbs[@]}"; do
        # Set backup filename
        db_backup_name="db_backup_${db}_$(date +%Y%m%d_%H%M%S).sql.gz"
        read -p "Backup filename for ${db} [default: $db_backup_name]: " custom_name
        db_backup_name=${custom_name:-$db_backup_name}

        echo -e "Backing up ${db}..."
        mysqldump -h "$db_host" -u "$db_user" -p"$db_pass" "$db" | gzip > "${dest_dir}/${db_backup_name}" &
        spinner
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ ${db} backed up successfully${NC}"
            # Create README file for each DB backup
            create_readme "$dest_dir" "$db_backup_name" "$description"
        else
            echo -e "${RED}✗ Failed to backup ${db}${NC}"
        fi
    done
}

# Main menu
echo -e "${GREEN}"
echo "╔══════════════════════════╗"
echo "║    SIMPLE BACKUP TOOL    ║"
echo "╚══════════════════════════╝"
echo -e "${NC}"

# Initialize destination directory variable
dest_dir=""

# Ask what to backup
if ask_yesno "Backup web directory?"; then
    backup_web
fi

if ask_yesno "Backup MySQL databases?"; then
    backup_db
fi

# Final message
echo -e "\n${GREEN}Backup complete!${NC}"
if [ -n "$dest_dir" ]; then
    echo -e "Files saved to: ${BLUE}${dest_dir}${NC}"
    echo -e "Descriptions saved in README files"
fi
