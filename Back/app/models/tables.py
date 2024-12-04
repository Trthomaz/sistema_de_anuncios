from app import db

#Fazer aqui as classes do banco de dados (a definir)

'''class Anuncio(db.Model):
    __tablename__ = "anuncios"

    id = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String)
    descricao = db.Column(db.String)

    def __init__(self, nome, descricao):
        self.nome = nome
        self.descricao = descricao
    
    def __repr__(self):
        return '<Anuncio %r>' % self.nome


class User(db.Model):
    __tablename__ = "users"

    email = db.Column(db.String, primary_key=True)
    name = db.Column(db.String)
    password = db.Column(db.String)

    def __init__(self, name, email, password):
        self.name = name
        self.email = email
        self.password = password
    
    def __repr__(self):
        return '<User %r>' % self.name
'''

#Example

# class User(db.Model):
#     __tablename__ = "users"

#     id = db.Column(db.Integer, primary_key=True)
#     username = db.Column(db.String, unique=True)
#     password = db.Column(db.String)
#     name = db.Column(db.String)
#     email = db.Column(db.String, unique=True)

#     def __init__(self, username, password, name, email):
#         self.username = username
#         self.password = password
#         self.name = name
#         self.email = email
    
#     def __repr__(self):
#         return "<User %r>" % self.name



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

        db.session.add(anuncio)
        db.session.commit()

    def add_conversa(self, conversa):

        db.session.add(conversa)
        db.session.commit()


class Categoria(db.Model):
    __tablename__ = "categorias"

    id = db.Column(db.Integer, primary_key=True)
    categoria = db.Column(db.String, unique=True)

    def __init__(self, categoria):
         self.categoria = categoria

class Tipo(db.Model):
    __tablename__ = "tipos"

    id = db.Column(db.Integer, primary_key=True)
    tipo = db.Column(db.String, unique=True)

    def __init__(self, tipo):
         self.tipo = tipo


class Anuncio(db.Model):
    __tablename__ = "anuncios"

    id = db.Column(db.Integer, primary_key=True)
    anunciante = db.Column(db.Integer, db.ForeignKey('perfis.id'))
    descricao = db.Column(db.Text)
    telefone = db.Column(db.String)
    #email?
    local = db.Column(db.String)
    categoria = db.Column(db.Integer, db.ForeignKey('categorias.id'))
    tipo = db.Column(db.Integer, db.ForeignKey('tipos.id'))

    nota = db.Column(db.Integer)
    ativo = db.Column(db.Boolean)

    #imagem

    def __init__(self, anunciante, descricao, telefone, local, categoria, ativo, tipo = 0, nota = 5): #Ver como puxar imagem

        self.anunciante = anunciante
        self.descricao = descricao
        self.telefone = telefone
        self.local = local
        self.categoria = categoria
        self.tipo = tipo

        self.nota = nota
        self.ativo = ativo

    def arquivar(self):
        self.ativo = False


class Mensagem(db.Model):
    __tablename__ = "mensagens"

    id = db.Column(db.Integer, primary_key=True)
    user = db.Column(db.Integer, db.ForeignKey('perfis.id'))
    txt = db.Column(db.Text)
    date = db.Column(db.DateTime)
    conversa = db.Column(db.Integer, db.ForeignKey('conversas.id'))

    def __init__(self, user, txt, date):

        self.user = user
        self.txt = txt
        self.date = date


class Conversa(db.Model):
    __tablename__ = "conversas"

    id = db.Column(db.Integer, primary_key=True)
    interessado = db.Column(db.Integer, db.ForeignKey('perfis.id'))
    anunciante = db.Column(db.Integer, db.ForeignKey('perfis.id'))
    arquivada = db.Column(db.Boolean)

    def __init__(self, interessado, anunciante):
                
            self.interessado = interessado
            self.anunciante = anunciante
            self.arquivada = False

    def add_msg(self, user, txt, date):

        if not self.arquivada:
            db.session.add(Mensagem(user, txt, date))
            db.session.commit()
    
    def arquivar(self):

                self.arquivada = True
