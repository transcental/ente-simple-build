#!/bin/bash
set -e

echo "Creating user $ENTE_DB_USER and granting permissions..."

# Criar usuário e database se não existirem
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	DO \$\$
	BEGIN
		IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$ENTE_DB_USER') THEN
			CREATE USER "$ENTE_DB_USER" WITH PASSWORD '$ENTE_DB_PASSWORD';
			RAISE NOTICE 'User % created', '$ENTE_DB_USER';
		ELSE
			RAISE NOTICE 'User % already exists', '$ENTE_DB_USER';
		END IF;
	END
	\$\$;
	
	GRANT ALL PRIVILEGES ON DATABASE "$POSTGRES_DB" TO "$ENTE_DB_USER";
	GRANT ALL PRIVILEGES ON SCHEMA public TO "$ENTE_DB_USER";
	GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "$ENTE_DB_USER";
	GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO "$ENTE_DB_USER";
	GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO "$ENTE_DB_USER";
EOSQL

echo "User setup completed."
