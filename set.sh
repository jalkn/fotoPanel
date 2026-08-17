#!/usr/bin/env bash
set -e

echo "=== Initializing Architecture for  & Studio Mode Automation ==="

# 1. Generate index.html in the repository root
cat << 'EOF' > index.html
<!DOCTYPE html>
<html lang="es" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <link class="icon" type="image/png" href="img/favicon.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>FOTOPANEL.ART</title>
    
    <!-- External Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&display=swap" rel="stylesheet">
    
    <style>
        /* CSS VARIABLES & THEME CONFIGURATION */
        :root[data-theme="dark"] {
            --jako-bg: #121212;
            --jako-text: #ffffff;
            --jako-border: rgba(255, 255, 255, 0.15);
            --jako-glass: rgba(30, 30, 30, 0.6);
            --jako-led: rgba(255, 255, 255, 0.6);
            --gradient-start: rgba(255, 255, 255, 0.05);
            --gradient-mid: rgba(18, 18, 18, 0.85);
            --gradient-end: #121212;
            --icon-hover: #ffffff;
        }

        :root[data-theme="light"] {
            --jako-bg: #ffffff;
            --jako-text: #000000;
            --jako-border: rgba(0, 0, 0, 0.12);
            --jako-glass: rgba(255, 255, 255, 0.85);
            --jako-led: rgba(0, 0, 0, 0.3);
            --gradient-start: rgba(0, 0, 0, 0.02);
            --gradient-mid: rgba(255, 255, 255, 0.85);
            --gradient-end: #ffffff;
            --icon-hover: #666666;
        }

        :root {
            --halftone-size: 3.6px;
        }

        /* GLOBAL RESET & BASE STYLES */
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
            transition: background-color 0.4s ease, color 0.4s ease;
        } 

        #texture-overlay {
            position: fixed;
            inset: 0;
            z-index: -1;
            pointer-events: none;
            background-size: cover;
            background-position: center;
            opacity: 0.15; 
            mix-blend-mode: overlay; 
        }

        ::selection {
            background-color: var(--jako-text);
            color: var(--jako-bg);
        }

        button, span, div { -webkit-tap-highlight-color: transparent; }

        /* AMBIENT BACKGROUND OVERLAYS */
        #page-bg-overlay, .ambient-gradient {
            position: fixed;
            inset: 0;
        }

        #page-bg-overlay {
            background: radial-gradient(circle at 50% 30%, var(--gradient-start) 0%, var(--gradient-mid) 65%, var(--gradient-end) 100%);
            z-index: -1;
            transition: background 0.5s ease;
        }

        .ambient-gradient {
            background: linear-gradient(to bottom, rgba(0,0,0,0.05), transparent, rgba(0,0,0,0.05));
            z-index: 0;
            pointer-events: none;
        }

        /* BUTTON BASE STYLES */
        button {
            background-color: transparent;
            border: none;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--jako-text);
            cursor: pointer;
            transition: opacity 0.2s ease, transform 0.2s ease;
        }

        button:hover { opacity: 0.8; }
        button:active { transform: scale(0.92); }
        button.active-btn { opacity: 1; filter: drop-shadow(0 0 3px var(--jako-text)); }

        .btn-reset-text {
            width: auto;
            padding: 0 0.5rem;
            gap: 0.5rem;
            font-size: 16px;
            font-weight: 700;
            letter-spacing: 0.25em;
        }

        .icon-stroke {
            width: 1.2rem;
            height: 1.2rem;
            stroke: var(--jako-text);
            transition: stroke 0.2s ease;
        }

        button:hover .icon-stroke { stroke: var(--icon-hover); }

        /* LAYOUT HEIGHT SECTIONS */
        .header-bar {
            height: 10dvh;
            max-height: 10dvh;
            flex-shrink: 0;
            display: flex;
            justify-content: center; 
            align-items: center;
            width: 100%;
            padding: 0 1rem;
            position: relative;
            z-index: 100;
            border-bottom: 1px solid var(--jako-border);
            background: var(--jako-glass);
        }

        /* MAIN VISUALIZER CONTAINER */
        .main-visualizer-container {
            height: 65dvh;
            max-height: 65dvh;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
            position: relative;
            overflow: hidden;
            flex-shrink: 0;
        }

        .info-strip-bottom {
            height: 5dvh;
            max-height: 5dvh;
            flex-shrink: 0;
        }

        .controls-bar {
            height: 10dvh;
            max-height: 10dvh;
            flex-shrink: 0;
            position: relative;
            z-index: 100;
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            padding: 0 0.5rem;
            border-top: 1px solid var(--jako-border);
            border-bottom: 1px solid var(--jako-border);
            background: var(--jako-glass);
            gap: 1.5rem;
        }

        .footer-container {
            height: 5dvh;
            max-height: 5dvh;
            width: 100%;
            flex-shrink: 0;
            background: var(--jako-glass);
            z-index: 50;
            padding: 0 1.25rem; 
            border-top: 1px solid var(--jako-border);
            display: flex;
            align-items: center;
            justify-content: space-between !important; 
        }

        /* PACK CONTAINER & VECTOR CANVAS STYLING */
        #fotopanel-pack-container {
            position: relative;
            height: 100%;
            max-height: 55dvh;
            width: auto;
            flex-shrink: 0;
            margin: auto;
            transform-origin: center center;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        #fotopanel-pack-container.mode-single { aspect-ratio: 1 / 1; }
        #fotopanel-pack-container.mode-grid { aspect-ratio: 1 / 2; }

        .pack-viewport {
            position: relative;
            width: 100%;
            height: 100%;
            overflow: hidden;
            border-radius: 2px;
            border: 1px solid var(--jako-border);
        }

        .pack-viewport svg {
            width: 100%;
            height: 100%;
            display: block;
        }

        .info-strip {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            color: var(--jako-text);
            font-size: 10px;
            letter-spacing: 0.25em;
            text-transform: uppercase;
            padding: 0.8rem 2rem;
            gap: 1.5rem;
            z-index: 20;
        }

        .info-strip-content {
            display: flex;
            align-items: center;
            gap: 1rem;
            white-space: nowrap;
        }

        .info-item-block {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 1px;
        }

        .info-item-title {
            font-size: 7px;
            opacity: 0.5;
            letter-spacing: 0.15em;
        }

        .info-separator {
            opacity: 0.4;
            font-weight: 300;
        }

        .tele-value { 
            color: var(--jako-text); 
        }

        .btn-control-action {
            width: 3.8rem !important;
            height: 100%;
        }

        /* FOOTER BRANDING */
        .footer-brand-text {
            display: flex;
            align-items: center;
            gap: 0.35em;
            font-size: 7px;
            letter-spacing: 0.35em;
            font-weight: 700;
            color: var(--jako-text);
            opacity: 0.5;
            text-transform: uppercase;
            transition: opacity 0.3s ease;
            line-height: 1;
        }

        .footer-copy-symbol {
            font-size: 1.5em;
            line-height: 1;
        }

        .footer-container:hover .footer-brand-text { opacity: 0.9; }

        /* RESPONSIVE SCALING */
        @media (max-height: 667px) {
            .footer-container { padding: 0 0.5rem; }
            .btn-reset-text { font-size: 10px; }
            .icon-stroke { width: 1.1rem; height: 1.1rem; }
            .info-strip { font-size: 7px; gap: 0.4rem; }
            .info-strip-content { gap: 0.4rem; }
            .info-item-title { font-size: 6px; }
            #fotopanel-pack-container { max-height: 48dvh; }
            .controls-bar { gap: 0.5rem; margin-bottom: 0.4rem; }
            .btn-control-action { width: 2rem !important; }
        }
    </style>
</head>
<body>

    <div id="page-bg-overlay"></div>
    <div id="texture-overlay"></div>
    <div class="ambient-gradient"></div>
        
    <!-- TOP HEADER -->
    <header class="header-bar" style="display: flex; flex-direction: column; justify-content: center; align-items: center; gap: 0.2rem;">
        <button class="btn-reset-text" title="Reset View" onclick="resetView()">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="5.5" class="icon-stroke">
                <rect x="4" y="4" width="16" height="16" />
            </svg>
            <span>FOTOPANEL</span>
        </button>
        <span id="top-strip-text" style="font-size: 7px; opacity: 0.5; letter-spacing: 0.25em; text-transform: uppercase;">IMAGINA • ENFOCA • PROYECTA</span>
    </header>

    <!-- MAIN VISUALIZER STAGE -->
    <main class="main-visualizer-container">
        <div id="fotopanel-pack-container" class="mode-single">
            <div class="pack-viewport">
                <canvas id="halftone-canvas" style="display: none;"></canvas>
                <div id="svg-output-target" style="width: 100%; height: 100%;"></div>
            </div>
        </div>
    </main>

    <!-- BOTTOM SPEC STRIP -->
    <div class="info-strip info-strip-bottom">
        <div class="info-strip-content">
            <div class="info-item-block">
                <span id="fotopanel-finish" class="tele-value">GRABADO LASER</span>
                <span id="lbl-printing-media" class="info-item-title">GRABADO LÁSER</span>
            </div>

            <span class="info-separator">/</span>

            <div class="info-item-block">
                <span id="fotopanel-media" class="tele-value">ACM 3MM</span>
                <span id="lbl-mdf-support" class="info-item-title">MATERIAL</span>
            </div>

            <span class="info-separator">/</span>

            <div class="info-item-block">
                <span id="fotopanel-label" class="tele-value">10X10 ACM 12MM</span>
                <span class="info-item-title">CMS</span>
            </div>
            
            <span class="info-separator">/</span>
            
            <div class="info-item-block">
                <span id="fotopanel-price" class="tele-value">25MIL</span>
                <span class="info-item-title">COP $</span>
            </div>
        </div>
    </div>

    <!-- BOTTOM ACTION CONTROLS -->
    <div class="controls-bar">
        <!-- Toggle Image Color Inversion -->
        <button id="btn-invert-color" title="Invert Color Scheme" onclick="toggleImageInvert()" class="btn-control-action">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="icon-stroke">
                <circle cx="12" cy="12" r="9" />
                <path d="M12 3v18a9 9 0 0 0 0-18z" fill="currentColor" />
            </svg>
        </button>

        <!-- Toggle Halftone Grid Resolution -->
        <button id="btn-toggle-halftone-size" title="Toggle Grid Density (Low/High Res)" onclick="toggleHalftoneSize()" class="btn-control-action">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="icon-stroke">
                <circle cx="6" cy="6" r="1.5" fill="currentColor" />
                <circle cx="12" cy="6" r="1.5" fill="currentColor" />
                <circle cx="18" cy="6" r="1.5" fill="currentColor" />
                <circle cx="6" cy="12" r="2" fill="currentColor" />
                <circle cx="12" cy="12" r="2.5" fill="currentColor" />
                <circle cx="18" cy="12" r="2" fill="currentColor" />
                <circle cx="6" cy="18" r="1.5" fill="currentColor" />
                <circle cx="12" cy="18" r="1.5" fill="currentColor" />
                <circle cx="18" cy="18" r="1.5" fill="currentColor" />
            </svg>
        </button>

        <!-- Toggle Mosaic / Package Mural Grid Mode -->
        <button id="btn-toggle-grid" title="Mosaic Grid View" onclick="toggleGridMode()" class="btn-control-action">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="icon-stroke">
                <rect x="3" y="3" width="7" height="7" />
                <rect x="14" y="3" width="7" height="7" />
                <rect x="14" y="14" width="7" height="7" />
                <rect x="3" y="14" width="7" height="7" />
            </svg>
        </button>
    </div>

    <!-- FOOTER -->
    <footer class="footer-container">
        <a href="https://github.com/jalkn" target="_blank" rel="noopener noreferrer" class="footer-brand-text" style="text-decoration: none; color: inherit;">
            <span>JAKO.DEV</span>
            <span class="footer-copy-symbol">©</span>
            <span>2026</span>
        </a>     

        <button id="btn-theme-toggle" title="Cambiar Tema (Claro/Oscuro)" onclick="toggleTheme()" class="btn-control-action">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="icon-stroke">
                <circle cx="12" cy="12" r="5" />
                <path d="M12 1v2m0 18v2M4.22 4.22l1.42 1.42m12.72 12.72l1.42 1.42M1 12h2m18 0h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42" />
            </svg>
        </button>
    </footer>

    <!-- Core Logic Engine -->
    <script>
        // Catalog setup
        const ARTEPANEL_CATALOG = {
            'PULSOR': {
                defaultVariant: 'STENCIL 10X10',
                variants: {
                    'STENCIL 10X10': { 
                        label: '10X10', 
                        spec_es: 'CORTE LASER SOLID',
                        media: '200GRS',
                        finish: 'PAPEL REC.',
                        price: '25MIL', 
                        scale: 0.50,
                        nodes: {
                            cols: 10,
                            rows: 20,
                            total: 200,
                            muralLabel: '200X100', 
                            totalPriceFormatted: '5MILLONES'
                        }
                    }
                }
            }
        };

        // Application state initializations
        let currentFotoItem = 'PULSOR';
        let currentFotoVariant = 'STENCIL 10X10';
        let isGridMode = false;
        let isImageInverted = false;
        let isCoarseHalftone = false;

        // Default image path
        const activeImageSrc = 'img/photo.png';

        // Icon SVG Templates for grid toggle button
        const SVG_GRID_FOUR = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="icon-stroke"><rect x="3" y="3" width="7" height="7" /><rect x="14" y="3" width="7" height="7" /><rect x="14" y="14" width="7" height="7" /><rect x="3" y="14" width="7" height="7" /></svg>`;
        const SVG_GRID_SINGLE = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="icon-stroke"><rect x="4" y="4" width="16" height="16" /></svg>`;

        // DOM elements cache helper
        const cachedElements = {};
        const getCachedEl = (id) => cachedElements[id] || (cachedElements[id] = document.getElementById(id));

        // Haptic feedback trigger
        const triggerHaptic = (pattern) => { 
            if (navigator.vibrate) navigator.vibrate(pattern); 
        };

        // Toggle UI theme (Dark / Light)
        function toggleTheme() {
            const html = document.documentElement;
            const currentTheme = html.getAttribute('data-theme') || 'dark';
            const nextTheme = currentTheme === 'dark' ? 'light' : 'dark';
            html.setAttribute('data-theme', nextTheme);
            localStorage.setItem('fotopanel_theme', nextTheme);
            triggerHaptic(10);
        }

        // Initialize Theme preference from localStorage
        function initTheme() {
            const savedTheme = localStorage.getItem('fotopanel_theme') || 'dark';
            document.documentElement.setAttribute('data-theme', savedTheme);
        }

        // Toggle Grid Mode (Mosaico 200 Nodos)
        function toggleGridMode() {
            isGridMode = !isGridMode;
            const btn = getCachedEl('btn-toggle-grid');
            if (btn) {
                if (isGridMode) {
                    btn.classList.add('active-btn');
                    btn.innerHTML = SVG_GRID_SINGLE;
                    btn.title = "Single Panel View";
                } else {
                    btn.classList.remove('active-btn');
                    btn.innerHTML = SVG_GRID_FOUR;
                    btn.title = "Mosaic Grid View";
                }
            }
            updateFotoUI();
            triggerHaptic([15, 30]);
        }

        // Toggle Halftone Grid Resolution (30 vs 60 dots)
        function toggleHalftoneSize() {
            isCoarseHalftone = !isCoarseHalftone;
            const btn = getCachedEl('btn-toggle-halftone-size');
            if (btn) btn.classList.toggle('active-btn', isCoarseHalftone);
            updateFotoUI();
            triggerHaptic([10, 20]);
        }

        // Toggle Image Inversion
        function toggleImageInvert() {
            isImageInverted = !isImageInverted;
            const btn = getCachedEl('btn-invert-color');
            if (btn) btn.classList.toggle('active-btn', isImageInverted);
            updateFotoUI();
            triggerHaptic([10, 20]);
        }

        // Reset stage to default setup
        function resetView() {
            isGridMode = false;
            isImageInverted = false;
            isCoarseHalftone = false;
            
            const btnGrid = getCachedEl('btn-toggle-grid');
            if (btnGrid) {
                btnGrid.classList.remove('active-btn');
                btnGrid.innerHTML = SVG_GRID_FOUR;
            }

            const btnInvert = getCachedEl('btn-invert-color');
            if (btnInvert) btnInvert.classList.remove('active-btn');

            const btnHalftone = getCachedEl('btn-toggle-halftone-size');
            if (btnHalftone) btnHalftone.classList.remove('active-btn');
            
            updateFotoUI();
            triggerHaptic([10, 10]);
        }

        // Generate vector halftone SVG directly via client Canvas calculation
        function generateVectorSVG(imageSrc, gridCols, isInverted, callback) {
            const img = new Image();
            img.crossOrigin = "Anonymous";
            img.onload = () => {
                const canvas = getCachedEl('halftone-canvas');
                const ctx = canvas.getContext('2d');

                const aspect = img.height / img.width;
                const gridRows = Math.round(gridCols * (isGridMode ? aspect : 1));

                canvas.width = gridCols;
                canvas.height = gridRows;

                ctx.drawImage(img, 0, 0, gridCols, gridRows);
                const imgData = ctx.getImageData(0, 0, gridCols, gridRows).data;

                const cellSize = 10;
                const viewWidth = gridCols * cellSize;
                const viewHeight = gridRows * cellSize;
                const maxRadius = isCoarseHalftone ? 4.5 : 2.2;
                const minRadius = 0.5;

                const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
                const baseBg = isDark ? "#121212" : "#ffffff";
                const baseDot = isDark ? "#ffffff" : "#000000";

                const bgColor = isInverted ? baseDot : baseBg;
                const dotColor = isInverted ? baseBg : baseDot;

                let svgString = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${viewWidth} ${viewHeight}" width="100%" height="100%" style="background-color: ${bgColor};">`;
                svgString += `<g fill="${dotColor}">`;

                for (let y = 0; y < gridRows; y++) {
                    for (let x = 0; x < gridCols; x++) {
                        const idx = (y * gridCols + x) * 4;
                        const r = imgData[idx];
                        const g = imgData[idx + 1];
                        const b = imgData[idx + 2];
                        
                        // Luminance calculation
                        const brightness = (0.299 * r + 0.587 * g + 0.114 * b);
                        const factor = isInverted ? (brightness / 255.0) : ((255 - brightness) / 255.0);
                        
                        const radius = minRadius + (factor * (maxRadius - minRadius));

                        if (radius > 0.2) {
                            const cx = (x * cellSize) + (cellSize / 2);
                            const cy = (y * cellSize) + (cellSize / 2);
                            svgString += `<circle cx="${cx.toFixed(2)}" cy="${cy.toFixed(2)}" r="${radius.toFixed(2)}" />`;
                        }
                    }
                }

                svgString += `</g></svg>`;
                callback(svgString);
            };
            img.src = imageSrc;
        }

        // Render current panel vector SVG within viewport
        function renderPanelImages(config) {
            const container = getCachedEl('fotopanel-pack-container');
            const target = getCachedEl('svg-output-target');
            if (!container || !target) return;

            if (isGridMode) {
                container.classList.remove('mode-single');
                container.classList.add('mode-grid');
                container.style.transform = `scale(0.85)`;
            } else {
                container.classList.remove('mode-grid');
                container.classList.add('mode-single');
                container.style.transform = `scale(${config.scale})`;
            }

            const gridResolution = isCoarseHalftone ? 30 : 60;
            generateVectorSVG(activeImageSrc, gridResolution, isImageInverted, (svgContent) => {
                target.innerHTML = svgContent;
            });
        }

        // Update UI specifications and trigger re-render
        function updateFotoUI() {
            const config = ARTEPANEL_CATALOG[currentFotoItem].variants[currentFotoVariant];
            const label = getCachedEl('fotopanel-label');
            const price = getCachedEl('fotopanel-price');
            const media = getCachedEl('fotopanel-media');
            const finish = getCachedEl('fotopanel-finish');
            const specEs = getCachedEl('lbl-printing-media');
            const mdfSupportLbl = getCachedEl('lbl-mdf-support');

            if (isGridMode) {
                if (label) label.textContent = config.nodes.muralLabel;
                if (mdfSupportLbl) mdfSupportLbl.textContent = `STENCILX${config.nodes.total}`;
                if (price) price.textContent = config.nodes.totalPriceFormatted;
                if (media) media.textContent = config.media;
                if (finish) finish.textContent = config.finish;
                if (specEs) specEs.textContent = config.spec_es;
            } else {
                if (label) label.textContent = config.label;
                if (mdfSupportLbl) mdfSupportLbl.textContent = 'STENCIL';
                if (price) price.textContent = config.price;
                if (media) media.textContent = config.media;
                if (finish) finish.textContent = config.finish;
                if (specEs) specEs.textContent = config.spec_es;
            }

            renderPanelImages(config);
        }

        // Initialize stage on DOM load
        document.addEventListener('DOMContentLoaded', () => {
            initTheme();
            updateFotoUI();
        });
    </script>
</body>
</html>
EOF

# 2. Generate app.py ( Control Interface & Embedded HTML Renderer)
cat << 'EOF' >filter.py
import os
from PIL import Image

def generate_halftone_svg(image_path, output_svg_path, grid_size=40, max_radius=4.0, min_radius=0.5):
    """
    Generates a halftone vector SVG (FotoPanel dot matrix) from an input image.

    :param image_path: Path to the source image file.
    :param output_svg_path: Path where the generated SVG file will be saved.
    :param grid_size: Number of points along the X and Y axes (grid resolution).
    :param max_radius: Maximum radius of each circle (dark areas).
    :param min_radius: Minimum radius of each circle (light areas / min perforation).
    """
    # Load input image and convert to grayscale
    img = Image.open(image_path).convert('L')
    
    # Calculate aspect ratio to preserve image proportions dynamically
    orig_width, orig_height = img.size
    aspect_ratio = orig_height / orig_width
    
    grid_width = grid_size
    grid_height = int(grid_size * aspect_ratio)
    
    # Resize image to target grid dimensions using Lanczos resampling
    img_resized = img.resize((grid_width, grid_height), Image.Resampling.LANCZOS)
    
    # Define cell size and overall SVG viewBox dimensions
    cell_size = 10
    view_width = grid_width * cell_size
    view_height = grid_height * cell_size

    # Build SVG header with clean background fill
    svg_elements = [
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {view_width} {view_height}" width="{view_width}" height="{view_height}">',
        '  <rect width="100%" height="100%" fill="#ffffff" />',
        '  <g fill="#000000">'
    ]

    # Iterate over pixel grid to produce proportional vector circles
    for y in range(grid_height):
        for x in range(grid_width):
            # Fetch pixel brightness level (0 = black, 255 = white)
            pixel = img_resized.getpixel((x, y))
            
            # Invert brightness so darker pixels yield larger vector points
            darkness = (255 - pixel) / 255.0
            
            # Map darkness ratio to corresponding circle radius
            radius = min_radius + (darkness * (max_radius - min_radius))
            
            if radius > 0.1:
                cx = (x * cell_size) + (cell_size / 2)
                cy = (y * cell_size) + (cell_size / 2)
                svg_elements.append(f'    <circle cx="{cx:.2f}" cy="{cy:.2f}" r="{radius:.2f}" />')

    svg_elements.append('  </g>')
    svg_elements.append('</svg>')

    # Write output SVG string to disk
    with open(output_svg_path, 'w', encoding='utf-8') as file:
        file.write('\n'.join(svg_elements))


# Define default input path with localized fallback check
input_image = "img/photo.png" if os.path.exists("img/photo.png") else "input.jpg"

if os.path.exists(input_image):
    # Generate low resolution vector preview
    generate_halftone_svg(input_image, "fotopanel_low_res.svg", grid_size=30, max_radius=4.5)
    
    # Generate high resolution vector output
    generate_halftone_svg(input_image, "fotopanel_high_res.svg", grid_size=60, max_radius=2.2)
    
    print(f"Halftone SVGs generated successfully from '{input_image}'.")
else:
    print(f"Error: Target image file '{input_image}' was not found.")
EOF


# Make set.sh executable
chmod +x set.sh

echo "=== Files created successfully ==="
echo ""
echo "=== Execution Steps ==="
echo ""
echo "1. Grant permissions and run set.sh locally:"
echo "   chmod +x set.sh"
echo "   ./set.sh"
echo ""
echo "   python3 filter.py"