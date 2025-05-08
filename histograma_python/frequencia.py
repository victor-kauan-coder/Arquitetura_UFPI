from PIL import Image
import plotly.express as px
import os
from pathlib import Path
import os
base_dir = os.path.dirname(os.path.abspath(__file__))
path_img = os.path.join(base_dir + "/imagens", '1.jpg')
print(path_img)
#21120
im = Image.open(path_img)

red_frequency_count = list(i for i in im.getdata())

fig = px.histogram(red_frequency_count, nbins=256, title="Interactive Histogram")
fig.show()

