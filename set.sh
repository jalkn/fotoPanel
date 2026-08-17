#!/usr/bin/env bash
set -e

echo "=== Initializing Architecture for FotoPanel Automation ==="

# 1. Generate index.html in the repository root
cat << 'EOF' > index.html
<!DOCTYPE html>
<html lang="es" data-theme="light">
<head>
    <meta charset="UTF-8">
    <link class="icon" type="image/png" href="img/favicon.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>FOTOPANEL.ART</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&display=swap" rel="stylesheet">
    
    <style>
        :root[data-theme="dark"] {
            --jako-bg: #121212;
            --jako-text: #ffffff;
            --jako-border: rgba(255, 255, 255, 0.15);
            --jako-glass: rgba(30, 30, 30, 0.6);
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
            --gradient-start: rgba(0, 0, 0, 0.02);
            --gradient-mid: rgba(255, 255, 255, 0.85);
            --gradient-end: #ffffff;
            --icon-hover: #666666;
        }

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

        #page-bg-overlay {
            position: fixed;
            inset: 0;
            background: radial-gradient(circle at 50% 30%, var(--gradient-start) 0%, var(--gradient-mid) 65%, var(--gradient-end) 100%);
            z-index: -1;
        }

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

        .header-bar {
            height: 10dvh;
            display: flex;
            justify-content: center; 
            align-items: center;
            width: 100%;
            z-index: 100;
            border-bottom: 1px solid var(--jako-border);
            background: var(--jako-glass);
        }

        .main-visualizer-container {
            height: 65dvh;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
            position: relative;
            overflow: hidden;
        }

        #fotopanel-pack-container {
            position: relative;
            height: 100%;
            max-height: 55dvh;
            width: auto;
            margin: auto;
            display: flex;
            align-items: center;
            justify-content: center;
            aspect-ratio: 1 / 1;
        }

        .pack-viewport {
            width: 100%;
            height: 100%;
            overflow: hidden;
            border-radius: 2px;
            border: 1px solid var(--jako-border);
        }

        #svg-output-target {
            width: 100%;
            height: 100%;
            transition: filter 0.3s ease;
        }

        .invert-active {
            filter: invert(1) hue-rotate(180deg);
        }

        .info-strip {
            height: 5dvh;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            color: var(--jako-text);
            font-size: 10px;
            letter-spacing: 0.25em;
            text-transform: uppercase;
            gap: 1.5rem;
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
        }

        .info-item-title {
            font-size: 7px;
            opacity: 0.5;
            letter-spacing: 0.15em;
        }

        .controls-bar {
            height: 10dvh;
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            border-top: 1px solid var(--jako-border);
            border-bottom: 1px solid var(--jako-border);
            background: var(--jako-glass);
            gap: 1.5rem;
        }

        .footer-container {
            height: 5dvh;
            width: 100%;
            background: var(--jako-glass);
            padding: 0 1.25rem; 
            border-top: 1px solid var(--jako-border);
            display: flex;
            align-items: center;
            justify-content: space-between; 
        }

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
            text-decoration: none;
        }

        .btn-control-action {
            width: 3.8rem !important;
            height: 100%;
        }
    </style>
</head>
<body>

    <div id="page-bg-overlay"></div>
        
    <header class="header-bar" style="display: flex; flex-direction: column; gap: 0.2rem;">
        <button class="btn-reset-text" title="Reset View" onclick="resetView()">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="5.5" class="icon-stroke">
                <rect x="4" y="4" width="16" height="16" />
            </svg>
            <span>FOTOPANEL</span>
        </button>
        <span style="font-size: 7px; opacity: 0.5; letter-spacing: 0.25em;">IMAGINA • ENFOCA • PROYECTA</span>
    </header>

    <main class="main-visualizer-container">
        <div id="fotopanel-pack-container">
            <div class="pack-viewport">
                <div id="svg-output-target"></div>
            </div>
        </div>
    </main>

    <div class="info-strip">
        <div class="info-strip-content">
            <div class="info-item-block">
                <span id="fotopanel-finish">PAPEL REC.</span>
                <span class="info-item-title">GRABADO LASER</span>
            </div>
            <span>/</span>
            <div class="info-item-block">
                <span id="fotopanel-media">200GRS</span>
                <span id="lbl-mdf-support" class="info-item-title">STENCIL</span>
            </div>
            <span>/</span>
            <div class="info-item-block">
                <span id="fotopanel-label">10X10 CM</span>
                <span id="lbl-grid-spec" class="info-item-title">GRID 1.0MM (100 DOTS)</span>
            </div>
            <span>/</span>
            <div class="info-item-block">
                <span id="fotopanel-price">25MIL</span>
                <span class="info-item-title">COP $</span>
            </div>
        </div>
    </div>

    <div class="controls-bar">
        <button id="btn-invert-color" title="Invert Colors" onclick="toggleImageInvert()" class="btn-control-action">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="icon-stroke">
                <circle cx="12" cy="12" r="9" />
                <path d="M12 3v18a9 9 0 0 0 0-18z" fill="currentColor" />
            </svg>
        </button>

        <button id="btn-toggle-halftone-size" title="Toggle Grid Density" onclick="toggleHalftoneSize()" class="btn-control-action">
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
    </div>

    <footer class="footer-container">
        <a href="https://github.com/jalkn" target="_blank" rel="noopener noreferrer" class="footer-brand-text">
            <span>JAKO.DEV</span>
            <span>©</span>
            <span>2026</span>
        </a>

        <button id="btn-theme-toggle" title="Cambiar Tema" onclick="toggleTheme()" class="btn-control-action">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="icon-stroke">
                <circle cx="12" cy="12" r="5" />
                <path d="M12 1v2m0 18v2M4.22 4.22l1.42 1.42m12.72 12.72l1.42 1.42M1 12h2m18 0h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42" />
            </svg>
        </button>
    </footer>

    <script>
        let isImageInverted = false;
        let isFineGrid = false; // False = 1.0mm pitch, True = 0.5mm pitch

        const cachedElements = {};
        const getCachedEl = (id) => cachedElements[id] || (cachedElements[id] = document.getElementById(id));
        const triggerHaptic = (pattern) => { if (navigator.vibrate) navigator.vibrate(pattern); };

        function initTheme() {
            const savedTheme = localStorage.getItem('fotopanel_theme') || 'light';
            document.documentElement.setAttribute('data-theme', savedTheme);
        }

        function toggleTheme() {
            const html = document.documentElement;
            const currentTheme = html.getAttribute('data-theme') || 'light';
            const nextTheme = currentTheme === 'dark' ? 'light' : 'dark';
            
            html.setAttribute('data-theme', nextTheme);
            localStorage.setItem('fotopanel_theme', nextTheme);
            triggerHaptic(10);
        }

        function toggleHalftoneSize() {
            isFineGrid = !isFineGrid;
            getCachedEl('btn-toggle-halftone-size')?.classList.toggle('active-btn', isFineGrid);
            updateFotoUI();
            triggerHaptic([10, 20]);
        }

        function toggleImageInvert() {
            isImageInverted = !isImageInverted;
            getCachedEl('btn-invert-color')?.classList.toggle('active-btn', isImageInverted);
            getCachedEl('svg-output-target')?.classList.toggle('invert-active', isImageInverted);
            triggerHaptic([10, 20]);
        }

        function resetView() {
            isImageInverted = false;
            isFineGrid = false;
            
            getCachedEl('btn-invert-color')?.classList.remove('active-btn');
            getCachedEl('btn-toggle-halftone-size')?.classList.remove('active-btn');
            getCachedEl('svg-output-target')?.classList.remove('invert-active');
            
            updateFotoUI();
            triggerHaptic([10, 10]);
        }

        function renderPanelImages() {
            const target = getCachedEl('svg-output-target');
            if (!target) return;

            const svgFile = isFineGrid ? 'fotopanel_high_res.svg' : 'fotopanel_low_res.svg';

            fetch(svgFile)
                .then(res => res.text())
                .then(svgData => target.innerHTML = svgData)
                .catch(err => console.error("SVG Loading Error:", err));
        }

        function updateFotoUI() {
            const gridSpec = getCachedEl('lbl-grid-spec');
            if (gridSpec) {
                gridSpec.textContent = isFineGrid ? 'GRID 0.5MM (200 DOTS)' : 'GRID 1.0MM (100 DOTS)';
            }
            renderPanelImages();
        }

        document.addEventListener('DOMContentLoaded', () => {
            initTheme();
            updateFotoUI();
        });
    </script>
</body>
</html>
EOF

# 2. Generate filter.py (Python Halftone Generator)
cat << 'EOF' > filter.py
#!/usr/bin/env python3
import os
from PIL import Image, ImageOps

def generate_halftone_svg(image_path, output_path, dots_per_panel, pitch_mm=1.0):
    if not os.path.exists(image_path):
        print(f"Error: Image {image_path} not found.")
        return

    # 1. Load image and convert to grayscale
    img = Image.open(image_path).convert('L')
    
    # 2. Normalize contrast to ensure full range mapping
    img = ImageOps.autocontrast(img, cutoff=1)
    
    # 3. Exact resize to dot grid using Lanczos resampling
    img = img.resize((dots_per_panel, dots_per_panel), Image.Resampling.LANCZOS)
    
    view_size = dots_per_panel * pitch_mm
    
    # Calibrated radii based on dot density
    max_radius = (pitch_mm / 2.0) * 0.88
    min_radius = pitch_mm * 0.08

    # Fixed base colors
    bg_color = "#ffffff"
    dot_color = "#000000"

    svg_lines = [
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {view_size:.2f} {view_size:.2f}" width="100%" height="100%" style="background-color: {bg_color};">',
        f'  <g fill="{dot_color}">'
    ]

    for y in range(dots_per_panel):
        for x in range(dots_per_panel):
            gray = img.getpixel((x, y))
            factor = (255.0 - gray) / 255.0
            radius = min_radius + (factor * (max_radius - min_radius))

            if radius > (pitch_mm * 0.05):
                cx = (x * pitch_mm) + (pitch_mm / 2.0)
                cy = (y * pitch_mm) + (pitch_mm / 2.0)
                svg_lines.append(f'    <circle cx="{cx:.2f}" cy="{cy:.2f}" r="{radius:.2f}" />')

    svg_lines.append('  </g>')
    svg_lines.append('</svg>')

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(svg_lines))

if __name__ == '__main__':
    img_src = 'img/photo.png'
    
    # Low Res (Grid 1.0mm - 100x100 dots)
    generate_halftone_svg(img_src, 'fotopanel_low_res.svg', dots_per_panel=100, pitch_mm=1.0)
    
    # High Res (Grid 0.5mm - 200x200 dots)
    generate_halftone_svg(img_src, 'fotopanel_high_res.svg', dots_per_panel=200, pitch_mm=0.5)
    
    print("SVGs (100 dots Low / 200 dots High) generated successfully.")
EOF

# Make set.sh and filter.py executable
chmod +x set.sh filter.py

echo "=== Files created successfully ==="
echo "Run './set.sh' to compile, then 'python3 filter.py' to generate vectors."