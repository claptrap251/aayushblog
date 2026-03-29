#!/bin/bash
# /home/ash — Unraid User Scripts build & deploy
# Run this as a cron job via Unraid User Scripts plugin

set -e

REPO_URL="https://github.com/claptrap251/aayushblog.git"
BUILD_DIR="/tmp/aayushblog-build"
DEPLOY_DIR="/mnt/user/appdata/swag/www"

if [ -d "$BUILD_DIR/.git" ]; then
  echo "[$(date)] Pulling latest changes..."
  cd "$BUILD_DIR"
  if ! git pull origin main; then
    echo "[$(date)] Pull failed, re-cloning..."
    cd /
    rm -rf "$BUILD_DIR"
    git clone --depth 1 "$REPO_URL" "$BUILD_DIR"
    cd "$BUILD_DIR"
  fi
else
  echo "[$(date)] Cloning repo..."
  rm -rf "$BUILD_DIR"
  git clone --depth 1 "$REPO_URL" "$BUILD_DIR"
  cd "$BUILD_DIR"
fi

echo "[$(date)] Writing build metadata..."
UPTIME_SECONDS=$(cat /proc/uptime | awk '{print int($1)}')
cat > src/data/server-status.json << EOFJ
{
  "buildTime": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "uptimeSeconds": $UPTIME_SECONDS
}
EOFJ

echo "[$(date)] Installing dependencies..."
npm ci

echo "[$(date)] Building site..."
npm run build

echo "[$(date)] Deploying to $DEPLOY_DIR..."
rsync -a --delete dist/ "$DEPLOY_DIR/"

echo "[$(date)] Done."
