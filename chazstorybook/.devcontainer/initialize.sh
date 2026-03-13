#!/bin/bash
set -e

# Create necessary directories
mkdir -p vendor
mkdir -p web/sites/default/files
mkdir -p config/sync

# Ensure proper permissions
chmod 777 web/sites/default/files
chmod 777 config/sync

# Create settings file if it doesn't exist
if [ ! -f "web/sites/default/settings.php" ]; then
    cp web/sites/default/default.settings.php web/sites/default/settings.php
    chmod 666 web/sites/default/settings.php
fi
