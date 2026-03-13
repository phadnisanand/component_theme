#!/bin/bash
set -e

# Install DDEV
curl -fsSL https://raw.githubusercontent.com/drud/ddev/master/scripts/install_ddev.sh | bash

# Disable DDEV analytics prompt
mkdir -p ~/.ddev
echo "instrumentation_opt_in: false" > ~/.ddev/global_config.yaml

# Install Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

# Verify installations
echo "✅ DDEV version: $(ddev --version)"
echo "✅ Composer version: $(composer --version)"

# Initialize DDEV configuration if needed
if [ ! -f ".ddev/config.yaml" ]; then
    ddev config --project-type=drupal11 --docroot=web --create-docroot
fi
