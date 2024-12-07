from app.models import *

class Anuncio(db.Model):
    __tablename__ = "anuncios"

    id = db.Column(db.Integer, primary_key=True)
    anunciante = db.Column(db.Integer, db.ForeignKey('perfis.id'))
    descricao = db.Column(db.Text)
    telefone = db.Column(db.String)
    local = db.Column(db.String)
    categoria = db.Column(db.Integer, db.ForeignKey('categorias.id'))
    tipo = db.Column(db.Integer, db.ForeignKey('tipos.id'))

    nota = db.Column(db.Integer)
    ativo = db.Column(db.Boolean, default=True)
    preco = db.Column(db.Float)

    #imagem

    def __init__(self, anunciante, titulo, descricao, telefone, local, categoria, ativo=True, tipo = 0, nota = 5,preco=0.0): #Ver como puxar imagem

        self.titulo = titulo
        self.anunciante = anunciante
        self.descricao = descricao
        self.telefone = telefone
        self.local = local
        self.categoria = categoria
        self.tipo = tipo

        self.nota = nota
        self.ativo = ativo
        self.preco=preco

    def arquivar(self):
        self.ativo = False