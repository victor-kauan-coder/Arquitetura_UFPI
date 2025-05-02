from PIL import Image



im = Image.open('C:/Users/kauan/Downloads/histograma/histograma/1.jpg')

width, height = im.size
red_count = [[0 for _ in range(height)] for _ in range(width)]
print(red_count)
for x in range(width):
    for y in range(height):
        r, g, b = im.getpixel((x, y))
        red_count[x][y] = r
print(red_count)