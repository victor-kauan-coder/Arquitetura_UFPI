from PIL import Image
import os

def substituir_canais_rgb(imagem_original, arquivo_r, arquivo_g, arquivo_b):
    largura, altura = imagem_original.size
    total_pixels = largura * altura

    with open(arquivo_r, "rb") as fr:
        dados_r = list(fr.read())
    with open(arquivo_g, "rb") as fg:
        dados_g = list(fg.read())
    with open(arquivo_b, "rb") as fb:
        dados_b = list(fb.read())

    novos_pixels = []
    for i in range(total_pixels):
        novos_pixels.append((dados_r[i], dados_g[i], dados_b[i]))
    

    nova_imagem = Image.new("RGB", (largura, altura))
    nova_imagem.putdata(novos_pixels)
    return nova_imagem

base_dir = os.path.dirname(os.path.abspath(__file__))
imagem_original = Image.open(os.path.join(base_dir + "/imagens","1.jpg")).convert("RGB")
imagem_final = substituir_canais_rgb(
    imagem_original,
    os.path.join(base_dir,"pixel_bytes_red.bin"),
    os.path.join(base_dir,"pixel_bytes_green.bin"),
    os.path.join(base_dir,"pixel_bytes_blue.bin")
)

imagem_final.save("imagem_rgb_recuperada.jpg")
