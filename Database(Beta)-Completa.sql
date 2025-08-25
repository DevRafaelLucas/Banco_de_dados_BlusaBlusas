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

-- INSERTS --

INSERT INTO pessoa (nome, email, cpf, genero, data_nascimento)
VALUES ('Ana Silva', 'ana@email.com', '12345678900', 'feminino', '1990-05-15');
SELECT * FROM pessoa;

INSERT INTO telefone (ddd, numero, tipo, id_pessoa)
VALUES ('11', '912345678', 'celular', 1),
       ('11', '31234567', 'residencial', 1);
SELECT * FROM telefone;       

INSERT INTO endereco (rua, cidade, bairro, uf, cep, numero, id_pessoa)
VALUES ('Rua A', 'Sâo Paulo', 'centro', 'SP', '01000-000', '123', 1);
SELECT * FROM endereco;

INSERT INTO usuario (data_inicio, data_fim, desconto, fidelidade, id_pessoa)
VALUES ('2024-01-01', '2025-01-01', 5.00, null, 1);
SELECT * FROM usuario;

INSERT INTO login (usuario, senha_hash, id_pessoa)
VALUES ('ana.silva', 'HASH123456', 1);
SELECT * FROM login;

INSERT INTO descricao (descricao, cor, tecido, tamanho, categoria, imagem_url)
VALUES ('Camiseta básica', 'Amarela', 'Algodão', 'M', 'Vestuario', 'https://imagem.com/camisa.jpg'),
('Camiseta termica', 'Preto', 'Algodão', 'P', 'Vestuario', 'https://imagem.com/camisa.jpg'),
('Camiseta básica', 'Azul', 'Aalha', 'G', 'Vestuario', 'https://imagem.com/camisa.jpg');
SELECT * FROM descricao;

INSERT INTO produto (denominacao, quantidade_estoque, preco, situacao, id_descricao)
VALUES ('Camisa simples', 100, 0.90, 'ativo', 1),
		('Camisa Marvel Hulk', 100, 59.90, 'ativo', 2),
		('Camisa The Walking Dead', 100, 1.00, 'ativo', 3);
SELECT * FROM produto;

INSERT INTO pagamento (parcela, valor)
VALUES (1, 59.90);
SELECT * FROM pagamento;

INSERT INTO nota_fiscal (numero_nota, valor_total)
VALUES ('NF123', 59.90);
SELECT * FROM nota_fiscal;

INSERT INTO venda (desconto, acrescimo, cupom, valor_total, id_usuario, id_pagamento, id_nota_fiscal)
VALUES (0, 0, 'PROMO10', 59.90, 1, 1, 1);
SELECT * FROM venda;

INSERT INTO itens_venda (desconto, acrescimo, quantidade_venda, preco, valor_total, id_produto, id_venda)
VALUES (0, 0, 2, 60.00, 120.00, 1, 1);
SELECT * FROM itens_venda;

INSERT INTO movimentacao_caixa (tipo, origem, valor, descricao, id_venda)
VALUES ('Entrada', 'Venda Camiseta', 59.90, 'Venda do produto Camisa Preta M', 1);
SELECT * FROM movimentacao_caixa;

INSERT INTO administrador (matricula, cargo, salario, situacao, id_pessoa, id_movimentacao_caixa)
VALUES ('ADM001', 'Gerente Financeiro', 350.00, 'Ativo', 1, 1);
SELECT * FROM administrador;

-- TRIGGERS --

-- Desabilitando verificação de chaves estrageiras para evitar problema  na execução de triggers que estiverem com atributos ligados, se necessario, pode ativar novamente.
SET FOREIGN_KEY_CHECKS = 0;

-- Salvando historico de comparação de preços antigos e novos de um produto.
DELIMITER // -- Ok
CREATE TRIGGER historico_preco_new_old
AFTER UPDATE ON produto 
FOR EACH ROW
BEGIN 
    IF (OLD.preco <> NEW.preco) THEN
        INSERT INTO historico_preco (preco_antigo, preco_novo, id_produto)
        VALUES (OLD.preco, NEW.preco, NEW.id_produto);
    END IF;
END;
//
DELIMITER ;
-- Testando Trigger:
/* SELECT * FROM produto;
UPDATE produto SET preco = 2.00 WHERE id_produto = 1; 
SELECT * FROM historico_preco; */


/* Jogando os dados de pessoas deletadas na tabela 'pessoas_deletadas' */
DELIMITER // 
CREATE TRIGGER trg_historico_pessoas_deletadas
AFTER DELETE ON pessoa 
FOR EACH ROW
BEGIN
    INSERT INTO pessoas_deletadas (
        id_pessoa, nome, email, cpf, genero, data_nascimento, data_cadastro, situacao
    )
    VALUES (
        OLD.id_pessoa, OLD.nome, OLD.email, OLD.cpf, OLD.genero, OLD.data_nascimento, OLD.data_cadastro, OLD.situacao
    );
END;
//
DELIMITER ;
-- Testando Trigger:
/* SELECT * FROM pessoa;
DELETE FROM pessoa WHERE id_pessoa = 1; 
SELECT * FROM pessoas_deletadas; */


/* Jogando os dados dos produtos deletados na tabela 'produtos_deletados' */
DELIMITER // 
CREATE TRIGGER trg_historicos_produtos_deletados
AFTER DELETE ON produto 
FOR EACH ROW
BEGIN
    INSERT INTO produtos_deletados (
        id_produto, denominacao, quantidade_estoque, preco, situacao, id_descricao
    )
    VALUES (
        OLD.id_produto, OLD.denominacao, OLD.quantidade_estoque, OLD.preco, OLD.situacao, OLD.id_descricao
    );
END;
//
DELIMITER ;
-- Testando Trigger:
/* SELECT * FROM produto;
DELETE FROM produto WHERE id_produto = 4;
SELECT * FROM produtos_deletados; */


DELIMITER // 
CREATE TRIGGER trg_historico_vendas_deletadas
AFTER DELETE ON venda 
FOR EACH ROW
BEGIN
    INSERT INTO vendas_deletadas (
        id_venda, desconto, acrescimo, cupom, data_compra, valor_total, situacao
    )
    VALUES (
        OLD.id_venda, OLD.desconto, OLD.acrescimo, OLD.cupom, OLD.data_compra, OLD.valor_total, OLD.situacao
    );
END;
//
DELIMITER ;
-- Testando Trigger:
/* SELECT * FROM venda;
DELETE FROM venda WHERE id_venda = 2;
SELECT * FROM vendas_deletadas; */


/* Se um item de venda for cancelado ele volta para o estoque */
DELIMITER //
CREATE TRIGGER trg_retornar_quantidade_estoque 
AFTER UPDATE ON itens_venda 
FOR EACH ROW
BEGIN
    IF (NEW.situacao = 'cancelado') THEN
        UPDATE produto 
         SET quantidade_estoque = (quantidade_estoque + OLD.quantidade_venda) 
         WHERE id_produto = NEW.id_produto; -- Explicação: Soma a quantidade de estoque anterior com a nova quantidade estoque da tabela 'produto' e atualiza o 'id_produto'
    END IF;
END;
//
DELIMITER ;
-- Testando Trigger:
/* SELECT * FROM itens_venda;
UPDATE itens_venda SET situacao = 'cancelada' WHERE id_itens_venda = 1;
SELECT * FROM produto; */


-- Se caso algum produto de 'itens_venda' for cancelado, então ele vai atualizar e mostrar uma nova soma de todos os produtos que estão na 'venda'.
DELIMITER //
CREATE TRIGGER trg_atualizar_vendas
AFTER UPDATE ON itens_venda 
FOR EACH ROW 
BEGIN      
	IF (NEW.situacao = 'cancelado') THEN         
		 UPDATE venda
        SET valor_total = (SELECT SUM(iv.valor_total)
            FROM itens_venda iv
            WHERE iv.id_venda = NEW.id_venda AND iv.situacao <> 'cancelado')
        WHERE id_venda = NEW.id_venda;
	END IF; 
END;
//
DELIMITER ;
-- Testando Trigger:
/* SELECT * FROM itens_venda;
SELECT * FROM venda;
UPDATE itens_venda SET situacao = 'cancelada' WHERE id_itens_venda = 1;
SELECT * FROM venda; */


/*Calcula valor total do item antes de inserir*/
DELIMITER // -- Ok
CREATE TRIGGER atualiza_valor_itens_venda
BEFORE INSERT ON itens_venda 
FOR EACH ROW
BEGIN
    DECLARE preco_produto DECIMAL(5,2);
    SET preco_produto = (SELECT preco FROM produto WHERE id_produto = NEW.id_produto);
    SET NEW.preco = preco_produto;
    SET NEW.valor_total = (NEW.preco * NEW.quantidade_venda) - NEW.desconto + NEW.acrescimo;
END;
//
DELIMITER ;
-- Testando Trigger:
 SELECT * FROM itens_venda;
 SELECT * FROM produto;*/

/* Vai haver uma separação do que é cancelado e do que está em andamento, os que estiverem em andamento serão somados e salvos em valor total da venda */
DELIMITER // -- Ok
CREATE TRIGGER trg_atualizar_valor_vendas
AFTER INSERT ON itens_venda
FOR EACH ROW
BEGIN
    UPDATE venda
    SET valor_total = (
        SELECT SUM(iv.valor_total)
        FROM itens_venda iv
        WHERE iv.id_venda = NEW.id_venda AND iv.situacao <> 'cancelado'
    )
    WHERE id_venda = NEW.id_venda;
END;
//
DELIMITER ;
-- Testando Trigger:
/* SELECT * FROM venda; */


-- !RELATORIOS! --

-- Produtos em ordem dos mais vendidos
CREATE VIEW relatorio_precos AS
SELECT p.denominacao AS Produto, p.preco AS Preço, iv.valor_total AS valor_total FROM itens_venda iv
INNER JOIN produto p ON p.id_produto = iv.id_produto
ORDER BY valor_total DESC;
/* SELECT * FROM relatorio_precos;
SELECT * FROM itens_venda; */

-- Exibe os dados do produto cadastrado
CREATE VIEW CadastroProduto AS  
SELECT p.id_produto AS Codigo,
p.denominacao AS Produto,
p.quantidade_estoque AS QuantidadenoEstoque,
p.preco AS Preço,
p.situacao AS SituacaoProduto,
d.descricao AS Descrição,
d.cor AS Cor,
d.tecido AS Tecido,
d.tamanho AS Tamanho,
d.categoria AS Categoria,
d.imagem_url AS URL 
FROM produto p
INNER JOIN descricao d ON d.id_descricao = p.id_descricao;
/* SELECT * FROM CadastroProduto; 
SELECT * FROM descricao; 
SELECT * FROM venda;*/