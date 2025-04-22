#!/usr/bin/env bash

### Create backups for individual or all databases, using environment variables for connection settings.
### Usage:
###     $ ./backup_databases.sh [<database_name>] [<backup_file_path>]

set -o errexit
set -o pipefail
set -o nounset

# Define working directory and source required files
working_dir="$(dirname ${0})"
source "${working_dir}/_sourced/constants.sh"
source "${working_dir}/_sourced/messages.sh"

message_welcome "Starting database backup process..."

# Ensure required environment variables are set
if [[ -z "${POSTGRES_HOST:-}" || -z "${POSTGRES_PORT:-}" || -z "${POSTGRES_USER:-}" || -z "${POSTGRES_PASSWORD:-}" || -z "${POSTGRES_DB:-}" ]]; then
    message_error "Environment variables POSTGRES_HOST, POSTGRES_PORT, POSTGRES_USER, POSTGRES_PASSWORD, and POSTGRES_DB must be set."
    exit 1
fi

# Export environment variables
export PGHOST="${POSTGRES_HOST}"
export PGPORT="${POSTGRES_PORT}"
export PGUSER="${POSTGRES_USER}"
export PGPASSWORD="${POSTGRES_PASSWORD}"
export PGDATABASE="${POSTGRES_DB}"

# Set backup directory, defaulting to /backups
export BACKUP_DIR="${POSTGRES_BACKUP_DIR:-/backups}"
# Function to display help message
# Function to display help message
show_help() {
    message_info "Usage: $0 <database_name|all> [<backup_file_path>]"
    echo
    echo "Arguments:"
    echo "  database_name      Name of the database to back up. Use 'all' to back up all databases."
    echo "  backup_file_path   (Optional) Path to the destination file where the backup will be saved (.sql.xz). If not provided, a default filename will be generated. BACKUP_DIR/DB_NAME_datetime.sql.xz"
    echo
    echo "Examples:"
    echo "  $0 all /path/to/backupfile.sql.xz      Back up all databases to the specified file."
    echo "  $0 my_database /path/to/backupfile.sql.xz   Back up 'my_database' to the specified file."
    echo
    exit 1
}

# Function to back up a single database
backup_single_database() {
    local DB_NAME=$1
    local FILE_PATH=${2:-"${BACKUP_DIR}/${DB_NAME}_$(date +'%Y_%m_%dT%H_%M_%S').sql.xz"}

    message_info "Backing up database '${DB_NAME}' to '${FILE_PATH}'..."
    PGPASSWORD="$PGPASSWORD" pg_dump -U "$PGUSER" -h "$PGHOST" -p "$PGPORT" -d "$DB_NAME" | xz -c > "$FILE_PATH"
    message_success "Backup of '${DB_NAME}' completed. File: '${FILE_PATH}'."
}

# Function to back up all databases
backup_all_databases() {
    local FILE_PATH=${1:-"${BACKUP_DIR}/dumpall_$(date +'%Y_%m_%dT%H_%M_%S').sql.xz"}

    message_info "Backing up all databases to '${FILE_PATH}'..."
    PGPASSWORD="$PGPASSWORD" pg_dumpall -U "$PGUSER" -h "$PGHOST" -p "$PGPORT" --clean --if-exists | xz -c > "$FILE_PATH"
    ln -sf "$FILE_PATH" "${BACKUP_DIR}/latest_backup_all.sql.xz"
    message_success "Backup of all databases completed. File: '${FILE_PATH}'."
}

# Main script execution
if [[ $# -ge 1 ]]; then
    DB_NAME=$1
    BACKUP_FILE=${2:-}
    if [[ "$DB_NAME" == "all" ]]; then
        backup_all_databases "$BACKUP_FILE"
    else
        backup_single_database "$DB_NAME" "$BACKUP_FILE"
    fi
else
    message_info "Error: No parameters provided."
    show_help
fi
