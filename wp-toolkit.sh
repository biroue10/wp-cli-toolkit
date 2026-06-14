#!/bin/bash

WP_PATH="/var/www/monsite"
WP_CLI="/usr/local/bin/wp"
DATE=$(date '+%Y-%m-%d_%H-%M-%S')
BACKUP_DIR="/var/backups/wp-toolkit"

log() {
    echo "[$(date '+%H:%M:%S')] $1"
}

check_requirements() {
    if [ ! -f "$WP_CLI" ]; then
        log "ERROR: WP-CLI not found at $WP_CLI"
        exit 1
    fi

    if [ ! -d "$WP_PATH" ]; then
        log "ERROR: WordPress not found at $WP_PATH"
        exit 1
    fi

    log "Requirements OK."
}



show_menu() {
    echo ""
    echo "============================="
    echo "   WP Toolkit — $WP_PATH"
    echo "============================="
    echo "  1. Plugin management"
    echo "  2. Theme management"
    echo "  3. User management"
    echo "  4. Update WordPress core"
    echo "  5. Database backup"
    echo "  6. Search and replace in DB"
    echo "  0. Exit"
    echo "============================="
    echo -n "Choose an option: "
    read CHOICE
}


manage_plugins() {
    echo ""
    echo "  1. List all plugins"
    echo "  2. Install a plugin"
    echo "  3. Activate a plugin"
    echo "  4. Deactivate a plugin"
    echo "  5. Update all plugins"
    echo "  6. Delete a plugin"
    echo -n "Choose: "
    read ACTION

    case $ACTION in
        1) sudo $WP_CLI plugin list --path="$WP_PATH" --allow-root ;;
        2) echo -n "Plugin slug: " && read PLUGIN && sudo $WP_CLI plugin install "$PLUGIN" --activate --path="$WP_PATH" --allow-root ;;
        3) echo -n "Plugin slug: " && read PLUGIN && sudo $WP_CLI plugin activate "$PLUGIN" --path="$WP_PATH" --allow-root ;;
        4) echo -n "Plugin slug: " && read PLUGIN && sudo $WP_CLI plugin deactivate "$PLUGIN" --path="$WP_PATH" --allow-root ;;
        5) sudo $WP_CLI plugin update --all --path="$WP_PATH" --allow-root ;;
        6) echo -n "Plugin slug: " && read PLUGIN && sudo $WP_CLI plugin delete "$PLUGIN" --path="$WP_PATH" --allow-root ;;
        *) log "Invalid option." ;;
    esac
}






manage_users() {
    echo "  2. Create a user"
    echo "  3. Change user password"
    echo "  4. Delete a user"
    echo -n "Choose: "
    read ACTION

    case $ACTION in
        1) sudo $WP_CLI user list --path="$WP_PATH" --allow-root ;;
        2)
            echo -n "Username: " && read USERNAME
            echo -n "Email: " && read EMAIL
            echo -n "Password: " && read PASSWORD
            echo -n "Role (admin/editor/author/subscriber): " && read ROLE
            sudo $WP_CLI user create "$USERNAME" "$EMAIL" --user_pass="$PASSWORD" --role="$ROLE" --path="$WP_PATH" --allow-root
            ;;
        3)
            echo -n "Username: " && read USERNAME
            echo -n "New password: " && read PASSWORD
            sudo $WP_CLI user update "$USERNAME" --user_pass="$PASSWORD" --path="$WP_PATH" --allow-root
            ;;
        4)
            echo -n "Username: " && read USERNAME
            sudo $WP_CLI user delete "$USERNAME" --reassign=1 --path="$WP_PATH" --allow-root
            ;;
        *) log "Invalid option." ;;
    esac
}



backup_database() {
    sudo mkdir -p "$BACKUP_DIR"
    BACKUP_FILE="${BACKUP_DIR}/wp-db-${DATE}.sql"
    log "Backing up database to $BACKUP_FILE..."
    sudo $WP_CLI db export "$BACKUP_FILE" --path="$WP_PATH" --allow-root
    sudo gzip "$BACKUP_FILE"
    log "Backup saved: ${BACKUP_FILE}.gz"
}

search_replace() {
    echo -n "Search for: " && read SEARCH
    echo -n "Replace with: " && read REPLACE
    log "Running search-replace: '$SEARCH' → '$REPLACE'"
    sudo $WP_CLI search-replace "$SEARCH" "$REPLACE" --path="$WP_PATH" --allow-root
}




main() {
    check_requirements
    while true; do
        show_menu
        case $CHOICE in
            1) manage_plugins ;;
            2) sudo $WP_CLI theme list --path="$WP_PATH" --allow-root ;;
            3) manage_users ;;
            4) sudo $WP_CLI core update --path="$WP_PATH" --allow-root ;;
            5) backup_database ;;
            6) search_replace ;;
            0) log "Goodbye." && exit 0 ;;
            *) log "Invalid option." ;;
        esac
    done
}


main
