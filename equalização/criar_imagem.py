from PIL import Image

def criar_imagem(im, niveis, canal_index):
    largura, altura = im.size
    nova = Image.new("L", (largura, altura))
    pixels_origem = list(im.getdata())
    pixels_novos = [niveis[p[canal_index]] for p in pixels_origem]
    nova.putdata(pixels_novos)
    return nova