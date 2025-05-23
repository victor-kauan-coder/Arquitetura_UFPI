from PIL import Image
import os

base_dir = os.path.dirname(os.path.abspath(__file__))
path_img = os.path.join(base_dir + "/imagens", '1.jpg')

im = Image.open(path_img)

red_frequency_count = list(i[0] for i in im.getdata())
bytes_red = bytes(red_frequency_count)

with open("./bins/red_channel.bin", 'wb') as f:
    f.write(bytes_red)