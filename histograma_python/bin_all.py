from PIL import Image
import os

base_dir = os.path.dirname(os.path.abspath(__file__))
path_img = os.path.join(base_dir + "/imagens", '1.jpg')

im = Image.open(path_img)

def create_bin(nome_arquivo:str, color_idx:int):
    frequency_count = list(i[color_idx] for i in im.getdata())
    pixel_bytes = bytes(frequency_count)
    
    with open(f"./trabalho/bins/{nome_arquivo}", 'wb') as f:
        f.write(pixel_bytes)

create_bin("red_channel.bin", 0)
create_bin("green_channel.bin", 1)
create_bin("blue_channel.bin", 2)