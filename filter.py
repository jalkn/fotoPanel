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
