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
    # Generate low resolution vector preview with updated max radius (1.08)
    generate_halftone_svg(input_image, "fotopanel_low_res.svg", grid_size=80, max_radius=1.08, min_radius=0.05)
    
    # Generate high resolution vector output with updated max radius (0.36)
    generate_halftone_svg(input_image, "fotopanel_high_res.svg", grid_size=160, max_radius=0.36, min_radius=0.05)
    
    print(f"Halftone SVGs generated successfully from '{input_image}'.")
else:
    print(f"Error: Target image file '{input_image}' was not found.")