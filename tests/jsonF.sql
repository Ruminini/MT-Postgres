SELECT validate_json('{"papa":[10,a]}');  -- 'a' no es valido
SELECT validate_json('{"nombre":"Tobias", "edad", 22}');  -- Usa , en vez de :
SELECT validate_json('[[[[[]]]]');    -- no cierran los mismos q abren