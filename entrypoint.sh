#!/bin/bash

# Substituir variáveis de ambiente no credentials.yaml
export POSTGRES_USER="${POSTGRES_USER}"
export POSTGRES_PASSWORD="${POSTGRES_PASSWORD}"
export POSTGRES_DB="${POSTGRES_DB}"
export MINIO_ROOT_USER="${MINIO_ROOT_USER}"
export MINIO_ROOT_PASSWORD="${MINIO_ROOT_PASSWORD}"

envsubst < /credentials.yaml > /tmp/credentials.yaml
mv /tmp/credentials.yaml /credentials.yaml

# Executar o comando original
exec "$@"
