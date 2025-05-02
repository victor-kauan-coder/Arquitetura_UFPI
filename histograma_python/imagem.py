from PIL import Image
import os
base_dir = os.path.dirname(os.path.abspath(__file__))
path_img = os.path.join(base_dir, '1.jpg')

im = Image.open(path_img)

width, height = im.size
red_count = [[0 for _ in range(height)] for _ in range(width)]
print(red_count)
for x in range(width):
    for y in range(height):
        r, g, b = im.getpixel((x, y))
        red_count[x][y] = r
print(red_count)