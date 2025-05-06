from PIL import Image
import os

base_dir = os.path.dirname(os.path.abspath(__file__))
path_img = os.path.join(base_dir, 'imagens/1.jpg')

img = Image.open(path_img).convert('L')
img.show()
pixel_count = [pixel for pixel in img.getdata()]
pixel_count = bytes(pixel_count)


with open("./trabalho/bins/gray_pixel_count.bin", 'wb') as f:
    f.write(pixel_count)

