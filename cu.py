from PIL import Image

# 1. Carrega a imagem em escala de cinza
img = Image.open('histograma_python/imagens/1.jpg').convert('L')
width, height = img.size
pixels = list(img.getdata())

# 2. Calcula o histograma
hist = [0] * 256
for px in pixels:
    hist[px] += 1

# 3. Calcula a CDF (função de distribuição acumulada)
cdf = []
cum_sum = 0
for h in hist:
    cum_sum += h
    cdf.append(cum_sum)

# Normaliza a CDF para o intervalo [0, 255]
cdf_min = next(x for x in cdf if x > 0)
total_pixels = width * height
mapping = [
    round((cdf[v] - cdf_min) / (total_pixels - cdf_min) * 255)
    for v in range(256)
]

# 4. Aplica a equalização
equalized_pixels = [mapping[p] for p in pixels]

# 5. Cria e salva a nova imagem
equalized_img = Image.new('L', (width, height))
equalized_img.putdata(equalized_pixels)
equalized_img.save('imagem_equalizada.jpg')
equalized_img.show()
