#Aqui deve colocar as fixtures comuns a todos os testes, que devem ser reutilizadas por exemplo nos mocks a serem usados por exemplo

from app import app, db
from app.models import *
import pytest


@pytest.fixture()
def appl():
    istance = app
    istance.config.update({
        "TESTING": True,
    })

    yield istance


@pytest.fixture()
def client(appl):
    return appl.test_client()


@pytest.fixture()
def perfil_model(client):
    email = "fabio@gabriel"
    senha = "cruzeiro"
    nome = "Fabio"
    curso = "Computacao"
    reputacao = 5.0

    perfil = Perfil(email, senha, nome, curso, reputacao)

    with app.app_context():
        db.session.add(perfil)
        db.session.commit()

        perfil_atual = Perfil.query.filter_by(email= email).first()

    yield perfil_atual

    with app.app_context():
        db.session.delete(perfil)
        db.session.commit()

