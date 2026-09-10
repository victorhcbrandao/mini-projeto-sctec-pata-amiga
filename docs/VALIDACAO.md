# Validação técnica

## Validação inicial independente

Leitura integral das 15 páginas do enunciado por renderização. Carga dos INSERTs fornecidos em SQLite em memória com adaptação explícita de IDENTITY e das funções de data do PostgreSQL. Execução dos SELECTs e JOINs das cargas e das 13 consultas de negócio. Conferência independente em Python dos 4.044 registros para loja, categoria, itens, valor e cinco intervalos. Dinheiro e rateio reconciliados com Decimal, sem erro de ponto flutuante. Os três CSVs coincidem integralmente com os registros dos INSERTs de staging.

| teste | obtido | esperado |
| --- | --- | --- |
| stg_pedido | 4044 | 4044 |
| stg_loja | 32 | 32 |
| stg_loja_praca | 48 | 48 |
| dim_tempo | 236 | 236 |
| dim_loja | 33 | 33 |
| dim_categoria | 38 | 38 |
| dim_praca | 13 | 13 |
| bridge_loja_praca | 48 | 48 |
| fato_pedido | 4044 | 4044 |
| categorias padronizadas | 8 | 8 |
| dim_tempo linha -1 | 1 | 1 |
| dim_loja linha -1 | 1 | 1 |
| dim_categoria linha -1 | 1 | 1 |
| dim_praca linha -1 | 1 | 1 |
| sk_tempo_pedido nula/orfa | 0 | 0 |
| sk_tempo_entrega nula/orfa | 0 | 0 |
| sk_loja nula/orfa | 0 | 0 |
| sk_categoria nula/orfa | 0 | 0 |
| pedidos distintos | 4044 | 4044 |
| WhatsApp | 414 | 414 |
| sem loja | 3 | 3 |
| sem entrega | 1953 | 1953 |
| fatores somam 1 | 0 | 0 |
| categoria nao mapeada | 0 | 0 |
| medicamento antes de racao | 0 | 0 |
| stg_pedido CSV = staging SQL | True | True |
| stg_loja CSV = staging SQL | True | True |
| stg_loja_praca CSV = staging SQL | True | True |
| 4044 registros: lookup, categoria, valores, itens e cinco intervalos independentes | True | True |
| total arredondado do enunciado | 1793309 | 1793309 |
| reconciliacao monetaria Decimal exata | 0.0000 | 0 |
| desconto, canal e duas chaves de tempo em todos os pedidos | True | True |
| NomePraca constante por praca | True | True |
| Regional constante por praca | True | True |
| DomiciliosComPet constante por praca | True | True |
| menor data de pedido | 2023-09-01 | 2023-09-01 |
| maior data de pedido | 2024-03-31 | 2024-03-31 |
| agregados e percentuais monetarios P2 P3 P5 por Decimal | True | True |
| cada praca com rateio Decimal exato | True | True |
| tickets medios por Decimal e contagem nao nula | True | True |

## Execução nativa confirmada

Executei os scripts no PostgreSQL 18.4, Windows x86_64, 64 bits. As saídas das etapas 01 a 04 foram compartilhadas por imagens; os resultados completos dos arquivos 05 e 06 foram conferidos nesta revisão. Os registros estão em `resultados/evidencias/`.

- Staging: 4.044 pedidos, 32 lojas, 48 relações.
- Dimensões e ponte: 236 registros de tempo, 33 lojas, 38 grafias de categoria, 13 praças e 48 relações; oito nomes de categoria incluindo -1.
- Fato: 4.044 linhas e 4.044 números de pedido distintos.
- Zero referências órfãs nas quatro chaves da fato e nas duas ligações da ponte.
- Nenhuma duplicação de categoria_origem ou chave_loja, nenhum fator inválido e soma 1 por loja.
- Nenhum intervalo negativo e nenhum prazo final preenchido quando a entrega está ausente.
- Período de pedidos: 01/09/2023 a 31/03/2024, sem registros fora da janela.
- Total da origem e da fato: R$ 1.793.308,51. Rateado: R$ 1.792.322,21; sem loja: R$ 986,30; diferença: R$ 0,00.
- As cinco respostas foram comparadas aos números do README. WhatsApp: 414 pedidos; sem loja: 3; sem entrega: 1.953; sem itens: 257; sem valor: 121.
- `Timbó` foi exibido corretamente no pgAdmin; CHAR_LENGTH retornou 5. A distorção de acentos no PowerShell era de apresentação e não exigiu recarga.

Na primeira tentativa, uma conexão aberta impediu a recriação do banco. Depois de desconectá-la, a carga revelou leitura WIN1252 incompatível com o arquivo UTF-8. Defini PGCLIENTENCODING=UTF8 e refiz a carga do zero com sucesso. O README inclui essa configuração.

O PostgreSQL 16 é a referência do professor, mas não foi a versão executada. A validação nativa aqui documentada é específica do PostgreSQL 18.4. 


## Critério de aceite nativo

- Cada comando deve terminar sem erro.
- Após 01: 4.044 / 32 / 48. Após 02: 236 / 33 e quatro tabelas vazias.
- Após 03: 38 / 13 / 48, oito nomes de categoria contando -1, fator 1 por loja.
- Após 04: 4.044 pedidos distintos, nenhuma FK nula ou órfã, três lojas -1, 1.953 entregas -1, 414 WhatsApp.
- Após 05: total conhecido 1.793.308,51; arredondado 1.793.309; rateio mais sem loja fecha com diferença zero.
- As verificações de erro do arquivo 06 devem devolver zero ocorrências ou nenhuma linha, conforme comentário.

As contagens da seção 8 do PDF foram reproduzidas na validação local. 