USE `Jonas Discos`;

-- Criar um novo cliente
START TRANSACTION;
CALL cria_cliente ("Rui Fernandes", "rfernandes@iol.pt", "4760-213", "Rua da Bombaça, 45", "Ribeirão", 2, 'NORMAL', '912345678');
COMMIT;

SELECT * FROM Cliente WHERE Cliente.nome = 'Rui Fernandes';


-- Calculo do lucro originado por um determinado cliente
START TRANSACTION;
CALL lucro_cliente (26);
COMMIT;


-- Calculo do lucro origindado de uma loja
START TRANSACTION;
CALL lucro_loja (2);
COMMIT;


-- Calculo do lucro originado por cada loja
START TRANSACTION;
CALL lucro ();
COMMIT;


-- Insere vários discos na base de dados (o número de discos a inserir é definido pela quantidade) que partilham as mesmas
-- características (nome, artista, género, etc...)
START TRANSACTION;
CALL insere_disco ('CAO!', 'Ornatos Violeta', 'Funk', 13, '1:03:56', 33, 'LP', 23.25 ,10.2, 1, 1, 13);
COMMIT;


-- Registar uma compra
START TRANSACtION;
CALL resgista_compra('2013-01-19', 30.23, 1, 1);
COMMIT;


-- Lista dos discos que foram vendidos numa determinada data numa determinada loja
START TRANSACTION;
CALL compra_por_data_numa_loja ('2014-03-02', 17);
COMMIT;


-- Determinação do número de discos vendidos de um determinado artista nas lojas de uma localidade
START TRANSACTION;
CALL ndiscos_artista_localidade ('Pink Floyd', 'Gaia');
COMMIT;