-- Exclusão do banco de dados

DROP DATABASE IF EXISTS esportes_reserva;


-- Exclusão da tabelas

DROP TABLE IF EXISTS reservas;

DROP TABLE IF EXISTS membros;

DROP TABLE IF EXISTS recisoes_pendentes;

DROP TABLE IF EXISTS espacos;


-- Exclusão da view

DROP VIEW IF EXISTS membros_reservas;


-- Exclusão do trigger

DROP TRIGGER IF EXISTS pagamento_check;


-- Exclusão da função

DROP FUNCTION IF EXISTS checar_cancelamento;


-- Exclusão dos procedimentos

DROP PROCEDURE IF EXISTS inserir_novo_membro;

DROP PROCEDURE IF EXISTS atualizar_email_membro;

DROP PROCEDURE IF EXISTS atualizar_pagamento;

DROP PROCEDURE IF EXISTS atualizar_senha_membro;

DROP PROCEDURE IF EXISTS cancelar_reserva;

DROP PROCEDURE IF EXISTS deletar_membro;

DROP PROCEDURE IF EXISTS fazer_reserva;

DROP PROCEDURE IF EXISTS inserir_novo_membro;

DROP PROCEDURE IF EXISTS ver_espacos_livres;

DROP PROCEDURE IF EXISTS ver_reservas;







