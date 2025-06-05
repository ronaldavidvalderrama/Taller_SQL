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