FROM ghcr.io/ente-io/server:latest

# Instalar gettext para envsubst (Alpine Linux)
USER root
RUN apk add --no-cache gettext

# Copiar o script de entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Voltar para o usuário padrão
USER 1000

# Usar o entrypoint personalizado
ENTRYPOINT ["/entrypoint.sh"]
