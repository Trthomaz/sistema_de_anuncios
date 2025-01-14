#Testes usados nas rotas de default

import pytest

#------------------------------------------------------------------------------------------------------------------------------------------------------
@pytest.mark.smoke
def test_login_success(client, perfil_model):
    response = client.get("/login", json={"cpf":perfil_model.email, "senha": perfil_model.senha})
    assert response.status_code == 200
    
    json = response.get_json()

    assert json["login"] == True
    assert json["email"] == perfil_model.email
    assert json["nome"] == perfil_model.nome
    assert json["curso"] == perfil_model.curso
    assert json["reputacao"] == perfil_model.reputacao


@pytest.mark.smoke
def test_login_fail(client, perfil_model):
    senha_errada = "atletico"

    response = client.get("/login", json={"cpf":perfil_model.email, "senha": senha_errada})
    assert response.status_code == 200
    
    json = response.get_json()

    assert json["login"] == False


#------------------------------------------------------------------------------------------------------------------------------------------------------
@pytest.mark.smoke
def test_logout_success(client, perfil_model):
    response = client.get("/login", json={"cpf": perfil_model.email, "senha": perfil_model.senha})

    response = client.get("/logout")
    assert response.status_code == 200

    json = response.get_json()

    assert json["status"] == True


@pytest.mark.smoke
def test_logout_fail(client, perfil_model):
    senha_errada = "atletico"

    response = client.get("/login", json={"cpf": perfil_model.email, "senha": senha_errada})
    response = client.get("/logout")
    assert response.status_code == 200

    json = response.get_json()

    assert json["status"] == False


#------------------------------------------------------------------------------------------------------------------------------------------------------
def test_criar_anuncio_success(client, anuncio_model_mount):

    preco = str(anuncio_model_mount.preco).replace(".", ",")
    response = client.get("/criar_anuncio", json={"user_id":anuncio_model_mount.anunciante,"titulo":anuncio_model_mount.titulo, "descricao": anuncio_model_mount.descricao, "tipo_anuncio":anuncio_model_mount.tipo, "categoria":anuncio_model_mount.categoria, "preco":preco, "celular":anuncio_model_mount.telefone, "cep":anuncio_model_mount.local, "imagem":anuncio_model_mount.imagem})

    assert response.status_code == 200

    json = response.get_json()

    assert json["status"] == True


def test_criar_anuncio_fail(client, anuncio_model_unmount):
    preco = str(anuncio_model_unmount.preco).replace(".", ",")
    response = client.get("/criar_anuncio", json={"titulo":anuncio_model_unmount.titulo, "descricao": anuncio_model_unmount.descricao, "tipo_anuncio":anuncio_model_unmount.tipo, "categoria":anuncio_model_unmount.categoria, "preco":preco, "celular":anuncio_model_unmount.telefone, "cep":anuncio_model_unmount.local, "imagem":anuncio_model_unmount.imagem})

    assert response.status_code == 200

    json = response.get_json()

    assert json["status"] == False


#------------------------------------------------------------------------------------------------------------------------------------------------------
def test_get_meus_anuncios_success(client, perfil_model, anuncio_model, categoria_model, tipo_model, transacao_model):
    anunciante_id = perfil_model.id
    
    data = transacao_model.data_inicio.strftime('%Y-%m-%d %H:%M:%S')
    response = client.get("/get_meus_anuncios", json={"user_id":anunciante_id, "data":data})
    assert response.status_code == 200

    json = response.get_json()

    assert len(json["anuncios"]) > 0
    
    json = json["anuncios"][0]

    assert json["id"] == anuncio_model.id
    assert json["titulo"] == anuncio_model.titulo
    assert json['anunciante_id'] == anuncio_model.anunciante
    assert json["descricao"] == anuncio_model.descricao
    assert json["telefone"] == anuncio_model.telefone
    assert json["local"] == anuncio_model.local
    assert json['categoria'] == categoria_model.categoria
    assert json["tipo"] == tipo_model.tipo
    assert json["nota"] == anuncio_model.nota
    assert json['ativo'] == anuncio_model.ativo
    assert json["preco"] == anuncio_model.preco
    assert json["anunciante/interessado"] == 'anunciante'
    assert json["imagem"] == anuncio_model.imagem


@pytest.mark.skip()
def test_get_meus_anuncios_with_from_transacoes(client, perfil_model, anuncio_model, categoria_model, tipo_model, transacao_model):
    pass


@pytest.mark.xfail()#Falhara propositalmente
def test_get_meus_anuncios_fail(client):
    from datetime import datetime
    anunciante_id = -1
    data = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')

    response = client.get("/get_meus_anuncios", json={"user_id":anunciante_id, "data":data})
    assert response.status_code == 200
    
    json = response.get_json()

    assert len(json["anuncios"]) > 0 #Nao tem nenhum anuncio


#------------------------------------------------------------------------------------------------------------------------------------------------------
@pytest.mark.smoke
def test_get_perfil_success(client, perfil_model):
    response = client.get("/get_perfil", json={"user_id":perfil_model.id})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]
    
    assert json["nome"] == perfil_model.nome
    assert json["curso"] == perfil_model.curso
    assert json["reputacao"] == perfil_model.reputacao


#------------------------------------------------------------------------------------------------------------------------------------------------------
def test_get_feed_success(client, perfil_model):#Tem 2 tipos de anuncios
    response = client.get("/get_feed", json={"user_id":perfil_model.id})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]

    assert len(json) == 2

    for venda in json["venda"]:
        assert type(venda["anuncio_id"]) == int
        assert type(venda["titulo"]) == str
        assert type(venda["preco"]) == float

    for busca in json["busca"]:
        assert type(busca["anuncio_id"]) == int
        assert type(busca["titulo"]) == str
        assert type(busca["preco"]) == float


#------------------------------------------------------------------------------------------------------------------------------------------------------
def test_fazer_busca_success(client, anuncio_model, perfil_model2):
    response = client.get("/fazer_busca", json={"user_id":perfil_model2.id, "txt":anuncio_model.titulo, "categoria":anuncio_model.categoria, "tipo":anuncio_model.tipo, "local":anuncio_model.local, "preco_inicial":anuncio_model.preco -1, "preco_final":anuncio_model.preco +1})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]

    assert len(json["anuncios"]) == 1
    assert json["anuncios"][0]["anuncio_id"] == anuncio_model.id
    assert json["anuncios"][0]["titulo"] == anuncio_model.titulo
    assert json["anuncios"][0]["preco"] == anuncio_model.preco
    assert json["anuncios"][0]["tipo"] == anuncio_model.tipo


def test_fazer_busca_fail(client, anuncio_model, perfil_model2):
    response = client.get("/fazer_busca", json={"user_id":perfil_model2.id, "txt":anuncio_model.titulo, "categoria":anuncio_model.categoria, "tipo":anuncio_model.tipo, "local":anuncio_model.local, "preco_inicial":anuncio_model.preco +1, "preco_final":anuncio_model.preco -1})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]

    assert len(json["anuncios"]) == 0


#------------------------------------------------------------------------------------------------------------------------------------------------------
def test_get_conversas_success(client, perfil_model, perfil_model2 ,conversa_model):
    response = client.get("/get_conversas", json={"user_id":perfil_model.id})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]["conversas"]

    assert json[0]["conversa_id"] == conversa_model.id
    assert json[0]["anunciante_id"] == perfil_model.id
    assert json[0]["interessado_id"] == perfil_model2.id
    assert json[0]["anunciante_nome"] == perfil_model.nome
    assert json[0]["interessado_nome"] == perfil_model2.nome


def test_get_conversas_fail(client):
    response = client.get("/get_conversas", json={"user_id":-1})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]

    assert len(json["conversas"]) == 0


#------------------------------------------------------------------------------------------------------------------------------------------------------
def test_iniciar_conversa_success(client, conversa_model_unmount):
    from app import app
    from app.models.conversa import Conversa

    response = client.get("/iniciar_conversa", json={"anunciante_id":conversa_model_unmount.anunciante, "interessado_id":conversa_model_unmount.interessado})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]

    with app.app_context():
        id = Conversa.query.filter(Conversa.anunciante == conversa_model_unmount.anunciante, Conversa.interessado == conversa_model_unmount.interessado).first().id

    assert json["conversa_id"] == id
    assert json["erro"] == "Tudo certo!"


def test_iniciar_conversa_fail(client, conversa_model):
    response = client.get("/iniciar_conversa", json={"anunciante_id":conversa_model.anunciante, "interessado_id":conversa_model.interessado})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]

    assert json["conversa_id"] == conversa_model.id
    assert json["erro"] == "Conversa já existe!"


#------------------------------------------------------------------------------------------------------------------------------------------------------
def test_get_mensagens_success(client, mensagem_model):
    from datetime import datetime

    response = client.get("/get_mensagens", json={"id":mensagem_model.conversa})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]

    assert len(json) == 1
    assert json[0]["msg_id"] == mensagem_model.id
    assert json[0]["user_id"] == mensagem_model.user
    assert json[0]["txt"] == mensagem_model.txt
    
    date = json[0]["date"]
    date_obj = datetime.strptime(date, '%a, %d %b %Y %H:%M:%S GMT')
    
    assert date_obj == mensagem_model.date
    

def test_get_mensagens_fail(client):
    response = client.get("/get_mensagens", json={"id":-1})
    assert response.status_code == 200

    json = response.get_json()

    assert len(json["dados"]) == 0


#------------------------------------------------------------------------------------------------------------------------------------------------------
def test_add_mensagem_success(client, mensagem_model_unmount):
    response = client.get("/add_mensagem", json={"user_id":mensagem_model_unmount.user, "txt":mensagem_model_unmount.txt, "conversa_id":mensagem_model_unmount.conversa, "data":mensagem_model_unmount.date.strftime('%Y-%m-%d %H:%M:%S')})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]
    
    assert json["msg"] == "ok"


#------------------------------------------------------------------------------------------------------------------------------------------------------
def test_get_anuncio_success(client, anuncio_model, categoria_model, tipo_model):
    response = client.get("/get_anuncio", json={"anuncio_id":anuncio_model.id})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]

    assert json["id"] == anuncio_model.id
    assert json["titulo"] == anuncio_model.titulo
    assert json["anunciante_id"] == anuncio_model.anunciante
    assert json["descricao"] == anuncio_model.descricao
    assert json["telefone"] == anuncio_model.telefone
    assert json["local"] == anuncio_model.local
    assert json["categoria"] == categoria_model.categoria
    assert json["tipo"] == tipo_model.tipo
    assert json["nota"] == anuncio_model.nota
    assert json["ativo"] == anuncio_model.ativo
    assert json["preco"] == anuncio_model.preco
    assert json["imagem"] == anuncio_model.imagem


#------------------------------------------------------------------------------------------------------------------------------------------------------
def test_excluir_anuncio_success(client, anuncio_model_mount):
    from app.models.anuncio import Anuncio
    from app import app, db

    with app.app_context():
        db.session.add(anuncio_model_mount)
        db.session.commit()
        id = Anuncio.query.filter_by(titulo=anuncio_model_mount.titulo).first().id

    response = client.get("/excluir_anuncio", json={"user_id":anuncio_model_mount.anunciante,"anuncio_id":id})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]

    assert json["msg"] == "Anúncio deletado."


def test_excluir_anuncio_fail(client, perfil_model2, anuncio_model):
    response = client.get("/excluir_anuncio", json={"user_id":perfil_model2.id, "anuncio_id":anuncio_model.id})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]

    assert json["msg"] == "O usuário não é o proprietário deste anúncio."


#------------------------------------------------------------------------------------------------------------------------------------------------------
def test_editar_anuncio_success(client, anuncio_model, tipo_model2, categoria_model2):
    titulo = "titulo"
    descricao = "descricao"
    tipo_anuncio = tipo_model2.tipo#exista
    categoria = categoria_model2.categoria#exista
    preco = 23.23
    celular = "celular"
    cep = "cep"
    imagem = "imagem"
    
    response = client.get("/editar_anuncio", json={"anuncio_id":anuncio_model.id,"titulo":titulo, "descricao":descricao, "tipo_anuncio":tipo_anuncio, "categoria":categoria, "preco":preco, "celular":celular, "cep":cep, "imagem":imagem})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]

    assert json["msg"] == "ok"


#------------------------------------------------------------------------------------------------------------------------------------------------------
def test_finalizar_transação_condicao_1(client, transacao_model_unmount):
    data = str(transacao_model_unmount.data_inicio).replace(' GMT', '')
    #data = datetime.strptime(data, '%Y-%m-%d %H:%M:%S')

    response = client.get("/finalizar_transação", json={"user_id":transacao_model_unmount.interessado, "anuncio_id":transacao_model_unmount.anuncio, "data":data})
    assert response.status_code == 200
    
    json = response.get_json()
    json = json["dados"]

    assert json["msg"] == "Transação criada com sucesso!"


def test_finalizar_transação_condicao_2(client, perfil_model, transacao_model_unmount):
    data = str(transacao_model_unmount.data_inicio).replace(' GMT', '')

    response = client.get("/finalizar_transação", json={"user_id":perfil_model.id, "anuncio_id":transacao_model_unmount.anuncio, "data":data})
    assert response.status_code == 200
    
    json = response.get_json()
    json = json["dados"]

    assert json["msg"] == "O anunciante não pode iniciar a transação!"


def test_finalizar_transação_condicao_3(client, transacao_model):
    data = str(transacao_model.data_inicio).replace(' GMT', '')

    response = client.get("/finalizar_transação", json={"user_id":transacao_model.interessado, "anuncio_id":transacao_model.anuncio, "data":data})
    assert response.status_code == 200
    
    json = response.get_json()
    json = json["dados"]

    assert json["msg"] == "Outro usuário já está interessado em fechar negócio."


def test_finalizar_transação_condicao_4(client, perfil_model, transacao_model):
    data = str(transacao_model.data_inicio).replace(' GMT', '')

    response = client.get("/finalizar_transação", json={"user_id":perfil_model.id, "anuncio_id":transacao_model.anuncio, "data":data})
    assert response.status_code == 200
    
    json = response.get_json()
    json = json["dados"]

    assert json["msg"] == "Transação finalizada com sucesso!"


def test_finalizar_transação_condicao_5(client, transacao_model_invalida_unmount):
    data = str(transacao_model_invalida_unmount.data_inicio).replace(' GMT', '')

    response = client.get("/finalizar_transação", json={"user_id":transacao_model_invalida_unmount.interessado, "anuncio_id":transacao_model_invalida_unmount.anuncio, "data":data})
    assert response.status_code == 200
    
    json = response.get_json()
    json = json["dados"]

    assert json["msg"] == "Transação criada com sucesso!"


def test_finalizar_transação_condicao_6(client, perfil_model, transacao_model_invalida_unmount):
    data = str(transacao_model_invalida_unmount.data_inicio).replace(' GMT', '')

    response = client.get("/finalizar_transação", json={"user_id":perfil_model.id, "anuncio_id":transacao_model_invalida_unmount.anuncio, "data":data})
    assert response.status_code == 200
    
    json = response.get_json()
    json = json["dados"]

    assert json["msg"] == "O anunciante não pode iniciar a transação!"


#------------------------------------------------------------------------------------------------------------------------------------------------------
def test_avaliar_success_maior_que_5(client, anuncio_model):
    nota = 7

    response = client.get("/avaliar", json={"user_id":anuncio_model.anunciante, "anuncio_id":anuncio_model.id, "nota":nota})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]

    assert json["msg"] == "Nota fora do escopo."


def test_avaliar_ativa_invalido(client, anuncio_model):
    nota = 4.5

    response = client.get("/avaliar", json={"user_id":anuncio_model.anunciante, "anuncio_id":anuncio_model.id, "nota":nota})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]

    assert json["msg"] == "Transação não encerrada"


def test_avaliar_notas_dadas(client, anuncio_model_T_nota):
    nota = 4.5

    response = client.get("/avaliar", json={"user_id":anuncio_model_T_nota.anunciante, "anuncio_id":anuncio_model_T_nota.id, "nota":nota})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]

    assert json["msg"] == "Notas já foram dadas"


def test_avaliar_success(client, anuncio_model_T_final, transacao_model_from_Anuncio_T_final):
    nota = 4
    
    response = client.get("/avaliar", json={"user_id":anuncio_model_T_final.anunciante, "anuncio_id":anuncio_model_T_final.id, "nota":nota})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]

    assert json["msg"] == "Nota dada com sucesso!"


@pytest.mark.skip()
def test_avaliar_fail(client, anuncio_model_T_final):
    nota = 4

    response = client.get("/avaliar", json={"user_id":anuncio_model_T_final.anunciante, "anuncio_id":anuncio_model_T_final.id, "nota":nota})
    assert response.status_code == 200

    json = response.get_json()
    json = json["dados"]

    assert json["msg"] == "vixe mano kkk de quem que é esse id aí vei...."


#------------------------------------------------------------------------------------------------------------------------------------------------------
#Testes funcoes  auxiliares


def test_transacao_valida(transacao_model):
    from app.controllers.default import transacao_valida
    from datetime import datetime, timedelta

    data = datetime.utcnow()
    transacao_model.data_inicio -= timedelta(days=1)

    response = transacao_valida(transacao_model, data)

    assert response == False


#------------------------------------------------------------------------------------------------------------------------------------------------------
def test_anuncio_para_dicionario(anuncio_model, categoria_model, tipo_model):
    from app.controllers.default import anuncio_para_dicionario
    from app import app

    anunciante_or_interessado = "anunciante"
    
    with app.app_context():#Para nao violar o contexto de persistencia.
        response = anuncio_para_dicionario(anuncio_model, anunciante_or_interessado)

    assert response["id"] == anuncio_model.id
    assert response["titulo"] == anuncio_model.titulo
    assert response["anunciante_id"] == anuncio_model.anunciante
    assert response["descricao"] == anuncio_model.descricao
    assert response["telefone"] == anuncio_model.telefone
    assert response["local"] == anuncio_model.local
    assert response["categoria"] == categoria_model.categoria
    assert response["tipo"] == tipo_model.tipo
    assert response["nota"] == anuncio_model.nota
    assert response["ativo"] == anuncio_model.ativo
    assert response["preco"] == anuncio_model.preco
    assert response["anunciante/interessado"] == anunciante_or_interessado
    assert response["imagem"] == anuncio_model.imagem


#------------------------------------------------------------------------------------------------------------------------------------------------------
def test_sort_by_date(mensagem_model, mensagem_model2):
    from app.controllers.default import sort_by_date

    response = [mensagem_model2, mensagem_model]

    sort_by_date(response, "bubble")

    assert response[0] == mensagem_model
    assert response[1] == mensagem_model2


#------------------------------------------------------------------------------------------------------------------------------------------------------
def test_quick_sort(mensagem_model, mensagem_model2):
    from app.controllers.default import quick_sort

    response = [mensagem_model2, mensagem_model]

    response = quick_sort(response)

    assert response[0] == mensagem_model
    assert response[1] == mensagem_model2


#------------------------------------------------------------------------------------------------------------------------------------------------------
@pytest.mark.skip(reason="Nao tem tratamento de excessao nesta rota, exemplo de possivel tratamento.")
@pytest.mark.smoke
def test_get_perfil_fail(client):
    response = client.get("/get_perfil", json={"user_id":-1})
    assert response.status_code == 200

    json = response.get_json()

    json = json["dados"]
    
    assert json["nome"] == None
    assert json["curso"] == None
    assert json["reputacao"] == None