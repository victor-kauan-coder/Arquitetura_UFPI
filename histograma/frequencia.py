from PIL import Image
import plotly.express as px
import os

base_dir = os.path.dirname(os.path.abspath(__file__))
path_img = os.path.join(base_dir + "/imagens", '1.jpg')
print(path_img)
#21120
im = Image.open(path_img)

red_frequency_count = list(i[0] for i in im.getdata())

fig = px.histogram(red_frequency_count, nbins=256, title="Histograma do canal vermelho da imagem feito em python")
fig.show()
fig.write_image("histograma.png")

