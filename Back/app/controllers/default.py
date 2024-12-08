from app.controllers import *



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

        dados["login"] = True #Temporario para nao quebrar aplicacao
        dados["user_id"] = user.id

        return jsonify(dados)
    
    
    return jsonify({"login":False})

@app.route("/logout")
def logout():
    user_id = session["user_id"]
    if user_id:
        session.pop(user_id, None)
        return jsonify({"status", True})
    return jsonify({"status", False})


@app.route("/get_anuncios_geral")
def get_anuncios_geral():
    dados = {}
    if session['user_id']:
        anuncios_pessoais = Anuncio.query().all()
        
        #Nao sei se funciona retornar a linha inteira
        dados["dados"] = anuncios_pessoais
        return jsonify(dados)
    dados["dados"] = None
    return jsonify(dados)

@app.route("/get_anuncios_pessoais")
def get_anuncios_pessoais():
    dados = {}
    if session['user_id']:
        anuncios_pessoais = Anuncio.query.filter_by(id=session["user_id"])

        #Nao sei se funciona retornar a linha inteira
        dados["dados"] = anuncios_pessoais
        return jsonify(dados)
    dados["dados"] = None
    return jsonify(dados)


@app.route("/criar_anuncio", methods=["POST", "GET"])
def criar_anuncio():
    dados = request.get_json()
    titulo = dados.get("titulo")
    ativo = True
    descricao = dados.get("descricao")
    tipo_anuncio = dados.get("tipo_anuncio")
    categoria = dados.get("categoria")
    preco = dados.get("preco")
    celular = dados.get("celular")
    cep = dados.get("cep")
    
    user_id = dados.get("user_id")
    anuncio = Anuncio(user_id,titulo,descricao,celular,cep,categoria,ativo=ativo,tipo=tipo_anuncio, preco=preco)
    try:
        perfil = Perfil.query.filter_by(id=user_id).first()
        perfil.add_anuncio(anuncio)
        return jsonify({"status":True})
    except:
        rollback()
        return jsonify({"status":False})





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

# @app.route("/")
# def teste():
#     #Requisicao estatica, nao personalizada
#     return "Cruzeiro e o melhor. Tryhard da computacao!"

# @app.route("/perfil/<user>")
# def perfil(user):
#     #Logica de exemplo de uma requisicao personalizada
#     if user == "Fabio":
#         return "Tudo ok"
#     else:
#         return "Nao autenticado"

#insert into users(email, name, password) values("fabio@gabriel.com","Fabio","cruzeiro");