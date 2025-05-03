from PIL import Image

img = Image.open('imagem_pb.jpg').convert('L')

pixel_count = [pixel for pixel in img.getdata()]
print(pixel_count)
pixel_count = bytes(pixel_count)

with open('gray_pixel_count.bin', 'wb') as f:
    f.write(pixel_count)

