Creación Base de datos
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema pizzeria_don_piccolo
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS pizzeria_don_piccolo ;

-- -----------------------------------------------------
-- Schema pizzeria_don_piccolo
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS pizzeria_don_piccolo DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE pizzeria_don_piccolo ;

-- -----------------------------------------------------
-- Table pizzeria_don_piccolo.persona
-- -----------------------------------------------------
DROP TABLE IF EXISTS pizzeria_don_piccolo.persona ;

CREATE TABLE IF NOT EXISTS pizzeria_don_piccolo.persona (
id INT NOT NULL AUTO_INCREMENT,
nombre VARCHAR(50) NOT NULL,
apellido VARCHAR(50) NOT NULL,
telefono VARCHAR(20) NOT NULL,
direccion VARCHAR(150) NOT NULL,
correo VARCHAR(100) NOT NULL,
PRIMARY KEY (id),
UNIQUE INDEX correo_UNIQUE (correo ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table pizzeria_don_piccolo.cliente
-- -----------------------------------------------------
DROP TABLE IF EXISTS pizzeria_don_piccolo.cliente ;

CREATE TABLE IF NOT EXISTS pizzeria_don_piccolo.cliente (
id INT NOT NULL AUTO_INCREMENT,
puntos INT NOT NULL DEFAULT '0',
PRIMARY KEY (id),
CONSTRAINT fk_cliente_persona
FOREIGN KEY (id)
REFERENCES pizzeria_don_piccolo.persona (id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table pizzeria_don_piccolo.pedido
-- -----------------------------------------------------
DROP TABLE IF EXISTS pizzeria_don_piccolo.pedido ;

CREATE TABLE IF NOT EXISTS pizzeria_don_piccolo.pedido (
id INT NOT NULL AUTO_INCREMENT,
cliente_fk INT NOT NULL,
fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
metodo_pago ENUM('EFECTIVO', 'TARJETA', 'APP') NOT NULL,
estado ENUM('PENDIENTE', 'EN PREPARACION', 'ENTREGADO', 'CANCELADO') NOT NULL DEFAULT 'PENDIENTE',
total DOUBLE NOT NULL DEFAULT '0',
PRIMARY KEY (id),
INDEX fk_pedido_1_idx (cliente_fk ASC) VISIBLE,
CONSTRAINT fk_pedido_1
FOREIGN KEY (cliente_fk)
REFERENCES pizzeria_don_piccolo.cliente (id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table pizzeria_don_piccolo.pizza
-- -----------------------------------------------------
DROP TABLE IF EXISTS pizzeria_don_piccolo.pizza ;

CREATE TABLE IF NOT EXISTS pizzeria_don_piccolo.pizza (
id INT NOT NULL AUTO_INCREMENT,
nombre VARCHAR(50) NOT NULL,
tamano ENUM('Pequeña', 'Mediana', 'Grande') NOT NULL,
precio_base DOUBLE NOT NULL,
tipo ENUM('Vegetariana', 'Especial', 'Clásica') NOT NULL,
PRIMARY KEY (id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table pizzeria_don_piccolo.detalle_pedido
-- -----------------------------------------------------
DROP TABLE IF EXISTS pizzeria_don_piccolo.detalle_pedido ;

CREATE TABLE IF NOT EXISTS pizzeria_don_piccolo.detalle_pedido (
id INT NOT NULL AUTO_INCREMENT,
pedido_fk INT NOT NULL,
pizza_fk INT NOT NULL,
cantidad INT NOT NULL,
subtotal DOUBLE NOT NULL,
PRIMARY KEY (id),
INDEX fk_detalle_pedido_1_idx (pedido_fk ASC) VISIBLE,
INDEX fk_detalle_pedido_2_idx (pizza_fk ASC) VISIBLE,
CONSTRAINT fk_detalle_pedido_1
FOREIGN KEY (pedido_fk)
REFERENCES pizzeria_don_piccolo.pedido (id),
CONSTRAINT fk_detalle_pedido_2
FOREIGN KEY (pizza_fk)
REFERENCES pizzeria_don_piccolo.pizza (id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table pizzeria_don_piccolo.repartidor
-- -----------------------------------------------------
DROP TABLE IF EXISTS pizzeria_don_piccolo.repartidor ;

CREATE TABLE IF NOT EXISTS pizzeria_don_piccolo.repartidor (
id INT NOT NULL AUTO_INCREMENT,
zona_asignada VARCHAR(50) NOT NULL,
estado ENUM('DISPONIBLE', 'NO DISPONIBLE') NOT NULL DEFAULT 'DISPONIBLE',
PRIMARY KEY (id),
CONSTRAINT fk_repartidor_persona
FOREIGN KEY (id)
REFERENCES pizzeria_don_piccolo.persona (id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table pizzeria_don_piccolo.domicilio
-- -----------------------------------------------------
DROP TABLE IF EXISTS pizzeria_don_piccolo.domicilio ;

CREATE TABLE IF NOT EXISTS pizzeria_don_piccolo.domicilio (
id INT NOT NULL AUTO_INCREMENT,
pedido_fk INT NOT NULL,
repartidor_fk INT NOT NULL,
hora_salida DATETIME NULL DEFAULT NULL,
hora_entrega DATETIME NULL DEFAULT NULL,
distancia_km DOUBLE NOT NULL,
costo_envio DOUBLE NOT NULL,
PRIMARY KEY (id),
INDEX fk_domicilio_1_idx (pedido_fk ASC) VISIBLE,
INDEX fk_domicilio_2_idx (repartidor_fk ASC) VISIBLE,
CONSTRAINT fk_domicilio_1
FOREIGN KEY (pedido_fk)
REFERENCES pizzeria_don_piccolo.pedido (id),
CONSTRAINT fk_domicilio_2
FOREIGN KEY (repartidor_fk)
REFERENCES pizzeria_don_piccolo.repartidor (id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table pizzeria_don_piccolo.historial_precios
-- -----------------------------------------------------
DROP TABLE IF EXISTS pizzeria_don_piccolo.historial_precios ;

CREATE TABLE IF NOT EXISTS pizzeria_don_piccolo.historial_precios (
id INT NOT NULL AUTO_INCREMENT,
pizza_fk INT NOT NULL,
precio_anterior DOUBLE NOT NULL,
precio_nuevo DOUBLE NOT NULL,
fecha_cambio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (id),
INDEX fk_historial_precios_1_idx (pizza_fk ASC) VISIBLE,
CONSTRAINT fk_historial_precios_1
FOREIGN KEY (pizza_fk)
REFERENCES pizzeria_don_piccolo.pizza (id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table pizzeria_don_piccolo.ingrediente
-- -----------------------------------------------------
DROP TABLE IF EXISTS pizzeria_don_piccolo.ingrediente ;

CREATE TABLE IF NOT EXISTS pizzeria_don_piccolo.ingrediente (
id INT NOT NULL AUTO_INCREMENT,
nombre VARCHAR(50) NOT NULL,
stock_actual INT NOT NULL,
stock_minimo INT NOT NULL,
costo_unitario DOUBLE NOT NULL,
PRIMARY KEY (id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table pizzeria_don_piccolo.pizza_ingrediente
-- -----------------------------------------------------
DROP TABLE IF EXISTS pizzeria_don_piccolo.pizza_ingrediente ;

CREATE TABLE IF NOT EXISTS pizzeria_don_piccolo.pizza_ingrediente (
pizza_fk INT NOT NULL,
ingrediente_fk INT NOT NULL,
cantidad_usada INT NOT NULL,
PRIMARY KEY (pizza_fk, ingrediente_fk),
INDEX fk_pizza_ingrediente_2_idx (ingrediente_fk ASC) VISIBLE,
CONSTRAINT fk_pizza_ingrediente_1
FOREIGN KEY (pizza_fk)
REFERENCES pizzeria_don_piccolo.pizza (id),
CONSTRAINT fk_pizza_ingrediente_2
FOREIGN KEY (ingrediente_fk)
REFERENCES pizzeria_don_piccolo.ingrediente (id))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

Insertar Datos en la Tabla
USE pizzeria_don_piccolo;

INSERT INTO persona (nombre, apellido, telefono, direccion, correo) VALUES
('Carlos', 'Pérez', '3101234567', 'Calle 50 # 20-30', 'carlos.perez@gmail.com'),
('María', 'Gómez', '3209876543', 'Carrera 33 # 45-12', 'maria.gomez@hotmail.com'),
('Andrés', 'Rodríguez', '3154567890', 'Transversal Oriental # 10-25', 'andres.rodriguez@yahoo.com'),
('Laura', 'Martínez', '3187654321', 'Avenida Los Almendros # 8-15', 'laura.martinez@gmail.com'),
('Jorge', 'Díaz', '3112345678', 'Calle 100 # 15-40', 'jorge.diaz@outlook.com'),
('Felipe', 'Rojas', '3161112233', 'Calle 60 # 18-20', 'felipe.rojas@pizzeria.com'),
('Diana', 'Torres', '3172223344', 'Carrera 27 # 50-10', 'diana.torres@pizzeria.com'),
('Mateo', 'Vargas', '3183334455', 'Calle 14 # 22-05', 'mateo.vargas@pizzeria.com'),
('Sofia', 'Castro', '3194445566', 'Carrera 40 # 70-33', 'sofia.castro@pizzeria.com');

INSERT INTO cliente (id, puntos) VALUES (1, 12), (2, 4), (3, 20), (4, 2), (5, 8);

INSERT INTO repartidor (id, zona_asignada, estado) VALUES
(6, 'Zona Norte', 'DISPONIBLE'),
(7, 'Zona Centro', 'DISPONIBLE'),
(8, 'Zona Sur', 'NO DISPONIBLE'),
(9, 'Zona Oriental', 'DISPONIBLE');

INSERT INTO ingrediente (nombre, stock_actual, stock_minimo, costo_unitario) VALUES
('Queso Mozzarella', 50, 10, 2500.00),
('Salsa de Tomate', 40, 8, 1200.00),
('Pepperoni', 30, 5, 3500.00),
('Champiñones', 25, 5, 2000.00),
('Jamón', 35, 6, 3000.00),
('Piña', 20, 4, 1500.00),
('Tomate', 25, 5, 1000.00);

INSERT INTO pizza (nombre, tamano, precio_base, tipo) VALUES
('Margarita', 'Mediana', 18000.00, 'Clásica'),
('Pepperoni', 'Grande', 26000.00, 'Clásica'),
('Hawaiana', 'Mediana', 20000.00, 'Especial'),
('Vegetariana', 'Mediana', 22000.00, 'Vegetariana'),
('Super Special', 'Grande', 30000.00, 'Especial');

INSERT INTO pizza_ingrediente (pizza_fk, ingrediente_fk, cantidad_usada) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 1, 3),
(2, 2, 1),
(2, 3, 2),
(3, 1, 2),
(3, 2, 1),
(3, 5, 2),
(3, 6, 2),
(4, 1, 2),
(4, 2, 1),
(4, 4, 2),
(4, 7, 2),
(5, 1, 3),
(5, 2, 1),
(5, 3, 2),
(5, 5, 2),
(5, 4, 2);

INSERT INTO pedido (cliente_fk, fecha_hora, metodo_pago, estado, total) VALUES
(1, '2026-09-01 12:30:00', 'EFECTIVO', 'ENTREGADO', 0.00),
(2, '2026-09-02 14:15:00', 'TARJETA', 'ENTREGADO', 0.00),
(1, '2026-09-05 19:00:00', 'APP', 'ENTREGADO', 0.00),
(3, '2026-09-08 20:30:00', 'EFECTIVO', 'EN PREPARACION', 0.00),
(4, '2026-09-10 13:00:00', 'TARJETA', 'PENDIENTE', 0.00);

INSERT INTO detalle_pedido (pedido_fk, pizza_fk, cantidad, subtotal) VALUES
(1, 1, 2, 36000.00),
(1, 3, 1, 20000.00),
(2, 2, 1, 26000.00),
(3, 4, 2, 44000.00),
(4, 5, 1, 30000.00),
(5, 2, 2, 52000.00);

INSERT INTO domicilio (pedido_fk, repartidor_fk, hora_salida, hora_entrega, distancia_km, costo_envio) VALUES
(1, 6, '2026-09-01 12:50:00', '2026-09-01 13:15:00', 3.5, 4000.00),
(2, 7, '2026-09-02 14:35:00', '2026-09-02 15:00:00', 5.0, 6000.00),
(3, 9, '2026-09-05 19:20:00', '2026-09-05 19:50:00', 4.2, 5000.00),
(4, 8, '2026-09-08 20:50:00', NULL, 6.0, 7000.00);

INSERT INTO historial_precios (pizza_fk, precio_anterior, precio_nuevo, fecha_cambio) VALUES
(1, 16000.00, 18000.00, '2026-08-15 10:00:00'),
(2, 24000.00, 26000.00, '2026-08-20 14:30:00'),
(3, 18500.00, 20000.00, '2026-09-01 09:15:00');

-- Funciones y Procedimientos
-- Función para calcular el total de un pedido (sumando precios de pizzas + costo de envío + IVA)

-- Estructura del Script

DELIMITER $$

DROP FUNCTION IF EXISTS calcular_total_pedido$$

CREATE FUNCTION calcular_total_pedido(p_id_pedido INT)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
DECLARE v_subtotal_pizzas DOUBLE DEFAULT 0;
DECLARE v_costo_envio DOUBLE DEFAULT 0;
DECLARE v_iva DOUBLE DEFAULT 0;
DECLARE v_total DOUBLE DEFAULT 0;

SELECT COALESCE(SUM(subtotal), 0) INTO v_subtotal_pizzas
FROM detalle_pedido
WHERE pedido_fk = p_id_pedido;

SELECT COALESCE(costo_envio, 0) INTO v_costo_envio
FROM domicilio
WHERE pedido_fk = p_id_pedido
LIMIT 1;

	SET v_iva = (v_subtotal_pizzas + v_costo_envio) * 0.19;

	SET v_total = v_subtotal_pizzas + v_costo_envio + v_iva;

	RETURN v_total;
END$$

DELIMITER ;


SELECT id, metodo_pago, estado, calcular_total_pedido(id) AS total_con_iva FROM pedido;

-- Función para calcular la ganancia neta diaria (ventas - costos de ingredientes)

-- Estructura del Script

DELIMITER $$

DROP FUNCTION IF EXISTS calcular_ganancia_neta_diaria$$

CREATE FUNCTION calcular_ganancia_neta_diaria(p_fecha DATE)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
DECLARE v_total_ventas DOUBLE DEFAULT 0;
DECLARE v_total_costo_ingredientes DOUBLE DEFAULT 0;
DECLARE v_ganancia_neta DOUBLE DEFAULT 0;


SELECT COALESCE(SUM(dp.subtotal), 0) INTO v_total_ventas
FROM pedido p
JOIN detalle_pedido dp ON p.id = dp.pedido_fk
WHERE DATE(p.fecha_hora) = p_fecha AND p.estado != 'CANCELADO';


SELECT COALESCE(SUM(dp.cantidad * pi.cantidad_usada * i.costo_unitario), 0) INTO v_total_costo_ingredientes
FROM pedido p
JOIN detalle_pedido dp ON p.id = dp.pedido_fk
JOIN pizza_ingrediente pi ON dp.pizza_fk = pi.pizza_fk
JOIN ingrediente i ON pi.ingrediente_fk = i.id
WHERE DATE(p.fecha_hora) = p_fecha AND p.estado != 'CANCELADO';


SET v_ganancia_neta = v_total_ventas - v_total_costo_ingredientes;

RETURN v_ganancia_neta;
END$$

DELIMITER ;

SELECT calcular_ganancia_neta_diaria('2026-09-01');

-- Procedimiento para cambiar automáticamente el estado del pedido a “entregado” cuando se registre la hora de entrega.

-- Estructura del Script

DELIMITER $$

CREATE PROCEDURE registrar_entrega_domicilio(
IN p_id_domicilio INT,
IN p_hora_entrega DATETIME
)
BEGIN
DECLARE v_id_pedido INT;

SELECT pedido_fk INTO v_id_pedido
FROM domicilio
WHERE id = p_id_domicilio;

IF v_id_pedido IS NOT NULL THEN
	

	UPDATE domicilio
	SET hora_entrega = p_hora_entrega
	WHERE id = p_id_domicilio;

	
	UPDATE pedido
	SET estado = 'ENTREGADO'
	WHERE id = v_id_pedido;
	
	SELECT CONCAT('Domicilio ', p_id_domicilio, ' y Pedido ', v_id_pedido, ' actualizados a ENTREGADO con éxito.') AS mensaje;

ELSE
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'El ID de domicilio especificado no existe.';
END IF;
END$$

DELIMITER ;

CALL registrar_entrega_domicilio(4, '2026-09-08 21:15:00');

-- Triggers
-- Trigger de actualización automática de stock de ingredientes cuando se realiza un pedido.

-- Estructura del Script
DELIMITER $$
CREATE TRIGGER actualizar_stock_ingredientes `AFTER INSERT ON `detalle_pedido
FOR EACH ROW
BEGIN

UPDATE ingrediente i
JOIN pizza_ingrediente pi ON i.id = pi.ingrediente_fk
SET i.stock_actual = i.stock_actual - (pi.cantidad_usada * NEW.cantidad)
WHERE pi.pizza_fk = NEW.pizza_fk;

END$$

DELIMITER ;

SELECT id, nombre, stock_actual FROM ingrediente;

INSERT INTO detalle_pedido (pedido_fk, pizza_fk, cantidad, subtotal)
VALUES (5, 1, 2, 36000.00);

-- Trigger de auditoría que registre en una tabla historial_precios cada vez que se modifique el precio de una pizza.

-- Estructura de Script
DELIMITER $$

CREATE TRIGGER auditoria_cambio_precio_pizza `AFTER UPDATE ON `pizza
FOR EACH ROW
BEGIN

IF OLD.precio_base <> NEW.precio_base THEN
INSERT INTO historial_precios (pizza_fk, precio_anterior, precio_nuevo, fecha_cambio)
VALUES (NEW.id, OLD.precio_base, NEW.precio_base, NOW());
END IF;
END$$

DELIMITER ;

SELECT id, nombre, precio_base FROM pizza WHERE id = 1;

UPDATE pizza
SET precio_base = 19500.00
WHERE id = 1;

SELECT * FROM historial_precios;

-- Trigger para marcar repartidor como “disponible” nuevamente cuando termina un domicilio.

-- Estructura del script
DELIMITER $$

CREATE TRIGGER marcar_repartidor_disponible `AFTER UPDATE ON `domicilio
FOR EACH ROW
BEGIN

IF OLD.hora_entrega IS NULL AND NEW.hora_entrega IS NOT NULL THEN
UPDATE repartidor
SET estado = 'DISPONIBLE'
WHERE id = NEW.repartidor_fk;
END IF;
END$$

DELIMITER ;



SELECT r.id, p.nombre, r.estado
FROM repartidor r
JOIN persona p ON r.id = p.id;

UPDATE domicilio
SET hora_entrega = NOW()
WHERE id = 4;

select p.nombre, r.estado
from domicilio d
JOIN repartidor r ON d.repartidor_fk = r.id
JOIN persona p ON r.id = p.id;

-- Consultas SQL
-- Clientes con pedidos entre dos fechas (BETWEEN)

-- Estructura del Script

SELECT
concat(p.nombre,' ',p.apellido) AS nombre_completo,
pe.fecha_hora
FROM pedido pe
JOIN cliente c ON pe.cliente_fk = c.id
JOIN persona p ON c.id = p.id
WHERE pe.fecha_hora BETWEEN '2026-09-01 00:00:00' AND '2026-09-05 23:59:59';

-- Pizzas más vendidas (GROUP BY y COUNT).

-- Estructura del Script

SELECT
p.nombre,
count(dp.cantidad)
FROM detalle_pedido dp
JOIN pizza p ON dp.pizza_fk = p.id
GROUP BY p.nombre;

-- Pedidos por repartidor (JOIN).

-- Estructura del Script

SELECT
r.id,
concat(p.nombre,' ',p.apellido) AS nombre_completo,
count(d.id) AS total_pedidos
FROM repartidor r
JOIN persona p ON r.id = p. id
JOIN domicilio d ON r.id = d.repartidor_fk
GROUP BY r.id;

-- Promedio de entrega por zona (AVG y JOIN).

-- Estructura del Script

SELECT
r.id,
CONCAT(p.nombre, ' ', p.apellido) AS repartidor,
AVG(d.distancia_km) AS promedio_distancia_km,
AVG(d.costo_envio) AS promedio_costo_envio
FROM domicilio d
JOIN repartidor r ON d.repartidor_fk = r.id
JOIN persona p ON r.id = p.id
GROUP BY r.id, p.nombre, p.apellido;

-- Clientes que gastaron más de un monto (HAVING).

-- Estructura del Script

SELECT
c.id,
CONCAT(per.nombre, ' ', per.apellido) AS cliente,
SUM(calcular_total_pedido(p.id)) AS gasto_total
FROM pedido p
JOIN cliente c ON p.cliente_fk = c.id
JOIN persona per ON c.id = per.id
WHERE p.estado != 'CANCELADO'
GROUP BY c.id, per.nombre, per.apellido
HAVING gasto_total > 50000.00;

-- Búsqueda por coincidencia parcial de nombre de pizza (LIKE).

-- Estructura del Script

SELECT *
FROM pizza
WHERE nombre LIKE '%Special%';

-- Subconsulta para obtener los clientes frecuentes (más de 5 pedidos mensuales).

-- Estructura del Script

SELECT
c.id,
CONCAT(per.nombre, ' ', per.apellido) AS cliente,
DATE_FORMAT(p.fecha_hora, '%Y-%m') AS mes,
COUNT(p.id) AS total_pedidos_mes
FROM pedido p
JOIN cliente c ON p.id = c.id
JOIN persona per ON c.id = per.id
GROUP BY c.id, per.nombre, per.apellido, mes
HAVING total_pedidos_mes > 0;

-- Vistas
-- Vista de resumen de pedidos por cliente (nombre del cliente, cantidad de pedidos, total gastado).

-- Estructura del Script

CREATE VIEW vista_resumen_pedidos_cliente AS
SELECT
c.id,
CONCAT(per.nombre, ' ', per.apellido) AS nombre_cliente,
COUNT(p.id) AS cantidad_pedidos,
SUM(CASE WHEN p.estado != 'CANCELADO' THEN calcular_total_pedido(p.id) ELSE 0 END) AS total_gastado
FROM cliente c
JOIN persona per ON c.id = per.id
LEFT JOIN pedido p ON c.id = p.cliente_fk
GROUP BY c.id, per.nombre, per.apellido;

SELECT * FROM vista_resumen_pedidos_cliente ORDER BY total_gastado DESC;

-- /*Vista de desempeño de repartidores (número de entregas, tiempo promedio, zona).*/

-- Estructura del Script

CREATE VIEW vista_desempeno_repartidores AS
SELECT
r.id,
CONCAT(per.nombre, ' ', per.apellido) AS nombre_repartidor,
r.estado,
COUNT(d.id) AS numero_entregas_realizadas,
AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)) AS tiempo_promedio_minutos,
AVG(d.distancia_km) AS promedio_distancia_km
FROM repartidor r
JOIN persona per ON r.id = per.id
JOIN domicilio d ON r.id = d.repartidor_fk AND d.hora_entrega IS NOT NULL
GROUP BY r.id, per.nombre, per.apellido, r.estado;


SELECT * FROM vista_desempeno_repartidores;

/*Vista de stock de ingredientes por debajo del mínimo permitido.*/

-- Estructura del Script

CREATE VIEW vista_stock_critico_ingredientes AS
SELECT
id,
nombre,
stock_actual,
stock_minimo,
(stock_minimo - stock_actual) AS deficit
FROM ingrediente
WHERE stock_actual < stock_minimo;


SELECT * FROM vista_stock_critico_ingredientes;

update ingrediente
set stock_actual = 5
where id = 7