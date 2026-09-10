-- PostgreSQL 16. Execute uma vez, depois dos arquivos 01 e 02.
-- Nenhuma staging e alterada. A grafia crua permite lookup sem duplicacao.
INSERT INTO dim_categoria (sk_categoria, categoria_origem, nome_categoria, grupo_categoria)
VALUES (-1, 'Nao Informado', 'Nao Informado', 'Nao Informado');

-- MED precede RA: Racao Medicamentosa pertence a Medicamento.
INSERT INTO dim_categoria (categoria_origem, nome_categoria, grupo_categoria)
SELECT DISTINCT "CategoriaProduto",
CASE
    WHEN UPPER(TRANSLATE(TRIM("CategoriaProduto"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%MED%' THEN 'Medicamento'
    WHEN UPPER(TRANSLATE(TRIM("CategoriaProduto"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%PETISC%' THEN 'Petisco'
    WHEN UPPER(TRANSLATE(TRIM("CategoriaProduto"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%RA%' THEN 'Racao'
    WHEN UPPER(TRANSLATE(TRIM("CategoriaProduto"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%HIG%' THEN 'Higiene'
    WHEN UPPER(TRANSLATE(TRIM("CategoriaProduto"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%BRINQ%' THEN 'Brinquedo'
    WHEN UPPER(TRANSLATE(TRIM("CategoriaProduto"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%ACESS%' THEN 'Acessorio'
    WHEN UPPER(TRANSLATE(TRIM("CategoriaProduto"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%SERV%' THEN 'Servico'
    ELSE 'Nao Informado' END,
CASE
    WHEN UPPER(TRANSLATE(TRIM("CategoriaProduto"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%MED%' THEN 'Saude e Higiene'
    WHEN UPPER(TRANSLATE(TRIM("CategoriaProduto"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%PETISC%' THEN 'Alimentacao'
    WHEN UPPER(TRANSLATE(TRIM("CategoriaProduto"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%RA%' THEN 'Alimentacao'
    WHEN UPPER(TRANSLATE(TRIM("CategoriaProduto"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%HIG%' THEN 'Saude e Higiene'
    WHEN UPPER(TRANSLATE(TRIM("CategoriaProduto"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%BRINQ%' THEN 'Bem-estar'
    WHEN UPPER(TRANSLATE(TRIM("CategoriaProduto"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%ACESS%' THEN 'Bem-estar'
    WHEN UPPER(TRANSLATE(TRIM("CategoriaProduto"), 'ÁÀÂÃÉÊÍÓÔÕÚÜÇáàâãéêíóôõúüç', 'AAAAEEIOOOUUCaaaaeeiooouuc')) LIKE '%SERV%' THEN 'Bem-estar'
    ELSE 'Nao Informado' END
FROM stg_pedido;

INSERT INTO dim_praca (sk_praca, cod_praca, nome_praca, regional, domicilios_com_pet)
VALUES (-1, 'N/I', 'Nao Informado', 'Nao Informado', NULL);

-- Uma linha por codigo. Os demais atributos sao constantes por praca na origem.
INSERT INTO dim_praca (cod_praca, nome_praca, regional, domicilios_com_pet)
SELECT "CodPraca", MAX("NomePraca"), MAX("Regional"),
       CAST(REPLACE(MAX("DomiciliosComPet"), '.', '') AS INTEGER)
FROM stg_loja_praca
GROUP BY "CodPraca";

-- A ligacao usa cod_loja (chave natural), nunca sk_loja.
INSERT INTO bridge_loja_praca (cod_loja, sk_praca, fator_publico)
SELECT s."CodLoja", d.sk_praca,
       CAST(REPLACE(s."PercentualPublico", ',', '.') AS DECIMAL(6,4))
FROM stg_loja_praca s
JOIN dim_praca d ON d.cod_praca = s."CodPraca";
