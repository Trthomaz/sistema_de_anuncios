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



def test_get_meus_anuncios_success(client):
    anunciante_id = 1
    
    response = client.get("/get_meus_anuncios", json={"user_id":anunciante_id})
    assert response.status_code == 200

    response = response.get_json()
    assert len(response["anuncios"]) > 0
    
    response = response["anuncios"][0]

    assert response["anunciante/interessado"] == 'anunciante'
    assert response['anunciante_id'] == anunciante_id
    assert response['ativo'] == True
    assert response['categoria'] == "serviço"
    assert response["descricao"] == "Fabio"
    assert response["id"] == 1
    assert response["imagem"] == None
    assert response["local"] == '11111-111'
    assert response["nota"] == 5
    assert response["preco"] == 49.9
    assert response["telefone"] == '(21) 99999-9999'
    assert response["tipo"] == "venda"
    assert response["titulo"] == "Cruzeirense"
    

@pytest.mark.xfail()#Falhara propositalmente
def test_get_meus_anuncios_fail(client):
    anunciante_id = -1
    response = client.get("/get_meus_anuncios", json={"user_id":anunciante_id})
    assert response.status_code == 200
    
    assert len(response["anuncios"]) > 0



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
