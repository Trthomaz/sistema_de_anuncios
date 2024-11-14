def Anuncio():
    
    def __init__(self, anunciante, descricao, telefone, email, local, categoria, ativo, tipo = "Compra", nota = 5): #Ver como puxar imagem

        self.anunciante = anunciante
        self.descricao = descricao
        self.telefone = telefone
        self.email = email
        self.local = local
        self.categoria = categoria

        self.nota = nota
        self.ativo = ativo

    def arquivar(self):

        self.ativo = False