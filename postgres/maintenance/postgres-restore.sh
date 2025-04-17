#!/usr/bin/env bash

### Restore databases using environment variables for connection settings.
### Usage:
###     $ ./restore_databases.sh <database_name|all> <backup_file_path>

set -o errexit
set -o pipefail
set -o nounset

# Define working directory and source required files
working_dir="$(dirname ${0})"
source "${working_dir}/_sourced/constants.sh"
source "${working_dir}/_sourced/messages.sh"

message_welcome "Starting database restore process..."

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

# Function to display help message
show_help() {
    message_info "Usage: $0 <database_name|all> <backup_file_path>"
    echo
    echo "Arguments:"
    echo "  database_name      Name of the database to restore. Use 'all' to restore all databases from a pg_dumpall backup."
    echo "  backup_file_path   Path to the compressed backup file (.sql.xz)."
    echo
    echo "Examples:"
    echo "  $0 all /path/to/backupfile.sql.xz      Restore all databases from the backup file."
    echo "  $0 my_database /path/to/backupfile.sql.xz   Restore 'my_database' from the backup file."
    echo
}

# Function to restore a database
restore_database() {
    local DB_NAME=$1
    local FILE_PATH=$2

    if [[ "$DB_NAME" == "all" ]]; then
        message_info "Restoring all databases from '${FILE_PATH}'..."
        xz -d -c "$FILE_PATH" > .dumpall_restore.sql
        PGPASSWORD="$PGPASSWORD" psql -U "$PGUSER" -h "$PGHOST" -p "$PGPORT" -d postgres -f .dumpall_restore.sql
        rm .dumpall_restore.sql
        message_success "All databases restored from '${FILE_PATH}'."
        PGPASSWORD="$PGPASSWORD" psql -U "$PGUSER" -h "$PGHOST" -p "$PGPORT" -d postgres -c "\l"

    else
        message_info "Restoring database '${DB_NAME}' from '${FILE_PATH}'..."
        xz -d -c "$FILE_PATH" | PGPASSWORD="$PGPASSWORD" psql -U "$PGUSER" -h "$PGHOST" -p "$PGPORT" -d "$DB_NAME"
        message_success "'${DB_NAME}' restored from '${FILE_PATH}'."
    fi
}

# Main script execution
if [[ "$#" -lt 2 ]]; then
    show_help
    exit 1
fi

RESTORE_DB="$1"
RESTORE_DB_SOURCE="$2"
restore_database "$RESTORE_DB" "$RESTORE_DB_SOURCE"

