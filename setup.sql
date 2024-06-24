DROP TABLE IF EXISTS programa CASCADE;
DROP TABLE IF EXISTS traza_ejecucion CASCADE;
DROP TABLE IF EXISTS alfabeto CASCADE;

CREATE TABLE programa (
    estado_ori VARCHAR(8),
    caracter_ori VARCHAR(8),
    estado_nue VARCHAR(8),
    caracter_nue VARCHAR(8),
    desplazamiento CHAR(1),
    PRIMARY KEY (estado_ori, caracter_ori)
);

CREATE TABLE traza_ejecucion (
    id SERIAL PRIMARY KEY,
    cabezal INT,
    estado VARCHAR(8),
    caracter VARCHAR(8),
    cinta TEXT
);

CREATE TABLE alfabeto (
    caracter CHAR(8) PRIMARY KEY
);
