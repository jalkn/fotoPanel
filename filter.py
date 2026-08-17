from PIL import Image
import math

def generate_halftone_svg(image_path, output_svg_path, grid_size=40, max_radius=4.0, min_radius=0.5):
    """
    Genera un SVG vectorial de entramado de puntos (Halftone / FotoPanel)
    a partir de una imagen de entrada.
    
    :param image_path: Ruta a la imagen fuente.
    :param output_svg_path: Ruta donde se guardará el SVG.
    :param grid_size: Número de puntos en el eje X/Y (resolución de la grilla).
    :param max_radius: Radio máximo del círculo (áreas oscuras).
    :param min_radius: Radio mínimo del círculo (áreas claras/perforación mínima).
    """
    # Cargar imagen y convertir a escala de grises
    img = Image.open(image_path).convert('L')
    
    # Redimensionar al tamaño de la grilla
    img_resized = img.resize((grid_size, grid_size), Image.Resampling.LANCZOS)
    
    # Definir dimensiones del ViewBox del SVG
    cell_size = 10  # Tamaño de cada celda en unidades de SVG
    width = grid_size * cell_size
    height = grid_size * cell_size

    svg_elements = [
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {width} {height}" width="{width}" height="{height}">',
        f'  <rect width="100%" height="100%" fill="#ffffff" />',  # Fondo base
        '  <g fill="#000000">'
    ]

    for y in range(grid_size):
        for x in range(grid_size):
            # Obtener luminosidad (0 = negro, 255 = blanco)
            pixel = img_resized.getpixel((x, y))
            
            # Invertir para que las zonas oscuras tengan puntos más grandes
            darkness = (255 - pixel) / 255.0
            
            # Calcular el radio proporcional
            radius = min_radius + (darkness * (max_radius - min_radius))
            
            if radius > 0.1:
                cx = (x * cell_size) + (cell_size / 2)
                cy = (y * cell_size) + (cell_size / 2)
                svg_elements.append(f'    <circle cx="{cx:.2f}" cy="{cy:.2f}" r="{radius:.2f}" />')

    svg_elements.append('  </g>')
    svg_elements.append('</svg>')

    with open(output_svg_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(svg_elements))

# Generar ambas resoluciones
generate_halftone_svg("input.jpg", "fotopanel_low_res.svg", grid_size=30, max_radius=4.5)
generate_halftone_svg("input.jpg", "fotopanel_high_res.svg", grid_size=60, max_radius=2.2)