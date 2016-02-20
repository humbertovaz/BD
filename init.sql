-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Jonas Discos
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Jonas Discos
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Jonas Discos` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `Jonas Discos` ;

-- -----------------------------------------------------
-- Table `Jonas Discos`.`Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Jonas Discos`.`Fornecedor` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(128) NULL,
  `nome` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Jonas Discos`.`Telefone_Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Jonas Discos`.`Telefone_Fornecedor` (
  `numero` VARCHAR(16) NOT NULL,
  `fornecedor` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`numero`),
  INDEX `fk_telefone_fornecedor_fornecedor_idx` (`fornecedor` ASC),
  CONSTRAINT `fk_telefone_fornecedor_fornecedor`
    FOREIGN KEY (`fornecedor`)
    REFERENCES `Jonas Discos`.`Fornecedor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Jonas Discos`.`Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Jonas Discos`.`Cliente` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(128) NOT NULL,
  `email` VARCHAR(128) NULL,
  `cod_postal` VARCHAR(16) NULL,
  `rua` VARCHAR(128) NULL,
  `localidade` VARCHAR(128) NULL,
  `nr_discos` INT UNSIGNED NOT NULL,
  `estatuto` ENUM('NORMAL', 'GOLDEN', 'PLATINUM') NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Jonas Discos`.`Telefone_Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Jonas Discos`.`Telefone_Cliente` (
  `numero` VARCHAR(16) NOT NULL,
  `cliente` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`numero`),
  INDEX `fk_telefone_cliente_cliente1_idx` (`cliente` ASC),
  CONSTRAINT `fk_telefone_cliente_cliente1`
    FOREIGN KEY (`cliente`)
    REFERENCES `Jonas Discos`.`Cliente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Jonas Discos`.`Loja`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Jonas Discos`.`Loja` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `total_fact` FLOAT UNSIGNED NOT NULL,
  `total_gasto` FLOAT UNSIGNED NOT NULL,
  `rua` VARCHAR(128) NOT NULL,
  `cod_postal` VARCHAR(16) NOT NULL,
  `localidade` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Jonas Discos`.`Compra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Jonas Discos`.`Compra` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `data_Compra` DATE NOT NULL,
  `custo_total` FLOAT NOT NULL,
  `loja` INT UNSIGNED NULL,
  `cliente` INT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_compra_loja1_idx` (`loja` ASC),
  INDEX `fk_compra_cliente1_idx` (`cliente` ASC),
  CONSTRAINT `fk_compra_loja1`
    FOREIGN KEY (`loja`)
    REFERENCES `Jonas Discos`.`Loja` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_compra_cliente1`
    FOREIGN KEY (`cliente`)
    REFERENCES `Jonas Discos`.`Cliente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Jonas Discos`.`Abastecimento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Jonas Discos`.`Abastecimento` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `data_Abastecimento` DATE NOT NULL,
  `custo_total` FLOAT UNSIGNED NOT NULL,
  `loja` INT UNSIGNED NOT NULL,
  `fornecedor` INT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_abastecimento_loja1_idx` (`loja` ASC),
  INDEX `fk_abastecimento_fornecedor1_idx` (`fornecedor` ASC),
  CONSTRAINT `fk_abastecimento_loja1`
    FOREIGN KEY (`loja`)
    REFERENCES `Jonas Discos`.`Loja` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_abastecimento_fornecedor1`
    FOREIGN KEY (`fornecedor`)
    REFERENCES `Jonas Discos`.`Fornecedor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Jonas Discos`.`Disco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Jonas Discos`.`Disco` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(128) NOT NULL,
  `nr_faixas` INT UNSIGNED NULL,
  `duracao` TIME NULL,
  `rpm` INT(2) NULL,
  `tipo` ENUM('EP', 'LP', 'SINGLE', 'MAXI') NULL,
  `pvp` FLOAT UNSIGNED NOT NULL,
  `compra_preco` FLOAT NULL,
  `abastecimento_custo` FLOAT UNSIGNED NOT NULL,
  `compra` INT UNSIGNED NULL,
  `abastecimento` INT UNSIGNED NULL,
  `loja` INT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_disco_compra1_idx` (`compra` ASC),
  INDEX `fk_disco_abastecimento1_idx` (`abastecimento` ASC),
  INDEX `fk_Disco_Loja1_idx` (`loja` ASC),
  CONSTRAINT `fk_disco_compra1`
    FOREIGN KEY (`compra`)
    REFERENCES `Jonas Discos`.`Compra` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_disco_abastecimento1`
    FOREIGN KEY (`abastecimento`)
    REFERENCES `Jonas Discos`.`Abastecimento` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Disco_Loja1`
    FOREIGN KEY (`loja`)
    REFERENCES `Jonas Discos`.`Loja` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Jonas Discos`.`Disco_Artista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Jonas Discos`.`Disco_Artista` (
  `artista` VARCHAR(128) NOT NULL,
  `disco` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`artista`, `disco`),
  INDEX `fk_disco_artista_disco1_idx` (`disco` ASC),
  CONSTRAINT `fk_disco_artista_disco1`
    FOREIGN KEY (`disco`)
    REFERENCES `Jonas Discos`.`Disco` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Jonas Discos`.`Disco_Genero`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Jonas Discos`.`Disco_Genero` (
  `genero` VARCHAR(128) NOT NULL,
  `disco` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`genero`, `disco`),
  INDEX `fk_disco_genero_disco1_idx` (`disco` ASC),
  CONSTRAINT `fk_disco_genero_disco1`
    FOREIGN KEY (`disco`)
    REFERENCES `Jonas Discos`.`Disco` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
