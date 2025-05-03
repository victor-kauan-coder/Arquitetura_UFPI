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

frequency_count = list(im.getdata())

fig = px.histogram([i[0] for i in frequency_count], nbins=256, title="Interactive Histogram")
fig.show()