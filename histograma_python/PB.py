from PIL import Image

imagem = Image.open("./1.jpg")

preto_e_branco = imagem.convert("L")

preto_e_branco.save("imagem_pb.jpg")
