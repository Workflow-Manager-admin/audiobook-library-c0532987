# Audiobook Library Database Setup (PostgreSQL)

This folder includes all SQL and setup scripts needed for the Audiobook Library local development database.

## Requirements

- PostgreSQL (v13+ recommended)
- (Optional) `psql` CLI

Database credentials and connection info are found in:
- `db_connection.txt`: Quick connection string, e.g.  
  `psql postgresql://appuser:dbuser123@localhost:5000/myapp`
- `db_visualizer/postgres.env`: Env vars for local access

## Initialization Steps

1. **Start PostgreSQL instance**

   Use the provided startup script (on compatible systems):
   ```
   bash startup.sh
   ```
   This script creates the database, user, and sets permissions for development.

2. **Run initial schema migration**

   From inside this folder, load the schema:
   ```
   psql "postgresql://appuser:dbuser123@localhost:5000/myapp" -f schema.sql
   ```
   If using psql interactively:
   ```
   psql "postgresql://appuser:dbuser123@localhost:5000/myapp"
   > \i schema.sql
   ```

   This creates the following tables:
   - `users`: user accounts (email, hashed password, etc)
   - `audiobooks`: store of audiobook catalog
   - `purchases`: link table for user's purchased audiobooks
   - `playback_positions`: tracks audiobook progress per user

3. **Seed data** (optional)

   See seed example in `schema.sql`. Uncomment INSERTs to add default data.

## Local Development Notes

- Use the connection info shown after running `startup.sh` (or see `db_connection.txt`).
- DB visualizer for local browsing is set up in `db_visualizer/`.
- Schema uses `ON DELETE CASCADE` for user and audiobook removals.

## Common psql commands

List tables:
```
\dt
```

Preview table:
```
SELECT * FROM users;
SELECT * FROM audiobooks;
SELECT * FROM purchases;
SELECT * FROM playback_positions;
```

## Schema Overview

- **users**: Each user has a unique email.
- **audiobooks**: Audiobook catalog.
- **purchases**: What audiobooks a user owns (cannot buy twice).
- **playback_positions**: Where a user left off for each audiobook.

---

_Contact your devops for further customization, production migration, or backups._
