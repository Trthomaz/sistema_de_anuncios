from app import db

#Funcoes genericas do BD
def rollback():
    db.session.rollback()
def add(data):
    db.session.add(data)
def commit():
    db.session.commit()


from app.models.anuncio import Anuncio
from app.models.categoria import Categoria
from app.models.conversa import Conversa
from app.models.mensagem import Mensagem
from app.models.perfil import Perfil
from app.models.tipo import Tipo

#from models import *