from flask import jsonify, request, session #Usado para retornar paginas HTML, ocioso ainda
from app import app, db
from app.models import *

app.secret_key = "chave_secreta_com_Cruzeiro"

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

    session['user_id'] = None
    user = Perfil.query.filter_by(email=email).first()
    if user and user.senha == senha:
        session['user_id'] = user.id
        
        dados = {}
        dados["email"] = user.email
        dados["nome"] = user.nome
        dados["curso"] = user.curso
        dados["reputacao"] = user.reputacao

        dados["login"] = "true" #Temporario para nao quebrar aplicacao

        return jsonify(dados)
    
    #insert into users(email, name, password) values("fabio@gabriel.com","Fabio","cruzeiro");
    
    return jsonify({"login":"false"})

@app.route("/logout")
def logout():
    user_id = session["user_id"]
    if user_id:
        session.pop(user_id, None)
        return jsonify({"status", "deslogado"})
    return jsonify({"status", "Ninguem cadastrado"})

# @app.route("/teste1")
# def teste1():
#     db.session.add(Perfil("lmeato@id.uff.br", "1234", "Leo", "CC", 5))
#     db.session.commit()
#     return "ok"

# @app.route("/teste2")
# def teste2():
#     s = Perfil.query.filter_by(nome="Leo").first()
#     curso = s.curso
#     return curso


@app.route("/anuncios_geral")
def anuncios_geral():
    dados = {}
    if session['user_id']:
        anuncios_pessoais = Anuncio.query().all()
        
        #Nao sei se funciona retornar a linha inteira
        dados["dados"] = anuncios_pessoais
        return jsonify(dados)
    dados["dados"] = None
    return jsonify(dados)

@app.route("/anuncios_pessoais")
def anuncios_pessoais():
    dados = {}
    if session['user_id']:
        anuncios_pessoais = Anuncio.query.filter_by(id=session["user_id"])

        #Nao sei se funciona retornar a linha inteira
        dados["dados"] = anuncios_pessoais
        return jsonify(dados)
    dados["dados"] = None
    return jsonify(dados)


#Fazer aqui o controle das requisicoes do flutter