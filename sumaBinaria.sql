-- Sumador de numeros binarios
CREATE OR REPLACE FUNCTION suma_binaria() RETURNS void AS $$
BEGIN
	TRUNCATE alfabeto;
	INSERT INTO alfabeto (caracter) VALUES ('0'), ('1'), ('+'), ('=');

	TRUNCATE programa;
	INSERT INTO programa (estado_ori, caracter_ori, estado_nue, caracter_nue, desplazamiento) VALUES

    -- Validar string
    ('q0', '0', 'q0b', '0', 'R'),
    ('q0', '1', 'q0b', '1', 'R'),
    ('q0b', '0', 'q0b', '0', 'R'),
    ('q0b', '1', 'q0b', '1', 'R'),
    ('q0b', '+', 'q1b', '+', 'R'),
    ('q1b', '0', 'q1', '0', 'R'),
    ('q1b', '1', 'q1', '1', 'R'),
    ('q1', '0', 'q1', '0', 'R'),
    ('q1', '1', 'q1', '1', 'R'),
    ('q1', '=', 'q2', '=', 'R'),
    ('q2', 'B', 'q3', 'B', 'L'),

    -- Buscar el ultimo bit del b con 0
    ('q3', '=', 'q3', '=', 'L'),
    ('q3', '_', 'q3', '_', 'L'),
    ('q3', '0', 'q4', '_', 'L'),
    ('q3', '1', 'q9', '_', 'L'),
    ('q3', '+', 'qf5', '+', 'L'),

    -- Buscar el + con 0
    ('q4', '0', 'q4', '0', 'L'),
    ('q4', '1', 'q4', '1', 'L'),
    ('q4', '+', 'q5', '+', 'L'),

    -- Buscar el ultimo bit del a con 0
    ('q5', '_', 'q5', '_', 'L'),
    ('q5', 'B', 'q6', 'B', 'R'),
    ('q5', '0', 'q6', '_', 'R'),
    ('q5', '1', 'q11', '_', 'R'),

    -- Ir a escribir 0
    ('q6', '0', 'q6', '0', 'R'),
    ('q6', '1', 'q6', '1', 'R'),
    ('q6', '_', 'q6', '_', 'R'),
    ('q6', '+', 'q6', '+', 'R'),
    ('q6', '=', 'q6', '=', 'R'),
    ('q6', 'B', 'q8', '0', 'L'),

    -- Ir a buscar el igual por der
    ('q8', '0', 'q8', '0', 'L'),
    ('q8', '1', 'q8', '1', 'L'),
    ('q8', '=', 'q3', '=', 'L'),

    -- Buscar el + con 1
    ('q9', '0',  'q9', '0', 'L'),
    ('q9', '1',  'q9', '1', 'L'),
    ('q9', '+', 'q10', '+', 'L'),

    -- Buscar el ultimo bit del a con 1
    ('q10', '_', 'q10', '_', 'L'),
    ('q10', 'B', 'q11', 'B', 'R'),
    ('q10', '0', 'q11', '_', 'R'),
    ('q10', '1', 'q13', '_', 'R'),

    -- Ir a escribir 1
    ('q11', '0', 'q11', '0', 'R'),
    ('q11', '1', 'q11', '1', 'R'),
    ('q11', '_', 'q11', '_', 'R'),
    ('q11', '+', 'q11', '+', 'R'),
    ('q11', '=', 'q11', '=', 'R'),
    ('q11', 'B', 'q8', '1', 'L'),

    -- Ir a escribir 0 con acarreo
    ('q13', '0', 'q13', '0', 'R'),
    ('q13', '1', 'q13', '1', 'R'),
    ('q13', '_', 'q13', '_', 'R'),
    ('q13', '+', 'q13', '+', 'R'),
    ('q13', '=', 'q13', '=', 'R'),
    ('q13', 'B', 'q15', '0', 'L'),
    
    -- Ir a buscar el igual por der con 1
    ('q15', '0', 'q15', '0', 'L'),
    ('q15', '1', 'q15', '1', 'L'),
    ('q15', '=', 'q16', '=', 'L'),

    -- Buscar el ultimo bit del b con 1
    ('q16', '_', 'q16', '_', 'L'),
    ('q16', '+','qf10', '+', 'L'),
    ('q16', '0',  'q9', '_', 'L'),
    ('q16', '1', 'q17', '_', 'L'),

    -- Buscar el + con 2
    ('q17', '0',  'q17', '0', 'L'),
    ('q17', '1',  'q17', '1', 'L'),
    ('q17', '+', 'q18', '+', 'L'),

    -- Buscar el ultimo bit del a con 2
    ('q18', '_', 'q18', '_', 'L'),
    ('q18', 'B', 'q13', 'B', 'R'),
    ('q18', '0', 'q13', '_', 'R'),
    ('q18', '1', 'q19', '_', 'R'),

    -- Ir a escribir 1 con acarreo
    ('q19', '0', 'q19', '0', 'R'),
    ('q19', '1', 'q19', '1', 'R'),
    ('q19', '_', 'q19', '_', 'R'),
    ('q19', '+', 'q19', '+', 'R'),
    ('q19', '=', 'q19', '=', 'R'),
    ('q19', 'B', 'q15', '1', 'L'),

    -- Buscar el ultimo bit del a con 0 y b terminado
    ('qf5', '_', 'qf5', '_', 'L'),
    ('qf5', 'B', 'q20', 'B', 'R'),
    ('qf5', '0', 'q6', '_', 'R'),
    ('qf5', '1', 'q11', '_', 'R'),

    -- Buscar el ultimo bit del a con 1 y b terminado
    ('qf10', '_', 'qf10', '_', 'L'),
    ('qf10', 'B', 'q27', 'B', 'R'),
    ('qf10', '0', 'q11', '_', 'R'),
    ('qf10', '1', 'q13', '_', 'R'),

    -- Ir a buscar el final
    ('q20', '0', 'q20', '0', 'R'),
    ('q20', '1', 'q20', '1', 'R'),
    ('q20', '_', 'q20', '_', 'R'),
    ('q20', '+', 'q20', '_', 'R'),
    ('q20', '=', 'q20', '=', 'R'),
    ('q20', 'B', 'q21', 'B', 'L'),

    -- Ver que escribo
    ('q21', '=', 'qfin', 'B', 'L'),
    ('q21', '0', 'q22', 'B', 'L'),
    ('q21', '1', 'q25', 'B', 'L'),

    -- Busco = con 0 hacia izq
    ('q22', '0', 'q22', '0', 'L'),
    ('q22', '1', 'q22', '1', 'L'),
    ('q22', '=', 'q23', '=', 'L'),

    -- Ir a escribir 0 hacia izq
    ('q23', '_', 'q23', '_', 'L'),
    ('q23', '0', 'q24', '0', 'R'),
    ('q23', '1', 'q24', '1', 'R'),
    ('q23', 'B', 'q24', 'B', 'R'),

    -- Escribir 0 y volver
    ('q24', '_', 'q20', '0', 'R'),

    -- Busco = con 1 hacia izq
    ('q25', '0', 'q25', '0', 'L'),
    ('q25', '1', 'q25', '1', 'L'),
    ('q25', '=', 'q26', '=', 'L'),

    -- Ir a escribir 1 hacia izq
    ('q26', '_', 'q26', '_', 'L'),
    ('q26', '0', 'q27', '0', 'R'),
    ('q26', '1', 'q27', '1', 'R'),
    ('q26', 'B', 'q27', 'B', 'R'),

    -- Escribir 1 y volver
    ('q27', '_', 'q20', '1', 'R'),

    -- Borrar hasta el resultado
    ('qfin', '_', 'qfin', 'B', 'L'),
    ('qfin', 'B', 'qf', 'B', 'L'),
    ('qfin', '0', 'qf', '0', 'L'),
    ('qfin', '1', 'qf', '1', 'L');

END;
$$ LANGUAGE plpgsql;

SELECT suma_binaria();
