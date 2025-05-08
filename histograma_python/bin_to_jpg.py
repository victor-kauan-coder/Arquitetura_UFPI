from PIL import Image
import os
import plotly.express as px
import pandas as pd
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
pixels = [i for i in imagem_final.getdata()]
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
    title="Histograma RGB por Canal",
    color_discrete_map={
    "Vermelho": "rgba(255, 102, 102, 0.6)",  # rosa claro
    "Verde":    "rgba(144, 238, 144, 0.6)",  # verde claro
    "Azul":     "rgba(173, 216, 230, 0.6)",  # azul claro
}
)
fig.show()
imagem_final.save("imagem_rgb_recuperada.jpg")
