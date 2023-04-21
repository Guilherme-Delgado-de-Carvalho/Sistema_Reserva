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