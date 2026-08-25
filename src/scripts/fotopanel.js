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
