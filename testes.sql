-- 1) Teste se as tabelas estão criadas corretamente

SELECT * FROM membros;

SELECT * FROM recisoes_pendentes;

SELECT * FROM espacos;

SELECT * FROM reservas;


-- 2) Inserção de um novo membro

CALL inserir_novo_membro('angelolott', '1234abcd', 'AngeloNLott@gmail.com');

SELECT * FROM membros 
ORDER BY membro_desde DESC;


-- 3) Apagamento de membros 

CALL deletar_membro('afeil');
CALL deletar_membro('little31');

SELECT * FROM membros;
SELECT * FROM recisoes_pendentes;


-- 4) Atualização de senha e e-mail

CALL atualizar_senha_membro('noah51', '18Oct1976');
CALL atualizar_email_membro('noah51', 'noah51@hotmail.com');

SELECT * FROM membros
WHERE membros.id = 'noah51';


-- 5) Atualização de pagamento 

SELECT * FROM membros
WHERE membros.id = 'marvin1';

SELECT * FROM reservas
WHERE reservas.membro_id = 'marvin1';

CALL atualizar_pagamento(9);

SELECT * FROM membros
WHERE membros.id = 'marvin1';

SELECT * FROM reservas
WHERE reservas.membro_id = 'marvin1';


-- 6) Busca por espaços livres

CALL ver_espacos_livres('Arco e Flecha', '2017-12-26', '13:00:00');

CALL ver_espacos_livres('Quadra de Badminton', '2018-04-15', '14:00:00');

CALL ver_espacos_livres('Quadra de Badminton', '2018-06-12', '15:00:00');


-- 7) Fazer uma reserva

-- CALL fazer_reserva('AR', '2017-12-26', '13:00:00', 'noah51');

CALL fazer_reserva('T1', CURDATE() + INTERVAL 2 WEEK , '11:00:00', 'noah51');

CALL fazer_reserva('AR', CURDATE() + INTERVAL 2 WEEK , '11:00:00', 'macejkovic73');

SELECT * FROM reservas;


-- 8) Cancelamento de reserva

CALL cancelar_reserva(1, @mensagem);

SELECT @mensagem;

CALL cancelar_reserva((SELECT id from membros_reservas
	WHERE membro_id = 'macejkovic73'
	ORDER BY id DESC
	LIMIT 1), @mensagem);

SELECT @mensagem;

CALL cancelar_reserva((SELECT id from membros_reservas
	WHERE membro_id = 'noah51'
	ORDER BY id DESC
	LIMIT 1), @mensagem);

SELECT @mensagem;

SELECT * FROM membros;







