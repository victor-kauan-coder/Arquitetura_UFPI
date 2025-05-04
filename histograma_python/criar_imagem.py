from PIL import Image
def criar_imagem(imagem_pb,pixels,name="imagem_equalizada"):
    im_equalizada = Image.new('L', ((imagem_pb.width, imagem_pb.height)))
    for x in range(imagem_pb.width):
        for y in range(imagem_pb.height):
            valor_original = imagem_pb.getpixel((x, y))
            novo_valor = pixels[valor_original]
            im_equalizada.putpixel((x, y), novo_valor)

    # Salva a nova imagem
    im_equalizada.save(f"{name}.jpg")