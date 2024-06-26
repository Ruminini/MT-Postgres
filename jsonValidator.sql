-- Validador de JSONs
CREATE OR REPLACE FUNCTION json_validator() RETURNS VOID AS $$
BEGIN

	TRUNCATE alfabeto;
	INSERT INTO alfabeto (caracter) VALUES ('{'), ('}'), ('['), (']'), ('"'), (':'), (','), ('n'), ('u'), ('l'), ('t'), ('r'), ('e'), ('f'), ('a'), ('s'), ('w'), ('0'), (' ');

	TRUNCATE programa;
	INSERT INTO programa (estado_ori, caracter_ori, estado_nue, caracter_nue, desplazamiento) VALUES

	-- Validar JSON
	('q0', '{', 'q{', '{', 'R'),
	('q0', '[', 'q[', '[', 'R'),
	('q0', '"', 'q"', '"', 'R'),
	('q0', ' ', 'q0', ' ', 'R'),
	('q0', 'B', 'q0', 'B', 'R'),
	('q0', 't', 'qtrue', '_', 'R'),
	('q0', 'f', 'qfalse', '_', 'R'),
	('q0', 'n', 'qnull', '_', 'R'),
	('q0', '0', 'qn', '_', 'R'),

	-- Llave abierta
	('q{', '}', 'q}', '_', 'L'),
	('q{', '"', 'q1', '"', 'R'),
	('q{', ' ', 'q{', ' ', 'R'),

	-- Validar interior de la llave
	('q1', 'w', 'q2', 'w', 'R'),	-- Que tenga al menos una letra
	('q1', ' ', 'q2', ' ', 'R'),

	('q2', 'w', 'q2', 'w', 'R'),
	('q2', ' ', 'q2', ' ', 'R'),
	('q2', '"', 'q3', '"', 'R'),	-- Esperamos que termine en "

	('q3', ' ', 'q3', ' ', 'R'),
	('q3', ':', 'q0', ':', 'R'),	-- Buscamos el :

	-- Buscar siguiente en objeto
	('q4', ' ', 'q4', ' ', 'R'),
	('q4', '_', 'q4', '_', 'R'),
	('q4', ',', 'q5', '_', 'R'),
	('q4', '}', 'q}', '_', 'L'),	-- Una vez validado buscamos el final del objeto

	-- Buscar apertura de Key
	('q5', '"', 'q1', '"', 'R'),
	('q5', ' ', 'q5', ' ', 'R'),

	-- Marcar valido hasta llave abierta
	('q}', 'w', 'q}', '_', 'L'),
	('q}', '0', 'q}', '_', 'L'),
	('q}', '"', 'q}', '_', 'L'),
	('q}', ':', 'q}', '_', 'L'),
	('q}', ' ', 'q}', '_', 'L'),
	('q}', '_', 'q}', '_', 'L'),
	('q}', '{', 'q6', '_', 'L'),

	-- Buscar en donde estaba
	('q6', ' ', 'q6', '_', 'L'),
	('q6', '_', 'q6', '_', 'L'),
	('q6', ':', 'q4', ':', 'R'),	-- Estaba en objeto
	('q6', '[', 'q7', '[', 'R'),	-- Estaba en arreglo
	('q6', 'B', 'q9', 'B', 'R'),

	-- Corchete abierto
	('q[', ']', 'q]', '_', 'L'),
	('q[', '{', 'q{', '{', 'R'),
	('q[', '[', 'q[', '[', 'R'),
	('q[', '"', 'q"', '"', 'R'),
	('q[', ' ', 'q[', ' ', 'R'),
	('q[', 't', 'qtrue', '_', 'R'),
	('q[', 'f', 'qfalse', '_', 'R'),
	('q[', 'n', 'qnull', '_', 'R'),
	('q[', '0', 'qn', '_', 'R'),

	-- Buscar siguiente en arreglo
	('q7', ' ', 'q7', ' ', 'R'),
	('q7', '_', 'q7', '_', 'R'),
	('q7', ',', 'q0', '_', 'R'),
	('q7', ']', 'q]', '_', 'L'),

	-- Marcar valido hasta corchete abierto
	('q]', ' ', 'q]', '_', 'L'),
	('q]', '_', 'q]', '_', 'L'),
	('q]', '[', 'q6', '_', 'L'),

	-- Validar String
	('q"', 'w', 'q"', 'w', 'R'),
	('q"', ' ', 'q"', ' ', 'R'),
	('q"', '"', 'q8', '_', 'L'),

	-- Marcar valido hasta comilla
	('q8', ' ', 'q8', '_', 'L'),
	('q8', 'w', 'q8', '_', 'L'),
	('q8', '"', 'q6', '_', 'L'),

	-- Validar true
	('qtrue', 'r', 'qrue', '_', 'R'),
	('qrue', 'u', 'que', '_', 'R'),
	('que', 'e', 'q6', '_', 'L'),

	-- Validar false
	('qfalse', 'a', 'qalse', '_', 'R'),
	('qalse', 'l', 'qlse', '_', 'R'),
	('qlse', 's', 'qse', '_', 'R'),
	('qse', 'e', 'q6', '_', 'L'),

	-- Validar null
	('qnull', 'u', 'qull', '_', 'R'),
	('qull', 'l', 'qll', '_', 'R'),
	('qll', 'l', 'q6', '_', 'L'),

	-- Validar numero
	('qn', '0', 'qn', '_', 'R'),
	('qn', ',', 'q6', ',', 'L'),
	('qn', ' ', 'q6', ' ', 'L'),
	('qn', '}', 'q6', '}', 'L'),
	('qn', ']', 'q6', ']', 'L'),
	('qn', 'B', 'q6', 'B', 'L'),

	-- Validar que no haya quedado nada sin leer
	('q9', '_', 'q9', '_', 'R'),
	('q9', 'B', 'qf', 'B', 'R');
END;
$$ LANGUAGE plpgsql;

SELECT json_validator();
