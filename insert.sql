-- Inserção de dados na tabela membros

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


-- Inserção de dados na tabela espacos

INSERT INTO espacos (id, espaco_tipo, preco) VALUES 
('AR', 'Arco e Flecha', '120.00'),
('B1', 'Quadra de Badminton', '8.00'),
('B2', 'Quadra de Badminton', '8.00'),
('MU1', 'Arena Multiuso', '50.00'),
('MU2', 'Arena Multiuso', '60.00'),
('T1', 'Quadra de Tenis', '10.00'),
('T2', 'Quadra de Tenis', '10.00');


-- Inserção de dados na tabela reservas

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



