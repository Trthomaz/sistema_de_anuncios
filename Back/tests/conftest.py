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
def perfil_model():
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


@pytest.fixture()
def tipo_model():
    atr_tipo = "Teste com Pytest em tipo"

    tipo = Tipo(atr_tipo)

    with app.app_context():
        db.session.add(tipo)
        db.session.commit()

        tipo_atual = Tipo.query.filter_by(tipo= atr_tipo).first()
    
    yield tipo_atual

    with app.app_context():
        db.session.delete(tipo)
        db.session.commit()


@pytest.fixture()
def categoria_model():
    atr_categoria = "Teste com PyTest em categoria"

    categoria = Categoria(atr_categoria)

    with app.app_context():
        db.session.add(categoria)
        db.session.commit()

        categoria_atual = Categoria.query.filter_by(categoria= atr_categoria).first()
    
    yield categoria_atual

    with app.app_context():
        db.session.delete(categoria)
        db.session.commit()


@pytest.fixture()
def anuncio_model_mount(perfil_model, categoria_model, tipo_model):
    titulo = "Camiseta Cruzeiro"
    id_anunciante = perfil_model.id
    descricao = "Camiseta do Gabigol 2025 com logo da Mafia Azul bordado com autografo."
    telefone = "(31) 99999-9999"
    local = "UFF Computacao"
    categoria = categoria_model.id
    id_tipo = tipo_model.id
    nota = 5
    ativo = True
    preco = 254.99
    imagem = None

    anuncio = Anuncio(id_anunciante, titulo, descricao, telefone, local, categoria, ativo, id_tipo, nota, preco, imagem)
    
    yield anuncio


@pytest.fixture()
def anuncio_model(perfil_model, anuncio_model_mount, categoria_model, tipo_model):

    anuncio = anuncio_model_mount

    with app.app_context():
        db.session.add(anuncio)
        db.session.commit()

        anuncio_atual = Anuncio.query.filter_by(anunciante= anuncio.anunciante).first()
    
    yield anuncio_atual

    with app.app_context():
        db.session.delete(anuncio)
        db.session.commit()


def anuncio_model_unmount(anuncio:Anuncio)->None:
    db.session.delete(anuncio)
    db.session.commit()


@pytest.fixture()
def perfil_model2():
    email = "dario@chen"
    senha = "pokemon"
    nome = "Dario"
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


@pytest.fixture()
def conversa_model(perfil_model, perfil_model2):
    interessado = perfil_model2.id
    anunciante = perfil_model.id

    conversa = Conversa(interessado, anunciante)

    with app.app_context():
        db.session.add(conversa)
        db.session.commit()

        conversa_atual = Conversa.query.filter_by(interessado= interessado, anunciante= anunciante)
    
    yield conversa_atual

    with app.app_context():
        db.session.delete(conversa)
        db.session.commit()


@pytest.fixture()
def mensagem_model(conversa_model):
    user = conversa_model.anunciante
    txt = "Esta camisa é original, autografada por ele proprio."
    date = "2025-01-01 03:25:42.591522"
    conversa = conversa_model.id

    mensagem = Mensagem(user, txt, date, conversa)

    with app.app_context():
        db.session.add(mensagem)
        db.session.commit()

        mensagem_atual = Mensagem.query.filter_by(user= user)
    
    yield mensagem_atual

    with app.app_context():
        db.session.delete(mensagem)
        db.session.commit()