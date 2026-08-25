#!/usr/bin/env bash
set -e

# =========================================================================
# macOS Terminal Colors
# =========================================================================
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
GRAY='\033[0;90m'
NC='\033[0m'

echo -e "${CYAN}=========================================================${NC}"
echo "=== Initializing Architecture for FotoPanel Automation ==="
echo -e "${CYAN}=========================================================${NC}"

# Create required directory tree
mkdir -p src/styles src/scripts docs img public/img

# 1. Generate package.json
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

# 2. Generate astro.config.mjs
cat << 'MJS_EOF' > astro.config.mjs
import { defineConfig } from 'astro/config';

export default defineConfig({
  srcDir: "./src",
  publicDir: "./public",
  outDir: "./dist",
  server: {
    port: 3000
  }
});
MJS_EOF

# 3. Generate index.html
cat << 'INDEX_EOF' > index.html
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <link class="icon" type="image/png" href="img/favicon.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>FOTOPANEL.ART</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="src/styles/global.css">
</head>
<body>

    <div id="page-bg-overlay"></div>
    <div class="ambient-gradient"></div>

    <!-- BLOCK 1: HEADER -->
    <header class="header-style-bar">
        <div></div>
        <button class="btn-reset-text" title="Home / Reset" onclick="resetView()">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="5.5" class="icon-stroke">
                <rect x="4" y="4" width="16" height="16" />
            </svg>
            <span>FOTOPANEL</span>
        </button>
        <div></div>
    </header>

    <!-- BLOCK 2: INFO STRIP TOP -->
    <div class="info-style-strip">
        <div class="info-strip-content">
            <span id="top-strip-text" class="info-separator">IMAGINA • ENFOCA • PROYECTA</span>
        </div>
    </div>

    <!-- BLOCK 3: MAIN VISUALIZER -->
    <main class="main-style-visualizer">
        <div id="fotopanel-pack-container" onclick="handleContainerClick(event)">
            <div class="pack-viewport"></div>
        </div>
    </main>

    <!-- BLOCK 5: INFO STRIP BOTTOM -->
    <div class="info-style-strip">
        <div class="info-strip-content" style="flex-direction: column; gap: 0.1rem; text-align: center;">
            <span id="fotopanel-finish" class="tele-value">ADH INKJET PRINT</span>
            <div style="font-size: 8px; opacity: 0.4; letter-spacing: 0.15em;">
                <span id="lbl-printing-media" class="tele-value" style="font-size: inherit;">SOPORTE MDF 9MM</span>
            </div>
        </div>
    </div>

    <!-- BLOCK 6: MAIN ACTION CONTROLS -->
    <div class="header-style-bar">
        <input type="file" id="user-image-input" accept="image/*" style="display: none;" onchange="handleUserImageUpload(event)">

        <!-- B&W / Color Switch -->
        <button id="btn-color-toggle" title="Toggle Color / B&W Mode" onclick="toggleFotoColorMode()" class="btn-control-action">
            <svg viewBox="0 0 24 24" class="icon-stroke">
                <defs>
                    <linearGradient id="color-bw-grad" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" stop-color="#ff6600" />
                        <stop offset="33%" stop-color="#0000ff" />
                        <stop offset="66%" stop-color="#ffffff" />
                        <stop offset="100%" stop-color="#000000" />
                    </linearGradient>
                </defs>
                <rect x="4" y="4" width="16" height="16" fill="url(#color-bw-grad)" stroke="none" />
            </svg>
        </button>

        <button id="btn-change-scale" title="Change Scale / Size" onclick="rotateFotoVariant('next')" class="btn-control-action">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="icon-stroke">
                <rect x="5" y="5" width="14" height="14" />
            </svg>
        </button>

        <!-- Crop & Zoom Toggle -->
        <button id="btn-crop-zoom" title="Toggle Scale Zoom" onclick="toggleCropZoom()" class="btn-control-action">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="icon-stroke">
                <path d="M6 2v14a2 2 0 002 2h14" />
                <path d="M18 22V8a2 2 0 00-2-2H2" />
            </svg>
        </button>

        <!-- Glass Aperture Lens Theme Switch -->
        <button id="acromatic-toggle-trigger" title="Toggle Light/Dark Theme" onclick="toggleTheme()" class="btn-control-action">
            <div class="glass-aperture-dial">
                <div class="aperture-ticks"></div>
                <div class="aperture-core"></div>
            </div>
        </button>
    </div>

    <script src="src/scripts/fotopanel.js"></script>
</body>
</html>
INDEX_EOF

# 4. Generate src/styles/global.css
cat << 'CSS_EOF' > src/styles/global.css
/* ==========================================================================
   1. CSS VARIABLES & THEME CONFIGURATION
   ========================================================================== */
:root[data-theme="dark"] {
    --jako-bg: #0a0a0a;
    --jako-text: #ffffff;
    --jako-border: rgba(255, 255, 255, 0.12);
    --jako-glass: rgba(20, 20, 20, 0.65);
    --jako-led: rgba(255, 255, 255, 0.6);
    --gradient-start: rgba(255, 255, 255, 0.05);
    --gradient-mid: rgba(10, 10, 10, 0.85);
    --gradient-end: #0a0a0a;
    --icon-hover: #ffffff;
    --aperture-deg: 0deg;
}

:root[data-theme="light"] {
    --jako-bg: #f4f5f7;
    --jako-text: #0d0d0d;
    --jako-border: rgba(0, 0, 0, 0.12);
    --jako-glass: rgba(255, 255, 255, 0.65);
    --jako-led: rgba(0, 0, 0, 0.3);
    --gradient-start: rgba(0, 0, 0, 0.02);
    --gradient-mid: rgba(244, 245, 247, 0.85);
    --gradient-end: #f4f5f7;
    --icon-hover: #555555;
    --aperture-deg: 180deg;
}

/* ==========================================================================
   2. GLOBAL RESET & BASE STYLES
   ========================================================================== */
*, ::before, ::after { 
    box-sizing: border-box; 
    margin: 0;
    padding: 0;
    font-family: inherit;
}

html, body {
    height: 100dvh;
    overflow: hidden;
}

body { 
    font-family: 'Orbitron', monospace, sans-serif; 
    background-color: var(--jako-bg); 
    color: var(--jako-text); 
    width: 100%;
    height: 100dvh;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: center;
    user-select: none;
    position: relative;
    letter-spacing: 0.05em;  
    overscroll-behavior: none;
    transition: background-color 0.5s ease, color 0.5s ease;
} 

::selection {
    background-color: var(--jako-text);
    color: var(--jako-bg);
}

button, span, div { -webkit-tap-highlight-color: transparent; }

/* Background ambient lighting overlays */
#page-bg-overlay, .ambient-gradient {
    position: fixed;
    inset: 0;
}

#page-bg-overlay {
    background: radial-gradient(circle at 50% 30%, var(--gradient-start) 0%, var(--gradient-mid) 65%, var(--gradient-end) 100%);
    z-index: -1;
    transform: translateZ(0);
    will-change: background;
    transition: background 0.6s cubic-bezier(0.25, 1, 0.5, 1);
}

.ambient-gradient {
    background: linear-gradient(to bottom, rgba(0,0,0,0.15), transparent, rgba(0,0,0,0.15));
    z-index: 0;
    pointer-events: none;
}

/* Standardized SVG & Glass Buttons */
button {
    background-color: transparent;
    border: none;
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--jako-text);
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

button:hover { opacity: 0.8; }
button:active { transform: scale(0.92); }

.icon-stroke { 
    width: 1.2rem;
    height: 1.2rem;
    stroke: var(--jako-text);
    transition: stroke 0.3s ease;
}

button:hover .icon-stroke { stroke: var(--icon-hover); }

/* Transitions */
.img-glow-transition, .info-strip, .header-style-bar, #fotopanel-pack-container, .panel-back-view {
    transition: opacity 0.5s cubic-bezier(0.4, 0, 0.2, 1), transform 0.5s cubic-bezier(0.4, 0, 0.2, 1), filter 0.5s ease, border-color 0.5s ease;
}

/* ==========================================================================
   3. UNIFIED STRUCTURE STYLES
   ========================================================================== */

/* HEADER & ACTION BARS */
.header-style-bar {
    height: 8dvh;
    max-height: 8dvh;
    flex-shrink: 0;
    display: flex;
    justify-content: space-around;
    align-items: center;
    width: 100%;
    padding: 0 1rem;
    position: relative;
    z-index: 100;
    border-top: 1px solid var(--jako-border);
    border-bottom: 1px solid var(--jako-border);
    background: var(--jako-glass);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    gap: 0.5rem;
}

header.header-style-bar {
    height: 10dvh;
    max-height: 10dvh;
    border-top: none;
    justify-content: space-between;
}

.btn-reset-text {
    width: auto;
    padding: 0 0.5rem;
    gap: 0.5rem;
    font-size: 16px;
    font-weight: 700;
    letter-spacing: 0.25em;
}

.btn-control-action {
    width: 3.5rem;
    height: 100%;
}

/* INDEPENDENT STATIC BAR STYLES FOR VISION DOCUMENTATION */
.block-4-static {
    height: 4.5dvh;
    width: 100%;
    flex-shrink: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 100;
    background: var(--jako-glass);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border-top: 1px solid var(--jako-border);
    border-bottom: 1px solid var(--jako-border);
    padding: 1.2rem;
    font-size: 9px;
    letter-spacing: 0.05em;
}

.block-4-btn {
    height: 100%;
    padding: 0 1rem;
    border-left: 1px solid var(--jako-border);
    border-right: 1px solid var(--jako-border);
}

/* INFO STRIPS */
.info-style-strip {
    height: 5dvh;
    max-height: 5dvh;
    flex-shrink: 0;
    width: 100%;
    color: var(--jako-text);
    font-size: 10px;
    letter-spacing: 0.25em;
    text-transform: uppercase;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 20;
}

.info-strip-content {
    display: flex;
    align-items: center;
    gap: 1rem;
    white-space: nowrap;
}

.info-separator {
    opacity: 0.4;
    font-weight: 300;
}

.tele-value { 
    color: var(--jako-text); 
    text-shadow: 0 0 8px var(--jako-led);
    transform: translateZ(0);
    transition: color 0.5s ease, text-shadow 0.5s ease;
}

/* MAIN VISUALIZER */
.main-style-visualizer {
    height: 58dvh;
    max-height: 58dvh;
    width: 100%;
    max-width: 800px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-end;
    padding: 0.5rem 1rem 1.5rem 1rem;
    position: relative;
    overflow: hidden;
    margin: 0 auto;
    flex-shrink: 0;
}

#fotopanel-pack-container {
    position: relative;
    width: 100%;
    max-width: 380px;
    max-height: 48dvh;
    aspect-ratio: 1 / 1;
    flex-shrink: 0;
    margin: 0 auto;
    cursor: pointer;
    filter: drop-shadow(0 30px 50px rgba(0,0,0,0.5));
    transform-origin: bottom center;
}

.pack-viewport {
    position: relative;
    width: 100%;
    height: 100%;
    overflow: hidden;
}

.user-surface-image {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
    transform-origin: center center;
    will-change: transform;
    transition: transform 0.3s cubic-bezier(0.25, 1, 0.5, 1);
}

.panel-back-view {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
    z-index: 20;
    opacity: 0;
    pointer-events: none;
}

.panel-back-view.active {
    opacity: 1;
    pointer-events: auto;
}

.grayscale-filter {
    filter: grayscale(100%);
}

/* GLASS APERTURE THEME SWITCH */
.glass-aperture-dial {
    width: 28px;
    height: 28px;
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    background: var(--jako-glass);
    border: 1px solid var(--jako-border);
    backdrop-filter: blur(6px);
    box-shadow: inset 0 0 4px var(--jako-border), 0 0 8px rgba(0,0,0,0.2);
    transition: transform 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
    transform: rotate(var(--aperture-deg));
}

.aperture-ticks {
    position: absolute;
    inset: 1px;
    border-radius: 50%;
    background: repeating-conic-gradient(
        from 0deg,
        var(--jako-text) 0deg 2deg,
        transparent 2deg 30deg
    );
    opacity: 0.35;
    mask-image: radial-gradient(circle, transparent 55%, black 60%);
    -webkit-mask-image: radial-gradient(circle, transparent 55%, black 60%);
}

.aperture-core {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: var(--jako-text);
    box-shadow: 0 0 6px var(--jako-text);
}

/* VISION SCROLL VIEWPORT RULES */
.vision-scroll-viewport {
    height: 58dvh;
    max-height: 58dvh;
    width: 100%;
    max-width: 800px;
    overflow-y: auto;
    padding: 1.5rem 1rem;
    margin: 0 auto;
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
    flex-shrink: 0;
}

.vision-card {
    background: var(--jako-glass);
    border: 1px solid var(--jako-border);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    padding: 1.2rem;
    border-radius: 4px;
}

.vision-card h2 {
    font-size: 11px;
    letter-spacing: 0.2em;
    margin-bottom: 1rem;
    border-bottom: 1px solid var(--jako-border);
    padding-bottom: 0.5rem;
    text-transform: uppercase;
}

.checklist-group {
    display: flex;
    flex-direction: column;
    gap: 0.6rem;
    font-size: 10px;
    letter-spacing: 0.05em;
}

.checklist-item {
    display: flex;
    align-items: flex-start;
    gap: 0.6rem;
    line-height: 1.4;
}

.checklist-item input[type="checkbox"] {
    accent-color: var(--jako-text);
    margin-top: 0.15rem;
}

/* RESPONSIVE LAYOUT ADJUSTMENTS */
@media (max-height: 667px) {
    .btn-reset-text { font-size: 11px; }
    .icon-stroke { width: 1rem; height: 1rem; }
    .info-style-strip { font-size: 8px; }
    #fotopanel-pack-container { max-height: 40dvh; }
    .btn-control-action { width: 2.5rem; }
}
CSS_EOF

# 5. Generate src/scripts/fotopanel.js
cat << 'JS_EOF' > src/scripts/fotopanel.js
// Catalog Specifications Data Structure
const ARTEPANEL_CATALOG = {
    'PULSOR': {
        defaultVariant: 'PANEL 40X40',
        variants: {
            'PANEL 20X20': { 
                label: '20X20 CMS', 
                media: 'SOPORTE MDF 12MM LAMINADO',
                finish: 'INKJET COLOR',
                id: 'FP-20X20',
                scale: 0.50
            },
            'PANEL 30X30': { 
                label: '30X30 CMS', 
                media: 'SOPORTE MDF 9MM LAMINADO',
                finish: 'INKJET COLOR',
                id: 'FP-30X30',
                scale: 0.75
            },
            'PANEL 40X40': { 
                label: '40X40 CMS', 
                media: 'SOPORTE MDF 9MM LAMINADO',
                finish: 'INKJET COLOR',
                id: 'FP-40X40',
                scale: 1.00
            }
        }
    }
};

// Global Application State
let currentFotoItem = 'PULSOR';
let currentFotoVariant = 'PANEL 40X40';
let isGrayscale = false;
let isShowingBack = false;
let isZoomed = false;

let activeImageSrc = 'img/photo.png';
const backImageSrc = 'img/back.png';

// Element Cache Helper
const cachedElements = {};
const getCachedEl = (id) => cachedElements[id] || (cachedElements[id] = document.getElementById(id));

// Haptic Feedback Helper
const triggerHaptic = (pattern) => { 
    if (navigator.vibrate) navigator.vibrate(pattern); 
};

// Theme Toggle Controller
function toggleTheme() {
    const html = document.documentElement;
    const currentTheme = html.getAttribute('data-theme') || 'dark';
    const nextTheme = currentTheme === 'dark' ? 'light' : 'dark';
    html.setAttribute('data-theme', nextTheme);
    localStorage.setItem('fotopanel_theme', nextTheme);
    triggerHaptic(10);
}

// Initialize saved theme settings
function initTheme() {
    const savedTheme = localStorage.getItem('fotopanel_theme') || 'dark';
    document.documentElement.setAttribute('data-theme', savedTheme);
}

// Trigger Hidden File Upload Dialog
function triggerImageUpload() {
    const input = getCachedEl('user-image-input');
    if (input) input.click();
}

// Process Image File Upload
function handleUserImageUpload(event) {
    const file = event.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = function(e) {
        activeImageSrc = e.target.result;
        isShowingBack = false;
        isZoomed = false;
        updateFotoUI();
        triggerHaptic([10, 20]);
    };
    reader.readAsDataURL(file);
}

// Toggle Visualizer Zoom
function toggleCropZoom() {
    isZoomed = !isZoomed;
    applyImageTransform();
    triggerHaptic(10);
}

// Apply Image Scale Transformations
function applyImageTransform() {
    const img = document.querySelector('.user-surface-image');
    if (img) {
        const scale = isZoomed ? 1.25 : 1.0;
        img.style.transform = `scale(${scale})`;
    }
}

// Rotate Product Dimensions / Sizes
function rotateFotoVariant(direction = 'next') {
    const variants = Object.keys(ARTEPANEL_CATALOG[currentFotoItem].variants);
    let currentIndex = variants.indexOf(currentFotoVariant);
    
    currentIndex = direction === 'next' 
        ? (currentIndex + 1) % variants.length 
        : (currentIndex - 1 + variants.length) % variants.length;
    
    currentFotoVariant = variants[currentIndex];
    isShowingBack = false;
    updateFotoUI();
    triggerHaptic(15);
}

// Toggle Color vs Grayscale Mode
function toggleFotoColorMode() {
    isShowingBack = false;
    isGrayscale = !isGrayscale;
    updateFotoUI();
    triggerHaptic(10);
}

// Toggle Panel Back View Display
function toggleBackView() {
    isShowingBack = !isShowingBack;
    const backEl = document.querySelector('.panel-back-view');
    if (backEl) {
        backEl.classList.toggle('active', isShowingBack);
    }
    triggerHaptic(20);
}

// Container Click Handler
function handleContainerClick(event) {
    if (event.target.closest('button')) return;
    toggleBackView();
}

// Reset App State to Defaults
function resetView() {
    currentFotoVariant = 'PANEL 40X40';
    isGrayscale = false;
    isShowingBack = false;
    isZoomed = false;
    activeImageSrc = 'img/photo.png';
    const input = getCachedEl('user-image-input');
    if (input) input.value = '';
    
    updateFotoUI();
    triggerHaptic([10, 10]);
}

// Dynamic Panel Visualizer Renderer
function renderPanelImages(config) {
    const container = getCachedEl('fotopanel-pack-container');
    if (!container) return;

    container.style.transform = `scale(${config.scale})`;

    let viewport = container.querySelector('.pack-viewport');
    if (!viewport) {
        viewport = document.createElement('div');
        viewport.className = 'pack-viewport';
        container.appendChild(viewport);
    }

    const bwClass = isGrayscale ? 'grayscale-filter' : '';
    const backActiveClass = isShowingBack ? 'active' : '';

    viewport.innerHTML = `
        <div style="position: absolute; inset: 0; background-color: #e5e5e5; z-index: 1;"></div>
        <img src="${activeImageSrc}" alt="Panel Surface Front" class="user-surface-image img-glow-transition ${bwClass}" style="z-index: 10;" />
        <img src="${backImageSrc}" alt="Panel Surface Back" class="img-glow-transition panel-back-view ${backActiveClass}" />
    `;

    applyImageTransform();
}

// Sync UI Labels with State Catalog
function updateFotoUI() {
    const config = ARTEPANEL_CATALOG[currentFotoItem].variants[currentFotoVariant];
    const media = getCachedEl('lbl-printing-media');
    const finish = getCachedEl('fotopanel-finish');
    
    if (media) media.textContent = `${config.media} `;
    if (finish) finish.textContent = config.finish;

    renderPanelImages(config);
}

// Application DOM Initialization
document.addEventListener('DOMContentLoaded', () => {
    initTheme();
    if (getCachedEl('fotopanel-pack-container')) {
        updateFotoUI();
    }
});
JS_EOF

# 6. Generate docs/vision.html
cat << 'DOCS_EOF' > docs/vision.html
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <link class="icon" type="image/png" href="../img/favicon.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>FOTOPANEL.ART - VISION & ROADMAP</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../src/styles/global.css">
</head>
<body>

    <div id="page-bg-overlay"></div>
    <div class="ambient-gradient"></div>

    <!-- BLOCK 1: HEADER -->
    <header class="header-style-bar">
        <div></div>
        <button class="btn-reset-text" title="Home / Reset" onclick="window.location.href='../index.html'">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="5.5" class="icon-stroke">
                <rect x="4" y="4" width="16" height="16" />
            </svg>
            <span>FOTOPANEL</span>
        </button>
        <div></div>
    </header>

    <!-- BLOCK 2: STATIC BAR FOR HEADER SUBTITLE -->
    <div class="block-4-static">
        <span>FOTOPANEL.ART :: ROADMAP & INTERIOR DESIGN VISION</span>
    </div>

    <!-- MAIN SCROLLABLE VISION CHECKLIST CONTENT -->
    <main class="vision-scroll-viewport">

        <!-- CHECKLIST 1: IMMEDIATE EXECUTION PLAN (WEBAPP LAUNCH SPRINT) -->
        <section class="vision-card">
            <h2>1. PLAN DE EJECUCIÓN INMEDIATO (SPRINT DE LANZAMIENTO WEBAPP)</h2>
            <div class="checklist-group">
                <strong style="font-size: 10px; opacity: 0.8; margin-top: 0.4rem; color: var(--jako-led);">DÍA 1: INTEGRACIÓN DE EXPORTACIÓN PNG Y REFACTORIZACIÓN UI</strong>
                <label class="checklist-item"><input type="checkbox"> Horas 1 - 3 (Lógica de Exportación): Integrar la librería html2canvas en el index.html. Crear la función exportPanelPreview() para capturar el contenedor #fotopanel-pack-container a resolución 1080x1080px.</label>
                <label class="checklist-item"><input type="checkbox"> Horas 4 - 5 (Branding e Overlay): Agregar una marca de agua sutil en la esquina inferior del PNG generado (FotoPanel.art • Muestra Digital) junto con un código QR o enlace directo.</label>
                <label class="checklist-item"><input type="checkbox" checked> Horas 6 - 8 (Ajuste de UI/UX): Limpieza de la barra de acciones, remoción de dependencias directas de WhatsApp / NodeCashflow y optimización de interacción táctil en móviles.</label>

                <strong style="font-size: 10px; opacity: 0.8; margin-top: 0.8rem; color: var(--jako-led);">DÍA 2: CONVERSIÓN A PWA Y PERSISTENCIA DE DATOS</strong>
                <label class="checklist-item"><input type="checkbox"> Horas 1 - 3 (Estructura PWA): Crear los archivos manifest.json y sw.js (Service Worker) para almacenamiento en caché offline, iconos de app para Android/iOS y pantalla de carga (splash screen).</label>
                <label class="checklist-item"><input type="checkbox" checked> Horas 4 - 6 (Persistencia Local): Configurar localStorage para guardar las preferencias del usuario (tema visual, foto cargada recientemente, tamaño seleccionado).</label>
                <label class="checklist-item"><input type="checkbox"> Horas 7 - 8 (Optimización de Carga): Comprimir activos gráficos (photo.png, back.png, favicon.png) y validar tiempos de respuesta.</label>

                <strong style="font-size: 10px; opacity: 0.8; margin-top: 0.8rem; color: var(--jako-led);">DÍA 3: DESPLIEGUE, DOMINIO Y PRUEBAS DE LANZAMIENTO</strong>
                <label class="checklist-item"><input type="checkbox"> Horas 1 - 3 (Infraestructura): Conectar el repositorio Git con Vercel o Netlify para despliegue continuo (CI/CD).</label>
                <label class="checklist-item"><input type="checkbox"> Horas 4 - 5 (Configuración de Red): Configurar los registros DNS para fotopanel.art (Registros A y CNAME) y habilitar certificado SSL (HTTPS automático).</label>
                <label class="checklist-item"><input type="checkbox"> Horas 6 - 8 (QA Móvil & Pruebas en Campo): Probar el flujo completo en múltiples dispositivos móviles, verificar la descarga de PNG y ajustar estilos en pantallas pequeñas.</label>
            </div>
        </section>

        <!-- CHECKLIST 2: SCHEDULE AND TECHNOLOGICAL EVOLUTION PHASES -->
        <section class="vision-card">
            <h2>2. CRONOGRAMA DE DESARROLLO Y HOJA DE RUTA</h2>
            <div class="checklist-group">
                <strong style="font-size: 10px; opacity: 0.8; margin-top: 0.4rem; color: var(--jako-led);">FASE 1: WEBAPP & PWA (LANZAMIENTO INMEDIATO)</strong>
                <label class="checklist-item"><input type="checkbox"> Web App Manifest & Service Worker: Agregar un archivo manifest.json y registrar un Service Worker en el index.html actual. Esto habilita el comportamiento PWA (Add to Home Screen) sin rehacer el código Vanilla JS, permitiendo que la webapp funcione offline y se sienta como una aplicación instalada en iOS/Android hoy mismo.</label>

                <strong style="font-size: 10px; opacity: 0.8; margin-top: 0.8rem; color: var(--jako-led);">FASE 2: MIGRACIÓN PROGRESIVA A ASTRO / FRAMEWORK (MES 1)</strong>
                <label class="checklist-item"><input type="checkbox"> De Vanilla JS a Astro Components: La estructura basada en bloques (header-style-bar, main-style-visualizer) se presta para una separación limpia en componentes de Astro (Header.astro, Visualizer.astro, Controls.astro).</label>
                <label class="checklist-item"><input type="checkbox"> Estado Reactivo Delgado: Reemplazar el objeto global ARTEPANEL_CATALOG y las variables de estado sueltas (isGrayscale, isZoomed) por Nanostores (o señales en Preact/Svelte). Esto mantiene la app ultraligera (&lt;50 KB) y facilita sincronizar el estado entre la vista previa 2D y el futuro módulo AR.</label>

                <strong style="font-size: 10px; opacity: 0.8; margin-top: 0.8rem; color: var(--jako-led);">EVOLUCIÓN FUTURA</strong>
                <label class="checklist-item"><input type="checkbox" checked> Refactorizar estructura en src/styles/global.css y src/scripts/fotopanel.js</label>
                <label class="checklist-item"><input type="checkbox"> Implementar simulación de acrílico grabado con luz de galería en Light Mode</label>
                <label class="checklist-item"><input type="checkbox"> Configurar loop gif/slider de 5 imágenes en el visualizer principal</label>
                <label class="checklist-item"><input type="checkbox"> Desarrollar e integrar módulo de reemplazo de background por foto propia</label>
                <label class="checklist-item"><input type="checkbox"> Integrar vista previa en modo AR (Realidad Aumentada)</label>
            </div>
        </section>

        <!-- CHECKLIST 3: BRAND UI MANUAL -->
        <section class="vision-card">
            <h2>3. MANUAL UI Y GUÍA DE DISEÑO</h2>
            <div class="checklist-group">
                <label class="checklist-item"><input type="checkbox" checked> Paleta Acromática: Dark Theme (#0a0a0a) / Light Theme (#f4f5f7)</label>
                <label class="checklist-item"><input type="checkbox" checked> Tipografía Técnica Principal: 'Orbitron', monospace, sans-serif</label>
                <label class="checklist-item"><input type="checkbox" checked> Estructura Móvil de 6 Bloques con alineación vertical viewport (100dvh)</label>
                <label class="checklist-item"><input type="checkbox"> Efecto Acrílico Ruteado: Bordes LED en Dark Mode / Sombras cenitales en Light Mode</label>
                <label class="checklist-item"><input type="checkbox"> Interacción Háptica para respuesta táctil en botones y switches</label>
            </div>
        </section>

        <!-- CHECKLIST 4: COST ANALYSIS -->
        <section class="vision-card">
            <h2>4. ANÁLISIS DE COSTOS Y MÁRGENES</h2>
            <div class="checklist-group">
                <label class="checklist-item"><input type="checkbox" checked> Panel 20x20: Venta $20,000 COP | Insumos ~$6,500 COP (Margen 67.5%)</label>
                <label class="checklist-item"><input type="checkbox" checked> Panel 30x30: Venta $30,000 COP | Insumos ~$10,000 COP (Margen 66.6%)</label>
                <label class="checklist-item"><input type="checkbox" checked> Panel 40x40: Venta $40,000 COP | Insumos ~$14,500 COP (Margen 63.7%)</label>
                <label class="checklist-item"><input type="checkbox"> Optimización de empaque minimalista y kit de montaje adosado</label>
            </div>
        </section>

        <!-- CHECKLIST 5: ENGINEERING -->
        <section class="vision-card">
            <h2>5. INGENIERÍA Y AUTOMATIZACIÓN</h2>
            <div class="checklist-group">
                <label class="checklist-item"><input type="checkbox"> Capturador Client-Side: Ocultar Bloques 1 y 6 para exportar render limpio</label>
                <label class="checklist-item"><input type="checkbox"> Script de Automatización Python en backend (FastAPI / Cron Job)</label>
                <label class="checklist-item"><input type="checkbox"> Pipeline de Renderizado 300 DPI con sangrías para impresión Inkjet</label>
                <label class="checklist-item"><input type="checkbox"> Integración del bot para sustitución progresiva del canal de WhatsApp</label>
            </div>
        </section>

        <!-- CHECKLIST 6: ARCHITECTURE -->
        <section class="vision-card">
            <h2>6. ARQUITECTURA DEL ECOSISTEMA</h2>
            <div class="checklist-group">
                <label class="checklist-item"><input type="checkbox" checked> Frontend Decoupled con Vanilla JS/CSS (Evolución hacia Astro)</label>
                <label class="checklist-item"><input type="checkbox"> Engine Micro-Backend Python para procesamiento de imagen y colas</label>
                <label class="checklist-item"><input type="checkbox" checked> Script orquestador único set.sh para gestión integral del repositorio</label>
                <label class="checklist-item"><input type="checkbox"> Módulo Bloque 7 (Panel Administrativo) para control en taller</label>
            </div>
        </section>

        <!-- CHECKLIST 7: MARKETING -->
        <section class="vision-card">
            <h2>7. ESTRATEGIA DE MERCADEO</h2>
            <div class="checklist-group">
                <label class="checklist-item"><input type="checkbox"> Posicionamiento de la marca hacia FOTOPANEL Studio / ARpanel</label>
                <label class="checklist-item"><input type="checkbox"> Muestra dinámica en galería virtual interactiva con refresco diario</label>
                <label class="checklist-item"><input type="checkbox"> Estrategia de prototipado y visualización para diseñadores de interiores</label>
                <label class="checklist-item"><input type="checkbox"> Campañas locales enfocadas en módulos coleccionables e interconectables</label>
            </div>
        </section>
    </main>

    <!-- BLOCK 5: STATIC FOOTER BAR -->
    <div class="block-4-static">
        <span>STATUS: SYSTEM ONLINE :: BUILD V1.0</span>
    </div>

    <!-- BLOCK 6: MAIN ACTION CONTROLS (FOOTER) -->
    <div class="header-style-bar">
        <button id="btn-back-home" title="Return to Visualizer" onclick="window.location.href='../index.html'" class="btn-control-action">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="icon-stroke">
                <path d="M19 12H5M12 19l-7-7 7-7"/>
            </svg>
        </button>

        <button id="acromatic-toggle-trigger" title="Toggle Light/Dark Theme" onclick="toggleTheme()" class="btn-control-action">
            <div class="glass-aperture-dial">
                <div class="aperture-ticks"></div>
                <div class="aperture-core"></div>
            </div>
        </button>
    </div>

    <script src="../src/scripts/fotopanel.js"></script>
</body>
</html>
DOCS_EOF

echo "=== Files created successfully ==="
echo "FOTOPANEL system ready."

