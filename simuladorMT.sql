CREATE OR REPLACE FUNCTION simuladorMT(OUT happy_ending BOOLEAN, OUT contador INT, INOUT cinta TEXT) RETURNS RECORD AS $$
#variable_conflict use_variable
DECLARE
    iter_limit INT := 10000;
    blanco CHAR(1) := 'B';
    cabezal INT := 1;
    estado VARCHAR(8) := 'q0';
    estado_final CHAR(2) := 'qf';
    caracter VARCHAR(8);
    desplazamiento CHAR(1);
    ret RECORD;
BEGIN
	TRUNCATE traza_ejecucion;
    cinta := regexp_replace(cinta, E'[\\n\\r\\t]+', ' ', 'g' );
    contador := 0;
    FOREACH caracter IN ARRAY regexp_split_to_array(cinta, '')
    LOOP
        IF NOT EXISTS (SELECT 1 FROM alfabeto a WHERE a.caracter = caracter) THEN
            RAISE EXCEPTION 'Caracter invalido: ''%''', caracter;
        END IF;
    END LOOP;

    WHILE TRUE LOOP

        caracter := SUBSTRING(cinta FROM cabezal FOR 1);

        -- RAISE NOTICE '% % % % %', contador, cabezal, estado, caracter, cinta;

        INSERT INTO traza_ejecucion (id, cabezal, estado, caracter, cinta)
        VALUES ( contador, cabezal, estado, caracter, cinta);

        IF estado = estado_final THEN
            RAISE NOTICE 'Finalizacion por estado final';
            EXIT;
        END IF;

        SELECT p.estado_nue, p.caracter_nue, p.desplazamiento
        INTO estado, caracter, desplazamiento
        FROM programa p
        WHERE p.estado_ori = estado AND p.caracter_ori = caracter;

        IF estado IS NULL THEN
            RAISE NOTICE 'Finalizacion por estado o caracter invalido.';
            EXIT;
        END IF;

        cinta := OVERLAY(cinta PLACING caracter FROM cabezal);

        IF desplazamiento = 'R' THEN
            cabezal := cabezal + 1;
        ELSIF desplazamiento = 'L' THEN
            cabezal := cabezal - 1;
        END IF;

        IF cabezal = 0 THEN
            cabezal := 1;
            cinta := blanco || cinta;
        ELSIF cabezal > LENGTH(cinta) THEN
            cinta := cinta || blanco;
        ELSIF cabezal = 2 AND blanco = SUBSTRING(cinta FROM 1 FOR 1) THEN
            cinta := SUBSTRING(cinta FROM 2);
            cabezal := 1;
        ELSIF cabezal = LENGTH(cinta) -1 AND blanco = SUBSTRING(cinta FROM LENGTH(cinta) FOR 1) THEN
            cinta := SUBSTRING(cinta FROM 1 FOR LENGTH(cinta) -1);
        END IF;

        contador := contador + 1;
        IF contador = iter_limit THEN
            RAISE EXCEPTION 'Limite de iteraciones alcanzado';
        END IF;
    END LOOP;

    happy_ending := (estado IS NOT NULL AND estado = 'qf');

    UPDATE traza_ejecucion
    SET final = happy_ending
    WHERE id = contador;

    RAISE NOTICE '% % % % %', contador, cabezal, estado, caracter, cinta;
    -- ret := (happy_ending, contador, cinta);
    -- RETURN;
END;
$$ LANGUAGE plpgsql;
