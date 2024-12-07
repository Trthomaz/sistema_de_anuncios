from app.models import *

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
            
            historico = Anuncio.query.filter_by(id=self.id).all()

            n = total = 0
            for a in historico:
                
                if not a.ativo:
                    total += a.nota ### FALHA. HÁ APENAS UMA NOTA POR ANÚNCIO
                    n += 1

            self.reputacacao = total/n

    def add_anuncio(self, anuncio):
        add(anuncio)
        commit()

    def add_conversa(self, conversa):
        add(conversa)
        commit()
