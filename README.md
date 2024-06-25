Trabajo práctico final de Teoría de Computación, Universidad Nacional General Sarmiento, primer semestre 2024.

[Consigna del trabajo](consigna.pdf)

Este trabajo práctico tiene como objetivo desarrollar un simulador de máquinas de Turing. Este simulador debe ser capaz de tomar la definición de una máquina de Turing, ejecutarla con un _string_ de entrada y registrar cada uno de los movimientos en una base de datos para análisis posterior. Para la implementación, se utilizará _PostgreSQL_ con programación en _pl/pgsql_. Es esencial preparar el entorno adecuado y garantizar que todas las dependencias necesarias estén instaladas, incluyendo Docker para el manejo de contenedores donde se ejecutará _PostgreSQL_. A continuación, se describen los pasos para configurar el entorno necesario para este proyecto.

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

### Nos conectamos al container y luego a postgres
```bash
docker exec -it postgres bash
psql -U postgres
```

### Cargamos el programa deseado:
```sql
SELECT str_num_json_validator();
SELECT json_validator();
SELECT suma_binaria();
SELECT palindrome();
```

### Ejecutamos la simulación con un string de entrada
```sql
SELECT simuladorMT('neuquen');
```
Obtendremos como resultado
```sql
 simuladormt
-------------
 (t,36,BB)
```
 1. El primer valor (t) indica si la maquina aceptó (t) o rechazo (f) el string de entrada.
 2. El segundo valor (36) indica la cantidad de pasos que se realizaron.
 3. El tercer valor (BB) muestra como quedo la cinta.

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