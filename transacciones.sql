-- 1. Cargar el respaldo de la base de datos unidad2.sql.
CREATE DATABASE unidad2;
\c unidad2;
-- C:\Program Files\PostgreSQL\10\bin
-- psql -U postgres unidad2 < C:\Users\ferna\OneDrive\Documents\Desafio Latam\5. Lenguaje de Consultas BD PostgreSQL\2. Relaciones y Operaciones Transaccionales\desafios\desafioTransacciones\unidad2.sql

-- 2. El cliente usuario01 ha realizado la siguiente compra:
-- ● producto: producto9
-- ● cantidad: 5
-- ● fecha: fecha del sistema
-- Mediante el uso de transacciones, realiza las consultas correspondientes para este
-- requerimiento y luego consulta la tabla producto para validar si fue efectivamente
-- descontado en el stock.

BEGIN TRANSACTION;

INSERT INTO compra(cliente_id, fecha)
VALUES((SELECT id FROM cliente WHERE nombre = 'usuario01'), current_date);

INSERT INTO detalle_compra(producto_id, compra_id, cantidad)
VALUES((SELECT id FROM producto WHERE descripcion = 'producto9'), (SELECT MAX(id) FROM compra), 5);

UPDATE producto SET stock = stock - 5 WHERE descripcion = 'producto9';

COMMIT;

-- 3. El cliente usuario02 ha realizado la siguiente compra:
-- ● producto: producto1, producto2, producto8
-- ● cantidad: 3 de cada producto
-- ● fecha: fecha del sistema
-- Mediante el uso de transacciones, realiza las consultas correspondientes para este
-- requerimiento y luego consulta la tabla producto para validar que si alguno de ellos
-- se queda sin stock, no se realice la compra.

SELECT * FROM compra WHERE id = (SELECT max(id) FROM compra);

BEGIN TRANSACTION;

INSERT INTO compra(cliente_id, fecha)
VALUES((SELECT id FROM cliente WHERE nombre = 'usuario02'), current_date);

INSERT INTO detalle_compra(producto_id, compra_id, cantidad)
VALUES((SELECT id FROM producto WHERE descripcion = 'producto1'), (SELECT MAX(id) FROM compra), 3),
      ((SELECT id FROM producto WHERE descripcion = 'producto2'), (SELECT MAX(id) FROM compra), 3),
      ((SELECT id FROM producto WHERE descripcion = 'producto8'), (SELECT MAX(id) FROM compra), 3);

UPDATE producto SET stock = stock - 3 WHERE descripcion = 'producto1';
UPDATE producto SET stock = stock - 3 WHERE descripcion = 'producto2';
UPDATE producto SET stock = stock - 3 WHERE descripcion = 'producto8';

COMMIT;

SELECT * FROM compra WHERE id = (SELECT max(id) FROM compra);

-- 4. Realizar las siguientes consultas:
-- a. Deshabilitar el AUTOCOMMIT
-- b. Insertar un nuevo cliente
-- c. Confirmar que fue agregado en la tabla cliente
-- d. Realizar un ROLLBACK
-- e. Confirmar que se restauró la información, sin considerar la inserción del
-- punto b
-- f. Habilitar de nuevo el AUTOCOMMIT

\set AUTOCOMMIT off

BEGIN TRANSACTION;
INSERT INTO cliente(id, nombre, email)
VALUES('usuario011', usuario011@gmail.com);
SAVEPOINT nuevo_cliente;
SELECT * FROM cliente WHERE id = (SELECT MAX(id) FROM cliente);
ROLLBACK TO nuevo_cliente;
COMMIT;
SELECT * FROM cliente WHERE id = (SELECT MAX(id) FROM cliente);

\set AUTOCOMMIT on