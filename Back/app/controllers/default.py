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
    

def destrinchar_anuncios(anuncios):
    lista = []
    for v in anuncios:
        c = Categoria.query.filter_by(id=v.categoria).first()
        t = Tipo.query.filter_by(id=v.tipo).first()
        lista.append({"id": v.id, "anunciante_id": v.anunciante, "descricao": v.descricao, "telefone": v.telefone, "local": v.local, "categoria": c.categoria, "tipo": t.tipo, "nota": v.nota, "ativo": v.ativo, "preco": v.preco, "anunciante/interessado": "anunciante"})
    return lista
    

@app.route("/get_meus_anuncios", methods = ["POST", "GET"])
def get_meus_anuncios():
    dados = request.get_json()
    id = dados.get("id")
    perfil = Perfil.query.filter_by(id=id).first()
    anuncios = Anuncio.query.filter_by(anunciante=perfil.id).all()
    anuncios_lista = destrinchar_anuncios(anuncios)
    dados = {}
    dados["anuncios"] = anuncios_lista
    return jsonify(dados)

@app.route("/inicializar1")
def inicializar1():
    db.session.add(Tipo("venda"))
    db.session.add(Tipo("procura"))
    db.session.add(Categoria("serviço"))
    db.session.add(Categoria("produto"))
    db.session.commit()
    return "ok"

@app.route("/inicializar2")
def inicializar2():
    db.session.add(Anuncio(2, "bili jin is not mai louver xis jast a gral det cleims det ai em de uan", "1111-1111", "Grags", 1, True, 1, 5, 15))
    db.session.commit()
    return "ok"

@app.route("/ver")
def ver():
    x = Anuncio.query.filter_by(anunciante=2).first()
    return x.descricao




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