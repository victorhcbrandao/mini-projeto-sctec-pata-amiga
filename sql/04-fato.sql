-- PostgreSQL 16. Um unico INSERT SELECT, sem subconsulta.
-- Grao: 1 linha = 1 pedido. Execute depois do 03, com a fato vazia.
-- NULL e ausencia de medida; -1 e membro desconhecido de dimensao.
INSERT INTO fato_pedido (
    numero_pedido, sk_tempo_pedido, sk_tempo_entrega, sk_loja, sk_categoria,
    houve_desconto, canal_pedido, dt_pedido, qt_itens, vl_liquido,
    dias_integracao_separacao, dias_separacao_nota, dias_nota_despacho,
    dias_despacho_entrega, dias_total_ate_entrega)
SELECT p."NumeroPedido",
    CASE WHEN TRIM(p."DtHoraPedido") = '' OR p."DtHoraPedido" IS NULL THEN -1
         ELSE CAST(TO_CHAR(TO_TIMESTAMP(p."DtHoraPedido", 'MM/DD/YYYY HH12:MI AM'), 'YYYYMMDD') AS INTEGER) END,
    CASE WHEN TRIM(p."DtEntregaCliente") = '' OR p."DtEntregaCliente" IS NULL THEN -1
         ELSE CAST(TO_CHAR(CAST(p."DtEntregaCliente" AS DATE), 'YYYYMMDD') AS INTEGER) END,
    CASE WHEN l.sk_loja IS NULL THEN -1 ELSE l.sk_loja END,
    CASE WHEN c.sk_categoria IS NULL THEN -1 ELSE c.sk_categoria END,
    CASE WHEN UPPER(TRANSLATE(TRIM(p."HouveDesconto"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) IN ('S','SIM','1','X','TRUE','V') THEN 'Sim'
         WHEN UPPER(TRANSLATE(TRIM(p."HouveDesconto"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) IN ('N','NAO','0','FALSE','F') THEN 'Nao'
         ELSE 'Nao Informado' END,
    -- WHATS antes de APP, para preservar os 414 pedidos de WhatsApp.
    CASE
    WHEN UPPER(TRANSLATE(TRIM(p."CanalPedido"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%WHATS%' THEN 'WhatsApp'
    WHEN UPPER(TRANSLATE(TRIM(p."CanalPedido"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%APP%' THEN 'App'
    WHEN UPPER(TRANSLATE(TRIM(p."CanalPedido"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%SITE%' THEN 'Site'
    WHEN UPPER(TRANSLATE(TRIM(p."CanalPedido"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%LOJA%' THEN 'Loja Fisica'
    WHEN UPPER(TRANSLATE(TRIM(p."CanalPedido"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%TEL%' THEN 'Telefone'
    ELSE 'Nao Informado' END,
    CAST(TO_TIMESTAMP(p."DtHoraPedido", 'MM/DD/YYYY HH12:MI AM') AS TIMESTAMP),
    CASE WHEN TRIM(p."QTD.Itens") IN ('','-') THEN NULL
         ELSE CAST(REPLACE(p."QTD.Itens", '.', '') AS INTEGER) END,
    CASE WHEN TRIM(REPLACE(p."ValorLiquidoPedido(R$)", 'R$', '')) IN ('', '-') THEN NULL
    WHEN p."ValorLiquidoPedido(R$)" LIKE '%,%' THEN
        CAST(REPLACE(REPLACE(REPLACE(REPLACE(p."ValorLiquidoPedido(R$)", 'R$', ''), ' ', ''), '.', ''), ',', '.') AS DECIMAL(15,2))
    ELSE CAST(REPLACE(REPLACE(p."ValorLiquidoPedido(R$)", 'R$', ''), ' ', '') AS DECIMAL(15,2)) END,
    -- Dias de calendario: data final - data inicial, sem fracao de dia.
    (CASE WHEN TRIM(p."Dt Separacao Estoque") = '' OR p."Dt Separacao Estoque" IS NULL THEN NULL ELSE CAST(p."Dt Separacao Estoque" AS DATE) END) - (CASE WHEN TRIM(p."DtHoraIntegracaoERP") = '' OR p."DtHoraIntegracaoERP" IS NULL THEN NULL ELSE CAST(TO_TIMESTAMP(p."DtHoraIntegracaoERP", 'MM/DD/YYYY HH12:MI AM') AS DATE) END),
    (CASE WHEN TRIM(p."DtNotaFiscal") = '' OR p."DtNotaFiscal" IS NULL THEN NULL ELSE CAST(p."DtNotaFiscal" AS DATE) END) - (CASE WHEN TRIM(p."Dt Separacao Estoque") = '' OR p."Dt Separacao Estoque" IS NULL THEN NULL ELSE CAST(p."Dt Separacao Estoque" AS DATE) END),
    (CASE WHEN TRIM(p."Dt_Despacho_Transportadora") = '' OR p."Dt_Despacho_Transportadora" IS NULL THEN NULL ELSE CAST(p."Dt_Despacho_Transportadora" AS DATE) END) - (CASE WHEN TRIM(p."DtNotaFiscal") = '' OR p."DtNotaFiscal" IS NULL THEN NULL ELSE CAST(p."DtNotaFiscal" AS DATE) END),
    (CASE WHEN TRIM(p."DtEntregaCliente") = '' OR p."DtEntregaCliente" IS NULL THEN NULL ELSE CAST(p."DtEntregaCliente" AS DATE) END) - (CASE WHEN TRIM(p."Dt_Despacho_Transportadora") = '' OR p."Dt_Despacho_Transportadora" IS NULL THEN NULL ELSE CAST(p."Dt_Despacho_Transportadora" AS DATE) END),
    (CASE WHEN TRIM(p."DtEntregaCliente") = '' OR p."DtEntregaCliente" IS NULL THEN NULL ELSE CAST(p."DtEntregaCliente" AS DATE) END) - (CASE WHEN TRIM(p."DtHoraIntegracaoERP") = '' OR p."DtHoraIntegracaoERP" IS NULL THEN NULL ELSE CAST(TO_TIMESTAMP(p."DtHoraIntegracaoERP", 'MM/DD/YYYY HH12:MI AM') AS DATE) END)
FROM stg_pedido p
LEFT JOIN dim_loja l ON l.chave_loja = CASE TRIM(REPLACE(REPLACE(UPPER(TRANSLATE(TRIM(p."Loja-Nome"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')), '/SC', ''), '  ', ' '))
    WHEN 'PATA AMIGA BLUMENAL CENTRO' THEN 'PATA AMIGA BLUMENAU CENTRO'
    WHEN 'PATA AMIGA FLORIPA NORTE' THEN 'PATA AMIGA FLORIANOPOLIS NORTE'
    WHEN 'PATA AMIGA JGUA DO SUL' THEN 'PATA AMIGA JARAGUA DO SUL'
    ELSE TRIM(REPLACE(REPLACE(UPPER(TRANSLATE(TRIM(p."Loja-Nome"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')), '/SC', ''), '  ', ' ')) END
LEFT JOIN dim_categoria c ON c.categoria_origem = p."CategoriaProduto";
