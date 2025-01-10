from app.models import *

class Anuncio(db.Model):
    __tablename__ = "anuncios"

    id = db.Column(db.Integer, primary_key=True)
    titulo = db.Column(db.String)
    anunciante = db.Column(db.Integer, db.ForeignKey('perfis.id'))
    descricao = db.Column(db.Text)
    telefone = db.Column(db.String)
    local = db.Column(db.String)
    categoria = db.Column(db.Integer, db.ForeignKey('categorias.id'))
    tipo = db.Column(db.Integer, db.ForeignKey('tipos.id'))

    nota = db.Column(db.Boolean)
    ativo = db.Column(db.Boolean, default=True)
    preco = db.Column(db.Float)

    imagem = db.Column(db.Text)

    def __init__(self, anunciante, titulo, descricao, telefone, local, categoria, ativo=True, tipo = 1,preco=0.0, imagem=None):

        self.titulo = titulo
        self.anunciante = anunciante
        self.descricao = descricao
        self.telefone = telefone
        self.local = local
        self.categoria = categoria
        self.tipo = tipo

        self.nota = False
        self.ativo = ativo
        self.preco=preco
        
        self.imagem = imagem

    def arquivar(self):
        self.ativo = False