#Aqui deve colocar as fixtures comuns a todos os testes, que devem ser reutilizadas por exemplo nos mocks a serem usados por exemplo

from app import app
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