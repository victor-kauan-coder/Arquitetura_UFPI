import plotly.express as pt
from PIL import Image

lista = []
with open("trabalho/pixel_bytes.bin", "rb") as arq:
    for byte in arq.read():
        lista.append(byte)

im = Image.new('L', (176, 120))
im.putdata(lista)
im.save("imagem_do_caralho.jpg")
im.show()

fig = pt.histogram(lista, nbins=256)
fig.show()