from app import app
from app.models import *
from flask import jsonify, request, session #Usado para retornar paginas HTML, ocioso ainda

app.secret_key = "chave_secreta_com_Cruzeiro"

# from app.controllers.anuncio import *
# from app.controllers.perfil import *