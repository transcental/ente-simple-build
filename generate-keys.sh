#!/bin/bash

# Script para gerar chaves de segurança para o Ente Photo Server
# Execute este script para gerar as chaves necessárias para o Coolify

echo "=== Gerando chaves de segurança para o Ente Photo Server ==="
echo ""

echo "Configure as seguintes variáveis de ambiente no Coolify:"
echo ""

echo "# Chave de criptografia"
echo "ENCRYPTION_KEY=$(openssl rand -base64 32)"
echo ""

echo "# Chave de hash"
echo "HASH_KEY=$(openssl rand -base64 64)"
echo ""

echo "# Chave JWT"
echo "JWT_SECRET=$(openssl rand -base64 32)"
echo ""

echo "# Database"
echo "POSTGRES_DB=ente-db"
echo ""

echo "=== Instruções ==="
echo "1. Copie as variáveis acima"
echo "2. No Coolify, vá para seu serviço > Environment Variables"
echo "3. Adicione cada variável uma por uma"
echo "4. As variáveis SERVICE_* são geradas automaticamente pelo Coolify"
echo "5. Execute o deploy"
echo ""

echo "=== Importante ==="
echo "• Guarde essas chaves em local seguro"
echo "• NÃO commite essas chaves no GitHub"
echo "• Use chaves diferentes para cada ambiente (dev/staging/prod)"
