from app.models import *

class Tipo(db.Model):
    __tablename__ = "tipos"

    id = db.Column(db.Integer, primary_key=True)
    tipo = db.Column(db.String, unique=True)

    def __init__(self, tipo):
         self.tipo = tipo