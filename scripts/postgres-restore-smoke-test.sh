#!/usr/bin/env bash
set -euo pipefail

backup_path="${1:?usage: postgres-restore-smoke-test.sh BACKUP_FILE [CONTAINER]}"
container_name="${2:-duitlah-postgres-1}"
source_db="${DB_NAME:-duitlah}"
db_user="${DB_USER:-duitlah}"
restore_db="duitlah_restore_check"

test -s "$backup_path"

docker exec "$container_name" dropdb --username "$db_user" --if-exists "$restore_db"
docker exec "$container_name" createdb --username "$db_user" "$restore_db"
docker exec -i "$container_name" pg_restore \
  --username "$db_user" \
  --dbname "$restore_db" \
  --no-owner \
  --no-privileges < "$backup_path"

source_version="$(docker exec "$container_name" psql --username "$db_user" --dbname "$source_db" --tuples-only --no-align --command "SELECT version FROM flyway_schema_history WHERE success ORDER BY installed_rank DESC LIMIT 1")"
restored_version="$(docker exec "$container_name" psql --username "$db_user" --dbname "$restore_db" --tuples-only --no-align --command "SELECT version FROM flyway_schema_history WHERE success ORDER BY installed_rank DESC LIMIT 1")"
source_tables="$(docker exec "$container_name" psql --username "$db_user" --dbname "$source_db" --tuples-only --no-align --command "SELECT count(*) FROM information_schema.tables WHERE table_schema='public' AND table_type='BASE TABLE'")"
restored_tables="$(docker exec "$container_name" psql --username "$db_user" --dbname "$restore_db" --tuples-only --no-align --command "SELECT count(*) FROM information_schema.tables WHERE table_schema='public' AND table_type='BASE TABLE'")"

test "$source_version" = "$restored_version"
test "$source_tables" = "$restored_tables"

docker exec "$container_name" dropdb --username "$db_user" "$restore_db"
echo "Restore verified: migration version $restored_version, $restored_tables public tables"
