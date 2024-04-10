.PHONY: restore-v13 dump-v13-inserts restore-v9.6

restore-v13:
	docker compose up -d postgres-13
	sleep 5
	docker compose exec postgres-13 psql -U myuser -d mydb -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
	docker compose exec -T postgres-13 pg_restore -U myuser -d mydb -Fc -v /var/www/db/original/rapid1_db.dump

dump-v13-inserts:
	docker compose exec -T postgres-13 pg_dump -U myuser -d mydb --column-inserts > /var/www/db/transient/v13_db_inserts.sql

restore-v9.6:
	docker compose up -d postgres-9.6
	sleep 5
	docker compose exec -T postgres-9.6 psql -U myuser -d mydb < /var/www/db/v13_db_inserts.sql
