const puppeteer = require('puppeteer');
const path = require('path');
const fs = require('fs');

(async () => {
    // Ensure output directory exists
    const outputDir = path.join(__dirname, 'output');
    if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir);
    }

    // Launch headless Chromium browser
    const browser = await puppeteer.launch({
        headless: 'new',
        args: ['--no-sandbox', '--disable-setuid-sandbox']
    });

    const page = await browser.newPage();
    // High DPI 1:1 Viewport setting
    await page.setViewport({ width: 1080, height: 1080, deviceScaleFactor: 2 });

    const indexPath = `file://${path.join(__dirname, 'index.html')}`;
    await page.goto(indexPath, { waitUntil: 'networkidle0' });

    // Capture standard initial full-color frame
    await page.screenshot({ path: path.join(outputDir, 'studio_40x40_color.png') });

    // Click color mode toggle to render B&W frame
    await page.click('#btn-color-toggle');
    await page.screenshot({ path: path.join(outputDir, 'studio_40x40_bw.png') });

    // Click variant scale toggle for next dimension frame
    await page.click('#btn-change-scale');
    await page.screenshot({ path: path.join(outputDir, 'studio_variant_next.png') });

    await browser.close();
    console.log('Studio Mode captures saved to /output.');
})();
