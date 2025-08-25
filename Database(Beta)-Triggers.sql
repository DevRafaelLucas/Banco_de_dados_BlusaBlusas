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
