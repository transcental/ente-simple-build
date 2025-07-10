FROM ghcr.io/ente-io/server:latest

# Instalar gettext para envsubst
USER root
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

# Copiar o script de entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Voltar para o usuário padrão
USER 1000

# Usar o entrypoint personalizado
ENTRYPOINT ["/entrypoint.sh"]
