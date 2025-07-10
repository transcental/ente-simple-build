#!/bin/bash

# Substituir variáveis de ambiente no credentials.yaml
envsubst < /credentials.yaml > /tmp/credentials.yaml
mv /tmp/credentials.yaml /credentials.yaml

# Executar o comando original
exec "$@"
