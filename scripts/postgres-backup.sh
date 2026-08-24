#!/usr/bin/env bash
set -euo pipefail

output_path="${1:?usage: postgres-backup.sh OUTPUT_FILE [CONTAINER]}"
container_name="${2:-duitlah-postgres-1}"
db_name="${DB_NAME:-duitlah}"
db_user="${DB_USER:-duitlah}"

docker exec "$container_name" pg_dump \
  --username "$db_user" \
  --dbname "$db_name" \
  --format=custom \
  --no-owner \
  --no-privileges > "$output_path"

test -s "$output_path"
echo "Backup written to $output_path"
