# Security Setup for Ente Photo Server

This document explains the security configuration for the Ente Photo Server deployment.

## Overview

The configuration has been secured by:

1. **Removing hardcoded secrets** from configuration files
2. **Using environment variables** for all sensitive data
3. **Implementing proper secrets management** practices
4. **Adding security safeguards** to prevent accidental exposure

## Environment Variables

All sensitive configuration is now managed through environment variables. Create a `.env` file based on `.env.example`:

```bash
cp .env.example .env
```

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `DB_PASSWORD` | PostgreSQL database password | `your_secure_database_password_here` |
| `S3_ACCESS_KEY` | MinIO access key | `your_minio_access_key_here` |
| `S3_SECRET_KEY` | MinIO secret key | `your_minio_secret_key_here` |
| `ENCRYPTION_KEY` | Base64 encryption key | Generated with `openssl rand -base64 32` |
| `HASH_KEY` | Base64 hash key | Generated with `openssl rand -base64 32` |
| `JWT_SECRET` | Base64 JWT secret | Generated with `openssl rand -base64 32` |

### Generating Secure Keys

Use these commands to generate secure keys:

```bash
# Generate encryption key
openssl rand -base64 32

# Generate hash key
openssl rand -base64 32

# Generate JWT secret
openssl rand -base64 32

# Generate secure password
openssl rand -hex 16
```

## Security Best Practices

### 1. Environment File Management

- **Never commit `.env` files** to version control
- Keep environment files secure with proper file permissions:
  ```bash
  chmod 600 .env
  ```
- Use different `.env` files for different environments (development, staging, production)

### 2. Secret Rotation

- **Regularly rotate secrets** in production environments
- Use a proper secrets management system (HashiCorp Vault, AWS Secrets Manager, etc.)
- Plan for zero-downtime secret rotation

### 3. Access Control

- Limit access to environment files and secrets
- Use principle of least privilege
- Implement proper authentication and authorization

### 4. Monitoring and Auditing

- Monitor access to sensitive configuration
- Log authentication and authorization events
- Set up alerts for suspicious activities

## Production Deployment

For production environments, consider:

### 1. External Secrets Management

Instead of using `.env` files, use a dedicated secrets management system:

```yaml
# Example with Docker Secrets
services:
  museum:
    secrets:
      - db_password
      - s3_secret_key
      - encryption_key
    environment:
      - DB_PASSWORD_FILE=/run/secrets/db_password
      - S3_SECRET_KEY_FILE=/run/secrets/s3_secret_key
      - ENCRYPTION_KEY_FILE=/run/secrets/encryption_key

secrets:
  db_password:
    external: true
  s3_secret_key:
    external: true
  encryption_key:
    external: true
```

### 2. Container Security

- Use non-root users in containers
- Implement proper network segmentation
- Use security scanning tools
- Keep container images updated

### 3. TLS/SSL Configuration

- Use HTTPS everywhere
- Implement proper certificate management
- Use strong cipher suites
- Enable HSTS headers

## Coolify Deployment

When deploying with Coolify:

1. **Set environment variables** in Coolify's environment settings
2. **Use Coolify's secrets management** features
3. **Enable proper access controls** in Coolify
4. **Monitor deployment logs** for security issues

### Environment Variables in Coolify

Configure these variables in Coolify:

```bash
# Database
DB_PASSWORD=your_secure_database_password

# MinIO
S3_ACCESS_KEY=your_minio_access_key
S3_SECRET_KEY=your_minio_secret_key

# Security Keys
ENCRYPTION_KEY=your_base64_encryption_key
HASH_KEY=your_base64_hash_key
JWT_SECRET=your_base64_jwt_secret

# Web URLs
ENTE_API_ORIGIN=https://api.yourdomain.com
ENTE_ALBUMS_ORIGIN=https://albums.yourdomain.com
ENTE_ACCOUNTS_ORIGIN=https://accounts.yourdomain.com
ENTE_FAMILY_ORIGIN=https://family.yourdomain.com
ENTE_CAST_ORIGIN=https://cast.yourdomain.com
```

## Verification

After setting up the environment variables, verify the configuration:

1. **Check that no secrets are hardcoded** in configuration files
2. **Verify environment variables are properly loaded**
3. **Test database and MinIO connectivity**
4. **Ensure the application starts successfully**

## Security Checklist

- [ ] All hardcoded secrets removed from configuration files
- [ ] Environment variables properly configured
- [ ] `.env` file created and secured (chmod 600)
- [ ] `.env` file added to `.gitignore`
- [ ] Strong, unique passwords generated for all services
- [ ] Encryption, hash, and JWT keys generated with proper entropy
- [ ] Production secrets stored in proper secrets management system
- [ ] Regular secret rotation schedule established
- [ ] Access controls implemented
- [ ] Monitoring and alerting configured

## Troubleshooting

### Common Issues

1. **Service fails to start**: Check that all required environment variables are set
2. **Database connection fails**: Verify DB_PASSWORD is correctly set
3. **MinIO access fails**: Check S3_ACCESS_KEY and S3_SECRET_KEY
4. **Authentication issues**: Verify JWT_SECRET is properly configured

### Debug Commands

```bash
# Check environment variables (be careful not to expose secrets)
docker-compose config

# Check service logs
docker-compose logs museum
docker-compose logs postgres
docker-compose logs minio
```

## Support

If you encounter security-related issues:

1. **Check the troubleshooting section** above
2. **Review the application logs** for specific error messages
3. **Verify environment variable configuration**
4. **Test with minimal configuration** to isolate issues

Remember: Never share actual secrets or environment files when seeking support!
