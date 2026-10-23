-- Muesto nombre de categorias, nombre de productos y el total de ingresos de cada producto vendido por categorias, 
-- los agrupo por nombre de categorias y nombre de productos, los filtro por aquellos productos que en total se vendieron y se recaudaron mas de 100 mil pesos 
-- y los ordeno de mayor a menor por el total_vendido
SELECT c.nombre AS nombre_categoria,
		p.nombre AS producto_vendido,
		SUM(v.precio_unitario * v.cantidad) AS total_vendido
FROM categorias c
INNER JOIN productos p
	ON c.id_categoria = p.id_categoria
INNER JOIN ventas v
	ON p.id_producto = id_venta
GROUP BY c.nombre, p.nombre
HAVING SUM(v.precio_unitario * v.cantidad) > 100000
ORDER BY total_vendido DESC;

-- Muestro todos los clientes registrados que aun no realizaron ninguna compra
SELECT c.*
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

SELECT c.nombre, c.apellido, p.nombre AS nombre_producto, v.fecha
FROM categorias ca
INNER JOIN productos p
 ON ca.id_categoria = p.id_categoria
INNER JOIN ventas v
 ON p.id_producto = v.id_producto
INNER JOIN clientes c
 ON v.id_cliente = c.id_cliente


-- Muestro el nombre y apellido del cliente, nombre, fecha de su ultima compra y cantidad de ese producto vendido
SELECT
    c.nombre,
    c.apellido,
    p.nombre AS nombre_producto,
    MAX(v.fecha) AS ultima_transaccion,
    SUM(v.cantidad) AS cantidad_comprada
FROM categorias ca
INNER JOIN productos p
    ON ca.id_categoria = p.id_categoria
INNER JOIN ventas v
    ON p.id_producto = v.id_producto
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
GROUP BY
    c.id_cliente,
    c.nombre,
    c.apellido,
    p.id_producto,
    p.nombre
ORDER BY cantidad_comprada DESC
LIMIT 1;