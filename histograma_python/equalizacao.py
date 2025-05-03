import plotly.express as px
from PIL import Image
import os

base_dir = os.path.dirname(os.path.abspath(__file__))
path_img = os.path.join(base_dir, "imagem_pb.jpg")
frequency_count = [0] * 256

caminho_arquivo = os.path.join(base_dir, "message (2).txt")

with open(caminho_arquivo, "r") as arquivo:
    lista_asm = [int(linha.strip().split(":")[1]) for linha in arquivo]

print(lista_asm)

im = Image.open(path_img)

width, height = im.size
for x in range(width):
    for y in range(height):
        g = im.getpixel((x, y))
        frequency_count[g] += 1
quant_pixels = sum(frequency_count)
print(quant_pixels)

pf = [] #função probabilidade
for pixels_count in frequency_count:
    pf.append(pixels_count/quant_pixels)

cdf = []
acumulator = 0
for probability in pf:
    acumulator += probability
    cdf.append(acumulator)
niveis = []
for sk in cdf:
    niveis.append(round(sk*(255)))

print(niveis)
nome_arquivo = 'histograma_equalizado.txt'


with open(nome_arquivo, 'w') as file:
    for pixel,value in enumerate(lista_asm):
        file.write(f"Pixel {pixel} - ocorrencia {value}\n")

print(f'O arquivo {nome_arquivo} foi criado com sucesso!')
im_equalizada = Image.new('L', (width, height))

for x in range(width):
    for y in range(height):
        valor_original = im.getpixel((x, y))
        novo_valor = lista_asm[valor_original]
        im_equalizada.putpixel((x, y), novo_valor)

# Salva a nova imagem
im_equalizada.save('imagem_equalizada_rars.jpg')

fig = px.histogram(niveis, nbins=256, title="Interactive Histogram")
fig.show()