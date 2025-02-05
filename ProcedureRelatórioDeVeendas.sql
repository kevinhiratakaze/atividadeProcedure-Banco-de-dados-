-- Database: projetoVenda

-- DROP DATABASE IF EXISTS "projetoVenda";

CREATE DATABASE "projetoVenda";

Use "projetovenda";


-- Criação das tabelas
CREATE TABLE produtos (
    id_produto SERIAL PRIMARY KEY,
    nome_produto VARCHAR(100) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL
);

CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome_cliente VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(15)
);


CREATE TABLE vendas (
    id_venda SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_venda DATE NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE itens_venda (
    id_item SERIAL PRIMARY KEY,
    id_venda INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_venda) REFERENCES vendas(id_venda),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

INSERT INTO produtos (nome_produto, preco, estoque) VALUES 
('Produto A', 10.00, 100),
('Produto B', 20.00, 200),
('Produto C', 15.00, 150);

INSERT INTO clientes (nome_cliente, email, telefone) VALUES 
('João Silva', 'joao@email.com', '1111-2222'),
('Maria Souza', 'maria@email.com', '3333-4444'),
('Carlos Pereira', 'carlos@email.com', '5555-6666');

INSERT INTO vendas (id_cliente, data_venda, valor_total) VALUES 
(1, '2025-02-01', 50.00),
(2, '2025-02-01', 40.00),
(3, '2025-02-02', 75.00);


INSERT INTO itens_venda (id_venda, id_produto, quantidade, preco_unitario) VALUES 
(1, 1, 3, 10.00),
(1, 2, 2, 20.00),
(2, 2, 2, 20.00),
(3, 3, 5, 15.00);


-- Criar a Procedure para gerar o relatório diário
CREATE OR REPLACE PROCEDURE Relatorio_Diario()
LANGUAGE plpgsql
AS $$
DECLARE
    row RECORD;
BEGIN
    RAISE NOTICE 'Relatório Diário:';
    RAISE NOTICE 'Data Venda | Total Produtos Vendidos';
    
    FOR row IN 
        SELECT 
            data_venda, 
            SUM(quantidade) AS total_produtos_vendidos
        FROM itens_venda
        JOIN vendas ON itens_venda.id_venda = vendas.id_venda
        GROUP BY data_venda
        ORDER BY data_venda
    LOOP
        RAISE NOTICE '% | %', row.data_venda, row.total_produtos_vendidos;
    END LOOP;
END;
$$;

CALL Relatorio_Diario();

