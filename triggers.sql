USE `Jonas Discos`;

-- Ao apagar um fornecedor, apagar também os seus números de telefone
DELIMITER //
CREATE TRIGGER apaga_fornecedor AFTER DELETE ON `Fornecedor`
FOR EACH ROW
BEGIN
	DELETE FROM Telefone_Fornecedor
	WHERE OLD.id = Telefone_Fornecedor.fornecedor;
    
    DELETE FROM Abastecimento
    WHERE OLD.id = Abastecimento.fornecedor;
END //

-- bertodiscos@gmail.com, Berto Discos


-- Ao apagar um cliente, apagar também os seus números de telefone


-- Ao apagar um abastecimento, remover esse abastecimento do disco


-- Ao apagar uma loja, removê-la do abastecimento, disco e compra


-- Ao apagar um disco, removê-lo do disco_artista, disco_genero, compra
