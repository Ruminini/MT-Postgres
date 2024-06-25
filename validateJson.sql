CREATE OR REPLACE FUNCTION validate_json(_cinta TEXT)
RETURNS TABLE (qf BOOLEAN, contador INT, cinta TEXT) AS $$
BEGIN
    PERFORM str_num_json_validator();
    SELECT (simuladorMT(_cinta)).cinta INTO _cinta;
    PERFORM json_validator();
    RETURN QUERY SELECT * FROM simuladorMT(_cinta);
END;
$$ LANGUAGE plpgsql;
