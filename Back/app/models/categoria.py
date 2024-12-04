from app.models import db

class Categoria(db.Model):
    __tablename__ = "categorias"

    id = db.Column(db.Integer, primary_key=True)
    categoria = db.Column(db.String, unique=True)

    def __init__(self, categoria):
         self.categoria = categoria