#Testes usados nas rotas de anuncios
'''import pytest
from app import app


@pytest.fixture()
def app_istance():
    instance = app

    yield instance

    instance.
    #Zerado o servidor


@pytest.fixture()
def client(app_istance):
    return app_istance.run(host='0.0.0.0', port=5000, threaded=True, debug=True)

def test_login(client):
    response = client.get("/login", json={'cpf':'a', 'senha':'a'})
    print(response)
    assert 1 ==1 '''


import pytest

def test_login_success(client):
    response = client.get("/login", json={"cpf":"fabio@gabriel", "senha": "cruzeiro"})
    assert response.status_code == 200
    
    json = response.get_json()

    assert json["login"] == True
    assert json["email"] == "fabio@gabriel"
    assert json["nome"] == "Fabio Gabriel"
    assert json["curso"] == "Computacao"
    assert json["reputacao"] == 4.9


def test_login_fail(client):
    response = client.get("/login", json={"cpf":"fabio@gabriel", "senha": "atletico"})
    assert response.status_code == 200
    
    json = response.get_json()

    assert json["login"] == False



def test_logout_success(client):
    response = client.get("/login", json={"cpf":"fabio@gabriel", "senha": "cruzeiro"})

    response = client.get("/logout")
    assert response.status_code == 200

    json = response.get_json()

    assert json["status"] == True


# @pytest.skip(reason="Nao implementado ainda")
def test_logout_fail(client):
    response = client.get("/login", json={"cpf":"fabio@gabriel", "senha": "atletico"})

    response = client.get("/logout")
    assert response.status_code == 200

    json = response.get_json()

    assert json["status"] == False

#Implementar fixture de response que repete varias vezes, eliminando redundancia
