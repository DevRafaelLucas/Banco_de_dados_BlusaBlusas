# Sistema de Banco de Dados - BlusaBlusas

## Introdução
Este projeto representa o modelo de banco de dados do sistema BlusaBlusas, voltado para gestão de vendas dos produtos de vestuário. O banco foi desenvolvido em MySQL e possui tabelas, inserções de dados, triggers e views para controle completo de operações comerciais.

---

## Tabelas
O banco de dados é composto pelas seguintes tabelas:

**pessoa, endereco, telefone, login, usuario, descricao, produto, historico_preco, nota_fiscal, pagamento, venda, itens_venda, administrador, pessoas_deletadas, produtos_deletados, vendas_deletadas**

Cada tabela foi projetada com integridade referencial, utilizando chaves primárias e estrangeiras para garantir consistência dos dados.

---

## Inserts
O script inclui comandos `INSERT` para popular as tabelas com dados de exemplo, permitindo testes e validações do modelo.

---

## Triggers
As triggers implementadas automatizam processos e garantem integridade lógica:

**historico_preco_new_old, trg_historico_pessoas_deletadas, trg_historicos_produtos_deletados, trg_historico_vendas_deletadas, trg_retornar_quantidade_estoque, trg_atualizar_vendas, atualiza_valor_itens_venda, trg_atualizar_valor_vendas**

Essas triggers realizam ações como:
- Registro de histórico de preços
- Backup de dados deletados
- Atualização automática de estoque e valores de venda

---

## Views
As views facilitam a geração de relatórios e visualização de dados:

**relatorio_precos, CadastroProduto**

- `relatorio_precos`: exibe os produtos ordenados pelos mais vendidos
- `CadastroProduto`: apresenta os dados completos dos produtos cadastrados

---

## Considerações Finais
Este banco de dados foi estruturado com foco em escalabilidade, integridade e automação. Ideal para sistemas comerciais que exigem controle detalhado de vendas, produtos e usuários.
