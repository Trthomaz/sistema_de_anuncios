#Testes usados nas rotas de default

import pytest


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



@pytest.mark.skip(reason="Tem que importar corretamente o conftest, a resolver.")
def test_criar_anuncio_success(client, anuncio_model_mount):
    from conftest import anuncio_model_unmount

    preco = str(anuncio_model_mount.preco).replace(".", ",")
    response = client.get("/criar_anuncio", json={"titulo":anuncio_model_mount.titulo, "descricao": anuncio_model_mount.descricao, "tipo_anuncio":anuncio_model_mount.tipo, "categoria":anuncio_model_mount.categoria, "preco":preco, "celular":anuncio_model_mount.telefone, "cep":anuncio_model_mount.local})

    assert response.status_code == 200

    json = response.get_json()

    assert json["status"] == True
    
    anuncio_model_unmount(anuncio_model_mount)#Retirando a persistencia


def test_criar_anuncio_fail(client, anuncio_model_mount):
    preco = str(anuncio_model_mount.preco).replace(".", ",")
    response = client.get("/criar_anuncio", json={"titulo":anuncio_model_mount.titulo, "descricao": anuncio_model_mount.descricao, "tipo_anuncio":anuncio_model_mount.tipo, "categoria":anuncio_model_mount.categoria, "preco":preco, "celular":anuncio_model_mount.telefone, "cep":anuncio_model_mount.local})

    assert response.status_code == 200

    json = response.get_json()

    assert json["status"] == False



def test_get_meus_anuncios_success(client, perfil_model, anuncio_model, categoria_model, tipo_model):
    anunciante_id = perfil_model.id
    
    response = client.get("/get_meus_anuncios", json={"user_id":anunciante_id})
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
    

@pytest.mark.xfail()#Falhara propositalmente
def test_get_meus_anuncios_fail(client):
    anunciante_id = -1
    response = client.get("/get_meus_anuncios", json={"user_id":anunciante_id})
    assert response.status_code == 200
    
    json = response.get_json()

    assert len(json["anuncios"]) > 0 #Nao tem nenhum anuncio



@pytest.mark.smoke
def test_get_perfil_success(client, perfil_model):
    response = client.get("/get_perfil", json={"user_id":perfil_model.id})
    assert response.status_code == 200

    json = response.get_json()

    json = json["dados"]
    
    assert json["nome"] == perfil_model.nome
    assert json["curso"] == perfil_model.curso
    assert json["reputacao"] == perfil_model.reputacao


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


@pytest.mark.skip(reason="Talvez nao faca sentido este teste, ja que qualquer forma se retorna 'a mesma estrutura'.")
def test_get_feed_fail(client, perfil_model):
    pass



@pytest.mark.skip(reason="Tem que corrigir na rota, ou ver como funciona.")
def test_fazer_busca_success(client, anuncio_model, perfil_model2):
    response = client.get("/fazer_busca", json={"user_id":perfil_model2.id, "txt":anuncio_model.titulo, "categoria":anuncio_model.categoria, "tipo":anuncio_model.tipo, "local":anuncio_model.local, "preco_inicial":anuncio_model.preco -1, "preco_final":anuncio_model.preco +1})
    assert response.status_code == 200

    json = response.get_json()

    json = json["dados"]

    assert len(json["anuncios"]) == 1
    assert json["anuncios"][0]["anuncio_id"] == anuncio_model.id
    assert json["anuncios"][0]["titulo"] == anuncio_model.imagem
    assert json["anuncios"][0]["preco"] == anuncio_model.preco


@pytest.mark.skip(reason="Tem que corrigir na rota, ou ver como funciona.")
def test_fazer_busca_fail(client, anuncio_model, perfil_model2):
    response = client.get("/fazer_busca", json={"user_id":perfil_model2.id, "txt":anuncio_model.titulo, "categoria":anuncio_model.categoria, "tipo":anuncio_model.tipo, "local":anuncio_model.local, "preco_inicial":anuncio_model.preco +1, "preco_final":anuncio_model.preco -1})
    assert response.status_code == 200

    json = response.get_json()

    json = json["dados"]

    assert len(json["anuncios"]) == 1
    assert len(json["anuncios"][0]) == 0



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



def test_iniciar_conversa_success(client):
    #response = client.get("/get_conversas", json={"anunciante_id":perfil_model.id, "interessado_id":perfil_model2.id})
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
