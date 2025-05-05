import plotly.express as px
import numpy as np
from criar_imagem import *
from PIL import Image
import os

base_dir = os.path.dirname(os.path.abspath(__file__))
path_img = os.path.join(base_dir + "/imagens", "1.jpg")

frequency_count = [0] * 256

caminho_arquivo = "histograma_equalizado_rars.txt"

with open(caminho_arquivo, "r") as arquivo:
    lista_asm = [int(linha.strip().split()[-1]) for linha in arquivo]

# print(lista_asm)

im = Image.open(path_img).convert('L')

frequency_count = list([i for i in im.getdata()])
counts = np.bincount(frequency_count, minlength=256)
quant_pixels = sum(counts)

pf = [] #função probabilidade
for pixels_count in counts:
    pf.append(pixels_count/quant_pixels)

cdf = []
acumulator = 0
for probability in pf:
    acumulator += probability
    cdf.append(acumulator)
niveis = []
for sk in cdf:
    niveis.append(round(sk*(255)))


nome_arquivo = 'histograma_equalizado_rars.txt'

with open(nome_arquivo, 'w') as file:
    for pixel,value in enumerate(lista_asm):
        file.write(f"Pixel {pixel} - ocorrencia {value}\n")

nome_arquivo = 'histograma_equalizado_altonivel.txt'

with open(nome_arquivo, 'w') as file:
    for pixel,value in enumerate(niveis):
        file.write(f"Pixel {pixel} - ocorrencia {value}\n")

print(f'O arquivo {nome_arquivo} foi criado com sucesso!')
# print(niveis)
# print(lista_asm)
criar_imagem(im, lista_asm, name="Imagem_PB_equalizada_assembly")
criar_imagem(im, niveis, name="Imagem_PB_equalizada_altonivel")

fig = px.histogram(lista_asm, nbins=256, title="Histograma do assembly")
fig.show()
fig = px.histogram(niveis, nbins=256, title="Histograma do python" )
fig.show()