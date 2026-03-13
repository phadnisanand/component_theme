#!/bin/bash
set -e

# Navigate to the workspace
cd /workspaces/$(basename "$GITHUB_REPOSITORY")

# Function to wait for Docker with timeout
wait_for_docker() {
    echo "🐳 Starting Docker service..."
    sudo service docker start

    local timeout=60
    local start_time=$(date +%s)

    while ! docker info > /dev/null 2>&1; do
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))

        if [ $elapsed -gt $timeout ]; then
            echo "❌ Docker failed to start within ${timeout} seconds"
            exit 1
        fi
        echo "⏳ Waiting for Docker... ($elapsed/${timeout}s)"
        sleep 1
    done
    echo "✅ Docker is ready"
}

# Function to handle composer installation
handle_composer() {
    echo "📦 Installing Composer dependencies..."
    if [ -f "composer.lock" ]; then
        echo "🔄 Installing from lock file..."
        composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev
    else
        echo "⚠️ Lock file not found, this may take longer..."
        composer install --no-interaction --prefer-dist --optimize-autoloader
    fi
    echo "✅ Composer setup complete"
}

# Function to wait for DDEV with timeout
wait_for_ddev() {
    echo "🚀 Starting DDEV environment..."
    ddev start &
    local ddev_pid=$!

    local timeout=120
    local start_time=$(date +%s)

    while ! ddev describe >/dev/null 2>&1; do
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))

        if [ $elapsed -gt $timeout ]; then
            echo "❌ DDEV failed to start within ${timeout} seconds"
            exit 1
        fi
        echo "⏳ Waiting for DDEV... ($elapsed/${timeout}s)"
        sleep 1
    done

    wait $ddev_pid
    echo "✅ DDEV is ready"
}

# Main execution with parallel processing
main() {
    if ! docker info > /dev/null 2>&1; then
        wait_for_docker
    fi

    # Install Composer dependencies
    handle_composer

    if ! ddev status | grep -q "running"; then
        wait_for_ddev
    fi

    # Display useful information
    cat << EOF

🎉 Development environment is ready!

Your DDEV hooks are configured to:
📥 POST-START: Import DB → Import Config → Clear Cache
💾 PRE-STOP: Clear Cache → Export Config → Backup Database

Useful commands:
- ddev describe        # Show project info and URLs
- ddev ssh            # SSH into the web container
- ddev composer       # Run Composer commands
- ddev drush          # Run Drush commands
- ddev logs           # View container logs
- ddev drush uli      # Generate one-time login link

Development URLs:
$(ddev describe | grep -E "Primary|Additional" | sed 's/^/- /')
EOF
}

# Execute main function
main
