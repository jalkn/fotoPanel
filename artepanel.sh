#!/usr/bin/env bash
# ==============================================================================
# Script Name: artepanel.sh
# Ecosystem  : FotoPanel.art (Astro + GCP + Capacitor Mobile Sync)
# Description: Unified orchestration script for cleaning, building, and 
#              preparing native deployment targets for App Store & Play Store.
# ==============================================================================

set -e

# Terminal Styling Output
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Logging Helper
log_status() {
    echo -e "${CYAN}[ArtePanel Mentor]${NC} $1"
}

# ==============================================================================
# FUNCTION: cleanup_legacy()
# Removes residual build artifacts, Astro caches, and temporary system files.
# ==============================================================================
cleanup_legacy() {
    log_status "Initiating environment cleanup..."

    local targets=(
        "dist"
        ".astro"
        "node_modules/.cache"
        "*.log"
        ".DS_Store"
        "npm-debug.log*"
    )

    for target in "${targets[@]}"; do
        if [ -e "$target" ] || [ -d "$target" ]; then
            log_status "Removing legacy artifact: ${target}"
            rm -rf "$target"
        fi
    done

    echo -e "${GREEN}[Success] Environment is clean and ready for execution.${NC}"
}

# ==============================================================================
# FUNCTION: init_directory_structure()
# Provisions project tree and foundational core configurations.
# ==============================================================================
init_directory_structure() {
    log_status "Setting up FotoPanel.art directory architecture..."

    mkdir -p src/styles src/scripts src/pages public/img docs android ios

    if [ ! -f "package.json" ]; then
        log_status "Generating package.json baseline..."
        cat << 'JSON_EOF' > package.json
{
  "name": "fotopanel",
  "type": "module",
  "version": "8.0.0",
  "scripts": {
    "dev": "astro dev",
    "start": "astro dev",
    "build": "astro build",
    "preview": "astro preview",
    "astro": "astro"
  },
  "dependencies": {
    "astro": "^4.0.0"
  }
}
JSON_EOF
    fi

    if [ ! -f "astro.config.mjs" ]; then
        log_status "Generating astro.config.mjs configuration..."
        cat << 'MJS_EOF' > astro.config.mjs
import { defineConfig } from 'astro/config';

export default defineConfig({
  srcDir: "./src",
  publicDir: "./public",
  outDir: "./dist",
  server: {
    port: 3000,
    host: true
  }
});
MJS_EOF
    fi

    echo -e "${GREEN}[Success] Directory tree and baseline configs initialized.${NC}"
}

# ==============================================================================
# FUNCTION: generate_manifest()
# Generates the PWA Web App Manifest for mobile installability.
# ==============================================================================
generate_manifest() {
    log_status "Generating PWA Web App Manifest (public/manifest.json)..."

    cat << 'MANIFEST_EOF' > public/manifest.json
{
  "short_name": "FotoPanel",
  "name": "FotoPanel.art - Visualizador",
  "icons": [
    {
      "src": "/img/favicon.png",
      "type": "image/png",
      "sizes": "192x192"
    },
    {
      "src": "/img/favicon.png",
      "type": "image/png",
      "sizes": "512x512"
    }
  ],
  "start_url": "/",
  "background_color": "#0a0a0a",
  "theme_color": "#0a0a0a",
  "display": "standalone",
  "orientation": "portrait"
}
MANIFEST_EOF

    echo -e "${GREEN}[Success] Web App Manifest generated.${NC}"
}

# ==============================================================================
# FUNCTION: generate_sw()
# Generates the Service Worker for client-side caching and offline reliance.
# ==============================================================================
generate_sw() {
    log_status "Generating Service Worker (public/sw.js)..."

    cat << 'SW_EOF' > public/sw.js
const CACHE_NAME = 'fotopanel-v1';
const ASSETS = [
  '/',
  '/manifest.json',
  '/src/styles/global.css',
  '/src/scripts/fotopanel.js',
  '/img/favicon.png'
];

self.addEventListener('install', (e) => {
  e.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(ASSETS))
  );
});

self.addEventListener('fetch', (e) => {
  e.respondWith(
    caches.match(e.request).then((response) => response || fetch(e.request))
  );
});
SW_EOF

    echo -e "${GREEN}[Success] Service Worker compiled.${NC}"
}

# ==============================================================================
# FUNCTION: run_dev_server()
# Ensures npm dependencies are present and launches Astro local dev environment.
# ==============================================================================
run_dev_server() {
    log_status "Verifying node_modules dependencies..."
    if [ ! -d "node_modules" ]; then
        log_status "Installing NPM packages..."
        npm install
    fi

    log_status "Booting Astro local development engine on http://localhost:3000..."
    npm run dev
}

# Command Execution Control
case "$1" in
    "clean")
        cleanup_legacy
        ;;
    "init")
        init_directory_structure
        generate_manifest
        generate_sw
        ;;
    "pwa")
        generate_manifest
        generate_sw
        ;;
    "dev")
        init_directory_structure
        generate_manifest
        generate_sw
        run_dev_server
        ;;
    *)
        log_status "Running default pipeline: Clean -> Init -> PWA Sync"
        cleanup_legacy
        init_directory_structure
        generate_manifest
        generate_sw
        ;;
esac