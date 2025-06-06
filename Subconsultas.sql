-- Active: 1748997798874@@127.0.0.1@3306@tallerSQL

--* Encuentra los nombres de los clientes que han realizado al menos un pedido de más de $500.000.

SELECT  u.usuario_id,
        u.nombre AS nombre_cliente
FROM pedidos p
JOIN (
    SELECT pedido_id, SUM(cantidad * precio_unitario) AS total_pedido
    FROM detalles_pedidos
    GROUP BY pedido_id
    HAVING total_pedido > 500000
) dp ON p.pedido_id = dp.pedido_id
JOIN usuarios u ON p.cliente_id = u.usuario_id;

--* Muestra los productos que nunca han sido pedidos.

SELECT  
    p.producto_id,
    p.nombre AS nombre_productoo
FROM productos p
WHERE p.producto_id NOT IN (
    SELECT dp.producto_id
    FROM detalles_pedidos dp
);

--* Lista los empleados que han gestionado pedidos en los últimos 6 meses.

SELECT e.empleado_id, u.nombre, e.puesto
FROM empleados e
JOIN usuarios u ON e.usuario_id = u.usuario_id
WHERE e.empleado_id IN (
    SELECT p.empleado_id
    FROM pedidos p
    WHERE p.fecha_pedido >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
);

--* Encuentra el pedido con el total de ventas más alto.

SELECT p.pedido_id, dp.cantidad, SUM(dp.cantidad * dp.precio_unitario) AS Totalventas
FROM pedidos p
JOIN detalles_pedidos dp ON p.pedido_id = dp.pedido_id
GROUP BY p.pedido_id, dp.cantidad
ORDER BY totalventas DESC
LIMIT 1;

--* Muestra los nombres de los clientes que han realizado más pedidos que el promedio de pedidos de todos los clientes.

SELECT u.usuario_id AS cliente_id, u.nombre
FROM usuarios u
JOIN pedidos p ON u.usuario_id = p.cliente_id
WHERE u.tipo_id = 1
GROUP BY u.usuario_id, u.nombre
HAVING COUNT(p.pedido_id) > (
    SELECT AVG(pedidos_por_cliente)
    FROM (
        SELECT COUNT(*) AS pedidos_por_cliente
        FROM pedidos
        GROUP BY cliente_id
    ) AS subconsulta
);

--* Obtén los productos cuyo precio es superior al precio promedio de todos los productos.

SELECT
    producto_id AS Productos, nombre, precio
FROM productos
WHERE precio > (
    SELECT AVG(precio)
    FROM productos
);

--* Lista los clientes que han gastado más de $1.000.000 en total.
SELECT
    u.usuario_id,
    u.nombre
FROM usuarios u
WHERE tipo_id = 1
AND u.usuario_id IN (
    SELECT p.cliente_id
    FROM pedidos p
    JOIN detalles_pedidos dp ON p.pedido_id = dp.pedido_id
    GROUP BY p.cliente_id
    HAVING SUM(dp.cantidad * dp.precio_unitario) > 1000000
);

--* Encuentra los empleados que ganan un salario mayor al promedio de la empresa.

SELECT
    e.empleado_id,
    e.puesto,
    e.salario
FROM empleados e
WHERE salario > (
    SELECT AVG(salario)
    FROM empleados
);

--* Obtén los productos que generaron ingresos mayores al ingreso promedio por producto.
SELECT
    p.producto_id,
    p.nombre
FROM productos p
JOIN detalles_pedidos dp ON p.producto_id = dp.producto_id
GROUP BY p.producto_id, p.nombre
HAVING SUM(dp.cantidad * dp.precio_unitario) > (
    SELECT AVG(Ingresos_por_productos)
    FROM (
        SELECT
            dp.pedido_id,
            SUM(dp.cantidad * dp.precio_unitario) AS Ingresos_por_productos
        FROM detalles_pedidos dp
        GROUP BY dp.pedido_id
    ) AS subconsulta
);

--* Encuentra el nombre del cliente que realizó el pedido más reciente.

SELECT
    u.usuario_id AS Clientes,
    u.nombre
FROM usuarios u
WHERE tipo_id = 1
  AND u.usuario_id = (
      SELECT p.cliente_id
      FROM pedidos p
      ORDER BY p.fecha_pedido DESC
      LIMIT 1
  );

--* Muestra los productos pedidos al menos una vez en los últimos 3 meses.

SELECT
    p.producto_id,
    p.nombre
FROM productos p
WHERE p.producto_id IN (
    SELECT dp.producto_id
    FROM detalles_pedidos dp
    JOIN pedidos pe ON dp.pedido_id = pe.pedido_id
    WHERE pe.fecha_pedido >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
);

--* Lista los empleados que no han gestionado ningún pedido.

SELECT
    e.empleado_id,
    e.puesto,
    u.nombre
FROM empleados e
JOIN usuarios u ON e.usuario_id = u.usuario_id
WHERE e.empleado_id NOT IN (
    SELECT DISTINCT p.empleado_id
    FROM pedidos p
);

--* Encuentra los clientes que han comprado más de tres tipos distintos de productos.

SELECT
    u.usuario_id AS Clientes,
    u.nombre
FROM usuarios u
WHERE tipo_id = 1
AND u.usuario_id IN (
    SELECT p.cliente_id
    FROM pedidos p
    JOIN detalles_pedidos dp ON p.pedido_id = dp.pedido_id
    GROUP BY p.cliente_id
    HAVING COUNT(DISTINCT dp.producto_id) > 3
);

--* Muestra el nombre del producto más caro que se ha pedido al menos cinco veces.

SELECT p.nombre, p.precio
FROM productos p
JOIN detalles_pedidos dp ON p.producto_id = dp.producto_id
GROUP BY p.producto_id, p.nombre, p.precio
HAVING COUNT(dp.producto_id) >= 5
ORDER BY p.precio DESC
LIMIT 1;

--* Lista los clientes cuyo primer pedido fue un año después de su registro.






--* Encuentra los nombres de los productos que tienen un stock inferior al promedio del stock de todos los productos.

SELECT nombre, stock
FROM productos
WHERE stock < (
    SELECT AVG(stock)
    FROM productos
);



