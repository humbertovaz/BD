USE `Jonas Discos`;

-- Criar um novo cliente
-- Utilização:
--   CALL cria_cliente ("Rui Fernandes", "rfernandes@iol.pt", "4760-213", "Rua da Bombaça, 45", "Ribeirão", 2, 'NORMAL', "912345678");
DELIMITER //
CREATE PROCEDURE `cria_cliente` (nome VARCHAR(128), email VARCHAR(128), cod_postal VARCHAR(128),
								 rua VARCHAR(128), localidade VARCHAR(128), nr_discos INT,
                                 estatuto ENUM('NORMAL', 'GOLDEN', 'PLATINUM'), numero VARCHAR(16))
BEGIN
INSERT INTO Cliente
	(nome, email, cod_postal, rua, localidade, nr_discos, estatuto)
	VALUES
	(nome, email, cod_postal, rua, localidade, nr_discos, estatuto);

INSERT INTO Telefone_Cliente
 	(numero, cliente)
 	VALUES
 	(numero, LAST_INSERT_ID() );
END //


-- Calculo do lucro originado por um determinado cliente
-- Utilização:
--   CALL lucro_cliente (32);
DELIMITER //
CREATE PROCEDURE `lucro_cliente` (cliente INT)
BEGIN
	SELECT SUM(compra_preco - abastecimento_custo) FROM Disco INNER JOIN Compra
    ON Disco.compra = Compra.id
    WHERE Compra.cliente = cliente;
END //


-- Calculo do lucro origindado de uma loja
-- Utilização:
--   CALL lucro_loja (2);
DELIMITER //
CREATE PROCEDURE `lucro_loja` (loja INT)
BEGIN
	SELECT total_fact - total_gasto AS Lucro FROM Loja
    WHERE Loja.id = loja;
END //


-- Calculo do lucro originado por cada loja
DELIMITER //
CREATE PROCEDURE `lucro` ()
BEGIN
	SELECT Loja.id AS Loja, total_fact - total_gasto AS Lucro FROM Loja;
END //


-- Insere vários discos na base de dados (o número de discos a inserir é definido pela quantidade) que partilham as mesmas
-- características (nome, artista, género, etc...)
-- Utilização:
--   CALL insere_disco ('O Monstro Precisa de Amigos', 'Ornatos Violeta', 'Rock', 13, '1:03:56', 33, 'LP', 23.25 ,10.2, 1, 1, 10);
DELIMITER //
CREATE PROCEDURE `insere_disco` (titulo VARCHAR(128), artista VARCHAR(128), genero VARCHAR(128),
                                 nr_faixas INT, duracao TIME, rpm INT(2), tipo ENUM('EP', 'LP', 'SINGLE', 'MAXI'),
                                 pvp FLOAT, abastecimento_custo FLOAT, abastecimento INT, loja INT, quantidade INT)
BEGIN
	DECLARE i INT DEFAULT 0;
    DECLARE disco_id INT;

    WHILE i < quantidade DO
		INSERT INTO Disco (titulo, nr_faixas, duracao, rpm, tipo, pvp, compra_preco, abastecimento_custo, compra, abastecimento, loja)
        VALUES (titulo, nr_faixas, duracao, rpm, tipo, pvp, NULL, abastecimento_custo, NULL, abastecimento, loja);
        
        SET disco_id = LAST_INSERT_ID();
        
        INSERT INTO Disco_Artista (artista, disco)
        VALUES (artista, disco_id);
        
        INSERT INTO Disco_Genero (genero, disco)
        VALUES (genero, disco_id);
        
		SET i = i + 1;
    END WHILE;
END //


-- Registar uma compra
-- Utilização
--   CALL resgista_compra('2013-01-19', 30.23, 1, 1)
DELIMITER //
CREATE PROCEDURE `regista_compra` (data_Compra DATE, custo_total FLOAT, nr_discos INT, loja INT, cliente INT)
BEGIN
	INSERT INTO Compra (data_Compra, custo_total, loja, cliente)
    VALUES (data_Compra, custo_total, loja, cliente);
    
    UPDATE Loja
    SET Loja.total_fact = Loja.total_fact + custo_total
    WHERE Loja.id = loja;
    
    UPDATE Cliente
    SET Cliente.nr_discos = Cliente.nr_discos + nr_discos,
        Cliente.estatuto  = IF (Cliente.nr_discos > 99, 'PLATINUM', IF (Cliente.nr_discos > 49, 'GOLDEN', 'NORMAL'))
    WHERE Cliente.id = cliente;
END //


-- Lista dos discos que foram vendidos numa determinada data numa determinada loja
-- Utilização:
--   CALL compra_por_data_numa_loja ('2014-03-02', 17);
DELIMITER //
CREATE PROCEDURE `compra_por_data_numa_loja` (data_Compra DATE, loja INT)
BEGIN
	SELECT D.* FROM Disco as D INNER JOIN Loja AS L
    ON D.loja = L.id 
    INNER JOIN Compra AS C
    ON D.compra = C.id
    WHERE C.data_compra = data_compra;
END //


-- Determinação do número de discos vendidos de um determinado artista nas lojas de uma localidade
-- Utilização:
--   CALL ndiscos_artista_localidade ('Pink Floyd', 'Gaia');
DELIMITER //
CREATE PROCEDURE `ndiscos_artista_localidade` (artista VARCHAR(128), localidade VARCHAR(128))
BEGIN
	SELECT COUNT(D.id) FROM Disco AS D INNER JOIN Disco_Artista AS DA
    ON D.id = DA.disco INNER JOIN Compra AS C
	ON D.compra = C.id INNER JOIN Loja AS L
    ON C.loja = L.id
    WHERE L.localidade = localidade AND DA.artista = artista;
END //