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