CREATE OR REPLACE FUNCTION simuladorMT(cinta TEXT) RETURNS RECORD AS $$
DECLARE
    iter_limit INT := 1000;
    blanco CHAR(1) := 'B';
    cabezal INT := 1;
    estado VARCHAR(8) := 'q0';
    estado_final CHAR(2) := 'qf';
    caracter VARCHAR(8);
    desplazamiento CHAR(1);
    contador INT := 0;
    ret RECORD;
    happy_ending BOOLEAN;
BEGIN
	TRUNCATE traza_ejecucion;

    WHILE TRUE LOOP

        caracter := SUBSTRING(cinta FROM cabezal FOR 1);

        RAISE NOTICE '% % % % %', contador, cabezal, estado, caracter, cinta;

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

    ret := (happy_ending, contador, cinta);
    RETURN ret;
END;
$$ LANGUAGE plpgsql;
