# wp-cli-toolkit

Interactive Bash menu for managing WordPress from the command line — plugins, themes, users, core updates, database backup, and search-replace. Built as part of my [syseng-journey](https://github.com/biroue10/syseng-journey) — a hands-on path from Service Desk to Junior Systems Administrator.

---

## Why WP-CLI?

When a WordPress site breaks, the admin dashboard is often inaccessible. WP-CLI lets you manage everything from the terminal — deactivate a broken plugin, reset a password, export the database — without needing a browser.

---

## Features

```
=============================
   WP Toolkit — /var/www/monsite
=============================
  1. Plugin management
  2. Theme management
  3. User management
  4. Update WordPress core
  5. Database backup
  6. Search and replace in DB
  0. Exit
=============================
```

| Feature | What it does |
|---------|-------------|
| Plugin management | List, install, activate, deactivate, update, delete plugins |
| Theme management | List installed themes |
| User management | List, create, change password, delete users |
| Core update | Update WordPress to the latest version |
| Database backup | Export and compress the database with timestamp |
| Search and replace | Update URLs or text across the entire database |

---

## Usage

```bash
git clone https://github.com/biroue10/wp-cli-toolkit.git
cd wp-cli-toolkit
chmod +x wp-toolkit.sh
```

Edit the variables at the top:
```bash
WP_PATH="/var/www/monsite"       # Path to your WordPress installation
BACKUP_DIR="/var/backups/wp-toolkit"  # Where database backups are saved
```

Run:
```bash
sudo ./wp-toolkit.sh
```

---

## Real-World Use Cases

**Plugin broke the site — fix without dashboard access:**
```
Option 1 → Plugin management → Deactivate a plugin
```

**Migrate site to new domain — update all URLs in database:**
```
Option 6 → Search: http://old-domain.com → Replace: https://new-domain.com
```

**Client locked out — reset admin password:**
```
Option 3 → User management → Change user password
```

**Before a major update — backup the database:**
```
Option 5 → Database backup
```

---

## Requirements

- WordPress installed on RHEL
- WP-CLI installed at `/usr/local/bin/wp`

```bash
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
```

---

## Roadmap

- [ ] Automatic backup before every core/plugin update
- [ ] Plugin list export to CSV
- [ ] Multi-site support
- [ ] Log all actions to file

---

## Part of

[biroue10/syseng-journey](https://github.com/biroue10/syseng-journey) — documenting my path from Service Desk Analyst to Junior Systems Administrator.
