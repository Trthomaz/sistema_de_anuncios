#Testes usados nas rotas de default

import pytest


#@pytest.mark.skip(reason="Persistir dado para teste")
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


#@pytest.mark.skip(reason="Persistir dado para teste")
@pytest.mark.smoke
def test_login_fail(client, perfil_model):
    senha_errada = "atletico"

    response = client.get("/login", json={"cpf":perfil_model.email, "senha": senha_errada})
    assert response.status_code == 200
    
    json = response.get_json()

    assert json["login"] == False



#@pytest.mark.skip(reason="Persistir dado para teste")
@pytest.mark.smoke
def test_logout_success(client, perfil_model):
    response = client.get("/login", json={"cpf": perfil_model.email, "senha": perfil_model.senha})

    response = client.get("/logout")
    assert response.status_code == 200

    json = response.get_json()

    assert json["status"] == True


#@pytest.mark.skip(reason="Persistir dado para teste")
@pytest.mark.smoke
def test_logout_fail(client, perfil_model):
    senha_errada = "atletico"

    response = client.get("/login", json={"cpf": perfil_model.email, "senha": senha_errada})

    response = client.get("/logout")
    assert response.status_code == 200

    json = response.get_json()

    assert json["status"] == False



def test_criar_anuncio_success(client, anuncio_model_mount):
    #Anuncio nao foi criado
    pass


def test_criar_anuncio_fail(client, anuncio_model):
    #Anuncio ja criado
    pass



def test_get_meus_anuncios_success(client, perfil_model, anuncio_model, categoria_model, tipo_model):
    anunciante_id = perfil_model.id
    
    response = client.get("/get_meus_anuncios", json={"user_id":anunciante_id})
    assert response.status_code == 200

    response = response.get_json()
    assert len(response["anuncios"]) > 0
    
    response = response["anuncios"][0]

    assert response["id"] == anuncio_model.id
    assert response["titulo"] == anuncio_model.titulo
    assert response['anunciante_id'] == anuncio_model.anunciante
    assert response["descricao"] == anuncio_model.descricao
    assert response["telefone"] == anuncio_model.telefone
    assert response["local"] == anuncio_model.local
    assert response['categoria'] == categoria_model.categoria
    assert response["tipo"] == tipo_model.tipo
    assert response["nota"] == anuncio_model.nota
    assert response['ativo'] == anuncio_model.ativo
    assert response["preco"] == anuncio_model.preco
    assert response["anunciante/interessado"] == 'anunciante'
    assert response["imagem"] == anuncio_model.imagem
    
    #a

@pytest.mark.xfail()#Falhara propositalmente
def test_get_meus_anuncios_fail(client):
    anunciante_id = -1
    response = client.get("/get_meus_anuncios", json={"user_id":anunciante_id})
    assert response.status_code == 200
    
    response = response.get_json()

    assert len(response["anuncios"]) > 0 #Nao tem nenhum anuncio



@pytest.mark.smoke
def test_get_perfil_success(client):
    pass


@pytest.mark.smoke
def test_get_perfil_fail(client):
    pass



def test_get_feed_success(client):#Tem 2 tipos de anuncios
    pass


def test_get_feed_fail(client):
    pass



def test_fazer_busca_success(client):
    pass


def test_fazer_busca_fail(client):
    pass



def test_get_conversas_success(client):
    pass


def test_get_conversas_fail(client):
    pass



def test_iniciar_conversa_success(client):
    pass


def test_iniciar_conversa_fail(client):
    pass



def test_get_mensagens_success(client):
    pass


def test_get_mensagens_fail(client):
    pass



def test_add_mensagem_success(client):
    pass


def test_add_mensagem_fail(client):
    pass



def test_get_anuncio_success(client):
    pass


def test_get_anuncio_fail(client):
    pass



def test_excluir_anuncio_success(client):
    pass


def test_excluir_anuncio_fail(client):
    pass



def test_editar_anuncio_success(client):
    pass


def test_editar_anuncio_fail(client):
    pass




#Implementar fixture de response que repete varias vezes, eliminando redundancia
