CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    data_compra DATE NOT NULL
);


CREATE TABLE relatorio_diario (
    id SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    total_produtos INT NOT NULL,
    data_geracao TIMESTAMP DEFAULT NOW()
);

CREATE OR REPLACE PROCEDURE gerar_relatorio_diario()
LANGUAGE plpgsql
AS $$
BEGIN
 
    INSERT INTO relatorio_diario (data, total_produtos)
    SELECT 
        data_compra AS data, 
        SUM(quantidade) AS total_produtos
    FROM pedidos
    WHERE data_compra = CURRENT_DATE
    GROUP BY data_compra;

    RAISE NOTICE 'Relatório diário gerado com sucesso!';
END;
$$;

CALL gerar_relatorio_diario();

0 0 * * * psql -U usuario -d nome_do_banco -c "CALL gerar_relatorio_diario();"
