-- Execute apos 01 a 05. Consultas somente leitura.
-- Contagens principais: 4044 linhas e 4044 pedidos distintos.
SELECT COUNT(*) AS linhas, COUNT(DISTINCT numero_pedido) AS pedidos_distintos FROM fato_pedido;
-- Cada consulta de erros abaixo deve retornar zero.
SELECT COUNT(*) AS fk_pedido_orfa FROM fato_pedido f LEFT JOIN dim_tempo t ON t.sk_tempo=f.sk_tempo_pedido WHERE t.sk_tempo IS NULL;
SELECT COUNT(*) AS fk_entrega_orfa FROM fato_pedido f LEFT JOIN dim_tempo t ON t.sk_tempo=f.sk_tempo_entrega WHERE t.sk_tempo IS NULL;
SELECT COUNT(*) AS fk_loja_orfa FROM fato_pedido f LEFT JOIN dim_loja l ON l.sk_loja=f.sk_loja WHERE l.sk_loja IS NULL;
SELECT COUNT(*) AS fk_categoria_orfa FROM fato_pedido f LEFT JOIN dim_categoria c ON c.sk_categoria=f.sk_categoria WHERE c.sk_categoria IS NULL;
SELECT COUNT(*) AS ponte_loja_orfa FROM bridge_loja_praca b LEFT JOIN dim_loja l ON l.cod_loja=b.cod_loja WHERE l.sk_loja IS NULL;
SELECT COUNT(*) AS ponte_praca_orfa FROM bridge_loja_praca b LEFT JOIN dim_praca d ON d.sk_praca=b.sk_praca WHERE d.sk_praca IS NULL;
-- Nenhuma linha: de-para e ponte sem duplicacoes e fatores validos.
SELECT categoria_origem,COUNT(*) FROM dim_categoria GROUP BY categoria_origem HAVING COUNT(*)>1;
SELECT chave_loja,COUNT(*) FROM dim_loja GROUP BY chave_loja HAVING COUNT(*)>1;
SELECT cod_loja,SUM(fator_publico) FROM bridge_loja_praca GROUP BY cod_loja HAVING SUM(fator_publico)<>1;
SELECT * FROM bridge_loja_praca WHERE fator_publico<=0 OR fator_publico>1;
-- Os atributos de uma praca devem ser constantes: nenhuma linha.
SELECT "CodPraca" FROM stg_loja_praca GROUP BY "CodPraca"
HAVING COUNT(DISTINCT "NomePraca")>1 OR COUNT(DISTINCT "Regional")>1 OR COUNT(DISTINCT "DomiciliosComPet")>1;
-- Zero: nenhum intervalo negativo e nenhum prazo final presente sem entrega.
SELECT COUNT(*) AS dias_negativos FROM fato_pedido
WHERE dias_integracao_separacao<0 OR dias_separacao_nota<0 OR dias_nota_despacho<0 OR dias_despacho_entrega<0 OR dias_total_ate_entrega<0;
SELECT COUNT(*) AS entrega_ausente_com_dias FROM fato_pedido WHERE sk_tempo_entrega=-1 AND dias_total_ate_entrega IS NOT NULL;
-- Primeiro e ultimo pedido: 2023-09-01 e 2024-03-31 (ordenacao cronologica).
SELECT CAST(dt_pedido AS DATE) AS data_pedido,COUNT(*) AS pedidos FROM fato_pedido GROUP BY CAST(dt_pedido AS DATE) ORDER BY data_pedido;
-- Datas fora da janela: zero.
SELECT COUNT(*) AS fora_da_janela FROM fato_pedido WHERE CAST(dt_pedido AS DATE)<'2023-09-01' OR CAST(dt_pedido AS DATE)>'2024-03-31';
-- Total conhecido 1793308.51; referencia arredondada do professor 1793309.
SELECT SUM(vl_liquido) AS total_exato,ROUND(SUM(vl_liquido)) AS total_arredondado FROM fato_pedido;
-- Origem tratada de maneira equivalente: deve igualar o total acima.
SELECT SUM(CASE WHEN TRIM(REPLACE("ValorLiquidoPedido(R$)",'R$','')) IN ('','-') THEN NULL
WHEN "ValorLiquidoPedido(R$)" LIKE '%,%' THEN CAST(REPLACE(REPLACE(REPLACE(REPLACE("ValorLiquidoPedido(R$)",'R$',''),' ',''),'.',''),',','.') AS DECIMAL(15,2))
ELSE CAST(REPLACE(REPLACE("ValorLiquidoPedido(R$)",'R$',''),' ','') AS DECIMAL(15,2)) END) AS total_origem FROM stg_pedido;
-- Para rateio e ausencias, execute P4_reconciliacao e P5c_ausencias no 05.
