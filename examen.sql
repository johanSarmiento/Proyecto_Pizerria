-- Consulta de pedidos por cliente
-- Consulta SQL que muestre el nombre del cliente, el ID del pedido, el total y el estado del pedido

SELECT 
	pe.id,
	CONCAT(p.nombre, ' ', p.apellido) AS nombre,
	SUM(dp.subtotal) AS suma_total,
    pe.estado
FROM detalle_pedido dp
JOIN pedido pe ON dp.pedido_fk = pe.id
JOIN cliente c ON pe.cliente_fk = c.id
JOIN persona p ON c.id = p.id
GROUP BY pe.id, pe.estado;

-- Consulta de pedidos entregados en un rango de fechas
-- Mostrar los pedidos con estado entregado cuya fecha esté entre dos fechas dadas (usa BETWEEN).

   SELECT
	concat(p.nombre,' ',p.apellido) AS nombre_completo,
	pe.fecha_hora,
    pe.estado
FROM pedido pe
JOIN cliente c ON pe.cliente_fk = c.id
JOIN persona p ON c.id = p.id
WHERE pe.fecha_hora BETWEEN '2026-09-01 00:00:00' AND '2026-09-05 23:59:59'
AND pe.estado = "ENTREGADO";

-- Consulta de resumen de pedidos por método de pago
-- Mostrar cuántos pedidos se hicieron por cada método de pago y el total acumulado (GROUP BY).

SELECT 
    pe.metodo_pago,
    COUNT(pe.metodo_pago) AS cantidad_metodos,
    SUM(pe.total) AS total
FROM pedido pe
GROUP BY  pe.metodo_pago;



-- Consulta de clientes frecuentes
-- Mostrar los clientes que tengan más de 5 pedidos en total (usa HAVING COUNT(*) > 5).

    SELECT
    c.id,
    CONCAT(per.nombre, ' ', per.apellido) AS cliente,
    COUNT(p.cliente_fk) AS cantidad_pedido
    FROM pedido p
    JOIN cliente c ON p.cliente_fk = c.id
    JOIN persona per ON c.id = per.id
    WHERE p.estado != 'CANCELADO'
    GROUP BY c.id, per.nombre, per.apellido
    HAVING COUNT(p.cliente_fk) >= 2;
