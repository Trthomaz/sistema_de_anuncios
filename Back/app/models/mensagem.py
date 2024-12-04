from app.models import *

class Mensagem(db.Model):
    __tablename__ = "mensagens"

    id = db.Column(db.Integer, primary_key=True)
    user = db.Column(db.Integer, db.ForeignKey('perfis.id'))
    txt = db.Column(db.Text)
    date = db.Column(db.DateTime)
    conversa = db.Column(db.Integer, db.ForeignKey('conversas.id'))

    def __init__(self, user, txt, date):

        self.user = user
        self.txt = txt
        self.date = date