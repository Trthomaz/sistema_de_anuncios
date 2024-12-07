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

        dados["login"] = "true" #Temporario para nao quebrar aplicacao

        return jsonify(dados)
    
    
    return jsonify({"login":"false"})

@app.route("/logout")
def logout():
    user_id = session["user_id"]
    if user_id:
        session.pop(user_id, None)
        return jsonify({"status", True})
    return jsonify({"status", False})
