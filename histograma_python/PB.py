from PIL import Image
import os

base_dir = os.path.dirname(os.path.abspath(__file__))
path_img = os.path.join(base_dir, 'imagens/1.jpg')
print(base_dir)
imagem = Image.open(path_img)
preto_e_branco = imagem.convert("L")
preto_e_branco.save(f"{base_dir}/imagens/imagem_pb.jpg")
