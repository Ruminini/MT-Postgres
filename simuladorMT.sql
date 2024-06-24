CREATE OR REPLACE FUNCTION simuladorMT(cinta TEXT) RETURNS VOID AS $$
DECLARE
    iter_limit INT := 1000;
    blanco CHAR(1) := 'B';
    cabezal INT := 1;
    estado VARCHAR(8) := 'q0';
    caracter VARCHAR(8);
    desplazamiento CHAR(1);
    estado_final BOOLEAN := FALSE;
    contador INT := 0;
BEGIN
	TRUNCATE traza_ejecucion;
    PERFORM setval('traza_ejecucion_id_seq', 1, false);

    WHILE NOT estado_final LOOP

        IF estado = 'qf' OR estado IS NULL THEN
            RAISE NOTICE 'Finalizacion por: %', estado;
            estado_final := TRUE;
        END IF;

        caracter := SUBSTRING(cinta FROM cabezal FOR 1);

        RAISE NOTICE '% % % % %', contador, cabezal, estado, caracter, cinta;

        INSERT INTO traza_ejecucion (cabezal, estado, caracter, cinta)
        VALUES ( cabezal, estado, caracter, cinta);

        SELECT p.estado_nue, p.caracter_nue, p.desplazamiento
        INTO estado, caracter, desplazamiento
        FROM programa p
        WHERE p.estado_ori = estado AND p.caracter_ori = caracter;

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
        END IF;

        contador := contador + 1;

        IF contador = iter_limit THEN
            RAISE EXCEPTION 'Limite de iteraciones alcanzado';
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
