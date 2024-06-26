-- Valida que sea un palindromo
CREATE OR REPLACE FUNCTION palindrome() RETURNS VOID AS $$
DECLARE
    A RECORD;
    B RECORD;
BEGIN

	TRUNCATE alfabeto;
	INSERT INTO alfabeto (caracter) VALUES
	('0'), ('1'), ('2'), ('3'), ('4'), ('5'), ('6'), ('7'), ('8'), ('9'),
	('a'), ('b'), ('c'), ('d'), ('e'), ('f'), ('g'), ('h'), ('i'), ('j'), ('k'), ('l'), ('m'), ('n'), ('ñ'), ('o'), ('p'), ('q'), ('r'), ('s'), ('t'), ('u'), ('v'), ('w'), ('x'), ('y'), ('z'),
	('A'),        ('C'), ('D'), ('E'), ('F'), ('G'), ('H'), ('I'), ('J'), ('K'), ('L'), ('M'), ('N'), ('Ñ'), ('O'), ('P'), ('Q'), ('R'), ('S'), ('T'), ('U'), ('V'), ('W'), ('X'), ('Y'), ('Z'),
    ('.'), (','), (':'), (';'), ('¿'), ('?'), ('¡'), ('!'), ('('), (')'), ('['), (']'), ('{'), ('}'), ('/'), ('+'), ('-'), ('_'), ('<'), ('>'), ('='), ('@'), ('#'), ('$'), ('%'), ('^'), ('&'), ('*'), ('¬'), ('~'), ('`'), ('|'), ('\'), ('°'), ('"'), ('''');

    -- No soporta 'B' ya que es usado para Blanco y tampoco ' ' ya que es un espacio

	TRUNCATE programa;

    FOR A IN SELECT caracter FROM alfabeto LOOP
        INSERT INTO programa (estado_ori, caracter_ori, estado_nue, caracter_nue, desplazamiento) VALUES
        ('q0', A.caracter, 'x'||A.caracter,  'B', 'R'),     -- Agarra el primer char y va a buscar el ultimo con chache
        ('x'||A.caracter, 'B', 'xf'||A.caracter,  'B', 'L'),-- Si encuentra B termino el string
        ('xf'||A.caracter, A.caracter, 'qs', 'B', 'L'),     -- Checkea que el ultimo caracter sea el guardado
        ('xf'||A.caracter, 'B', 'qf', 'B', 'L'),            -- Si esta en blanco tenia largo impar
        ('qs', A.caracter, 'qs', A.caracter, 'L');          -- Con cualquier letra va a la izq
        FOR B IN SELECT caracter FROM alfabeto LOOP
            INSERT INTO programa (estado_ori, caracter_ori, estado_nue, caracter_nue, desplazamiento) VALUES
            ('x'||A.caracter, B.caracter, 'x'||A.caracter, B.caracter, 'R'); -- Con cualquier letra va a la derecha
        END LOOP;
    END LOOP;

	INSERT INTO programa (estado_ori, caracter_ori, estado_nue, caracter_nue, desplazamiento) VALUES
    ('qs', 'B', 'q0', 'B', 'R'), -- Cuando llega al inicio vuelve a buscar primer char
    ('q0', 'B', 'qf', 'B', 'R'); -- Si el primer caracter es B termino de recorrerla o string vacia

    -- ( 10 + 27 + 26 + 36 ) = 99
    -- 99 * ( 99 + 5 ) + 2 = 10298


END;
$$ LANGUAGE plpgsql;

select palindrome();
