from app.models import db

class Anuncio(db.Model):
    __tablename__ = "anuncios"

    id = db.Column(db.Integer, primary_key=True)
    anunciante = db.Column(db.Integer, db.ForeignKey('perfis.id'))
    descricao = db.Column(db.Text)
    telefone = db.Column(db.String)
    #email?
    local = db.Column(db.String)
    categoria = db.Column(db.Integer, db.ForeignKey('categorias.id'))
    tipo = db.Column(db.Integer, db.ForeignKey('tipos.id'))

    nota = db.Column(db.Integer)
    ativo = db.Column(db.Boolean)

    #imagem

    def __init__(self, anunciante, descricao, telefone, local, categoria, ativo, tipo = 0, nota = 5): #Ver como puxar imagem

        self.anunciante = anunciante
        self.descricao = descricao
        self.telefone = telefone
        self.local = local
        self.categoria = categoria
        self.tipo = tipo

        self.nota = nota
        self.ativo = ativo

    def arquivar(self):
        self.ativo = False