from PIL import Image
import os


class CONVERTER:
    
    def __init__(self): # Constructor
        print("Convertidor Iniciado...")
    def rgb888_to_rgb565(self,r, g, b):
        """Convierte un píxel RGB888 a RGB565."""
        r_5 = (r >> 3) & 0x1F  # 5 bits para R
        g_6 = (g >> 2) & 0x3F  # 6 bits para G
        b_5 = (b >> 3) & 0x1F  # 5 bits para B
        return (r_5 << 11) | (g_6 << 5) | b_5

    def image_to_rgb565_flat(self,image_path, width=135, height=240):
        """Convierte una imagen a una lista de valores RGB565 en formato binario continuo."""
        if not os.path.exists(image_path):
            raise FileNotFoundError(f"El archivo no existe: {image_path}")
        
        try:
            img = Image.open(image_path)
            img = img.convert("RGB")  # Asegura que la imagen esté en RGB
            img = img.resize((width, height))  # Redimensiona a 135x240
            pixels_rgb565 = []

            for y in range(height):
                for x in range(width):
                    r, g, b = img.getpixel((x, y))
                    rgb565 = self.rgb888_to_rgb565(r, g, b)
                    pixels_rgb565.append(f"{rgb565:016b}")  # Convertir a binario de 16 bits
            
            return "".join(pixels_rgb565)  # Combinar todo en un solo texto
        except Exception as e:
            print(f"Error al procesar la imagen: {e}")
            return None
    def Create_Bin_Text(self,name):
    # Cambia esta ruta por la ruta correcta a tu imagen
        dirname = os.path.dirname(__file__)
        image_path = os.path.join(dirname, name)
        try:
            # Convierte la imagen a formato RGB565 con tamaño 135x240 y en texto continuo
            pixels_rgb565_flat = self.image_to_rgb565_flat(image_path, width=135, height=240)
            print (len(pixels_rgb565_flat))
            if pixels_rgb565_flat:
                # Imprime toda la matriz como texto continuo en binario
                print("Valores RGB565 en binario (como texto continuo):")
                print(pixels_rgb565_flat)
                
                # Opción para guardar en un archivo
                with open("output_rgb565_135x240_continuo.txt", "w") as file:
                    file.write(pixels_rgb565_flat)
                print("El texto binario continuo se ha guardado en 'output_rgb565_135x240_continuo.txt'")
            return pixels_rgb565_flat
        except FileNotFoundError as e:
            print(e)
