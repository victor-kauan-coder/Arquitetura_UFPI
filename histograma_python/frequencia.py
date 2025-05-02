from PIL import Image
import plotly.express as px
import os
from pathlib import Path
import os
base_dir = os.path.dirname(os.path.abspath(__file__))
path_img = os.path.join(base_dir, '1.jpg')
frequency_count = []
#21120
im = Image.open(path_img)

width, height = im.size
for x in range(width):
    for y in range(height):
        r, g, b = im.getpixel((x, y))
        frequency_count.append(r)

fig = px.histogram(frequency_count, nbins=256, title="Interactive Histogram")
fig.show()