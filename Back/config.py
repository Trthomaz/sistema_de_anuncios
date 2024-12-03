# import os
# basedir = os.path.abspath(os.path.dirname(__file__))
# #SQLALCHEMY_DATABASE_URI = 'sqlite:///storage.db'
# SQLALCHEMY_DATABASE_URI = 'sqlite:///'+os.path.join(basedir,'storage.db')


SQLALCHEMY_DATABASE_URI = 'mysql://root:ferrari1921@localhost/banco_mysql'


SQLALCHEMY_TRACK_MODIFICATIONS = False

#Configuracoes da ligacao do banco de dados