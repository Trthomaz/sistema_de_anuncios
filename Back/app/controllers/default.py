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


# @app.route("/get_anuncios_geral")
# def get_anuncios_geral():
#     dados = {}
#     if session['user_id']:
#         anuncios_pessoais = Anuncio.query.all()
        
#         #Nao sei se funciona retornar a linha inteira
#         dados["dados"] = anuncios_pessoais
#         return jsonify(dados)
#     dados["dados"] = None
#     return jsonify(dados)

# @app.route("/get_anuncios_pessoais")
# def get_anuncios_pessoais():
#     dados = {}
#     if session['user_id']:
#         anuncios_pessoais = Anuncio.query.filter_by(id=session["user_id"])

#         #Nao sei se funciona retornar a linha inteira
#         dados["dados"] = anuncios_pessoais
#         return jsonify(dados)
#     dados["dados"] = None
#     return jsonify(dados)


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
    imagem = dados.get("imagem")
    
    user_id = dados.get("user_id")
    anuncio = Anuncio(user_id,titulo,descricao,celular,cep,categoria,ativo=ativo,tipo=tipo_anuncio, preco=preco, imagem=imagem)
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
    data = dados.get("data")
    data = datetime.datetime.strptime(data, '%Y-%m-%d %H:%M:%S')
    anuncios = Anuncio.query.filter_by(anunciante=id).all() 
    anuncios_lista = []
    for v in anuncios:
        anuncios_lista.append(anuncio_para_dicionario(v, "anunciante"))
    ############# Não sei se funciona
    transacoes = Transacao.query.filter_by(interessado = id).all()
    for v in transacoes:
        a = Anuncio.query.filter_by(id=v.anuncio).first()
        if transacao_valida(v, data):
            anuncios_lista.append(anuncio_para_dicionario(a, "interessado"))
        else:
            if a.ativo:
                db.session.delete(v)  # possível fonte de erro
                db.session.commit()
    ###################################
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
    anuncios_venda = Anuncio.query.filter(Anuncio.anunciante != id, Anuncio.tipo == 1, Anuncio.ativo == True).all()
    anuncios_busca = Anuncio.query.filter(Anuncio.anunciante != id, Anuncio.tipo == 2, Anuncio.ativo == True).all()
    anuncios_venda = anuncios_venda[:5]
    anuncios_busca = anuncios_busca[:5]
    av = []
    ab = []
    for v in anuncios_venda:
        av.append({"anuncio_id": v.id, "titulo": v.titulo, "imagem": v.imagem, "preco": v.preco}) # Substituir titulo e imagem
    for v in anuncios_busca:
        ab.append({"anuncio_id": v.id, "titulo": v.titulo, "imagem": v.imagem, "preco": v.preco}) # Substituir titulo e imagem  # (???)
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
                                    (Anuncio.tipo == tipo) | (t),#(Anuncio.tipo == tipo) if t else True
                                    (Anuncio.local == local) | (l),
                                    (Anuncio.preco > preco_i) | (pi),
                                    (Anuncio.preco < preco_f) | (pf),
                                    Anuncio.anunciante != user_id,
                                    Anuncio.titulo.like(f'%{txt}%')).all()#Anuncio.titulo.like(f'%{txt}%')  #txt in Anuncio.titulo
    anuncios_lista = []
    for v in anuncios:
        c = Categoria.query.filter_by(id=v.categoria).first()
        t = Tipo.query.filter_by(id=v.tipo).first()
        anuncios_lista.append({"anuncio_id": v.id, "titulo": v.titulo, "imagem": v.imagem, "preco": v.preco, "tipo": v.tipo})
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
    c = Conversa.query.filter(Conversa.anunciante == interessado_id, Conversa.interessado == anunciante_id).all()  # ponto com chance de dar ruim
    conversas = conversas + c
    if conversas == []:
        db.session.add(Conversa(interessado_id, anunciante_id))
        db.session.commit()
        id = Conversa.query.filter(Conversa.anunciante == anunciante_id, Conversa.interessado == interessado_id).first().id
        dados["dados"] = {"conversa_id": id, "erro": "Tudo certo!"}
    else:
        id = conversas[0].id
        dados["dados"] = {"conversa_id": id, "erro": "Conversa já existe!"}
    return jsonify(dados)

@app.route("/get_mensagens", methods = ["POST", "GET"])
def get_mensagens():
    dados = request.get_json()
    id = dados.get("id")
    mensagens = Mensagem.query.filter_by(conversa=id).all()
    mensagens = sort_by_date(mensagens, "bubble")
    m = []
    for v in mensagens:
        m.append({"msg_id": v.id, "user_id": v.user, "txt": v.txt, "date": v.date})
    dados = {}
    dados["dados"] = m
    return jsonify(dados)

@app.route("/add_mensagem", methods = ["POST", "GET"])
def add_mensagem():
    dados = request.get_json()
    user_id = dados.get("user_id")
    txt = dados.get("txt")
    data = dados.get("data")
    data = datetime.datetime.strptime(data, '%Y-%m-%d %H:%M:%S')
    cvv_id = dados.get("conversa_id")
    db.session.add(Mensagem(user_id, txt, data, cvv_id))
    db.session.commit()
    return jsonify({"dados": {"msg": "ok"}})

@app.route("/get_anuncio", methods = ["POST", "GET"])
def get_anuncio():
    dados = request.get_json()
    id = dados.get("anuncio_id")
    a = Anuncio.query.filter_by(id=id).first()
    anuncio = anuncio_para_dicionario(a, "anunciante")
    dados = {}
    dados["dados"] = anuncio
    return jsonify(dados)

@app.route("/excluir_anuncio", methods = ["POST", "GET"])
def excluir_anuncio():
    dados = request.get_json()
    user_id = dados.get("user_id")
    anuncio_id = dados.get("anuncio_id")
    anuncio = Anuncio.query.filter_by(id=anuncio_id).first()
    if anuncio.anunciante == user_id:
        db.session.delete(anuncio)
        db.session.commit()
        return jsonify({"dados": {"msg": "Anúncio deletado."}})
    return jsonify({"dados": {"msg": "O usuário não é o proprietário deste anúncio."}})

@app.route("/editar_anuncio", methods = ["POST", "GET"])
def editar_anuncio():

    dados = request.get_json()
    id = dados.get("anuncio_id")
    titulo = dados.get("titulo")
    descricao = dados.get("descricao")
    tipo_anuncio = dados.get("tipo_anuncio")
    categoria = dados.get("categoria")
    preco = dados.get("preco")
    celular = dados.get("celular")
    cep = dados.get("cep")
    imagem = dados.get("imagem")

    print(categoria)

    anuncio = Anuncio.query.filter_by(id = id).first()
    anuncio.titulo = titulo
    anuncio.descricao = descricao
    anuncio.telefone = celular
    anuncio.local = cep
    anuncio.categoria = categoria
    anuncio.tipo = tipo_anuncio
    anuncio.preco = preco
    anuncio.imagem = imagem

    db.session.commit()

    return jsonify({"dados": {"msg": "ok"}})

@app.route("/finalizar_transação", methods = ["POST", "GET"])
def finalizar_transação():

    dados = request.get_json()
    user_id = dados.get("user_id")
    anuncio_id = dados.get("anuncio_id")
    data = dados.get("data")
    data = datetime.datetime.strptime(data, '%Y-%m-%d %H:%M:%S')
    anuncio = Anuncio.query.filter_by(id=anuncio_id).first()
    transacoes = Transacao.query.filter_by(anuncio = anuncio_id).all()
    resposta = ""
    if transacoes == []:
        if user_id != anuncio.anunciante:
            db.session.add(Transacao(data, anuncio_id, user_id))
            db.session.commit()
            resposta = "Transação criada com sucesso!"
        else:
            resposta = "O anunciante não pode iniciar a transação!"
    else:
        # if len(transacoes) > 1:
        #     # Não deveria acontecer em hipótese alguma. Se acontecer, tratar aqui.
        #     pass
        # else:
            transacao = transacoes[0]
            if transacao_valida(transacao, data):
                if user_id != anuncio.anunciante:
                    resposta = "Outro usuário já está interessado em fechar negócio."
                else:
                    anuncio.ativo = False
                    resposta = "Transação finalizada com sucesso!"
                    db.session.commit()
            else:
                db.session.delete(transacao)
                if user_id != anuncio.anunciante:
                    db.session.add(Transacao(data, anuncio_id, user_id))
                    resposta = "Transação criada com sucesso!"
                else:
                    resposta = "O anunciante não pode iniciar a transação!"
                db.session.commit()
    return jsonify({"dados": {"msg": resposta}})

@app.route("/avaliar", methods = ["POST", "GET"])
def avaliar():
    dados = request.get_json()
    id = dados.get("user_id")
    a_id = dados.get("anuncio_id")
    nota = dados.get("nota")
    if not (0 < nota < 5):
        return jsonify({"dados": {"msg": "Nota fora do escopo."}})
    anuncio = Anuncio.query.filter_by(id = a_id).first()
    if anuncio.ativo:
        return jsonify({"dados": {"msg": "Transação não encerrada"}})
    if anuncio.nota:
        return jsonify({"dados": {"msg": "Notas já foram dadas"}})
    transacao = Transacao.query.filter_by(anuncio = a_id).first()
    #perfil = Perfil.query.filter_by(id=id).first()
    p_a = Perfil.query.filter_by(id=transacao.anunciante).first()
    p_i = Perfil.query.filter_by(id=transacao.interessado).first()
    if id == transacao.interessado:
        transacao.add_nota_interessado(nota)
        p_a.att_reputação()
    elif id == anuncio.anunciante:
        transacao.add_nota_anunciante(nota)
        p_i.att_reputacao()
    else:
        return jsonify({"dados": {"msg": "vixe mano kkk de quem que é esse id aí vei...."}})
    if (transacao.nota_interessado is not None) and (transacao.nota_anunciante is not None):
        anuncio.nota = True
    #ver confusão com a nota do anuncio e dar um jeito de saber se a nota já foi dada
    db.session.commit()
    return jsonify({"dados": {"msg": "Nota dada com sucesso!"}})
    
        
# Funções auxiliares

def transacao_valida(transacao, data):
    diff = data - transacao.data_inicio
    return (diff.days < 1)

def anuncio_para_dicionario(a, anunciante_or_interessado):
    c = Categoria.query.filter_by(id=a.categoria).first()
    t = Tipo.query.filter_by(id=a.tipo).first()
    anuncio = {"id": a.id, "titulo": a.titulo, "anunciante_id": a.anunciante, "descricao": a.descricao, "telefone": a.telefone, "local": a.local, "categoria": c.categoria, "tipo": t.tipo, "nota": a.nota, "ativo": a.ativo, "preco": a.preco, "anunciante/interessado": anunciante_or_interessado, "imagem": a.imagem}
    return anuncio

def sort_by_date(objs, type):
    if type == "bubble":
        n = len(objs)
        for i in range (n):
            for j in range (n - 1):
                if objs[j].date > objs[j + 1].date:
                    objs[j], objs[j+1] = objs[j+1], objs[j]
        return objs
    elif type == "quick":
        return quick_sort(objs)

def quick_sort(lista):
    if len(lista) <= 1:
        return lista

    pivo = lista[0]
    lista1 = []
    lista2 = []
    for v in lista[1::]:
        if v.date > pivo.date:
            lista2.append(v)
        else:
            lista1.append(v)
    return quick_sort(lista1) + [pivo] + quick_sort(lista2)


# Testes e mexidas diretas no bd

@app.route("/mexer")
def mexer():
    lista = Mensagem.query.filter().all()
    for v in lista:
        db.session.delete(v)
    lista = Conversa.query.filter().all()
    for v in lista:
        db.session.delete(v)
    #db.session.add(Perfil("kenji@es.com", "1234", "Kenji", "Sistemas de Informação", 5))
    '''lista = Anuncio.query.filter().all()
    for v in lista:
        db.session.delete(v)
    db.session.add(Perfil("jpoço@es.com", "1234", "João do Poço", "Ciência da Computação", 5))
    p = Perfil.query.filter_by().first()
    lista = Mensagem.query.filter().all()
    for v in lista:
        db.session.delete(v)
    lista = Conversa.query.filter().all()
    for v in lista:
        db.session.delete(v)
    a = Anuncio.query.filter_by(titulo="Mouse Gamer RGB")
    a.anunciante = p.id
    lista = Perfil.query.filter().all()
    for v in lista:
        if v.nome != "João do Poço":
            db.session.delete(v)'''
    db.session.commit()
    return "ok"

# @app.route("/inicializar1")
# def inicializar1():
#     db.session.add(Tipo("venda"))
#     db.session.add(Tipo("procura"))
#     db.session.add(Categoria("serviço"))
#     db.session.add(Categoria("produto"))
#     db.session.add(Perfil("a", "a", "A", "AA", 5))
#     db.session.add(Perfil("b", "b", "B", "BB", 5))
#     db.session.add(Anuncio(2, "titulo", "bili jin is not mai louver xis jast a gral det cleims det ai em de uan", "1111-1111", "Grags", 1, True, 1, 15))
#     #db.session.add(Anuncio(2, "bili jin is not mai louver xis jast a gral det cleims det ai em de uan", "1111-1111", "Grags", 1, True, 1, 15))
#     db.session.add(Conversa(1, 2))
#     #db.session.add(Mensagem(1, "oi", datetime.datetime.utcnow(), 1))
#     db.session.commit()
#     return "ok"

# @app.route("/inicializar2")
# def inicializar2():
#     db.session.add(Anuncio(2, "bili jin is not mai louver xis jast a gral det cleims det ai em de uan", "1111-1111", "Grags", 1, True, 1, 15))
#     db.session.commit()
#     return "ok"

# @app.route("/inicializar3")
# def inicializar3():
#     db.session.add(Conversa(1, 2))
#     db.session.commit()
#     return "ok"

# @app.route("/inicializar4")
# def inicializar4():
#     db.session.add(Mensagem(1, "oi", datetime.datetime.utcnow(), 1))
#     db.session.commit()
#     return "ok"

# @app.route("/ver")
# def ver():
#     x = Anuncio.query.filter_by(anunciante=2).first()
#     return x.descricao

# @app.route("/get_teste")
# def get_teste():
#     x = Anuncio.query.filter_by(anunciante=1).all()
#     y = []
#     for v in x:
#         y.append(v.categoria)
#     y = str(y)
#     print(y)
#     return x

######################################### END LEO ################################################



# @app.route("/teste1")
# def teste1():
#     db.session.add(Perfil("a", "a", "A", "AA", 5))
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