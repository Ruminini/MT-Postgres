CREATE OR REPLACE FUNCTION descripciones(
    OUT descripcion TEXT
) RETURNS SETOF TEXT AS $$
DECLARE
    record RECORD;
BEGIN
    FOR record IN SELECT cinta, estado, cabezal FROM traza_ejecucion LOOP
        descripcion := 
            SUBSTRING(record.cinta FROM 1 FOR record.cabezal - 1) || 
            record.estado ||
            SUBSTRING(record.cinta FROM record.cabezal);
        RETURN NEXT;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
