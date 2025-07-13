# Deploy no Coolify - Ente Photo Server

## Preparação para Deploy Seguro

### 1. Arquivos para Commit no GitHub

Você pode fazer commit seguro dos seguintes arquivos:
- `docker-compose.yaml` (atualizado com variáveis de ambiente)
- `museum.yaml.template` (template sem credenciais)
- `DEPLOY-COOLIFY.md` (este arquivo)

### 2. Arquivos que NÃO devem ser commitados

Adicione ao `.gitignore`:
```
museum.yaml
.env
credentials.yaml
data/
```

### 3. Configuração no Coolify

#### Passo 1: Criar o Serviço no Coolify
1. Conecte seu repositório GitHub ao Coolify
2. Crie um novo serviço do tipo "Docker Compose"
3. Aponte para o branch com o código atualizado

#### Passo 2: Configurar Variáveis de Ambiente

No Coolify, configure as seguintes variáveis de ambiente:

**Variáveis de Segurança (gere novas chaves):**
```bash
# Gerar chaves de criptografia
ENCRYPTION_KEY=$(openssl rand -base64 32)
HASH_KEY=$(openssl rand -base64 64)
JWT_SECRET=$(openssl rand -base64 32)
```

**Variáveis de Database:**
```bash
POSTGRES_DB=ente-db
```

**Variáveis do Coolify (automáticas):**
- `SERVICE_USER_POSTGRES` - Gerada automaticamente
- `SERVICE_PASSWORD_POSTGRES` - Gerada automaticamente
- `SERVICE_USER_MINIO` - Gerada automaticamente
- `SERVICE_PASSWORD_MINIO` - Gerada automaticamente
- `SERVICE_FQDN_MUSEUM` - Gerada automaticamente
- `SERVICE_FQDN_WEB_3000` - Gerada automaticamente
- `SERVICE_FQDN_WEB_3002` - Gerada automaticamente
- `SERVICE_FQDN_MINIO_3200` - Gerada automaticamente

#### Passo 3: Configurar Custom Build Command

**⚠️ ATENÇÃO: Problema de Timing das Variáveis**

O Custom Build Command é executado **antes** das variáveis automáticas do Coolify estarem disponíveis. Por isso, **NÃO use** o Custom Build Command para o `envsubst`.

**Solução Implementada:**
- O arquivo `init-config.sh` é executado dentro do container quando ele inicia
- Neste momento, todas as variáveis de ambiente do Coolify já estão disponíveis
- O `envsubst` é executado corretamente dentro do container

**NÃO configure Custom Build Command** - deixe em branco ou remova se já estiver configurado.

#### Passo 4: Volumes Persistentes

Certifique-se de que os volumes estejam mapeados corretamente:
- `postgres-data` para dados do PostgreSQL
- `minio-data` para dados do MinIO
- `./data` para dados do Ente (se necessário)

### 4. Comandos para Gerar Chaves Localmente

Se preferir gerar as chaves localmente antes de adicionar no Coolify:

```bash
# Encryption Key
echo "ENCRYPTION_KEY=$(openssl rand -base64 32)"

# Hash Key
echo "HASH_KEY=$(openssl rand -base64 64)"

# JWT Secret
echo "JWT_SECRET=$(openssl rand -base64 32)"
```

### 5. Vantagens desta Abordagem

✅ **Segurança**: Credenciais ficam apenas no Coolify
✅ **Versionamento**: Código pode ser commitado sem riscos
✅ **Flexibilidade**: Fácil para trocar ambientes (dev/staging/prod)
✅ **Padrão**: Usa as variáveis mágicas do Coolify corretamente
✅ **Manutenção**: Fácil rotação de credenciais

### 6. Troubleshooting

Se encontrar problemas com variáveis não definidas, verifique:
1. Se o `envsubst` está sendo executado corretamente
2. Se todas as variáveis estão configuradas no Coolify
3. Se o `museum.yaml` está sendo gerado corretamente

### 7. Estrutura Final

```
your-repo/
├── docker-compose.yaml         # ✅ Pode ser commitado
├── museum.yaml.template        # ✅ Pode ser commitado
├── museum.yaml                 # ❌ NÃO commitar (gerado automaticamente)
├── .env                        # ❌ NÃO commitar
├── credentials.yaml            # ❌ NÃO commitar
├── DEPLOY-COOLIFY.md          # ✅ Pode ser commitado
└── .gitignore                 # ✅ Pode ser commitado
```
