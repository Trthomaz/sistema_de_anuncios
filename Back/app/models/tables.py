from app import db

#Fazer aqui as classes do banco de dados (a definir)

class Anuncio(db.Model):
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