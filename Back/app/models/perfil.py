from app.models import *
from app.models.transacao import Transacao

class Perfil(db.Model):
    __tablename__ = "perfis"

    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String)
    senha = db.Column(db.String)
    nome = db.Column(db.String)
    curso = db.Column(db.String)
    reputacao = db.Column(db.Float)

    def __init__(self, email, senha, nome, curso, reputacao):

        self.email = email
        self.senha = senha
        self.nome = nome
        self.curso = curso
        self.reputacao = reputacao

    def att_reputacao(self):
        n = 0
        total = 0

        q1 = Anuncio.query.filter_by(anunciante=self.id).all()
        for a in q1:
            q2 = Transacao.query.filter_by(anuncio=a.id).all()
            for t in q2:
                if t.nota_interessado is not None:  # Verifica se não é None
                    total += t.nota_interessado
                    n += 1

        q3 = Transacao.query.filter_by(interessado=self.id).all()
        for t in q3:
            if t.nota_anunciante is not None:  # Verifica se não é None
                total += t.nota_anunciante
                n += 1

        if n > 0:  # Evita divisão por zero
            self.reputacao = total / n
        else:
            self.reputacao = 0  # Define reputação como 0 caso não haja notas
        commit()

    def add_anuncio(self, anuncio):
        add(anuncio)
        commit()

    # def add_conversa(self, conversa):
    #     add(conversa)
    #     commit()
