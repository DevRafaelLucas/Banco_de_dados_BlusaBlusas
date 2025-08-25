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