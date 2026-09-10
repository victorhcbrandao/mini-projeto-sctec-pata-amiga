# Resultados de referência

Calculados inicialmente com SQLite adaptado e conferência independente em Python; posteriormente conferidos com a saída nativa do PostgreSQL 18.4. Estas tabelas são uma apresentação dos resultados; as saídas compartilhadas estão em `evidencias/`. Valores em reais, tempos em dias de calendário. As consultas originais estão em `sql/05-perguntas.sql`.

## P1_rede

| integracao_separacao | separacao_nota | nota_despacho | despacho_entrega | total_erp_entrega | entregas_concluidas |
| --- | --- | --- | --- | --- | --- |
| 2,13 | 0,64 | 4,11 | 2,14 | 9,00 | 2.091 |

## P1_portes

| porte | pedidos | integracao_separacao | separacao_nota | nota_despacho | despacho_entrega | total_erp_entrega | entregas_concluidas |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Grande | 1.763 | 1,96 | 0,64 | 3,32 | 2,01 | 7,93 | 903 |
| Media | 1.663 | 1,98 | 0,62 | 3,34 | 2,03 | 7,95 | 880 |
| Nao Informado | 3 | 2,00 | 0,00 | 4,00 | 3,00 | 8,50 | 2 |
| Pequena | 615 | 3,02 | 0,69 | 8,53 | 2,86 | 15,16 | 306 |

## P2_categorias

| nome_categoria | faturamento | percentual_rede |
| --- | --- | --- |
| Racao | 1.076.202,55 | 60,01 |
| Medicamento | 305.904,03 | 17,06 |
| Petisco | 128.590,16 | 7,17 |
| Servico | 94.001,37 | 5,24 |
| Higiene | 92.314,45 | 5,15 |
| Acessorio | 64.661,39 | 3,61 |
| Brinquedo | 31.634,56 | 1,76 |

## P2_portes

| porte | nome_categoria | faturamento |
| --- | --- | --- |
| Grande | Racao | 468.186,60 |
| Grande | Medicamento | 135.928,72 |
| Grande | Petisco | 56.003,89 |
| Grande | Servico | 41.775,77 |
| Grande | Higiene | 39.253,11 |
| Grande | Acessorio | 26.423,80 |
| Grande | Brinquedo | 13.822,08 |
| Media | Racao | 443.131,62 |
| Media | Medicamento | 128.625,36 |
| Media | Petisco | 51.173,37 |
| Media | Servico | 37.051,79 |
| Media | Higiene | 34.716,87 |
| Media | Acessorio | 27.991,06 |
| Media | Brinquedo | 14.192,11 |
| Nao Informado | Racao | 686,78 |
| Nao Informado | Higiene | 178,00 |
| Nao Informado | Petisco | 121,52 |
| Pequena | Racao | 164.197,55 |
| Pequena | Medicamento | 41.349,95 |
| Pequena | Petisco | 21.291,38 |
| Pequena | Higiene | 18.166,47 |
| Pequena | Servico | 15.173,81 |
| Pequena | Acessorio | 10.246,53 |
| Pequena | Brinquedo | 3.620,37 |

## P3_desconto

| canal_pedido | houve_desconto | pedidos | pedidos_com_valor | ticket_medio | faturamento |
| --- | --- | --- | --- | --- | --- |
| App | Nao | 160 | 155 | 167,63 | 25.982,85 |
| App | Nao Informado | 58 | 58 | 505,68 | 29.329,36 |
| App | Sim | 1.055 | 1.018 | 488,04 | 496.822,22 |
| Loja Fisica | Nao | 101 | 97 | 197,55 | 19.162,65 |
| Loja Fisica | Nao Informado | 45 | 43 | 347,75 | 14.953,10 |
| Loja Fisica | Sim | 678 | 661 | 494,04 | 326.561,47 |
| Nao Informado | Nao | 27 | 25 | 206,95 | 5.173,78 |
| Nao Informado | Nao Informado | 8 | 8 | 463,31 | 3.706,47 |
| Nao Informado | Sim | 202 | 194 | 561,59 | 108.949,32 |
| Site | Nao | 152 | 148 | 189,68 | 28.073,34 |
| Site | Nao Informado | 57 | 56 | 428,13 | 23.975,20 |
| Site | Sim | 823 | 794 | 501,92 | 398.520,83 |
| Telefone | Nao | 34 | 34 | 195,23 | 6.637,78 |
| Telefone | Nao Informado | 12 | 12 | 522,31 | 6.267,66 |
| Telefone | Sim | 218 | 215 | 514,02 | 110.513,85 |
| WhatsApp | Nao | 56 | 55 | 179,26 | 9.859,49 |
| WhatsApp | Nao Informado | 18 | 18 | 447,80 | 8.060,34 |
| WhatsApp | Sim | 340 | 332 | 514,33 | 170.758,80 |

## P3_canais

| canal_pedido | pedidos | faturamento | percentual_rede |
| --- | --- | --- | --- |
| App | 1.273 | 552.134,43 | 30,79 |
| Site | 1.032 | 450.569,37 | 25,13 |
| Loja Fisica | 824 | 360.677,22 | 20,11 |
| WhatsApp | 414 | 188.678,63 | 10,52 |
| Telefone | 264 | 123.419,29 | 6,88 |
| Nao Informado | 237 | 117.829,57 | 6,57 |

## P4_pracas

| cod_praca | nome_praca | domicilios_com_pet | faturamento_rateado | percentual_rede | percentual_domicilios | reais_por_domicilio |
| --- | --- | --- | --- | --- | --- | --- |
| PRC01 | Vale do Itajai | 148.000 | 633.746,09 | 35,34 | 17,29 | 4,28 |
| PRC05 | Grande Florianopolis | 132.000 | 283.546,75 | 15,81 | 15,42 | 2,15 |
| PRC02 | Norte Industrial | 96.000 | 175.431,90 | 9,78 | 11,21 | 1,83 |
| PRC06 | Litoral Sul | 58.000 | 137.051,20 | 7,64 | 6,78 | 2,36 |
| PRC03 | Litoral Norte | 61.000 | 128.872,75 | 7,19 | 7,13 | 2,11 |
| PRC11 | Extremo Oeste | 63.000 | 98.359,18 | 5,48 | 7,36 | 1,56 |
| PRC07 | Carbonifera | 67.000 | 88.707,42 | 4,95 | 7,83 | 1,32 |
| PRC08 | Serra Catarinense | 44.000 | 80.477,64 | 4,49 | 5,14 | 1,83 |
| PRC10 | Meio-Oeste | 51.000 | 58.955,63 | 3,29 | 5,96 | 1,16 |
| PRC04 | Foz do Itajai | 74.000 | 46.749,72 | 2,61 | 8,64 | 0,63 |
| PRC12 | Planalto Norte | 33.000 | 31.100,84 | 1,73 | 3,86 | 0,94 |
| PRC09 | Planalto Serrano | 29.000 | 29.323,10 | 1,64 | 3,39 | 1,01 |

## P4_sem_loja

| pedidos_sem_loja | faturamento_sem_praca |
| --- | --- |
| 3 | 986,30 |

## P4_reconciliacao

| total_rede | total_rateado | sem_loja | diferenca |
| --- | --- | --- | --- |
| 1.793.308,51 | 1.792.322,21 | 986,30 | 0,00 |

## P5a_ranking

| cod_loja | nome_loja | cidade | populacao_cidade | itens | itens_por_mil_habitantes | dias_entrega | pedidos | pedidos_com_itens | entregas_concluidas |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| LJ-012 | Pata Amiga Rio dos Cedros | Rio dos Cedros | 11.322 | 474 | 41,87 | 14,24 | 61 | 59 | 29 |
| LJ-008 | Pata Amiga Presidente Getulio | Presidente Getúlio | 16.359 | 570 | 34,84 | 14,16 | 88 | 80 | 43 |
| LJ-011 | Pata Amiga Ibirama | Ibirama | 18.613 | 597 | 32,07 | 15,39 | 98 | 89 | 54 |
| LJ-016 | Pata Amiga Itapoa | Itapoá | 20.586 | 534 | 25,94 | 15,39 | 84 | 80 | 36 |
| LJ-020 | Pata Amiga Santo Amaro da Imperatriz | Santo Amaro da Imperatriz | 22.357 | 530 | 23,71 | 15,88 | 85 | 81 | 50 |
| LJ-009 | Pata Amiga Taio | Taió | 18.173 | 352 | 19,37 | 14,57 | 59 | 58 | 30 |
| LJ-005 | Pata Amiga Timbo | Timbó | 45.011 | 804 | 17,86 | 7,70 | 123 | 115 | 60 |
| LJ-007 | Pata Amiga Gaspar | Gaspar | 71.133 | 1.189 | 16,72 | 8,01 | 181 | 167 | 96 |
| LJ-027 | Pata Amiga Otacilio Costa | Otacílio Costa | 18.227 | 289 | 15,86 | 15,61 | 44 | 42 | 18 |
| LJ-010 | Pata Amiga Ituporanga | Ituporanga | 25.748 | 354 | 13,75 | 16,53 | 51 | 47 | 19 |
| LJ-002 | Pata Amiga Rio do Sul | Rio do Sul | 73.135 | 885 | 12,10 | 8,35 | 149 | 136 | 86 |
| LJ-026 | Pata Amiga Sao Joaquim | São Joaquim | 27.234 | 320 | 11,75 | 15,07 | 45 | 44 | 27 |
| LJ-024 | Pata Amiga Laguna | Laguna | 46.122 | 541 | 11,73 | 8,51 | 80 | 75 | 45 |
| LJ-006 | Pata Amiga Indaial | Indaial | 71.987 | 750 | 10,42 | 7,74 | 128 | 113 | 65 |
| LJ-023 | Pata Amiga Ararangua | Araranguá | 68.274 | 689 | 10,09 | 8,25 | 107 | 100 | 68 |
| LJ-022 | Pata Amiga Tubarao | Tubarão | 105.511 | 889 | 8,43 | 7,69 | 157 | 144 | 83 |
| LJ-014 | Pata Amiga Jaragua do Sul | Jaraguá do Sul | 184.579 | 1.507 | 8,16 | 8,01 | 239 | 225 | 120 |
| LJ-028 | Pata Amiga Curitibanos | Curitibanos | 39.061 | 308 | 7,89 | 8,65 | 47 | 46 | 20 |
| LJ-015 | Pata Amiga Sao Bento do Sul | São Bento do Sul | 87.310 | 567 | 6,49 | 8,18 | 105 | 92 | 55 |
| LJ-030 | Pata Amiga Concordia | Concórdia | 74.641 | 470 | 6,30 | 7,74 | 89 | 81 | 39 |
| LJ-001 | Pata Amiga Blumenau Centro | Blumenau | 361.855 | 2.002 | 5,53 | 7,80 | 315 | 301 | 154 |
| LJ-031 | Pata Amiga Xanxere | Xanxerê | 52.034 | 284 | 5,46 | 8,17 | 54 | 53 | 29 |
| LJ-019 | Pata Amiga Palhoca | Palhoça | 168.259 | 844 | 5,02 | 7,69 | 172 | 157 | 85 |
| LJ-032 | Pata Amiga Sao Miguel do Oeste | São Miguel do Oeste | 41.520 | 186 | 4,48 | 8,00 | 42 | 38 | 25 |
| LJ-004 | Pata Amiga Brusque | Brusque | 143.270 | 558 | 3,89 | 7,63 | 122 | 117 | 63 |
| LJ-021 | Pata Amiga Criciuma | Criciúma | 217.392 | 822 | 3,78 | 8,07 | 152 | 145 | 76 |
| LJ-025 | Pata Amiga Lages | Lages | 158.846 | 593 | 3,73 | 7,69 | 107 | 103 | 61 |
| LJ-018 | Pata Amiga Sao Jose Kobrasol | São José | 250.181 | 929 | 3,71 | 8,01 | 155 | 147 | 75 |
| LJ-029 | Pata Amiga Chapeco | Chapecó | 254.235 | 824 | 3,24 | 7,85 | 159 | 150 | 82 |
| LJ-013 | Pata Amiga Joinville Sul | Joinville | 597.658 | 1.888 | 3,16 | 7,83 | 309 | 291 | 156 |
| LJ-003 | Pata Amiga Itajai Praia | Itajaí | 264.054 | 798 | 3,02 | 7,98 | 159 | 147 | 96 |
| LJ-017 | Pata Amiga Florianopolis Norte | Florianópolis | 537.213 | 1.426 | 2,65 | 8,02 | 275 | 261 | 144 |

## P5b_franquia

| faixa_franquia | pedidos | faturamento | percentual_rede |
| --- | --- | --- | --- |
| Ouro | 2.316 | 1.011.264,38 | 56,39 |
| Diamante | 818 | 382.209,74 | 21,31 |
| Prata | 719 | 314.812,03 | 17,55 |
| Bronze | 188 | 84.036,06 | 4,69 |
| Nao Informado | 3 | 986,30 | 0,05 |

## P5c_ausencias

| pedidos | sem_loja | sem_entrega | sem_itens | sem_valor | percentual_sem_entrega | percentual_sem_itens | percentual_sem_valor |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 4.044 | 3 | 1.953 | 257 | 121 | 48,29 | 6,36 | 2,99 |

