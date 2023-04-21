-- Criação da banco de dados

CREATE DATABASE IF NOT EXISTS esportes_reserva
DEFAULT CHARACTER SET utf8
DEFAULT COLLATE utf8_general_ci;


-- Inicialização do banco de dados

USE esportes_reserva;


-- Criação das tabelas

CREATE TABLE IF NOT EXISTS membros(
	id VARCHAR(255) PRIMARY KEY,
    senha VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    membro_desde TIMESTAMP DEFAULT NOW(),
    pagamento DECIMAL(13, 2) NOT NULL DEFAULT 0
);


CREATE TABLE IF NOT EXISTS recisoes_pendentes(
	id VARCHAR(255) PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    requesicao_data TIMESTAMP DEFAULT NOW(),
    pagamento DECIMAL(13, 2) NOT NULL DEFAULT 0
);


CREATE TABLE IF NOT EXISTS espacos(
	id VARCHAR(255) PRIMARY KEY,
    espaco_tipo VARCHAR(255) NOT NULL,
    preco DECIMAL(13, 2) NOT NULL
);


CREATE TABLE IF NOT EXISTS reservas(
	id INT PRIMARY KEY AUTO_INCREMENT,
    espaco_id VARCHAR(255) NOT NULL,
    data_reservada DATE NOT NULL,
    horario_reservado TIME NOT NULL,
    membro_id VARCHAR(255),
    data_reserva TIMESTAMP NOT NULL DEFAULT NOW(),
    pagamento_status VARCHAR(255) NOT NULL DEFAULT "Não pago",
    CONSTRAINT uc1 UNIQUE(espaco_id, data_reservada, horario_reservado)
);


-- Adição da chaves estrangeiras 

ALTER TABLE reservas
ADD CONSTRAINT fk1 FOREIGN KEY(membro_id) REFERENCES membros(id) ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE reservas
ADD CONSTRAINT fk2 FOREIGN KEY(espaco_id) REFERENCES espacos(id) ON DELETE CASCADE ON UPDATE CASCADE;


-- Criação da view

CREATE VIEW membros_reservas AS
SELECT r.id, r.espaco_id, e.espaco_tipo, r.data_reservada, r.horario_reservado, r.membro_id, r.data_reserva, e.preco, r.pagamento_status
FROM reservas AS r
INNER JOIN espacos AS e
ON r.espaco_id = e.id;


-- Inserção do dados nas tabelas

INSERT INTO membros(id, senha, email, membro_desde) VALUES
('afeil', 'feil1988<3', 'Abdul.Feil@hotmail.com', '2017-04-15 12:10:13');

INSERT INTO membros(id, senha, email, membro_desde) VALUES
('amely_18', 'loseweightin18', 'Amely.Bauch91@yahoo.com', '2018-02-06 16:48:43');

INSERT INTO membros(id, senha, email, membro_desde) VALUES
('bbahringer', 'iambeau17', 'Beaulah_Bahringer@yahoo.com', '2017-12-28 05:36:50');

INSERT INTO membros(id, senha, email, membro_desde, pagamento) VALUES
('little31', 'whocares31', 'Anthony_Little31@gmail.com', '2017-06-01 21:12:11', '10.00');

INSERT INTO membros(id, senha, email, membro_desde) VALUES
('macejkovic73', 'jadajeda12', 'Jada.Macejkovic73@gail.com', '2017-05-30 17:30:22');

INSERT INTO membros(id, senha, email, membro_desde, pagamento) VALUES
('marvin1', 'if0909mar', 'Marvin_Schulist@gmail.com', '2017-09-09 02:30:49', '10.00');

INSERT INTO membros(id, senha, email, membro_desde) VALUES
('nitzsche77', 'bret77@#', 'Bret_Nitzsche77@gmail.com', '2018-01-09 17:36:49');

INSERT INTO membros(id, senha, email, membro_desde) VALUES
('noah51', '18Oct1976#51', 'Noah51@gamil.com', '2017-12-16 22:59:46');

INSERT INTO membros(id, senha, email, membro_desde) VALUES
('oreillys', 'reallycool#1', 'Martine_OReilly@yahoo.com', '2017-10-12 05:39:20');

INSERT INTO membros(id, senha, email, membro_desde) VALUES
('wyattgreat', 'wyatt111', 'Wyatt_Wisozk@gmail.com', '2017-07-18 16:28:35');


INSERT INTO espacos (id, espaco_tipo, preco) VALUES 
('AR', 'Arco e Flecha', '120.00'),
('B1', 'Quadra de Badminton', '8.00'),
('B2', 'Quadra de Badminton', '8.00'),
('MU1', 'Arena Multiuso', '50.00'),
('MU2', 'Arena Multiuso', '60.00'),
('T1', 'Quadra de Tenis', '10.00'),
('T2', 'Quadra de Tenis', '10.00');


INSERT INTO reservas (espaco_id, data_reservada, horario_reservado, membro_id, data_reserva, pagamento_status) VALUES 
('AR', '2017-12-26', '13:00:00', 'oreillys', '2017-12-20 20:31:27', 'Pago'),
('MU1', '2017-12-30', '17:00:00', 'noah51', '2017-12-22 05:22:10', 'Pago'),
('T2', '2017-12-31', '16:00:00', 'macejkovic73', '2017-12-28 18:14:23', 'Pago'),
('T1', '2018-03-05', '08:00:00', 'little31', '2018-02-22 20:19:17', 'Não Pago'),
('MU2', '2018-03-02', '11:00:00', 'marvin1', '2018-03-01 16:13:45', 'Pago'),
('B1', '2018-03-28', '16:00:00', 'marvin1', '2018-03-23 22:46:36', 'Pago'),
('B1', '2018-04-15', '14:00:00', 'macejkovic73', '2018-04-12 22:23:20', 'Cancelado'),
('T2', '2018-04-23', '13:00:00', 'macejkovic73', '2018-04-19 10:49:00', 'Cancelado'),
('T1', '2018-05-25', '10:00:00', 'marvin1', '2018-05-21 11:20:46', 'Não Pago'),
('B2', '2018-06-12', '15:00:00', 'bbahringer', '2018-05-30 14:40:23', 'Pago');


-- Criação do trigger
-- Adicionar o membro a ser excluído na tabela de recisões pendentes caso o mesmo tenha pagamentos a serem feitos

DELIMITER $$

CREATE TRIGGER pagamento_check BEFORE DELETE
ON membros
FOR EACH ROW
BEGIN 
	DECLARE v_pagamento DECIMAL(13, 2);
    
    SET v_pagamento = OLD.pagamento;
	
    IF v_pagamento > 0 THEN
		INSERT INTO recisoes_pendentes (id, email, pagamento) VALUES (OLD.id, OLD.email, OLD.pagamento);
	END IF;
END $$


-- Criação da função
-- Checar quantos cancelamentos seguidos o membro possui

DELIMITER $$

CREATE FUNCTION checar_cancelamento(p_reserva_id INT) RETURNS INT DETERMINISTIC
BEGIN 
	DECLARE v_fim INT DEFAULT 0;
	DECLARE v_cancelamento INT DEFAULT 0;
 	DECLARE v_pagamento_status VARCHAR(255);
    
    DECLARE curPagamento CURSOR FOR (
		SELECT pagamento_status FROM reservas
		WHERE membro_id = (SELECT membro_id FROM reservas WHERE id = p_reserva_id)
		ORDER BY data_reserva DESC
		);
	
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_fim = 1;
    
	OPEN curPagamento;
    
    loop_cancelamento: LOOP
		FETCH curPagamento INTO v_pagamento_status;
        
			IF v_fim = 1 OR v_pagamento_status != 'Cancelado' THEN 
				LEAVE loop_cancelamento;
            ELSE
            	SET v_cancelamento =  v_cancelamento + 1;
			END IF;
    END LOOP;
    
    RETURN v_cancelamento;
END $$


-- Criação dos procedimentos
-- Inserir um novo mebro a tabela de membros

DELIMITER $$

CREATE PROCEDURE inserir_novo_membro(IN p_id VARCHAR(255), IN p_senha VARCHAR(255), IN p_email VARCHAR(255)) 
BEGIN 
	INSERT INTO membros (id, senha, email) VALUE (p_id, p_senha, p_email);
END $$


-- Deletar um mebro da tabela de membros

DELIMITER $$

CREATE PROCEDURE deletar_membro(IN p_id VARCHAR(255))
BEGIN 
	DELETE FROM membros
    WHERE membros.id = p_id;
END $$


-- Deleta atualiza a senha de um membro na tabela de membros 

DELIMITER $$

CREATE PROCEDURE atualizar_senha_membro(IN p_id VARCHAR(255), IN p_senha VARCHAR(255))
BEGIN 
	UPDATE membros
    SET membros.senha = p_senha
    WHERE membros.id = p_id;
END $$


-- Deleta atualiza o e-mail de um membro na tabela de membros 

DELIMITER $$

CREATE PROCEDURE atualizar_email_membro(IN p_id VARCHAR(255), IN p_email VARCHAR(255))
BEGIN 
	UPDATE membros
    SET membros.email = p_email
    WHERE membros.id = p_id;
END $$


-- Fazer um nova reserva na tabela reservas e atualizar o valor de pagamento na tabela membros

DELIMITER $$

CREATE PROCEDURE fazer_reserva(IN p_espaco_id VARCHAR(255), IN p_data_reservada DATE, IN p_horario_reservado TIME, IN p_membro_id VARCHAR(255))
BEGIN 
	DECLARE v_pagamento DECIMAL(13, 2);
    DECLARE v_preco DECIMAL(13, 2);
    
	-- Atribuir o valor do espaco para a variável v_preco 
    
    SET v_preco := (SELECT preco FROM espacos WHERE id = p_espaco_id);
    
    -- Inserir novo registro na tabela reservas
    
    INSERT INTO reservas (espaco_id, data_reservada, horario_reservado, membro_id) VALUES (p_espaco_id, p_data_reservada, p_horario_reservado, p_membro_id);
    
    -- Atribuir o valor do pagamento para a variável v_pagamento 
    
    SELECT pagamento INTO v_pagamento FROM membros WHERE id = p_membro_id;
    
    -- Atualizar o valor de pagamento  
    
	UPDATE membros
    SET membros.pagamento = v_pagamento + v_preco
    WHERE id = p_membro_id;
    
END $$


DELIMITER $$

CREATE PROCEDURE atualizar_pagamento(IN p_reserva_id VARCHAR(255))
BEGIN
	DECLARE v_membro_id VARCHAR(255);
	DECLARE v_pagamento DECIMAL(13, 2);
    DECLARE v_preco DECIMAL(13, 2);
    
	-- Atualizar o pagamento
    UPDATE reservas
    SET pagamento_status = "Pago"
    WHERE id = p_reserva_id;
    
	-- Atribuir o valor do id do membro para a variável v_membro_id
    SET v_membro_id := (SELECT membro_id FROM membros_reservas WHERE id = p_reserva_id);

	-- Atribuir o valor do espaco para a variável v_preco 
    SET v_preco := (SELECT preco FROM membros_reservas WHERE id = p_reserva_id);

    -- Atribuir o valor do pagamento para a variável v_pagamento 
    SET v_pagamento := (SELECT pagamento FROM membros WHERE id = v_membro_id);
    
    -- Atualizar o valor de pagamento  
	UPDATE membros
    SET membros.pagamento = v_pagamento - v_preco
    WHERE membros.id = v_membro_id;
    
END $$


-- Verificar as reservas de um mebro específico

DELIMITER $$

CREATE PROCEDURE ver_reservas(IN p_id VARCHAR(255))
BEGIN 
	SELECT * FROM membros_reservas 
    WHERE membro_id = p_id;
END $$


-- Verificar a disponibilidade de um espaco em uma determinada data e horário específico

DELIMITER $$

CREATE PROCEDURE ver_espacos_livres(IN p_espaco_tipo VARCHAR(255), IN p_data_reservada DATE, IN p_horario_reservado TIME)
BEGIN
	-- Retorna apenas registros da tabela espacos nos quais não possuem reserva já feita no horário determinado e data especificada
    
	SELECT * FROM espacos
    WHERE espacos.espaco_tipo = p_espaco_tipo 
    AND espacos.id NOT IN 
	(SELECT espaco_id FROM membros_reservas
    WHERE data_reservada = p_data_reservada
    AND horario_reservado = p_horario_reservado
    AND pagamento_status != 'Cancelado');
END $$


-- Cancelar uma reserva feita

DELIMITER $$

CREATE PROCEDURE cancelar_reserva(IN p_reserva_id VARCHAR(255), OUT p_mensagem VARCHAR(255))
BEGIN 
	DECLARE v_cancelamento INT;
	DECLARE v_data_reservada DATE;
 	DECLARE v_membro_id VARCHAR(255);
	DECLARE v_pagamento DECIMAL(13, 2);
 	DECLARE v_pagamento_status VARCHAR(255);
    DECLARE v_preco DECIMAL(13, 2);
    
    SET v_cancelamento = 0;

	-- Atribuir o valor do id do membro para a variável v_membro_id
    
    SET v_membro_id := (SELECT membro_id FROM membros_reservas WHERE id = p_reserva_id);

	-- Atribuir o valor da data reservada do membro para a variável v_data_reservada
    
    SET v_data_reservada := (SELECT data_reservada FROM membros_reservas WHERE id = p_reserva_id);
    
    -- Atribuir o valor do pagamento para a variável v_pagamento 
    
    SET v_pagamento := (SELECT pagamento FROM membros WHERE id = v_membro_id);

    -- Atribuir o valor do pagamento status para a variável v_pagamento_status
    
    SET v_pagamento_status := (SELECT pagamento_status FROM membros_reservas WHERE id = v_membro_id);
    
	-- Atribuir o valor do espaco para a variável v_preco 
    
    SET v_preco := (SELECT preco FROM membros_reservas WHERE id = p_reserva_id);

    
    /* Verificar se o cancelamento pode ser feito 
    Cancelamento só pode ser realizado antes da data e apenas ser não tiver já sido pago ou cancelado
	*/
    IF CURDATE() >= v_data_reservada THEN
		SELECT 'Cancelamento não pode ser feito após a data reservada' INTO p_mensagem;
	ELSEIF v_pagamento_status IN ('Cancelado', 'Pago') THEN 
		SELECT 'Cancelamento não pode ser feito, visto que já foi cancelado ou pago' INTO p_mensagem;
	ELSE

		-- Atualizar o status 
        
		UPDATE reservas
		SET reservas.pagamento_status = "Cancelado"
		WHERE reservas.id = p_reserva_id;
        
        
		-- Atualizar o valor de pagamento  
        
		UPDATE membros
		SET membros.pagamento = v_pagamento - v_preco
		WHERE membros.id = v_membro_id;
        
        
        -- Checar  quantidade de cancelamentos
        
		SET v_cancelamento = checar_cancelamento(p_reserva_id);
    
    
		-- Caso o membros tem 2 ou mais cancelamentos seguidos, ele é taxado no valor de 10 
        
		IF v_cancelamento >= 2 THEN   
			SET v_pagamento = 10;
      
			UPDATE membros
			SET membros.pagamento = membros.pagamento + v_pagamento
			WHERE membros.id = v_membro_id;
    
		END IF;
    
		-- Mensagem de cancelamento
        
        SELECT 'Reserva Cancelada' INTO p_mensagem;
        
    END IF;
END $$

DELIMITER ;



