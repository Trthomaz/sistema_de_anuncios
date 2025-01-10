from app.models import *

class Conversa(db.Model):
    __tablename__ = "conversas"

    id = db.Column(db.Integer, primary_key=True)
    interessado = db.Column(db.Integer, db.ForeignKey('perfis.id'))
    anunciante = db.Column(db.Integer, db.ForeignKey('perfis.id'))
    arquivada = db.Column(db.Boolean)

    def __init__(self, interessado, anunciante, arquivada=False):
                
            self.interessado = interessado
            self.anunciante = anunciante
            self.arquivada = arquivada

    def add_msg(self, user, txt, date):

        if not self.arquivada:
            db.session.add(Mensagem(user, txt, date))
            db.session.commit()
    
    def arquivar(self):

                self.arquivada = True