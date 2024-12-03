-- PRAGMA foreign_keys=OFF;
-- BEGIN TRANSACTION;
START TRANSACTION;
CREATE TABLE alembic_version (
	version_num VARCHAR(32) NOT NULL, 
	CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)
);
INSERT INTO alembic_version VALUES('fcd5279e1602');
CREATE TABLE categorias (
	id INTEGER NOT NULL, 
	categoria VARCHAR, 
	PRIMARY KEY (id), 
	UNIQUE (categoria)
);
CREATE TABLE perfis (
	id INTEGER NOT NULL, 
	email VARCHAR, 
	senha INTEGER, 
	nome VARCHAR, 
	curso VARCHAR, 
	reputacao FLOAT, 
	PRIMARY KEY (id)
);
INSERT INTO perfis VALUES(1,'lmeato@id.uff.br',1234,'Leo','CC',5.0);
INSERT INTO perfis VALUES(2,'lmeato@id.uff.br',1234,'Leo','CC',5.0);
CREATE TABLE tipos (
	id INTEGER NOT NULL, 
	tipo VARCHAR, 
	PRIMARY KEY (id), 
	UNIQUE (tipo)
);
CREATE TABLE anuncios (
	id INTEGER NOT NULL, 
	anunciante INTEGER, 
	descricao TEXT, 
	telefone VARCHAR, 
	local VARCHAR, 
	categoria INTEGER, 
	tipo INTEGER, 
	nota INTEGER, 
	ativo BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(anunciante) REFERENCES perfis (id), 
	FOREIGN KEY(categoria) REFERENCES categorias (id), 
	FOREIGN KEY(tipo) REFERENCES tipos (id)
);
CREATE TABLE conversas (
	id INTEGER NOT NULL, 
	interessado INTEGER, 
	anunciante INTEGER, 
	arquivada BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(anunciante) REFERENCES perfis (id), 
	FOREIGN KEY(interessado) REFERENCES perfis (id)
);
CREATE TABLE mensagens (
	id INTEGER NOT NULL, 
	user INTEGER, 
	txt TEXT, 
	date DATETIME, 
	conversa INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(conversa) REFERENCES conversas (id), 
	FOREIGN KEY(user) REFERENCES perfis (id)
);
COMMIT;
