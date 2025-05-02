from PIL import Image
import plotly.express as px

frequency_count = []
#21120
im = Image.open('1.jpg')

width, height = im.size
for x in range(width):
    for y in range(height):
        r, g, b = im.getpixel((x, y))
        frequency_count.append(r)

fig = px.histogram(frequency_count, nbins=256, title="Interactive Histogram")
fig.show()