#!/bin/bash

# Generate Secure Secrets for Ente Photo Server
# This script generates secure secrets for the Ente Photo Server deployment

set -e

echo "🔐 Generating secure secrets for Ente Photo Server..."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if .env file exists
if [ -f ".env" ]; then
    echo -e "${YELLOW}Warning: .env file already exists!${NC}"
    echo "This script will create a new .env file with generated secrets."
    echo ""
    read -p "Do you want to continue? This will overwrite your existing .env file. [y/N]: " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
    echo ""
fi

# Generate secure secrets
echo -e "${BLUE}Generating database password...${NC}"
DB_PASSWORD=$(openssl rand -hex 16)

echo -e "${BLUE}Generating MinIO credentials...${NC}"
S3_ACCESS_KEY=$(openssl rand -hex 16)
S3_SECRET_KEY=$(openssl rand -hex 24)

echo -e "${BLUE}Generating encryption keys...${NC}"
ENCRYPTION_KEY=$(openssl rand -base64 32)
HASH_KEY=$(openssl rand -base64 32)
JWT_SECRET=$(openssl rand -base64 32)

# Create .env file
echo -e "${BLUE}Creating .env file...${NC}"
cat > .env << EOF
# Ente Photo Server Environment Variables
# Generated on $(date)
# DO NOT commit this file to version control

# Database Configuration
DB_HOST=postgres
DB_PORT=5432
DB_NAME=ente_db
DB_USER=pguser
DB_PASSWORD=${DB_PASSWORD}

# MinIO/S3 Configuration
S3_ACCESS_KEY=${S3_ACCESS_KEY}
S3_SECRET_KEY=${S3_SECRET_KEY}
S3_ENDPOINT=localhost:3200
S3_REGION=eu-central-2

# MinIO Browser Configuration
MINIO_BROWSER_REDIRECT_URL=https://minio.yourdomain.com

# Encryption and Security Keys
ENCRYPTION_KEY=${ENCRYPTION_KEY}
HASH_KEY=${HASH_KEY}
JWT_SECRET=${JWT_SECRET}

# Ente Web Application URLs
ENTE_API_ORIGIN=https://api.yourdomain.com
ENTE_ALBUMS_ORIGIN=https://albums.yourdomain.com
ENTE_ACCOUNTS_ORIGIN=https://accounts.yourdomain.com
ENTE_FAMILY_ORIGIN=https://family.yourdomain.com
ENTE_CAST_ORIGIN=https://cast.yourdomain.com

# Optional SMTP Configuration (for email notifications)
# SMTP_HOST=smtp.yourdomain.com
# SMTP_PORT=587
# SMTP_USERNAME=your_smtp_username
# SMTP_PASSWORD=your_smtp_password
# SMTP_FROM_EMAIL=noreply@yourdomain.com
EOF

# Set secure permissions
chmod 600 .env

echo -e "${GREEN}✅ Secrets generated successfully!${NC}"
echo ""
echo -e "${YELLOW}Important security notes:${NC}"
echo "1. The .env file has been created with secure permissions (600)"
echo "2. Never commit the .env file to version control"
echo "3. Store these secrets securely in production environments"
echo "4. Update the domain URLs in the .env file to match your setup"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Update the domain URLs in .env to match your setup"
echo "2. Deploy the application with: docker-compose up -d"
echo "3. Set up these environment variables in Coolify"
echo ""
echo -e "${GREEN}Generated secrets summary:${NC}"
echo "- Database password: ${#DB_PASSWORD} characters"
echo "- MinIO access key: ${#S3_ACCESS_KEY} characters"
echo "- MinIO secret key: ${#S3_SECRET_KEY} characters"
echo "- Encryption key: ${#ENCRYPTION_KEY} characters (base64)"
echo "- Hash key: ${#HASH_KEY} characters (base64)"
echo "- JWT secret: ${#JWT_SECRET} characters (base64)"
echo ""
echo -e "${RED}🔒 Keep these secrets secure and never share them!${NC}"
