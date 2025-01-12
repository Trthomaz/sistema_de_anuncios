from app.models import *

class Transacao(db.Model):

    __tablename__ = "transacoes"

    id = db.Column(db.Integer, primary_key=True)
    data_inicio = db.Column(db.DateTime)
    anuncio = db.Column(db.Integer, db.ForeignKey('anuncios.id'))
    interessado = db.Column(db.Integer, db.ForeignKey('perfis.id'))
    nota_interessado = db.Column(db.Integer) #Do interessado para o anunciante
    nota_anunciante = db.Column(db.Integer)

    def __init__(self, data_inicio, anuncio, interessado, nota_interessado=None, nota_anunciante=None):

        self.data_inicio = data_inicio
        self. anuncio = anuncio
        self.interessado = interessado
        self.nota_interessado = nota_interessado
        self.nota_anunciante = nota_anunciante
    
    def add_nota_interessado(self, nota):
        
        self.nota_interessado = nota
        #db.commit()

    def add_nota_anunciante(self, nota):

        self.nota_anunciante = nota
        #db.commit()