from flask import jsonify, request #Usado para retornar paginas HTML, ocioso ainda
from app import app, db
from app.models.tables import *

@app.route("/")
def teste():
    #Requisicao estatica, nao personalizada
    return "Cruzeiro e o melhor. Tryhard da computacao!"
'''
@app.route("/perfil/<user>")
def perfil(user):
    #Logica de exemplo de uma requisicao personalizada
    if user == "Fabio":
        return "Tudo ok"
    else:
        return "Nao autenticado"
'''

@app.route("/login", methods=["POST", "GET"])
def login():
    dados = request.get_json()
    email = dados.get('cpf')
    senha =  dados.get('senha')

    user = Perfil.query.filter_by(email=email).first()
    if user and user.senha == senha:
        return jsonify({"login":"true"})
    
    #insert into users(email, name, password) values("fabio@gabriel.com","Fabio","cruzeiro");
    
    return jsonify({"login":"false"})

@app.route("/teste1")
def teste1():
    db.session.add(Perfil("lmeato@id.uff.br", "1234", "Leo", "CC", 5))
    db.session.commit()
    return "ok"

@app.route("/teste2")
def teste2():
    s = Perfil.query.filter_by(nome="Leo").first()
    curso = s.curso
    return curso

#Fazer aqui o controle das requisicoes do flutter