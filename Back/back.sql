START TRANSACTION;

CREATE TABLE alembic_version (
    version_num VARCHAR(32) NOT NULL, 
    CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)
);

INSERT INTO alembic_version VALUES('fcd5279e1602');

CREATE TABLE categorias (
    id INT NOT NULL, 
    categoria VARCHAR(255),  -- Definir comprimento máximo para o VARCHAR
    PRIMARY KEY (id), 
    UNIQUE (categoria)
);

CREATE TABLE perfis (
    id INT NOT NULL, 
    email VARCHAR(255),  -- Definir comprimento máximo para o VARCHAR
    senha INT,  -- Usar INT para senha
    nome VARCHAR(255),  -- Definir comprimento máximo para o VARCHAR
    curso VARCHAR(255),  -- Definir comprimento máximo para o VARCHAR
    reputacao FLOAT, 
    PRIMARY KEY (id)
);

INSERT INTO perfis VALUES(1,'lmeato@id.uff.br',1234,'Leo','CC',5.0);
INSERT INTO perfis VALUES(2,'lmeato@id.uff.br',1234,'Leo','CC',5.0);

CREATE TABLE tipos (
    id INT NOT NULL, 
    tipo VARCHAR(255),  -- Definir comprimento máximo para o VARCHAR
    PRIMARY KEY (id), 
    UNIQUE (tipo)
);

CREATE TABLE anuncios (
    id INT NOT NULL, 
    anunciante INT, 
    descricao TEXT,  -- TEXT já é suportado no MySQL
    telefone VARCHAR(255),  -- Definir comprimento máximo para o VARCHAR
    local VARCHAR(255),  -- Definir comprimento máximo para o VARCHAR
    categoria INT, 
    tipo INT, 
    nota INT, 
    ativo TINYINT(1),  -- BOOLEAN no SQLite deve ser convertido para TINYINT(1) no MySQL
    PRIMARY KEY (id), 
    FOREIGN KEY (anunciante) REFERENCES perfis (id), 
    FOREIGN KEY (categoria) REFERENCES categorias (id), 
    FOREIGN KEY (tipo) REFERENCES tipos (id)
);

CREATE TABLE conversas (
    id INT NOT NULL, 
    interessado INT, 
    anunciante INT, 
    arquivada TINYINT(1),  -- BOOLEAN no SQLite deve ser convertido para TINYINT(1) no MySQL
    PRIMARY KEY (id), 
    FOREIGN KEY (anunciante) REFERENCES perfis (id), 
    FOREIGN KEY (interessado) REFERENCES perfis (id)
);

CREATE TABLE mensagens (
    id INT NOT NULL, 
    user INT, 
    txt TEXT,  -- TEXT já é suportado no MySQL
    date DATETIME,  -- DATETIME é o tipo correto no MySQL
    conversa INT, 
    PRIMARY KEY (id), 
    FOREIGN KEY (conversa) REFERENCES conversas (id), 
    FOREIGN KEY (user) REFERENCES perfis (id)
);

COMMIT;

