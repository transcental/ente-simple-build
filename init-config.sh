#!/bin/bash
# init-config.sh - Script para gerar museum.yaml dentro do container

# Verificar se envsubst está disponível
if ! command -v envsubst &> /dev/null; then
    echo "envsubst não encontrado, instalando..."
    apk add --no-cache gettext
fi

# Gerar museum.yaml a partir do template
echo "Gerando museum.yaml a partir do template..."
envsubst < /museum.yaml.template > /museum.yaml

# Verificar se o arquivo foi gerado
if [ -f "/museum.yaml" ]; then
    echo "✅ museum.yaml gerado com sucesso"
else
    echo "❌ Falha ao gerar museum.yaml"
    exit 1
fi

# Executar o comando original do container
exec "$@"
