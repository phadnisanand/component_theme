# DDEV Drupal 11 Codespace

This GitHub Codespace provides a complete DDEV development environment for your existing Drupal 11 project with automated data import via DDEV hooks.

## Quick Start

1. **Open in Codespace**: Click the "Create codespace" button or use the GitHub CLI
2. **Wait for Setup**: The devcontainer will automatically install DDEV and verify your project structure
3. **Start DDEV**:
   ```bash
   ddev start
   ```
   Your DDEV hooks will automatically:
   - Import database from `db/site.sql.gz`
   - Import configuration from `config/sync/`
   - Clear cache

4. **Access Your Site**: The site will be available at port 8080 (auto-opens in browser)

## Your Project Structure

```
├── .devcontainer/           # Codespace configuration
├── .ddev/                  # Your existing DDEV configuration
│   └── config.yaml         # Your DDEV settings with hooks
├── config/sync/            # Your existing Drupal config
├── db/                     # Your database backups
│   └── site.sql.gz        # Your database snapshot
├── web/                   # Your existing Drupal docroot
└── README.md
```

## Your DDEV Hooks

Your existing DDEV configuration includes these automated hooks:

### POST-START Hook
Runs automatically when you start DDEV:
```bash
ddev import-db --file=db/site.sql.gz && ddev drush cim -y && ddev drush cr
```

### PRE-STOP Hook
Runs automatically when you stop DDEV:
```bash
ddev drush cr && ddev drush cex -y && ddev drush sql-dump --gzip --result-file=../db/site.sql
```

## Available Services

- **Drupal Site**: Port 8080 (auto-opens in browser)

## Common Commands

### DDEV Commands
```bash
# Start the environment
ddev start

# Stop the environment
ddev stop

# Restart the environment
ddev restart

# SSH into the web container
ddev ssh

# View project information
ddev describe

# View logs
ddev logs
```

### Drupal/Drush Commands
```bash
# Generate one-time login link
ddev drush uli

# Clear cache
ddev drush cache:rebuild

# Run database updates
ddev drush updatedb

# Export configuration
ddev drush config:export

# Import configuration
ddev drush config:import

# Check site status
ddev drush status
```

### Database Commands
```bash
# Your hooks handle these automatically, but manual commands:
ddev import-db --file=db/site.sql.gz    # Import database
ddev drush sql-dump --gzip --result-file=../db/site.sql  # Backup database
ddev drush sql-cli                       # Access database CLI
```

### Configuration Commands
```bash
# Your hooks handle these automatically, but manual commands:
ddev drush cim -y          # Import configuration
ddev drush cex -y          # Export configuration
ddev drush config:status   # Check config status
```

## File Permissions

The import script automatically handles file permissions, but if you need to fix them manually:

```bash
ddev exec "chown -R www-data:www-data /var/www/html/web/sites/default/files"
ddev exec "chmod -R 755 /var/www/html/web/sites/default/files"
```

## Troubleshooting

### DDEV Won't Start
```bash
# Check Docker status
sudo service docker status

# Start Docker if needed
sudo service docker start

# Try starting DDEV again
ddev start
```

### Database Import Issues
```bash
# Check available snapshots
ls -la database-snapshots/

# Import with verbose output
ddev import-db --src=database-snapshots/your-file.sql --verbose
```

### Config Import Issues
```bash
# Check config files
ls -la config/sync/

# Import with verbose output
ddev drush config:import --verbose
```

## Development Workflow

Your DDEV hooks automate the common development workflow:

### Starting Work
1. **Start DDEV**: `ddev start`
   - Automatically imports latest database from `db/site.sql.gz`
   - Automatically imports configuration from `config/sync/`
   - Automatically clears cache
2. **Get Login Link**: `ddev drush uli`
3. **Start Development**: Make your changes

### Ending Work
1. **Stop DDEV**: `ddev stop`
   - Automatically clears cache
   - Automatically exports configuration to `config/sync/`
   - Automatically creates fresh database backup at `db/site.sql`
2. **Commit Changes**: Add your changes to Git

This ensures your database and configuration are always in sync!

## Performance Tips

- The environment uses Mutagen for file sync performance
- Large file uploads should be placed directly in the `files/` directory
- Use `ddev logs` to monitor performance issues

## Extensions and Tools

The Codespace includes these VS Code extensions:
- PHP Intelephense (PHP language support)
- Prettier (code formatting)
- Tailwind CSS IntelliSense
- Auto Rename Tag
- Apache syntax highlighting

## Security Notes

- This environment is for development only
- The database credentials are default DDEV values (db/db/db)
- SSL certificates are self-signed development certificates
- Never use this configuration in production
