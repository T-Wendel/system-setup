#!/bin/bash

#if [ "$EUID" -ne 0 ]; then
#    echo "Oi! Run me as root, would ya?"
#    exit
#fi

# Define your log file and scripts directory based on the system setup root folder
LOG_FILE="$HOME/scripts/system-setup/setup.log"
SCRIPTS_ROOT="$HOME/scripts/system-setup"

function parse_log() {
    local failed_scripts=()
    while IFS= read -r line; do
        if [[ "$line" =~ FAILURE ]]; then
            # Extract the script name from the line
            local script_name=$(echo "$line" | grep -oP '\[\K[^\]]*')
            failed_scripts+=("$script_name")
        fi
    done < "$LOG_FILE"
    echo "${failed_scripts[@]}"
}

# Function to run a script and log its success or failure
function run_script_and_log() {
    local script_path="$1"
    local script_name=$(basename "$script_path")
    local log_date=$(date "+%Y-%m-%d %H:%M:%S")

    echo "Running script: $script_name..."
    if bash "$script_path"; then
        echo "[$log_date] [$script_name] - SUCCESS" >> "$LOG_FILE"
        echo "Successfully ran $script_name."
    else
        echo "[$log_date] [$script_name] - FAILURE" >> "$LOG_FILE"
        echo "Failed to run $script_name. Check the log at $LOG_FILE for details."
    fi
}

# Function to detect system type
function detect_system_type() {
    if type lsb_release >/dev/null 2>&1; then
        # Grab the distributor ID
        DISTRO=$(lsb_release -si)
    else
        # Fallback if lsb_release is unavailable
        echo "Your system does not support lsb_release. You'll need to manually specify the system type."
        exit 1
    fi

    case $DISTRO in
        Debian|Ubuntu)
            echo "$SCRIPTS_ROOT/debian"
            ;;
        Fedora|CentOS)
            echo "$SCRIPTS_ROOT/fedora"
            ;;
        *)
            echo "Unsupported system: $DISTRO. You might need to manually adjust the scripts."
            exit 1
            ;;
    esac
}

script_order=(
    "testScript.sh"
    "update.sh"
    "installToolkit.sh"
    "neovimNightly.sh"
    "installGo.sh"
		"installDelve.sh"
    "createDirectories.sh"
    "'setupNeovim&Tmux.sh'"
    "createAliases.sh"
    "setupFzf.sh"
)

# Main logic
SYSTEM_PATH=$(detect_system_type)

# Check if log file exists and is not empty
if [ ! -f "$LOG_FILE" ] || [ ! -s "$LOG_FILE" ]; then
    echo "Log file does not exist or is empty. Running all scripts for $DISTRO."
    for script in "${script_order[@]}"; do
        full_path="$SYSTEM_PATH/$script"
        [ -e "$full_path" ] || continue # Skip if no scripts found
        chmod +x $full_path
        run_script_and_log "$full_path"
    done
else
    echo "Checking for previously failed scripts..."
    failed_scripts=$(parse_log)

    for script in $failed_scripts; do
        script_path="$SYSTEM_PATH/$script"
        if [ -f "$script_path" ]; then
            run_script_and_log "$script_path"
        else
            echo "Failed script not found: $script_path"
        fi
    done
fi
