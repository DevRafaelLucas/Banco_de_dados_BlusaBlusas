-- DROP DATABASE vendasBlusaBlusas; 
CREATE DATABASE vendasBlusaBlusas;
USE vendasBlusaBlusas;
-- SHOW TABLES;
-- SHOW DATABASES; 

-- TABELAS --

CREATE TABLE pessoa (
    id_pessoa INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(20) NOT NULL,
    email VARCHAR(30) UNIQUE,
    cpf VARCHAR(15) NOT NULL UNIQUE,
    genero ENUM('masculino', 'feminino', 'outro') NOT NULL DEFAULT 'outro',
    data_nascimento DATE NOT NULL,
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    situacao ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo'
);

CREATE TABLE endereco (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    rua VARCHAR(30) NOT NULL,
    cidade VARCHAR(30) NOT NULL,
    bairro VARCHAR(30) NOT NULL,
    uf CHAR(2) NOT NULL,
    cep VARCHAR(10) NOT NULL,
    complemento VARCHAR(20),
    numero VARCHAR(10) NOT NULL,
    tipo_endereco ENUM('residencial', 'comercial') NOT NULL DEFAULT 'residencial',
    situacao ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo',
    id_pessoa INT NOT NULL,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

CREATE TABLE telefone (
    id_telefone INT AUTO_INCREMENT PRIMARY KEY,
    ddd CHAR(2) NOT NULL,
    numero VARCHAR(9) NOT NULL,
    tipo ENUM('residencial', 'celular', 'comercial') NOT NULL DEFAULT 'celular',
    situacao ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo',
    id_pessoa INT NOT NULL,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

CREATE TABLE login (
    id_login INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(20) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    tentativas_login INT NOT NULL DEFAULT 0,
    alterar_senha CHAR(1) NOT NULL DEFAULT 'N',
    tipo_usuario ENUM('admin', 'normal') NOT NULL DEFAULT 'normal',
    data_acesso DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_saida DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    situacao ENUM('ativo', 'inativo', 'bloqueado') NOT NULL DEFAULT 'ativo',
    id_pessoa INT NOT NULL,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    desconto DECIMAL(5,2),
    fidelidade VARCHAR (20),
    id_pessoa INT NOT NULL,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

CREATE TABLE descricao (
    id_descricao INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL,
    cor VARCHAR(10) NOT NULL,
    tecido VARCHAR(15) NOT NULL,
    tamanho ENUM('PP', 'P', 'M', 'G', 'GG') NOT NULL DEFAULT 'P', -- Exeção para letras minusculas
    categoria VARCHAR(20) NOT NULL,
    imagem_url VARCHAR(255)
);

CREATE TABLE produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
	denominacao VARCHAR(30) NOT NULL,
    quantidade_estoque INT NOT NULL,
    preco DECIMAL(5,2) NOT NULL,
    situacao ENUM('ativo', 'esgotado', 'descontinuado') NOT NULL DEFAULT 'ativo',
    id_descricao INT NOT NULL,
    FOREIGN KEY (id_descricao) REFERENCES descricao(id_descricao)
    
);

CREATE TABLE historico_preco (
    id_historico_preco INT AUTO_INCREMENT PRIMARY KEY,
    data_alteracao DATETIME DEFAULT CURRENT_TIMESTAMP,
    preco_antigo DECIMAL(5,2) NOT NULL,
    preco_novo DECIMAL(5,2) NOT NULL,
    id_produto INT NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

CREATE TABLE nota_fiscal (
    id_nota_fiscal INT AUTO_INCREMENT PRIMARY KEY,
    numero_nota VARCHAR(50) NOT NULL,
    data_emissao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(5,2) NOT NULL
);

CREATE TABLE pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    parcela INT NOT NULL,
    valor DECIMAL(5,2) NOT NULL,
    data_pagamento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    forma_pagamento ENUM('debito', 'credito', 'boleto', 'pix') NOT NULL DEFAULT 'pix',
    situacao ENUM('pendente', 'pago', 'cancelado') NOT NULL DEFAULT 'pendente'
);

CREATE TABLE venda (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    desconto DECIMAL(5,2),
    acrescimo DECIMAL(5,2),
    cupom VARCHAR(10),
    data_compra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(5,2) NOT NULL,
    situacao ENUM('confirmada', 'em andamento', 'cancelada') NOT NULL DEFAULT 'em andamento',
    id_usuario INT NOT NULL,
    id_pagamento INT NOT NULL,
    id_nota_fiscal INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_pagamento) REFERENCES pagamento(id_pagamento),
    FOREIGN KEY (id_nota_fiscal) REFERENCES nota_fiscal(id_nota_fiscal)
);

CREATE TABLE itens_venda (
    id_itens_venda INT AUTO_INCREMENT PRIMARY KEY,
    desconto DECIMAL(5,2),
    acrescimo DECIMAL(5,2),
    quantidade_venda INT NOT NULL,
    preco DECIMAL(5,2) NOT NULL,
    valor_total DECIMAL(5,2),
    situacao ENUM('confirmada', 'em andamento', 'cancelada') NOT NULL DEFAULT 'em andamento',
    id_produto INT NOT NULL,
    id_venda INT NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
    FOREIGN KEY (id_venda) REFERENCES venda(id_venda)
);

CREATE TABLE movimentacao_caixa (
    id_movimentacao_caixa INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('saida', 'entrada') NOT NULL DEFAULT 'entrada',
    origem VARCHAR(50) NOT NULL,
    valor DECIMAL(5,2) NOT NULL,
    data_movimentacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descricao TEXT,
    id_venda INT NOT NULL,
    FOREIGN KEY (id_venda) REFERENCES venda(id_venda)
);

CREATE TABLE administrador (
    id_administrador INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(20) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    salario DECIMAL(5,2),
    situacao VARCHAR(20) NOT NULL,
    id_pessoa INT NOT NULL,
    id_movimentacao_caixa INT NOT NULL,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

CREATE TABLE pessoas_deletadas (
    id_pessoa INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(20) NOT NULL,
    email VARCHAR(30) UNIQUE,
    cpf VARCHAR(15) NOT NULL UNIQUE,
    genero ENUM('masculino', 'feminino', 'outro') NOT NULL DEFAULT 'outro',
    data_nascimento DATE NOT NULL,
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    situacao ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo'
);

CREATE TABLE produtos_deletados (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
	denominacao VARCHAR(30) NOT NULL,
    quantidade_estoque INT NOT NULL,
    preco DECIMAL(5,2) NOT NULL,
    situacao ENUM('ativo', 'esgotado', 'descontinuado') NOT NULL DEFAULT 'ativo',
    id_descricao INT NOT NULL,
    FOREIGN KEY (id_descricao) REFERENCES descricao(id_descricao)
);

CREATE TABLE vendas_deletadas (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    desconto DECIMAL(5,2),
    acrescimo DECIMAL(5,2),
    cupom VARCHAR(10),
    data_compra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(5,2) NOT NULL,
    situacao ENUM('confirmada', 'em andamento', 'cancelada') NOT NULL DEFAULT 'em andamento'
);
