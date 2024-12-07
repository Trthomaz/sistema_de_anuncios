from app.controllers import *

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
    
    user_id = session["user_id"]
    anuncio = Anuncio(user_id,titulo,descricao,celular,cep,categoria,ativo=ativo,tipo=tipo_anuncio, reco=preco)
    try:
        Perfil().add_anuncio(anuncio)
        return jsonify({"status":True})
    except:
        rollback()
        return jsonify({"status":False})