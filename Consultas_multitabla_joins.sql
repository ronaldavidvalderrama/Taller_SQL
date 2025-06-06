-- Active: 1748997798874@@127.0.0.1@3306@tallerSQL

-- * Encuentra los nombres de los clientes y los detalles de sus pedidos.
SELECT nombre AS Cliente, detalle_id, pedido_id, producto_id, cantidad, precio_unitario
FROM usuarios AS u
JOIN detalles_pedidos AS d ON u.usuario_id = d.pedido_id
WHERE tipo_id = 1

--* Lista todos los productos pedidos junto con el precio unitario de cada pedido

SELECT pedido_id, precio_unitario
FROM detalles_pedidos


--* Encuentra los nombres de los clientes y los nombres de los empleados que gestionaron sus pedidos

SELECT 
    c.nombre AS nombre_cliente,
    e.nombre AS nombre_empleado
FROM pedidos p
JOIN usuarios c ON p.cliente_id = c.usuario_id
JOIN empleados emp ON p.empleado_id = emp.empleado_id
JOIN usuarios e ON emp.usuario_id = e.usuario_id;

-- Muestra todos los pedidos y, si existen, los productos en cada pedido, incluyendo los pedidos sin productos usando `LEFT JOIN`
SELECT 
    dp.pedido_id,
    pe.cliente_id,
    pe.empleado_id,
    pr.nombre AS producto,
    pe.fecha_pedido,
    pe.estado
FROM pedidos AS pe
LEFT JOIN detalles_pedidos AS dp ON pe.pedido_id = dp.pedido_id
LEFT JOIN productos AS pr ON dp.producto_id = pr.producto_id

-- Encuentra los productos y, si existen, los detalles de pedidos en los que no se ha incluido el producto usando `RIGHT JOIN`.
SELECT 
    dp.producto_id AS detalle_id,
    pr.nombre AS producto,
    pr.categoria,
    pr.precio
FROM detalles_pedidos AS dp
RIGHT JOIN productos AS pr ON pr.producto_id = dp.producto_id

-- Lista todos los empleados junto con los pedidos que han gestionado, si existen, usando `LEFT JOIN` para ver los empleados sin pedidos.
SELECT pe.pedido_id, pe.cliente_id, pe.empleado_id, e.puesto, pe.fecha_pedido FROM pedidos AS pe -- Sujeto de intercepcion
LEFT JOIN empleados AS e ON e.empleado_id = pe.empleado_id; -- Sujeto de data completa

-- Encuentra los empleados que no han gestionado ningún pedido usando un `LEFT JOIN` combinado con `WHERE`.
SELECT * FROM pedidos
WHERE empleado_id NOT IN (
    SELECT empleado_id
    FROM pedidos
);

-- Calcula el total gastado en cada pedido, mostrando el ID del pedido y el total, usando `JOIN`.
SELECT pe.cliente_id, dp.cantidad,
    (cantidad * precio_unitario) AS Total
FROM pedidos AS pe
JOIN detalles_pedidos AS dp ON pe.pedido_id = dp.pedido_id;

-- Realiza un `CROSS JOIN` entre clientes y productos para mostrar todas las combinaciones posibles de clientes y productos.
SELECT * FROM usuarios AS u
CROSS JOIN productos AS pr
WHERE tipo_id = 1;

-- * Encuentra los nombres de los clientes y los productos que han comprado, si existen, incluyendo los clientes que no han realizado pedidos usando `LEFT JOIN`.
SELECT 
    u.nombre AS 'Nombre_cliente',
    pr.nombre AS 'Producto_comprado' 
FROM pedidos AS pe
LEFT JOIN usuarios AS u ON u.usuario_id = pe.cliente_id
LEFT JOIN detalles_pedidos AS dp ON dp.pedido_id = pe.pedido_id
LEFT JOIN productos AS pr ON pr.producto_id = dp.producto_id
WHERE tipo_id = 1;

--* Listar todos los proveedores que suministran un determinado producto.

SELECT
    p.proveedor_id,
    p.nombre,
    pr.producto_id
FROM proveedores p
JOIN proveedores_productos pr ON pr.proveedor_id = p.proveedor_id

--* Obtener todos los productos que ofrece un proveedor específico.

SELECT
    p.producto_id,
    p.nombre AS Producto,
    pr.proveedor_id
FROM productos AS p
JOIN proveedores_productos AS pr ON p.producto_id = pr.producto_id
WHERE pr.proveedor_id = 1

-- * Lista los proveedores que no están asociados a ningún producto (es decir, que aún no suministran).

SELECT
    p.proveedor_id,
    p.nombre,
    pr.producto_id
FROM proveedores p
LEFT JOIN proveedores_productos pr ON pr.proveedor_id = p.proveedor_id
WHERE pr.producto_id IS NULL


--* Contar cuántos proveedores tiene cada producto.

SELECT 
    p.producto_id,
    p.nombre AS Producto,
    COUNT(pr.proveedor_id) AS Cantidad_provedores 
FROM productos AS p
JOIN proveedores_productos pr ON p.producto_id = pr.producto_id
GROUP BY p.producto_id, p.nombre

--* Para un proveedor determinado (p. ej. `proveedor_id = 3`), muestra el nombre de todos los productos que suministra.

SELECT
    pr.proveedor_id,
    p.nombre AS Producto_suministra
FROM productos p
JOIN proveedores_productos pr ON p.producto_id = pr.producto_id
WHERE proveedor_id = 3

--* Para un producto específico (p. ej. `producto_id = 1`),
-- muestra todos los proveedores que lo distribuyen, con sus datos de contacto.

SELECT
    p.producto_id AS Producto,
    pr.nombre AS Proveedor,
    pr.telefono
FROM proveedores pr
JOIN productos p ON p.producto_id = producto_id
WHERE p.producto_id = 1 

--* Cuenta cuántos proveedores tiene cada producto, listando `producto_id`, `nombre` y `cantidad_proveedores`.

SELECT 
    p.producto_id,
    p.nombre AS Producto,
    COUNT(pr.proveedor_id) AS Cantidad_provedores 
FROM productos AS p
JOIN proveedores_productos pr ON p.producto_id = pr.producto_id
GROUP BY p.producto_id, p.nombre

-- Cuenta cuántos productos suministra cada proveedor, mostrando `proveedor_id`, `nombre_proveedor` y `total_productos`.

SELECT
    pr.proveedor_id,
    pr.nombre AS nombre_proveedor,
    COUNT(pp.producto_id) AS total_productos
FROM proveedores AS pr
JOIN proveedores_productos AS pp ON pr.proveedor_id = pp.proveedor_id
GROUP BY pr.proveedor_id, pr.nombre; 

