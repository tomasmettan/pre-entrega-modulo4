/*Muestra el nombre de cada categoría, la cantidad
total de unidades vendidas y el ingreso total generado.
Se muestran únicamente las categorías cuyos ingresos superan los $100.000.
Y se ordenan las categorías de mayor a menor ingreso. */
SELECT c.nombre AS nombre_categoria,
    SUM(v.cantidad) AS unidades_vendidas,
    SUM(v.precio_unitario * v.cantidad) AS total_ingreso
FROM categorias c
INNER JOIN productos p
    ON c.id_categoria = p.id_categoria
INNER JOIN ventas v
    ON p.id_producto = v.id_producto
GROUP BY c.id_categoria, c.nombre
HAVING SUM(v.precio_unitario * v.cantidad) > 100000
ORDER BY total_ingreso DESC;

/*Muestra los clientes registrados que no tienen
ninguna venta asociada. Utiliza LEFT JOIN para conservar
todos los clientes y filtra aquellos que no tienen coincidencias
en la tabla ventas. */
SELECT
    c.id_cliente,
    c.nombre,
    c.apellido,
	COALESCE(v.id_venta::VARCHAR, 'Sin compras') AS estado_compra
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

/*Muestra el nombre y apellido de cada cliente,
 el producto que más unidades compró y la fecha de su última
 compra de ese producto. Une las tablas clientes,
 ventas y productos, y utiliza una subconsulta con LIMIT 1
 para seleccionar el producto más comprado por cada cliente.  */
SELECT
    c.nombre,
    c.apellido,
    p.nombre AS nombre_producto,
    MAX(v.fecha) AS ultima_transaccion
FROM clientes c
INNER JOIN ventas v
    ON c.id_cliente = v.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
WHERE p.id_producto = (
    SELECT v2.id_producto
    FROM ventas v2
    WHERE v2.id_cliente = c.id_cliente
    GROUP BY v2.id_producto
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
GROUP BY
    c.id_cliente,
    c.nombre,
    c.apellido,
    p.id_producto,
    p.nombre
ORDER BY c.nombre;
