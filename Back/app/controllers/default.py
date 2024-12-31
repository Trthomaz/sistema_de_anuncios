from app.controllers import *
import datetime


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
        session.pop("user_id", None)
        return jsonify({"status": True})
    return jsonify({"status": False})


@app.route("/get_anuncios_geral")
def get_anuncios_geral():
    dados = {}
    if session['user_id']:
        anuncios_pessoais = Anuncio.query.all()
        
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
    preco = float(preco.replace(',', '.'))
    celular = dados.get("celular")
    cep = dados.get("cep")
    
    user_id = dados.get("user_id")
    anuncio = Anuncio(user_id,titulo,descricao,celular,cep,categoria,ativo=ativo,tipo=tipo_anuncio, preco=preco)
    try:
        #Perfil().add_anuncio(anuncio)
        perfil = Perfil.query.filter_by(id=user_id).first()
        perfil.add_anuncio(anuncio)
        return jsonify({"status":True})
    except Exception as e:
        print(e)
        rollback()
        return jsonify({"status":False})


########################################### LEO #################################################

# Parte real oficial

@app.route("/get_meus_anuncios", methods = ["POST", "GET"])
def get_meus_anuncios():
    dados = request.get_json()
    id = dados.get("user_id")
    anuncios = Anuncio.query.filter_by(anunciante=id).all()
    anuncios_lista = []
    for v in anuncios:
        c = Categoria.query.filter_by(id=v.categoria).first()
        t = Tipo.query.filter_by(id=v.tipo).first()
        anuncios_lista.append({"id": v.id, "titulo": v.titulo, "anunciante_id": v.anunciante, "descricao": v.descricao, "telefone": v.telefone, "local": v.local, "categoria": c.categoria, "tipo": t.tipo, "nota": v.nota, "ativo": v.ativo, "preco": v.preco, "anunciante/interessado": "anunciante", "imagem": v.imagem})
    dados = {}
    dados["anuncios"] = anuncios_lista
    return jsonify(dados)

@app.route("/get_perfil", methods = ["POST", "GET"])
def get_perfil():
    dados = request.get_json()
    id = dados.get("user_id")
    perfil = Perfil.query.filter_by(id=id).first()
    dados = {}
    dados["dados"] = {"nome": perfil.nome, "curso": perfil.curso, "reputacao": perfil.reputacao}
    return jsonify(dados)

@app.route("/get_feed", methods = ["POST", "GET"])
def get_feed():
    dados = request.get_json()
    id = dados.get("user_id")
    anuncios_venda = Anuncio.query.filter(Anuncio.anunciante != id, Anuncio.tipo == 1).all()
    anuncios_busca = Anuncio.query.filter(Anuncio.anunciante != id, Anuncio.tipo == 2).all()
    anuncios_venda = anuncios_venda[:5]
    anuncios_busca = anuncios_busca[:5]
    av = []
    ab = []
    for v in anuncios_venda:
        av.append({"anuncio_id": v.id, "titulo": v.titulo, "imagem": v.imagem, "preco": v.preco}) # Substituir titulo e imagem
    for v in anuncios_busca:
        ab.append({"anuncio_id": v.id, "titulo": v.titulo, "imagem": v.imagem, "preco": v.preco}) # Substituir titulo e imagem
    dados = {}
    dados["dados"] = {"venda": av, "busca": ab}
    return jsonify(dados)

@app.route("/fazer_busca", methods = ["POST", "GET"])  # precisa ser bem testado. não tenho certeza se funciona.
def fazer_busca():
    dados = request.get_json()
    user_id = dados.get("user_id")
    txt = dados.get("txt")
    categoria = dados.get("categoria")
    tipo = dados.get("tipo")
    local = dados.get("local")
    preco_i = dados.get("preco_inicial")
    preco_f = dados.get("preco_final")
    c = categoria == -1
    t = tipo == -1
    l = local == "-1"
    pi = preco_i == -1
    pf = preco_f == -1
    anuncios = Anuncio.query.filter((Anuncio.categoria == categoria) | (c),
                                    (Anuncio.tipo == tipo) | (t),
                                    (Anuncio.local == local) | (l),
                                    (Anuncio.preco > preco_i) | (pi),
                                    (Anuncio.preco < preco_f) | (pf),
                                    Anuncio.anunciante != user_id,
                                    txt in Anuncio.titulo).all()
    anuncios_lista = []
    for v in anuncios:
        c = Categoria.query.filter_by(id=v.categoria).first()
        t = Tipo.query.filter_by(id=v.tipo).first()
        anuncios_lista.append({"anuncio_id": v.id, "titulo": v.titulo, "imagem": v.imagem, "preco": v.preco})
    dados = {}
    dados["dados"] = {"anuncios": anuncios_lista}
    return jsonify(dados)
    

@app.route("/get_conversas", methods = ["POST", "GET"])
def get_conversas():
    dados = request.get_json()
    id = dados.get("user_id")
    conversas = Conversa.query.filter((Conversa.anunciante == id) | (Conversa.interessado == id), Conversa.arquivada == False).all()
    c = []
    for v in conversas:
        a = Perfil.query.filter_by(id=v.anunciante).first().nome
        i = Perfil.query.filter_by(id=v.interessado).first().nome
        c.append({"conversa_id": v.id, "anunciante_id": v.anunciante, "interessado_id": v.interessado, "anunciante_nome": a, "interessado_nome": i})
    dados = {}
    dados["dados"] = {"conversas": c}
    return jsonify(dados)

@app.route("/iniciar_conversa", methods = ["POST", "GET"])
def iniciar_conversa():
    dados = request.get_json()
    anunciante_id = dados.get("anunciante_id")
    interessado_id = dados.get("interessado_id")
    dados = {}
    conversas = Conversa.query.filter(Conversa.anunciante == anunciante_id, Conversa.interessado == interessado_id).all()
    if conversas == []:
        db.session.add(Conversa(interessado_id, anunciante_id))
        db.session.commit()
        id = Conversa.query.filter(Conversa.anunciante == anunciante_id, Conversa.interessado == interessado_id).first().id
        dados["dados"] = {"conversa_id": id, "erro": "Tudo certo!"}
    else:
        dados["dados"] = {"conversa_id": -1, "erro": "Conversa já existe!"}
    return jsonify(dados)

@app.route("/get_mensagens", methods = ["POST", "GET"])
def get_mensagens():
    dados = request.get_json()
    id = dados.get("id")
    mensagens = Mensagem.query.filter_by(conversa=id).all()  # ver o sort
    m = []
    for v in mensagens:
        m.append({"msg_id": v.id, "user_id": v.user, "txt": v.txt, "date": v.date})
    dados = {}
    dados["dados"] = m
    return jsonify(dados)

@app.route("/add_mensgem", methods = ["POST", "GET"])
def add_mensagem():
    dados = request.get_json()
    user_id = dados.get("user_id")
    txt = dados.get("txt")
    #date = dados.get("date")
    date = datetime.datetime.utcnow()
    cvv_id = dados.get("conversa_id")
    db.session.add(Mensagem(user_id, txt, date, cvv_id))
    db.session.commit()
    return "ok"

@app.route("/get_anuncio", methods = ["POST", "GET"])
def get_anuncio():
    dados = request.get_json()
    id = dados.get("anuncio_id")
    a = Anuncio.query.filter_by(id=id).first()
    c = Categoria.query.filter_by(id=a.categoria).first()
    t = Tipo.query.filter_by(id=a.tipo).first()
    anuncio = {"id": a.id, "titulo": a.titulo, "anunciante_id": a.anunciante, "descricao": a.descricao, "telefone": a.telefone, "local": a.local, "categoria": c.categoria, "tipo": t.tipo, "nota": a.nota, "ativo": a.ativo, "preco": a.preco, "imagem": a.imagem}
    dados = {}
    dados["dados"] = anuncio
    return jsonify(dados)

# Testes e mexidas diretas no bd

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

@app.route("/inicializar3")
def inicializar3():
    db.session.add(Conversa(1, 2))
    db.session.add(Conversa(2, 1))
    db.session.commit()
    return "ok"

@app.route("/inicializar4")
def inicializar4():
    db.session.add(Mensagem(1, "oi", datetime.datetime.utcnow(), 1))
    db.session.commit()
    return "ok"

@app.route("/ver")
def ver():
    x = Anuncio.query.filter_by(anunciante=2).first()
    return x.descricao

@app.route("/get_teste")
def get_teste():
    x = Anuncio.query.filter_by(anunciante=1).all()
    y = []
    for v in x:
        y.append(v.categoria)
    y = str(y)
    print(y)
    return x

######################################### END LEO ################################################



@app.route("/teste1")
def teste1():
    db.session.add(Perfil("a", "a", "A", "AA", 5))
    db.session.commit()
    return "ok"

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