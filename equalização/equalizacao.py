import plotly.express as px
import pandas as pd
import numpy as np
from criar_imagem import *
from PIL import Image
import os

base_dir = os.path.dirname(os.path.abspath(__file__))
path_img = os.path.join(base_dir + "/imagens", "1.jpg")

frequency_count = [0] * 256

# print(lista_asm)

im = Image.open(path_img).convert('RGB')

def equalizar(im):
    canais = []
    for canal in range(3):
        # Extrai o canal específico de todos os pixels
        valores = [p[canal] for p in im.getdata()]
        
        # Histograma (contagem de frequência)
        counts = np.bincount(valores, minlength=256)
        total_pixels = sum(counts)

        # CDF
        cdf = []
        acumulado = 0
        for contagem in counts:
            acumulado += contagem
            cdf.append(acumulado)

        # Calcula novos níveis de intensidade
        niveis = [int((sk * 255) // total_pixels) for sk in cdf]

        # Cria imagem do canal equalizado
        canal_eq = criar_imagem(im, niveis, canal)
        canais.append(canal_eq)

    # Junta os três canais equalizados
    return Image.merge("RGB", tuple(canais))

def histograma_rgb(imagem):
    imagem = imagem.convert("RGB")
    r_hist = [0] * 256
    g_hist = [0] * 256
    b_hist = [0] * 256

    for r, g, b in imagem.getdata():
        r_hist[r] += 1
        g_hist[g] += 1
        b_hist[b] += 1

    return r_hist, g_hist, b_hist

imagem_equalizada = equalizar(im)
r_hist, g_hist, b_hist = histograma_rgb(imagem_equalizada)
histogramas = []
histogramas.append(r_hist)
histogramas.append(g_hist)
histogramas.append(b_hist)
arquivos = ["histograma_red_altonivel","histograma_green_altonivel","histograma_blue_altonivel"]
imagem_equalizada.save("imagens/imagem_equalizada_altonivel.jpg")
imagem_equalizada.show(title="Equalizada")
pixels = [pixel for pixel in imagem_equalizada.getdata()]
# Exibir histograma do canal vermelho (exemplo)
dados = []
for r, g, b in pixels:
    dados.append((r, "Vermelho"))
    dados.append((g, "Verde"))
    dados.append((b, "Azul"))

# Criamos o DataFrame
df = pd.DataFrame(dados, columns=["Intensidade", "Canal"])

# Criamos o gráfico
fig = px.histogram(
    df,
    x="Intensidade",
    color="Canal",
    nbins=256,
    title="Histograma RGB por Canal - Equalizado",
    color_discrete_map={
    "Vermelho": "rgba(255, 102, 102, 0.6)",  # rosa claro
    "Verde":    "rgba(144, 238, 144, 0.6)",  # verde claro
    "Azul":     "rgba(173, 216, 230, 0.6)",  # azul claro
}
)
fig.show()

#criar histograma para cada canal 
for i in range(3):
    with open(f"result_python/{arquivos[i]}.txt", "w") as file:
        for pixel,qtd in enumerate(histogramas[i]):
            file.write(f"Pixel {pixel} - ocorrencia {qtd}\n")
