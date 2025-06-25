# 🚀 TrackGuests3 Production Deployment Guide

## ✨ Application Overview
**TrackGuests3** is a luxury hospitality guest management system with:
- 🎯 **Smart typeahead room selection** with real-time filtering
- 🎨 **Platinum luxury design** with glass morphism and premium UX
- ⚡ **LiveView real-time updates** for seamless user experience
- 📱 **Mobile-responsive design** across all devices
- 🔐 **Enterprise-grade authentication** system

## 🏗️ Production Build Status
✅ **Production release successfully built!**
- Location: `_build/prod/rel/trackguests3`
- Assets compiled and minified
- All dependencies resolved
- **PostgreSQL configured for production**
- Ready for deployment

## 🔐 Environment Variables Required

```bash
# Core application secrets
export SECRET_KEY_BASE="s+Ciu2RyP2GAyerTPfuDn7Tb5AdXC2aZkt8hbzv5ZlI8eCNh53ojEAIfWaDQ3bWO"

# PostgreSQL database configuration
export DATABASE_URL="postgresql://username:password@localhost/trackguests3_prod"
# Example with custom host/port:
# export DATABASE_URL="postgresql://trackguests_user:secure_password@db.example.com:5432/trackguests3_prod"

# Web server configuration
export PHX_HOST="your-domain.com"           # Your production domain
export PORT="4000"                          # Port to bind to
export PHX_SERVER="true"                   # Enable Phoenix server

# Optional optimizations
export POOL_SIZE="10"                      # Database connection pool size
export ECTO_IPV6="false"                   # Enable IPv6 if needed
```

## 🐘 PostgreSQL Database Setup

### **1. Install PostgreSQL**
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install postgresql postgresql-contrib

# macOS with Homebrew
brew install postgresql

# Docker
docker run --name trackguests-postgres -e POSTGRES_PASSWORD=secure_password -p 5432:5432 -d postgres:15
```

### **2. Create Database and User**
```bash
# Connect to PostgreSQL as superuser
sudo -u postgres psql

# Create database and user
CREATE DATABASE trackguests3_prod;
CREATE USER trackguests_user WITH PASSWORD 'secure_password';
GRANT ALL PRIVILEGES ON DATABASE trackguests3_prod TO trackguests_user;
ALTER USER trackguests_user CREATEDB;
\q
```

### **3. Verify Connection**
```bash
# Test the connection
psql -h localhost -U trackguests_user -d trackguests3_prod
```

## 🚀 Deployment Commands

### 1. **Set Environment Variables**
```bash
# Set all required environment variables
export SECRET_KEY_BASE="s+Ciu2RyP2GAyerTPfuDn7Tb5AdXC2aZkt8hbzv5ZlI8eCNh53ojEAIfWaDQ3bWO"
export DATABASE_URL="postgresql://trackguests_user:secure_password@localhost/trackguests3_prod"
export PHX_HOST="your-domain.com"
export PORT="4000"
export PHX_SERVER="true"
```

### 2. **Run Database Migrations**
```bash
# Run database migrations
_build/prod/rel/trackguests3/bin/migrate
```

### 3. **Start Production Server**
```bash
# Option A: Standard start (daemon mode)
_build/prod/rel/trackguests3/bin/trackguests3 start

# Option B: Server script (interactive mode)
_build/prod/rel/trackguests3/bin/server

# Option C: Foreground mode for debugging
_build/prod/rel/trackguests3/bin/trackguests3 foreground
```

### 4. **Verify Deployment**
```bash
# Check if server is running
curl http://your-domain.com:4000/

# Or visit in browser:
# https://your-domain.com/visitor/check-in
```

## 🛠️ Management Commands

```bash
# Connect to running release remotely
_build/prod/rel/trackguests3/bin/trackguests3 remote

# Stop the server gracefully
_build/prod/rel/trackguests3/bin/trackguests3 stop

# Restart the server
_build/prod/rel/trackguests3/bin/trackguests3 restart

# View all available commands
_build/prod/rel/trackguests3/bin/trackguests3
```

## 🌐 Deployment Platforms

### **Local Server / VPS**
- Use the commands above directly on your server
- Ensure Elixir runtime is installed (Erlang/OTP 25+)
- Configure reverse proxy (nginx/Apache) for SSL

### **Docker Deployment**
```dockerfile
# Example Dockerfile structure
FROM hexpm/elixir:1.15-erlang-26-alpine
# Copy _build/prod/rel/trackguests3 to container
# Set environment variables
# EXPOSE 4000
# CMD ["bin/trackguests3", "start"]
```

### **Cloud Platforms**
- **Fly.io**: Use `fly deploy` with proper configuration
- **Railway**: Connect GitHub repo with auto-deploy
- **Heroku**: Add Elixir buildpack and configure env vars
- **DigitalOcean**: Deploy to App Platform or Droplet

## 🔧 Performance Optimizations

### **Production Settings**
- ✅ Assets minified and compressed (CSS: 203ms, JS: 26ms)
- ✅ Static file caching enabled
- ✅ PostgreSQL connection pooling (configurable via POOL_SIZE)
- ✅ Live reload disabled for production

### **SSL/HTTPS Configuration**
```elixir
# Add to config/prod.exs for SSL
config :trackguests3, Trackguests3Web.Endpoint,
  https: [
    port: 443,
    cipher_suite: :strong,
    keyfile: System.get_env("SSL_KEY_PATH"),
    certfile: System.get_env("SSL_CERT_PATH")
  ],
  force_ssl: [hsts: true]
```

## 📊 Monitoring & Logging

```bash
# View application logs
_build/prod/rel/trackguests3/bin/trackguests3 remote
# Then in iex console:
:observer.start()

# Or check system logs
tail -f /var/log/trackguests3.log
```

## 🎯 Production Features Ready
- ✅ **Guest check-in workflow** with typeahead room selection
- ✅ **Real-time form validation** and user feedback  
- ✅ **Luxury hospitality design** with premium UX
- ✅ **Mobile-responsive interface** for all devices
- ✅ **Authentication system** for secure access
- ✅ **PostgreSQL database** for production scalability
- ✅ **Database migrations** for schema management

## 🚀 **Your luxury guest tracking application is ready for production!**

