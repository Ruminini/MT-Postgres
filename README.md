# Simulador Maquina de Turing en PostgreSQL.
**Teoría de Computación, Universidad Nacional General Sarmiento, primer semestre 2024.**

[Consigna del trabajo](consigna.pdf)

## Instalacion y configuración

### Instalamos Postgres en Docker
```bash
docker run --name postgres -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres
```

### Instalamos extensiones para VScode
 - [SQLTools](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools)
 - [SQLTools PostgreSQL Driver](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools-driver-pg)

### Creamos las tablas y funciones
En cada uno de los siguientes archivos seleccionamos **▷ Run on active connection**.
 - [setup.sql](setup.sql)
 - [simuladorMT.sql](simuladorMT.sql)
 - [str_num_json_validator.sql](str_num_json_validator.sql)
 - [json_validator.sql](json_validator.sql)
 - [suma_binaria.sql](suma_binaria.sql)
 - [palindrome.sql](palindrome.sql)
 - [descripciones.sql](descripciones.sql)
 - [validateJson.sql](validateJson.sql)

### Nos conectamos al container y luego a postgres
```bash
docker exec -it postgres bash
psql -U postgres
```
## Uso
Luego de acceder a Postgres e inicializar todo
### Cargamos el programa deseado:
```sql
SELECT str_num_json_validator();
SELECT json_validator();
SELECT suma_binaria();
SELECT palindrome(); -- Para el ejemplo usamos este
```

### Ejecutamos la simulación con un string de entrada
```sql
SELECT * FROM simuladorMT('neuquen');
```
Obtendremos como resultado
 qf | contador | cinta
----|----------|-------
 t  |       36 | BB
 1. **'qf'** indica si la maquina aceptó (t) o rechazo (f) el string de entrada.
 2. **'contador'** indica la cantidad de pasos que se realizaron.
 3. **'cinta'** muestra como quedo la cinta al finalizar la maquina.

### Observamos cada uno de los pasos de la simulación
```sql
SELECT * FROM traza_ejecucion;
```
id | cabezal | estado | caracter |  cinta  | final
----|---------|--------|----------|---------|-------
  0 |       1 | q0     | n        | neuquen |
  1 |       1 | xn     | e        | euquen  |
  2 |       2 | xn     | u        | euquen  |
  3 |       3 | xn     | q        | euquen  |
  4 |       4 | xn     | u        | euquen  |
  5 |       5 | xn     | e        | euquen  |
  ↓ |       ↓ | ↓      | ↓        | ↓       | ↓
 32 |       1 | qs     | B        | Bq      |
 33 |       1 | q0     | q        | q       |
 34 |       2 | xq     | B        | BB      |
 35 |       1 | xfq    | B        | B       |
 36 |       1 | qf     | B        | BB      | t

### Observamos las descripciones instantaneas
```sql
SELECT descripciones();
```
descripciones|-
-------------|-
 q0neuquen
 xneuquen
 exnuquen
 euxnquen
 euqxnuen
 ...
 qsBq
 q0q
 BxqB
 xfqB
 qfBB

## Validar JSONs

### Usando simuadorMT();
```sql
SELECT str_num_json_validator();
SELECT simuladorMT('{"nombre": "Tobias", "año": 2024}');
SELECT json_validator();
SELECT * FROM simuladorMT('{"wwwwww": "wwwwww", "www": 0000}');
```

### Usando validateJson();
```sql
SELECT * FROM validate_json('{"nombre": "Tobias", "año": 2024}');
```
