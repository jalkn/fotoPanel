#!/bin/bash
set -e

# =========================================================================
# macOS Terminal Colors (Fixed ANSI escape sequences)
# =========================================================================
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}     JAKO CORE - COMPILER ENGINE         ${NC}"
echo -e "${CYAN}=========================================${NC}"

# =========================================================================
# 1. Cache Purge
# =========================================================================
echo -e "\n${MAGENTA}[1/6] Executing aseptic purge of old cache...${NC}"
CACHE_PATHS=(".astro" "dist" "node_modules/.vite")
for path in "${CACHE_PATHS[@]}"; do
    if [ -d "$path" ]; then
        echo -e "${GRAY}🧹 Removing residues from: $path${NC}"
        rm -rf "$path"
    fi
done
echo -e "${GREEN}✔ Development environment completely clean.${NC}"

# =========================================================================
# 2. Base Infrastructure Configuration
# =========================================================================
echo -e "\n${YELLOW}[2/6] Verifying base configuration files...${NC}"

# package.json
cat << 'JSON_EOF' > package.json
{
  "name": "jako-core",
  "type": "module",
  "version": "1.0.0",
  "scripts": {
    "dev": "astro dev",
    "start": "astro dev",
    "build": "astro build",
    "preview": "astro preview",
    "astro": "astro"
  },
  "dependencies": {
    "astro": "^4.11.3"
  }
}
JSON_EOF

# astro.config.mjs
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

# =========================================================================
# 3. Component Injections (PULS UI - Layout, Header & Footer)
# =========================================================================
echo -e "\n${CYAN}[3/6] Injecting core Astro layout and components...${NC}"

mkdir -p src/layouts src/components src/pages

# Base Layout
cat << 'LAYOUT_EOF' > src/layouts/Layout.astro
---
interface Props {
	title: string;
}
const { title } = Astro.props;
---
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link class="icon" type="image/png" href="img/favicon.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>{title}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Plus+Jakarta+Sans:wght@300;400;500;700&display=swap" rel="stylesheet">
    <script is:inline>
        tailwind.config = { 
            theme: { 
                extend: { 
                    screens: { 'xs': '400px' },
                    colors: { 
                        'jako-black': '#050508',
                        'jako-darkblue': '#030712'
                    },
                    fontFamily: { 
                        'sans': ['Orbitron', 'sans-serif'],
                        'mono': ['Orbitron', 'monospace'],
                        'body': ['Plus Jakarta Sans', 'sans-serif']
                    }
                }
            }
        }
    </script>
    <style is:global>
        body { 
            font-family: 'Orbitron', sans-serif !important; 
            scroll-behavior: smooth; 
            letter-spacing: 0.05em; 
            background-color: #030712 !important; 
            color: #f8fafc !important;
        } 

        #page-bg-overlay {
            position: fixed;
            inset: 0;
            background: radial-gradient(circle at 50% 30%, rgba(37, 99, 235, 0.24) 0%, rgba(15, 23, 42, 0.8) 55%, #030712 100%) !important;
            z-index: -1;
        }

        .tele-label { color: rgba(248, 250, 252, 0.4) !important; } 
        .tele-value { color: #ffffff !important; text-shadow: 0 0 14px rgba(255, 255, 255, 0.65), 0 0 4px rgba(255, 255, 255, 0.3) !important; } 
        
        .border-custom { border-color: rgba(255, 255, 255, 0.15) !important; }
        .border-custom:hover { border-color: rgba(255, 255, 255, 0.6) !important; }

        .glass { 
            background: rgba(5, 5, 8, 0.45) !important; 
            border: 1px solid rgba(255, 255, 255, 0.06) !important; 
            border-top: 1px solid rgba(255, 255, 255, 0.25) !important; 
            backdrop-filter: blur(35px) !important; 
            -webkit-backdrop-filter: blur(35px) !important;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.65), inset 0 1px 0 rgba(255, 255, 255, 0.03) !important;
        }

        .img-glow-transition {
            transition: filter 0.5s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.5s ease, transform 0.5s cubic-bezier(0.4, 0, 0.2, 1) !important;
            will-change: filter, transform;
        }

        .custom-hud-scroll::-webkit-scrollbar { display: none; }
        .custom-hud-scroll { -ms-overflow-style: none; scrollbar-width: none; }
    </style>
</head>
<body class="antialiased selection:bg-white selection:text-black overflow-x-hidden text-white">
    <div id="page-bg-overlay"></div>
    <div class="fixed inset-0 bg-gradient-to-b from-black/20 via-transparent to-black/30 z-0 pointer-events-none"></div>
    <slot />
</body>
</html>
LAYOUT_EOF
echo -e "${GREEN}✔ Component injected: src/layouts/Layout.astro${NC}"

# HeaderHud.astro
cat << 'HEADER_EOF' > src/components/HeaderHud.astro
<header class="fixed top-0 w-full z-50 glass border-b border-white/5">
    <div class="w-full flex flex-col">
        
        <div class="px-4 sm:px-8 grid grid-cols-3 items-center uppercase tracking-widest font-mono text-[11px] text-white/50 min-h-[65px] sm:min-h-[72px] select-none">
            <div class="justify-self-start flex items-center justify-center">
                <a href="https://jako.world" class="group flex items-center justify-center transition-all duration-300 focus:outline-none cursor-pointer">
                    <img src="img/back.png" alt="Back to jako.world" class="h-[13px] sm:h-[15px] w-auto object-contain opacity-65 group-hover:opacity-100 transition-all duration-500 filter drop-shadow-[0_0_8px_rgba(255,255,255,0.6)]" />
                </a>
            </div>
            
            <div class="justify-self-center text-center tracking-[0.28em] font-black drop-shadow-[0_0_12px_rgba(255,255,255,0.45)] text-white text-[13px] sm:text-[15px]">
                <span>VAULT</span>
            </div>
            
            <div class="justify-self-end flex items-center justify-center">
                <a href="https://biorush.shop" class="group flex items-center justify-center transition-all duration-300 focus:outline-none cursor-pointer">
                    <img src="img/pace.png" alt="To biorush.shop" class="h-[13px] sm:h-[15px] w-auto object-contain opacity-65 group-hover:opacity-100 transition-all duration-500 filter drop-shadow-[0_0_8px_rgba(255,255,255,0.6)]" />
                </a>
            </div>
        </div>

        <div class="w-full h-[1px] bg-gradient-to-r from-transparent via-white/10 to-transparent"></div>

        <div class="w-full flex flex-col bg-white/[0.01]">
            <div class="w-full grid grid-cols-5 items-center justify-between px-4 sm:px-8 h-12 gap-1 sm:gap-4 text-center select-none">
                
                <div id="telemetry-sphere-idx-trigger" class="flex flex-col-reverse items-start text-left cursor-pointer hover:text-white text-white/60 transition-colors">
                    <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Esfera</span>
                    <span id="telemetry-sphere-idx" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-bold text-white/90">0000</span>
                </div>

                <div id="sub-sets-solar-trigger" class="flex flex-col-reverse items-center text-center cursor-pointer hover:text-white text-white/60 transition-colors">
                    <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Hz</span>
                    <span id="sub-sets-solar" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-bold text-white drop-shadow-[0_0_8px_rgba(255,255,255,0.4)]">0.00</span>
                </div>

                <div id="z-dial-trigger" class="flex flex-col-reverse items-center text-center cursor-pointer hover:text-white text-white/60 transition-colors">
                    <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Dial</span>
                    <span id="z-dial-mirror" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-black text-white drop-shadow-[0_0_10px_rgba(255,255,255,0.5)]">0PU0</span>
                </div>

                <div id="sub-reps-tension-trigger" class="flex flex-col-reverse items-center text-center cursor-pointer hover:text-white text-white/60 transition-colors">
                    <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Tensión</span>
                    <span id="sub-reps-tension" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-bold text-white drop-shadow-[0_0_8px_rgba(255,255,255,0.4)]">0.0</span>
                </div>

                <div id="telemetry-active-node-trigger" class="flex flex-col-reverse items-end text-right cursor-pointer hover:text-white text-white/60 transition-colors">
                    <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Nodos</span>
                    <span id="telemetry-active-node" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-bold text-white/90">0000</span>
                </div>
            </div>

            <div class="w-full flex items-center justify-center px-4 h-8 bg-black/20 border-t border-white/[0.02]">
                <span id="panel-telemetry-data-secondary" class="text-[8.5px] xs:text-[9.5px] sm:text-[10px] text-center tracking-[0.25em] sm:tracking-[0.35em] text-white/70 font-medium transition-all duration-300 whitespace-normal block leading-none uppercase select-none">
                    LENGUAJE DE GOTA BIOCINÉTICA REGENERATIVA
                </span>
            </div>
        </div>
    </div>
</header>
HEADER_EOF
echo -e "${GREEN}✔ Component injected: src/components/HeaderHud.astro${NC}"

# FooterHud.astro
cat << 'FOOTER_EOF' > src/components/FooterHud.astro
<footer id="dynamic-footer" class="fixed bottom-0 left-0 w-full z-30 glass border-t border-white/5 transition-opacity duration-500 select-none bg-gradient-to-t from-black/95 via-black/80 to-transparent">
    <div class="w-full flex flex-col font-mono uppercase text-xs">

        <div class="w-full flex items-center justify-center px-4 h-8 bg-black/20">
            <span id="panel-telemetry-data" class="text-[8.5px] xs:text-[9.5px] sm:text-[10px] text-center tracking-[0.25em] sm:tracking-[0.35em] text-white/70 font-medium transition-all duration-300 whitespace-normal block leading-none uppercase select-none">
                (MODELO 1:1) COMPRAS TU PIEZA Y FINANCIAS OTRA PARA LA COMUNIDAD
            </span>
        </div>

        <div class="w-full h-[1px] bg-gradient-to-r from-transparent via-white/10 to-transparent"></div>

        <div class="w-full bg-white/[0.01]">
            <div class="w-full grid grid-cols-5 items-center justify-between px-4 sm:px-8 h-12 gap-1 sm:gap-4 text-center select-none">
                <div id="telemetry-product-media-trigger" class="flex flex-col-reverse items-start text-left cursor-pointer hover:text-white text-white/60 transition-colors">
                    <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Medio</span>
                    <span id="telemetry-product-media" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-bold text-white/90">--</span>
                </div>
                <div id="telemetry-product-dim-trigger" class="flex flex-col-reverse items-center text-center cursor-pointer hover:text-white text-white/60 transition-colors">
                    <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Dim Cms</span>
                    <span id="telemetry-product-dim" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-bold text-white drop-shadow-[0_0_8px_rgba(255,255,255,0.4)]">--</span>
                </div>
                <div id="telemetry-product-price-trigger" class="flex flex-col-reverse items-center text-center cursor-pointer hover:text-white text-white/60 transition-colors">
                    <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Precio</span>
                    <span id="telemetry-product-price" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-black text-white drop-shadow-[0_0_10px_rgba(255,255,255,0.5)]">--</span>
                </div>
                <div id="telemetry-product-rate-trigger" class="flex flex-col-reverse items-center text-center cursor-pointer hover:text-white text-white/60 transition-colors">
                    <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Rate</span>
                    <span id="telemetry-product-rate" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-bold text-white drop-shadow-[0_0_8px_rgba(255,255,255,0.4)]">--</span>
                </div>
                <div id="telemetry-product-dial-trigger" class="flex flex-col-reverse items-end text-right cursor-pointer hover:text-white text-white/60 transition-colors">
                    <span class="text-[7.5px] sm:text-[8.5px] tracking-[0.2em] text-white/30 mt-0.5 uppercase font-mono">Dials</span>
                    <span id="telemetry-product-dial" class="font-mono tracking-[0.15em] text-[10px] sm:text-[12px] font-bold text-white/90">--</span>
                </div>
            </div>
        </div>

        <div class="w-full h-[1px] bg-white/5"></div>

        <div class="w-full h-12 relative z-10">
            <div class="w-full grid grid-cols-[54px_54px_1fr_54px_54px] items-center h-full px-4 sm:px-8">
                <button id="btn-extra-left" class="h-full w-full flex items-center justify-center bg-transparent border-r border-white/5 hover:bg-white/[0.03] hover:text-white text-white/40 transition-all duration-300 focus:outline-none">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4"><path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12a7.5 7.5 0 0 1 15 0m-15 0a7.5 7.5 0 1 1 15 0m-15 0H3m16.5 0H21m-1.5 0H12m-8.457 3.077 1.41-.513m14.095-5.13 1.41-.513M5.106 17.785l1.15-.827m11.379-8.16 1.15-.827M8.14 21.27l.707-1.03m7.432-10.858.707-1.03M12 3v1.5m0 15V21m-2.83-16.543.827 1.15m10.15 14.15.827 1.15m-11.54 2.83 1.03-.707m10.858-7.432 1.03-.707M3.077 8.14l.513.707m15.13 14.095.513.707M4.175 5.106l.827 1.15m14.15 10.15.827 1.15" /></svg>
                </button>
                <button id="btn-reveal-raw" class="h-full w-full flex items-center justify-center bg-transparent border-r border-white/5 hover:bg-white/[0.03] hover:text-white text-white/40 transition-all duration-300 focus:outline-none">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m9-.75a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9 3.75h.008v.008H12v-.008Z" /></svg>
                </button>
                <button id="btn-activar-nodo" class="h-full w-full bg-transparent hover:bg-white/[0.05] hover:text-white text-white/90 font-black text-[11px] tracking-[0.35em] transition-all duration-300 focus:outline-none">
                    ACTIVAR
                </button>
                <button id="btn-reveal-bio" class="h-full w-full flex items-center justify-center bg-transparent border-l border-white/5 hover:bg-white/[0.03] hover:text-white text-white/40 transition-all duration-300 focus:outline-none">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4"><path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 0 1 0-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178Z" /><path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" /></svg>
                </button>
                <button id="btn-extra-right" class="h-full w-full flex items-center justify-center bg-transparent border-l border-white/5 hover:bg-white/[0.03] hover:text-white text-white/40 transition-all duration-300 focus:outline-none">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4"><path stroke-linecap="round" stroke-linejoin="round" d="M9.594 3.94c.09-.542.56-.94 1.11-.94h2.593c.55 0 1.02.398 1.11.94l.213 1.281c.063.374.313.686.645.87.074.04.147.083.22.127.324.196.72.257 1.075.124l1.217-.456a1.125 1.125 0 0 1 1.37.49l1.296 2.247a1.125 1.125 0 0 1-.26 1.43l-1.003.767a1.123 1.123 0 0 0-.417 1.03c.004.074.006.148.006.222 0 .074-.002.148-.006.222a1.123 1.123 0 0 0 .417 1.03l1.003.767a1.125 1.125 0 0 1 .26 1.43l-1.296 2.247a1.125 1.125 0 0 1-1.37.49l-1.216-.456a1.125 1.125 0 0 0-1.075.124c-.073.044-.146.087-.22.128-.332.183-.582.495-.645.869l-.213 1.281c-.09.543-.56.94-1.11.94h-2.594c-.55 0-1.019-.398-1.11-.94l-.213-1.281a1.125 1.125 0 0 0-.646-.869c-.074-.041-.147-.084-.22-.129a1.125 1.125 0 0 0-1.075-.124l-1.216.456a1.125 1.125 0 0 1-1.37-.49l-1.296-2.247a1.125 1.125 0 0 1 .26-1.43l1.003-.767c.318-.243.483-.646.417-1.03a1.121 1.121 0 0 0-.006-.222c0-.074.002-.148.006-.222a1.122 1.122 0 0 0-.417-1.03l-1.003-.767a1.125 1.125 0 0 1-.26-1.43l1.296-2.247a1.125 1.125 0 0 1 1.37-.49l1.216.456c.356.133.751.072 1.076-.124.072-.044.146-.087.22-.128.332-.183.582-.495.646-.869L9.593 3.94Z" /><path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" /></svg>
                </button>
            </div>
        </div>

        <div class="w-full h-[1px] bg-white/5"></div>

        <div class="w-full h-12 relative z-10 bg-black/20 p-1">
            <div class="w-full grid grid-cols-[1fr_1fr] gap-3 h-full px-4 sm:px-8">
                <div class="grid grid-cols-[32px_1fr_32px] gap-1 h-full w-full items-center">
                    <button id="btn-stencil-prev" class="h-full flex items-center justify-center text-white/20 hover:text-white/50 hover:bg-white/[0.02] rounded-l-lg transition-all focus:outline-none"><span class="text-[9px] font-bold">&lt;</span></button>
                    <div id="menu-bio-STENCIL-holder" class="h-full w-full flex items-center justify-center select-none"></div>
                    <button id="btn-stencil-next" class="h-full flex items-center justify-center text-white/20 hover:text-white/50 hover:bg-white/[0.02] rounded-r-lg transition-all focus:outline-none"><span class="text-[9px] font-bold">&gt;</span></button>
                </div>
                <div class="grid grid-cols-[32px_1fr_32px] gap-1 h-full w-full items-center">
                    <button id="btn-panel-prev" class="h-full flex items-center justify-center text-white/20 hover:text-white/50 hover:bg-white/[0.02] rounded-l-lg transition-all focus:outline-none"><span class="text-[9px] font-bold">&lt;</span></button>
                    <div id="menu-bio-PANEL-holder" class="h-full w-full flex items-center justify-center select-none"></div>
                    <button id="btn-panel-next" class="h-full flex items-center justify-center text-white/20 hover:text-white/50 hover:bg-white/[0.02] rounded-r-lg transition-all focus:outline-none"><span class="text-[9px] font-bold">&gt;</span></button>
                </div>
            </div>
        </div>

        <div class="w-full h-[1px] bg-white/5"></div>

        <div class="w-full h-11 relative z-10">
            <div class="w-full grid grid-cols-[54px_1fr_54px] items-center h-full px-4 sm:px-8 text-[8px] tracking-[0.4em]">
                <div class="h-full w-full flex items-center justify-start border-r border-white/5">
                    <a href="https://jako.world" class="group w-full h-full flex items-center justify-start hover:bg-white/[0.02] transition-all duration-300 focus:outline-none cursor-pointer">
                        <img src="img/back.png" alt="Back to jako.world" class="w-3.5 h-3.5 object-contain opacity-30 group-hover:opacity-80 transition-all duration-500" />
                    </a>
                </div>    
                <div class="h-full w-full flex items-center justify-center text-center font-bold text-white/20">
                    <a href="https://jako.world" class="h-full w-full flex items-center justify-center hover:text-white/60 hover:bg-white/[0.005] transition-all duration-300 focus:outline-none">POWERED BY JAKO.WORLD</a>
                </div>
                <div class="h-full w-full flex items-center justify-end border-l border-white/5">
                    <a href="https://biorush.shop" class="group w-full h-full flex items-center justify-end hover:bg-white/[0.02] transition-all duration-300 focus:outline-none cursor-pointer">
                        <img src="img/pace.png" alt="To biorush.shop" class="w-3.5 h-3.5 object-contain opacity-30 group-hover:opacity-80 transition-all duration-500" />
                    </a>
                </div>
            </div>
        </div>

    </div>
</footer>
FOOTER_EOF
echo -e "${GREEN}✔ Component injected: src/components/FooterHud.astro${NC}"

# index.astro
cat << 'INDEX_EOF' > src/pages/index.astro
---
import Layout from '../layouts/Layout.astro';
import HeaderHud from '../components/HeaderHud.astro';
import FooterHud from '../components/FooterHud.astro';
---
<Layout title="JAKO VAULT">
    <HeaderHud />
    
    <main id="main-vault" class="w-screen h-screen flex flex-col relative overflow-hidden">
        <div class="flex-1 w-full flex flex-col items-center justify-between p-4 sm:p-6 select-none relative z-10 overflow-hidden min-h-screen pt-[160px]">
            
            <div id="artepanel-pack-container" class="my-auto relative w-[68vw] h-[68vw] sm:w-[58vw] sm:h-[58vw] md:w-[35vh] md:h-[35vh] max-w-[350px] max-h-[350px] min-w-[210px] min-h-[210px] aspect-square shrink-0 drop-shadow-[0_25px_55px_rgba(0,0,0,0.95)] transition-all duration-300">
                <div class="w-full h-full relative overflow-hidden rounded-md bg-transparent">
                    
                    <img id="artepanel-pack-img-back" src="img/40x40W.png" alt="artepanel Pack Back" class="img-glow-transition absolute inset-0 w-full h-full object-cover opacity-0 pointer-events-none z-0" />
                    <img id="artepanel-pack-img" src="img/40x40B.png" alt="artepanel Pack Front" class="img-glow-transition absolute inset-0 w-full h-full object-cover pointer-events-auto z-10" />
                    <img id="artepanel-pack-img-raw" src="img/20x20B.png" alt="Raw Content" class="img-glow-transition absolute inset-0 w-full h-full object-cover opacity-0 pointer-events-none z-[5]" />
                    
                    <div class="absolute inset-0 flex items-center justify-center p-0 z-20 pointer-events-none">
                        <svg id="laser-vector-target" viewBox="0 0 400 400" class="w-full h-full fill-none stroke-white/25 stroke-[1.2] transition-all duration-500 origin-center">
                            <defs>
                                <path id="textPath-top" d="M 65,200 A 135,135 0 0,1 335,200" />
                                <path id="textPath-bottom" d="M 65,200 A 135,135 0 0,0 335,200" />
                            </defs>
                            <g class="origin-center">
                                <path d="M 90,90 L 310,90 L 90,310 L 310,310 Z" class="opacity-15 stroke-[1]" />
                                <path d="M 90,90 Q 200,125 310,90" class="opacity-15 stroke-[1]" />
                                <path d="M 90,310 Q 200,275 310,310" stroke-dasharray="3 3" class="opacity-15 stroke-[1]" />
                                <text id="z-dial" x="200" y="218" text-anchor="middle" class="fill-white font-black text-[45px] tracking-[0.35em] font-sans">8PU10</text>
                            </g>
                            <g style="display: none;">
                                <text class="fill-white font-black text-[10px] tracking-[0.25em] uppercase transition-all duration-500">
                                    <textPath id="laser-variant-title" href="#textPath-top" startOffset="50%" text-anchor="middle">MACROPULSOR FOCUS</textPath>
                                </text>
                                <text class="fill-white/60 font-black text-[10px] tracking-[0.25em] uppercase transition-all duration-500">
                                    <textPath id="artepanel-description" href="#textPath-bottom" startOffset="50%" text-anchor="middle">Enfoque y claridad cognitiva</textPath>
                                </text>
                            </g>
                        </svg>
                    </div>
                </div>
            </div>

        </div>
    </main>

    <FooterHud />

<script is:inline>
    const ARTEPANEL_CATALOG = {
        'STENCIL': {
            defaultVariant: '25X25',
            variants: {
                '25X25': { 
                    label: 'STENCIL25X25', 
                    desc: 'Stencil para murales participativos en interiores y exteriores.', 
                    spec: '(MODELO 1:1) ADQUIERES TU PIEZA Y FINANCIAS OTRA PARA LA COMUNIDAD', 
                    price: '$12USD', 
                    id: 'ST-25X25',
                    img: 'img/surface.png', imgBack: 'img/20x20B.png', imgRaw: 'img/stencil25B.png',
                    telemetry: { DIM: '25x25', MEDIA: 'STENCIL', DIAL: '⧗240', RATE: '$0.05USD' }
                },
                '40X40': { 
                    label: 'MICROSTENCIL FOCUS', 
                    desc: 'Stencil para murales participativos en interiores y exteriores.', 
                    spec: '(MODELO 1:1) ADQUIERES TU PIEZA Y FINANCIAS OTRA PARA LA COMUNIDAD', 
                    price: '$29USD', 
                    id: 'ST-MICRO',
                    img: 'img/surface.png', imgBack: 'img/20x20B.png', imgRaw: 'img/microB.png',
                    telemetry: { DIM: '40x40', MEDIA: 'STENCIL', DIAL: '⧗240', RATE: '$0.05USD' }
                },
                '80X80': { 
                    label: 'MACROSTENCIL SURGE', 
                    desc: 'Stencil para murales participativos en interiores y exteriores.', 
                    spec: '(MODELO 1:1) ADQUIERES TU PIEZA Y FINANCIAS OTRA PARA LA COMUNIDAD', 
                    price: '$125USD', 
                    id: 'ST-MACRO',
                    img: 'img/surface.png', imgBack: 'img/20x20B.png', imgRaw: 'img/macroB.png',
                    telemetry: { DIM: '80x80', MEDIA: 'STENCIL', DIAL: '⧗2500', RATE: '$0.05USD' }
                }
            }
        },
        'PANEL': {
            defaultVariant: '20X20',
            variants: {
                '20X20': { 
                    label: 'PANEL20X20', 
                    desc: 'INKJET ADH sobre MDF para montajes individuales o mosaicos.', 
                    spec: '(MODELO 1:1) ADQUIERES TU PIEZA Y FINANCIAS OTRA PARA LA COMUNIDAD', 
                    price: '$12USD', 
                    id: 'FP-20X20',
                    img: 'img/surface.png', imgBack: 'img/20x20B.png', imgRaw: 'img/panel20B.png',
                    telemetry: { DIM: '20x20', MEDIA: 'MDF', DIAL: '⧗240', RATE: '$0.05USD' }
                },
                '30X30': { 
                    label: 'PANEL30X30', 
                    desc: 'INKJET ADH sobre MDF para montajes individuales o mosaicos.', 
                    spec: '(MODELO 1:1) ADQUIERES TU PIEZA Y FINANCIAS OTRA PARA LA COMUNIDAD', 
                    price: '$29USD', 
                    id: 'FP-30X30',
                    img: 'img/surface.png', imgBack: 'img/panel30W.png', imgRaw: 'img/panel30B.png',
                    telemetry: { DIM: '30x30', MEDIA: 'MDF', DIAL: '⧗576', RATE: '$0.05USD' }
                },
                '40X40': { 
                    label: 'PANEL40X40', 
                    desc: 'INKJET ADH sobre MDF para montajes individuales o mosaicos.', 
                    spec: '(MODELO 1:1) ADQUIERES TU PIEZA Y FINANCIAS OTRA PARA LA COMUNIDAD', 
                    price: '$55USD', 
                    id: 'FP-40X40',
                    img: 'img/surface.png', imgBack: 'img/panel40W.png', imgRaw: 'img/panel40B.png',
                    telemetry: { DIM: '40x40', MEDIA: 'MDF', DIAL: '⧗1100', RATE: '$0.05USD' }
                }
            }
        }
    };
    
    let currentBioItem = 'STENCIL';
    let currentBioVariant = '40X40';
    const numeroCelular = "573025333130";
    let isDialFrozen = false;

    const $ = (id) => document.getElementById(id);
    const cachedElements = {};
    function getCachedEl(id) {
        if (!cachedElements[id]) cachedElements[id] = $(id);
        return cachedElements[id];
    }

    const triggerHaptic = (ms) => { if (navigator.vibrate) navigator.vibrate(ms); };

    function aplicarModoVisual(modo) {
        const front = getCachedEl('artepanel-pack-img');
        const back = getCachedEl('artepanel-pack-img-back');
        const raw = getCachedEl('artepanel-pack-img-raw');
        const svg = getCachedEl('laser-vector-target');

        [front, back, raw].forEach(el => { if(el) el.style.opacity = '0'; });
        
        if (modo === 'front') {
            front.style.opacity = '1'; front.style.zIndex = '10'; back.style.zIndex = '0';
            if (svg) { svg.style.opacity = '1'; svg.style.pointerEvents = 'auto'; }
        } else if (modo === 'back') {
            back.style.opacity = '1'; back.style.zIndex = '10'; front.style.zIndex = '0';
            if (svg) { svg.style.opacity = '0'; svg.style.pointerEvents = 'none'; }
        } else if (modo === 'raw') {
            raw.style.opacity = '1';
            if (svg) { svg.style.opacity = '0'; svg.style.pointerEvents = 'none'; }
        }
    }

    function vincularBotones() {
        const btnBio = getCachedEl('btn-reveal-bio');
        const btnRaw = getCachedEl('btn-reveal-raw');
        const btnActivar = getCachedEl('btn-activar-nodo');
        
        let modoActual = 'front';
        const alternarModo = (modo, haptic) => {
            if (modoActual === modo) { aplicarModoVisual('front'); modoActual = 'front'; } 
            else { aplicarModoVisual(modo); modoActual = modo; triggerHaptic(haptic); }
        };

        if (btnBio) btnBio.addEventListener('click', () => alternarModo('back', 12));
        if (btnRaw) btnRaw.addEventListener('click', () => alternarModo('raw', 10));
        if (btnActivar) btnActivar.addEventListener('click', () => adquirirNodo());

        const setupCiclosNav = (prevId, nextId, tipo) => {
            getCachedEl(prevId)?.addEventListener('click', () => ciclarVariante(tipo, -1));
            getCachedEl(nextId)?.addEventListener('click', () => ciclarVariante(tipo, 1));
        };
        setupCiclosNav('btn-stencil-prev', 'btn-stencil-next', 'STENCIL');
        setupCiclosNav('btn-panel-prev', 'btn-panel-next', 'PANEL');
    }

    function inicializarArtepanel() {
        const stencilHolder = getCachedEl('menu-bio-STENCIL-holder');
        const panelHolder = getCachedEl('menu-bio-PANEL-holder');
        
        if (stencilHolder) {
            stencilHolder.innerHTML = `<span id="menu-bio-STENCIL" class="cursor-pointer tracking-[0.15em] transition-all duration-300 h-full w-full flex items-center justify-center font-bold">STENCIL</span>`;
            getCachedEl('menu-bio-STENCIL').addEventListener('click', () => cambiarBioItem('STENCIL'));
        }
        if (panelHolder) {
            panelHolder.innerHTML = `<span id="menu-bio-PANEL" class="cursor-pointer tracking-[0.15em] transition-all duration-300 h-full w-full flex items-center justify-center font-bold">PANEL</span>`;
            getCachedEl('menu-bio-PANEL').addEventListener('click', () => cambiarBioItem('PANEL'));
        }
        
        vincularBotones();
        actualizarBioUI();
    }

    function cambiarBioItem(itemKey) {
        currentBioItem = itemKey;
        currentBioVariant = ARTEPANEL_CATALOG[itemKey].defaultVariant;
        actualizarBioUI();
        triggerHaptic(15);
    }

    function ciclarVariante(tipo, direccion) {
        if (currentBioItem !== tipo) {
            currentBioItem = tipo;
            currentBioVariant = ARTEPANEL_CATALOG[tipo].defaultVariant;
        }
        const variantes = Object.keys(ARTEPANEL_CATALOG[tipo].variants);
        let currentIndex = variantes.indexOf(currentBioVariant);
        if (currentIndex === -1) currentIndex = 0;

        let nextIndex = (currentIndex + direccion) % variantes.length;
        if (nextIndex < 0) nextIndex = variantes.length - 1;

        currentBioVariant = variantes[nextIndex];
        actualizarBioUI();
        triggerHaptic(12);
    }

    function calculateSphereIndex() {
        const now = new Date();
        const epoch = new Date('2012-12-21T00:00:00Z');
        const daysSinceEpoch = Math.floor((now - epoch) / 86400000);
        const sphereQuadrant = Math.floor(now.getHours() / 6);
        return `${String((daysSinceEpoch * 4) + sphereQuadrant).padStart(4, '0')}`;
    }

    function updateZ() {
        const now = new Date();
        const minutes = now.getMinutes();
        const seconds = now.getSeconds();

        const currentSphereIdx = calculateSphereIndex();
        const elIdx = getCachedEl('telemetry-sphere-idx');
        if (elIdx && elIdx.textContent !== currentSphereIdx) elIdx.textContent = currentSphereIdx;

        if (!isDialFrozen) {
            let setsStage = 1; let repsStage = 1; let currentAction = 'P'; 

            if (seconds % 2 !== 0) {
                const progress1s = now.getMilliseconds() / 1000; 
                setsStage = Math.floor(progress1s * 12) + 1; repsStage = 13 - setsStage; 
                if (progress1s < 0.25) currentAction = 'P'; else if (progress1s < 0.5) currentAction = 'U'; else if (progress1s < 0.75) currentAction = 'L'; else currentAction = 'S';
            } else {
                setsStage = Math.floor((minutes % 12) + 1);
                if (seconds < 30) {
                    currentAction = ["PL", "PU", "LU", "SU"][Math.floor((seconds % 30) / 7.5)] || "PL";
                    repsStage = Math.floor((seconds % 10) + 2);
                } else {
                    currentAction = ["PUL", "LPS", "SPU", "ULS"][Math.floor(((seconds - 30) % 30) / 7.5)] || "ULS";
                    repsStage = Math.floor(((seconds - 30) % 10) + 3);
                }
            }
            
            setsStage = Math.max(1, Math.min(12, setsStage)); repsStage = Math.max(1, Math.min(12, repsStage));
            const biokineticCoordinate = `${setsStage}${currentAction}${repsStage}`;

            const elDial = getCachedEl('z-dial'); if (elDial) elDial.textContent = biokineticCoordinate;
            const subSetsSolar = getCachedEl('sub-sets-solar'); if (subSetsSolar) subSetsSolar.textContent = `${(0.05 + (setsStage / 240)).toFixed(3)}`;
            const subRepsTension = getCachedEl('sub-reps-tension'); if (subRepsTension) subRepsTension.textContent = `${(14.2 + (repsStage * 0.8)).toFixed(1)}`;
            const elDialMirror = getCachedEl('z-dial-mirror'); if (elDialMirror) elDialMirror.textContent = biokineticCoordinate;
        }
                
        const elActiveNode = getCachedEl('telemetry-active-node');
        if (elActiveNode) elActiveNode.textContent = `${String((now.getHours() * 3600) + (minutes * 60) + seconds + 1).padStart(4, '0')}`;
    }

    const TELEMETRY_MEANINGS = {
        'telemetry-product-media': "Sustrato industrial. Medio físico de transferencia.", 
        'telemetry-product-dim': "Área geométrica del soporte material.", 
        'telemetry-product-dial': "Gotas biocinéticas. Densidad de vectores.", 
        'telemetry-product-rate': "Valor base por dial activo.", 
        'telemetry-product-price': "Compras tu pieza y financias otra para la comunidad" 
    };
    
    const PULS_MEANINGS = {
        'sub-sets-solar-trigger': "FRECUENCIA COAXIAL VIVA TIERRA-LUNA-SOL.", 
        'sub-reps-tension-trigger': "COHESIÓN TENSIONAL Y MAGNETISMO GRAVITACIONAL.", 
        'z-dial-trigger': () => {
            const coord = getCachedEl('z-dial-mirror')?.textContent || "1P1";
            const match = coord.match(/^(\d+)([A-Z]+)(\d+)$/); if (!match) return "MATRIZ BIOCINÉTICA ACTIVA.";
            const [_, sets, action, reps] = match; let vectorText = "";
            switch (action) {
                case 'P': vectorText = `PASOS X${sets}`; break; case 'S': vectorText = `SALTOS X${sets}`; break; case 'U': vectorText = `PRESIONES X${sets}`; break; case 'L': vectorText = `CARGAS X${sets}`; break;
                case 'PL': vectorText = `PASOS CON CARGA X${sets}`; break; case 'PU': vectorText = `PASOS CON PRESIÓN X${sets}`; break; case 'LU': vectorText = `CARGAS CON PRESIÓN X${sets}`; break; case 'SU': vectorText = `SALTOS CON PRESIÓN X${sets}`; break;
                case 'PUL': vectorText = `PASOS CON PRESIÓN Y CARGA X${sets}`; break; case 'LPS': vectorText = `CARGAS CON PASO Y SALTO X${sets}`; break; case 'SPU': vectorText = `SALTOS CON PASO Y PRESIÓN X${sets}`; break; case 'ULS': vectorText = `PRESIONES CON CARGA Y SALTO X${sets}`; break;
                default: vectorText = "GOTA BIOCINÉTICA REGENERATIVA";
            }
            return `${reps} ${vectorText}`;
        }, 
        'telemetry-sphere-idx-trigger': "MATRIZ CUÁNTICA. CICLO DE ESFERA.", 
        'telemetry-active-node-trigger': "SATURACIÓN SINÁPTICA. NODOS ACUMULADOS REALES." 
    };

    function actualizarBioUI() {
        const itemConfig = ARTEPANEL_CATALOG[currentBioItem];
        const variantConfig = itemConfig.variants[currentBioVariant];
        
        const descEl = getCachedEl('artepanel-description');
        const packImg = getCachedEl('artepanel-pack-img');
        const packImgBack = getCachedEl('artepanel-pack-img-back');
        
        if (descEl && packImg && packImgBack) {
            descEl.classList.add('opacity-0');
            setTimeout(() => {
                descEl.textContent = variantConfig.desc;
                packImg.src = variantConfig.img;
                packImgBack.src = variantConfig.imgBack;
                getCachedEl('artepanel-pack-img-raw').src = variantConfig.imgRaw;
                const labelTitle = getCachedEl('laser-variant-title'); if (labelTitle) labelTitle.textContent = variantConfig.label;
                descEl.classList.remove('opacity-0');
            }, 120);
        }

        ['media', 'dim', 'price', 'rate', 'dial'].forEach(key => {
            const el = getCachedEl(`telemetry-product-${key}`);
            if (el) el.textContent = key === 'price' ? variantConfig.price : variantConfig.telemetry[key.toUpperCase()];
        });

        const textFluidClass = "text-[8px] xs:text-[9.5px] sm:text-[11px] tracking-[0.2em] sm:tracking-[0.35em] uppercase font-sans transition-all duration-300";
        Object.keys(ARTEPANEL_CATALOG).forEach(item => {
            const el = getCachedEl(`menu-bio-${item}`);
            if (el) {
                el.className = (item === currentBioItem)
                    ? `cursor-pointer font-black h-full w-full flex items-center justify-center text-white bg-white/[0.07] rounded-lg border border-white/20 shadow-[inset_0_1px_3px_rgba(255,255,255,0.25),_0_2px_8px_rgba(255,255,255,0.05)] ${textFluidClass}` 
                    : `cursor-pointer font-medium h-full w-full flex items-center justify-center text-white/20 bg-transparent rounded-lg hover:text-white/50 hover:bg-white/[0.02] ${textFluidClass}`;
            }
        });
    }

    function habilitarReveladoTelemetria() {
        const telemetryData = getCachedEl('panel-telemetry-data');
        const txtOriginal = "(MODELO 1:1) COMPRAS TU PIEZA Y FINANCIAS OTRA PARA LA COMUNIDAD";
        let timerComercial = null;

        Object.keys(TELEMETRY_MEANINGS).forEach(id => {
            const el = getCachedEl(id); if (!el || !telemetryData) return;
            el.addEventListener('click', () => {
                clearTimeout(timerComercial);
                el.parentElement.classList.remove('text-white/50'); el.parentElement.classList.add('text-white');
                telemetryData.innerHTML = TELEMETRY_MEANINGS[id];
                timerComercial = setTimeout(() => {
                    telemetryData.innerHTML = txtOriginal; el.parentElement.classList.remove('text-white'); el.parentElement.classList.add('text-white/50');
                }, 8000);
            });
        });

        const telemetryDataSecondary = getCachedEl('panel-telemetry-data-secondary');
        const txtOriginalSecondary = "LENGUAJE BIOCINÉTICO P.U.L.S.";
        let timerQuantum = null;

        Object.keys(PULS_MEANINGS).forEach(id => {
            const el = getCachedEl(id); if (!el || !telemetryDataSecondary) return;
            const esHeaderPuro = id.startsWith('sub-');
            const contenedorLed = esHeaderPuro ? el.parentElement : el;

            el.addEventListener('click', () => {
                clearTimeout(timerQuantum);
                if (id === 'z-dial-trigger') isDialFrozen = true;

                if (esHeaderPuro) contenedorLed.classList.replace('text-white/60', 'text-white');
                else if (id === 'z-dial-trigger') el.style.filter = "drop-shadow(0 0 25px rgba(255,255,255,0.95))";
                else {
                    contenedorLed.classList.replace('text-white/40', 'text-white');
                    contenedorLed.querySelector('span:last-child').classList.replace('text-white', 'text-white/60');
                }
                
                const meaningValue = PULS_MEANINGS[id];
                telemetryDataSecondary.innerHTML = typeof meaningValue === 'function' ? meaningValue() : meaningValue;
                
                timerQuantum = setTimeout(() => {
                    telemetryDataSecondary.innerHTML = txtOriginalSecondary;
                    if (id === 'z-dial-trigger') { isDialFrozen = false; el.style.filter = "none"; }
                    if (esHeaderPuro) contenedorLed.classList.replace('text-white', 'text-white/60');
                    else if (id !== 'z-dial-trigger') {
                        contenedorLed.classList.replace('text-white', 'text-white/40');
                        contenedorLed.querySelector('span:last-child').classList.replace('text-white', 'text-white/60');
                    }
                }, 8000);
            });
        });
    }

    function adquirirNodo() {
        const variantConfig = ARTEPANEL_CATALOG[currentBioItem].variants[currentBioVariant];
        const currentCoord = getCachedEl('z-dial')?.textContent || "N/A";
        const currentSphere = getCachedEl('telemetry-sphere-idx')?.textContent || "N/A";
        const currentNode = getCachedEl('telemetry-active-node')?.textContent || "N/A";
        const freqValue = getCachedEl('sub-sets-solar')?.textContent || "0.00";
        const tensionValue = getCachedEl('sub-reps-tension')?.textContent || "0.0";
        const dialInterpretation = currentCoord.replace(/(\d+)([A-Z]+)(\d+)/, "$1 FASES, $3 NODOS - ESTADO $2");
        
        const mensaje = `⚡ *ORDEN - ARTEPANEL* ⚡\n\n` +
                        `• *Vector:* ${currentBioItem} ${currentBioVariant}\n` +
                        `• *Carga:* ${variantConfig.spec}\n` +
                        `• *ID:* \`${variantConfig.id}\`\n` +
                        `• *Precio:* ${variantConfig.price}\n\n` +
                        `--- *LENGUAJE P.U.L.S.* ---\n` +
                        `• *Matriz de Configuración:* \`${currentCoord}\`\n` +
                        `• *Análisis de Estado:* ${dialInterpretation}\n` +
                        `• *Lote:* \`${currentSphere}\`\n` +
                        `• *Saturación:* \`${currentNode}\`\n` +
                        `• *Resonancia:* \`${freqValue}\`\n` +
                        `• *Cohesión:* \`${tensionValue}\`\n\n` +
                        `Activar configuración actual.`;

        triggerHaptic([15, 40, 15]);
        window.open(`https://api.whatsapp.com/send?phone=${numeroCelular}&text=${encodeURIComponent(mensaje)}`, '_blank');
    }

    document.addEventListener('DOMContentLoaded', () => {
        inicializarArtepanel();
        updateZ(); setInterval(updateZ, 1000);
        habilitarReveladoTelemetria();

        const laserSvg = getCachedEl('laser-vector-target');
        if (laserSvg) laserSvg.style.pointerEvents = 'none'; 

        const zDialSvgText = getCachedEl('z-dial');
        if (zDialSvgText) {
            zDialSvgText.style.cursor = 'pointer'; zDialSvgText.style.pointerEvents = 'auto'; 
            zDialSvgText.addEventListener('click', (e) => { e.stopPropagation(); getCachedEl('z-dial-trigger')?.click(); });
        }
    });
</script>
</body>
</html>
INDEX_EOF
echo -e "${GREEN}✔ Component injected: src/pages/index.astro${NC}"

# =========================================================================
# 4. Environment Verification & Compilation
# =========================================================================
echo -e "\n${YELLOW}[4/6] Verifying local execution environment...${NC}"

if [ ! -d "node_modules/astro" ]; then
    echo -e "${MAGENTA}⚠️ Modules not found. Downloading Node dependencies...${NC}"
    npm install
else
    echo -e "${GREEN}✔ Local modules environment stable.${NC}"
fi

echo -e "${CYAN}🔄 Synchronizing Astro dynamic TypeScript maps...${NC}"
npx astro sync

echo -e "\n${CYAN}[5/6] Compiling Quantum Clock for Production Build...${NC}"
npx astro build

# =========================================================================
# 5. Production Live Cloud Deployment
# =========================================================================
echo -e "\n${MAGENTA}🚀 Synchronizing clean assets directly to Google Cloud Storage...${NC}"
gsutil -m rsync -R dist gs://jako-vault-core

echo -e "\n${GREEN}========================================================${NC}"
echo -e "${GREEN}✔ SYSTEM LIVE ON PRODUCTION CLOUD ARCHITECTURE${NC}"
echo -e "${GREEN}🔗 Link: https://storage.googleapis.com/jako-vault-core/index.html${NC}"
echo -e "${GREEN}========================================================${NC}"

# =========================================================================
# 6. Local Target Execution (Preview Build)
# =========================================================================
echo -e "\n${CYAN}[6/6] Launching local Localhost engine...${NC}"
npx astro preview --port 3000 --open