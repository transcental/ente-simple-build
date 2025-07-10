# Ente Server - Simplified Deploy for Coolify

This repository contains an optimized version of [Ente Server](https://github.com/ente-io/ente) for Coolify deployment, using pre-built images to avoid build issues.

## 🚀 Features

- ✅ **Fast deployment** - Uses pre-built images (2-3 minutes vs 15-20 minutes)
- ✅ **No build issues** - No need to compile Go or dependencies
- ✅ **No socat container** - Removes the container that causes hanging
- ✅ **Optimized healthcheck** - PostgreSQL with adjusted timings
- ✅ **Simplified configuration** - Ready to use on Coolify

## 📋 Prerequisites

- Coolify installed and configured
- Domain configured for Coolify
- GitHub/GitLab account

## 🛠️ How to Deploy

### 1. Fork or clone this repository

```bash
git clone https://github.com/your-username/ente-simple-build.git
```

### 2. Configure on Coolify

1. **Create new project**: In Coolify, create a new project called `ente-server`

2. **Add service**: 
   - Click "Add Service"
   - Select "Docker Compose"
   - Paste your repository URL
   - Configure:
     - **Branch**: `main`
     - **Dockerfile/Compose Path**: `compose.yaml`
     - **Build Pack**: `Docker Compose`

3. **Configure domains** (optional):
   - **API Museum**: `ente-api.yourdomain.com` (port 8080)
   - **MinIO Console**: `ente-minio.yourdomain.com` (port 3201)

4. **Deploy**: Click "Deploy" and wait

### 3. Configure MinIO

After deployment:

1. Access MinIO Console: `https://ente-minio.yourdomain.com`
2. Login: `changeme` / `changeme1234`
3. Create required buckets:
   - `b2-eu-cen`
   - `wasabi-eu-central-2-v3`
   - `scw-eu-fr-v3`

### 4. Test

```bash
# Test the API
curl https://ente-api.yourdomain.com/ping

# Should return: {"message":"pong"}
```

## 🔧 Configuration

### Environment Variables (recommended)

In Coolify, configure these variables for better security:

```env
POSTGRES_PASSWORD=your_secure_password
MINIO_ROOT_USER=your_minio_user
MINIO_ROOT_PASSWORD=your_secure_minio_password
```

### Customization

- **museum.yaml**: Ente server configuration
- **compose.yaml**: Container configuration

## 📊 Included Services

| Service | Port | Description |
|---------|------|-------------|
| Museum (API) | 8080 | Main Ente server |
| PostgreSQL | 5432 | Database |
| MinIO | 3200 | S3-compatible storage |
| MinIO Console | 3201 | MinIO web interface |

## 🆚 Differences from Original

### Removed:
- ❌ `build` section (uses pre-built image)
- ❌ `socat` container (causes hanging)
- ❌ Build dependencies (gcc, musl-dev, etc.)

### Added:
- ✅ `restart: unless-stopped` for all services
- ✅ Optimized PostgreSQL healthcheck
- ✅ Fixed S3 endpoint configuration
- ✅ Complete documentation

## 🐛 Troubleshooting

### Check logs
```bash
# Museum service logs
docker logs ente-server-museum-1

# PostgreSQL logs
docker logs ente-server-postgres-1

# MinIO logs
docker logs ente-server-minio-1
```

### Common Issues

1. **Database connection error**: Wait for PostgreSQL healthcheck
2. **Buckets not found**: Create buckets in MinIO Console
3. **502 error**: Check if domain is configured correctly

## 🔗 Useful Links

- [Original Ente Server](https://github.com/ente-io/ente/tree/main/server)
- [Coolify Documentation](https://coolify.io/docs)
- [MinIO Documentation](https://docs.min.io/)

## 📝 License

This project maintains the same license as the original Ente project.

## 🤝 Contributing

Contributions are welcome! Open an issue or pull request.

---

⚠️ **Important**: Remember to change default passwords before using in production!
