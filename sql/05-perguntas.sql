-- PostgreSQL 16. Consultas complementares cobrem todos os subitens do PDF.
-- AVG ignora NULL; percentuais usam divisao decimal; arredondamento so na exibicao.

-- P1_rede
SELECT ROUND(AVG(dias_integracao_separacao),2) AS integracao_separacao,
ROUND(AVG(dias_separacao_nota),2) AS separacao_nota,
ROUND(AVG(dias_nota_despacho),2) AS nota_despacho,
ROUND(AVG(dias_despacho_entrega),2) AS despacho_entrega,
ROUND(AVG(dias_total_ate_entrega),2) AS total_erp_entrega,
COUNT(dias_total_ate_entrega) AS entregas_concluidas FROM fato_pedido;

-- P1_portes
SELECT l.porte, COUNT(*) AS pedidos,
ROUND(AVG(f.dias_integracao_separacao),2) AS integracao_separacao,
ROUND(AVG(f.dias_separacao_nota),2) AS separacao_nota,
ROUND(AVG(f.dias_nota_despacho),2) AS nota_despacho,
ROUND(AVG(f.dias_despacho_entrega),2) AS despacho_entrega,
ROUND(AVG(f.dias_total_ate_entrega),2) AS total_erp_entrega,
COUNT(f.dias_total_ate_entrega) AS entregas_concluidas
FROM fato_pedido f JOIN dim_loja l ON l.sk_loja=f.sk_loja
GROUP BY l.porte ORDER BY l.porte;

-- P2_categorias
SELECT c.nome_categoria, ROUND(SUM(f.vl_liquido),2) AS faturamento,
ROUND(100.0*SUM(f.vl_liquido)/(SELECT SUM(vl_liquido) FROM fato_pedido),2) AS percentual_rede
FROM fato_pedido f JOIN dim_categoria c ON c.sk_categoria=f.sk_categoria
GROUP BY c.nome_categoria ORDER BY faturamento DESC;

-- P2_portes
SELECT l.porte, c.nome_categoria, ROUND(SUM(f.vl_liquido),2) AS faturamento
FROM fato_pedido f JOIN dim_categoria c ON c.sk_categoria=f.sk_categoria
JOIN dim_loja l ON l.sk_loja=f.sk_loja
GROUP BY l.porte,c.nome_categoria ORDER BY l.porte,faturamento DESC;

-- P3_desconto
SELECT canal_pedido, houve_desconto, COUNT(*) AS pedidos,
COUNT(vl_liquido) AS pedidos_com_valor, ROUND(AVG(vl_liquido),2) AS ticket_medio,
ROUND(SUM(vl_liquido),2) AS faturamento
FROM fato_pedido GROUP BY canal_pedido,houve_desconto ORDER BY canal_pedido,houve_desconto;

-- P3_canais
SELECT canal_pedido, COUNT(*) AS pedidos, ROUND(SUM(vl_liquido),2) AS faturamento,
ROUND(100.0*SUM(vl_liquido)/(SELECT SUM(vl_liquido) FROM fato_pedido),2) AS percentual_rede
FROM fato_pedido GROUP BY canal_pedido ORDER BY faturamento DESC;

-- P4_pracas
SELECT d.cod_praca, d.nome_praca, d.domicilios_com_pet,
ROUND(SUM(f.vl_liquido*b.fator_publico),2) AS faturamento_rateado,
ROUND(100.0*SUM(f.vl_liquido*b.fator_publico)/(SELECT SUM(vl_liquido) FROM fato_pedido),2) AS percentual_rede,
ROUND(100.0*d.domicilios_com_pet/(SELECT SUM(domicilios_com_pet) FROM dim_praca WHERE sk_praca <> -1),2) AS percentual_domicilios,
ROUND(SUM(f.vl_liquido*b.fator_publico)/d.domicilios_com_pet,2) AS reais_por_domicilio
FROM fato_pedido f JOIN dim_loja l ON l.sk_loja=f.sk_loja
JOIN bridge_loja_praca b ON b.cod_loja=l.cod_loja
JOIN dim_praca d ON d.sk_praca=b.sk_praca
GROUP BY d.cod_praca,d.nome_praca,d.domicilios_com_pet ORDER BY faturamento_rateado DESC;

-- P4_sem_loja
SELECT COUNT(*) AS pedidos_sem_loja, ROUND(SUM(vl_liquido),2) AS faturamento_sem_praca
FROM fato_pedido WHERE sk_loja=-1;

-- P4_reconciliacao
SELECT (SELECT SUM(vl_liquido) FROM fato_pedido) AS total_rede,
(SELECT SUM(f.vl_liquido*b.fator_publico) FROM fato_pedido f JOIN dim_loja l ON l.sk_loja=f.sk_loja JOIN bridge_loja_praca b ON b.cod_loja=l.cod_loja) AS total_rateado,
(SELECT SUM(vl_liquido) FROM fato_pedido WHERE sk_loja=-1) AS sem_loja,
ROUND((SELECT SUM(vl_liquido) FROM fato_pedido)
- (SELECT SUM(f.vl_liquido*b.fator_publico) FROM fato_pedido f JOIN dim_loja l ON l.sk_loja=f.sk_loja JOIN bridge_loja_praca b ON b.cod_loja=l.cod_loja)
- (SELECT SUM(vl_liquido) FROM fato_pedido WHERE sk_loja=-1),2) AS diferenca;

-- P5a_ranking
SELECT l.cod_loja,l.nome_loja,l.cidade,l.populacao_cidade,
SUM(f.qt_itens) AS itens, ROUND(1000.0*SUM(f.qt_itens)/l.populacao_cidade,2) AS itens_por_mil_habitantes,
ROUND(AVG(f.dias_total_ate_entrega),2) AS dias_entrega,
COUNT(*) AS pedidos, COUNT(f.qt_itens) AS pedidos_com_itens,
COUNT(f.dias_total_ate_entrega) AS entregas_concluidas
FROM fato_pedido f JOIN dim_loja l ON l.sk_loja=f.sk_loja
WHERE l.sk_loja <> -1 AND l.populacao_cidade > 0
GROUP BY l.cod_loja,l.nome_loja,l.cidade,l.populacao_cidade
ORDER BY itens_por_mil_habitantes DESC,l.cod_loja;

-- P5b_franquia
SELECT l.faixa_franquia, COUNT(*) AS pedidos, ROUND(SUM(f.vl_liquido),2) AS faturamento,
ROUND(100.0*SUM(f.vl_liquido)/(SELECT SUM(vl_liquido) FROM fato_pedido),2) AS percentual_rede
FROM fato_pedido f JOIN dim_loja l ON l.sk_loja=f.sk_loja
GROUP BY l.faixa_franquia ORDER BY faturamento DESC;

-- P5c_ausencias
SELECT COUNT(*) AS pedidos,
SUM(CASE WHEN sk_loja=-1 THEN 1 ELSE 0 END) AS sem_loja,
SUM(CASE WHEN sk_tempo_entrega=-1 THEN 1 ELSE 0 END) AS sem_entrega,
SUM(CASE WHEN qt_itens IS NULL THEN 1 ELSE 0 END) AS sem_itens,
SUM(CASE WHEN vl_liquido IS NULL THEN 1 ELSE 0 END) AS sem_valor,
ROUND(100.0*SUM(CASE WHEN sk_tempo_entrega=-1 THEN 1 ELSE 0 END)/COUNT(*),2) AS percentual_sem_entrega,
ROUND(100.0*SUM(CASE WHEN qt_itens IS NULL THEN 1 ELSE 0 END)/COUNT(*),2) AS percentual_sem_itens,
ROUND(100.0*SUM(CASE WHEN vl_liquido IS NULL THEN 1 ELSE 0 END)/COUNT(*),2) AS percentual_sem_valor
FROM fato_pedido;
