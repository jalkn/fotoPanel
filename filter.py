#!/usr/bin/env python3
#!/usr/bin/env python3
import os
from PIL import Image, ImageOps

def generate_halftone_svg(image_path, output_path, dots_per_panel, pitch_mm=1.0, is_inverted=False):
    if not os.path.exists(image_path):
        print(f"Error: No se encontró la imagen {image_path}")
        return

    # 1. Cargar imagen y convertir a escala de grises
    img = Image.open(image_path).convert('L')
    
    # 2. Normalizar contraste para asegurar rango completo
    img = ImageOps.autocontrast(img, cutoff=1)
    
    # 3. Redimensionar exacto al grid de puntos usando Lanczos
    img = img.resize((dots_per_panel, dots_per_panel), Image.Resampling.LANCZOS)
    
    view_size = dots_per_panel * pitch_mm
    
    # Radios calibrados según la densidad del punto
    max_radius = (pitch_mm / 2.0) * 0.88
    min_radius = pitch_mm * 0.08

    bg_color = "#000000" if is_inverted else "#121212"
    dot_color = "#ffffff" if is_inverted else "#ffffff"

    svg_lines = [
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {view_size:.2f} {view_size:.2f}" width="100%" height="100%" style="background-color: {bg_color};">',
        f'  <g fill="{dot_color}">'
    ]

    for y in range(dots_per_panel):
        for x in range(dots_per_panel):
            gray = img.getpixel((x, y))
            factor = (gray / 255.0) if is_inverted else ((255.0 - gray) / 255.0)
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
    
    # High Res Duplicado (Grid 0.5mm - 200x200 dots)
    generate_halftone_svg(img_src, 'fotopanel_high_res.svg', dots_per_panel=200, pitch_mm=0.5)
    
    print(f"SVGs (100 dots Low / 200 dots High) generados correctamente.")
