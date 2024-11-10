from flask import jsonify, request #Usado para retornar paginas HTML, ocioso ainda
from app import app, db
from app.models.tables import User

@app.route("/")
def teste():
    #Requisicao estatica, nao personalizada
    return "Cruzeiro e o melhor. Tryhard da computacao!"

@app.route("/perfil/<user>")
def perfil(user):
    #Logica de exemplo de uma requisicao personalizada
    if user == "Fabio":
        return "Tudo ok"
    else:
        return "Nao autenticado"


@app.route("/login", methods=["POST", "GET"])
def login():
    dados = request.get_json()
    email = dados.get('cpf')
    password =  dados.get('senha')

    user = User.query.filter_by(email=email).first()
    if user and user.password == password:
        return jsonify({"login":"true"})
    
    #insert into users(email, name, password) values("fabio@gabriel.com","Fabio","cruzeiro");
    
    return jsonify({"login":"false"})

#Fazer aqui o controle das requisicoes do flutter