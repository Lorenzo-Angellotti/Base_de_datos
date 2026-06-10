use master
go

use aromasLuminar
go

-- 1. Listar todos los productos
SELECT id_producto, nombre, tamano, precio, stock
FROM producto
WHERE activo = 1;

-- 2. Buscar productos de una categoría específica
SELECT p.nombre, p.tamano, p.precio, c.nombre_categoria
FROM producto p
INNER JOIN categoria c ON p.id_categoria = c.id_categoria
WHERE c.nombre_categoria = 'Esencias';

-- 3. Listar productos con stock bajo
SELECT nombre, tamano, stock
FROM producto
WHERE stock <= 5
ORDER BY stock ASC;

-- 4. Consultar productos ordenados por precio menor a mayor
SELECT nombre, tamano, precio
FROM producto
ORDER BY precio ASC;

-- 5. Consultar clientes registrados
SELECT id_cliente, nombre, email, telefono, fecha_registro
FROM cliente
ORDER BY fecha_registro DESC;

-- 6. Listar pedidos con datos del cliente
SELECT 
    p.id_pedido, 
    c.nombre AS cliente, 
    c.email, 
    p.fecha_pedido,
    p.total, 
    p.estado_pedido, 
    p.estado_pago
FROM pedido p
INNER JOIN cliente c ON p.id_cliente = c.id_cliente
ORDER BY p.fecha_pedido DESC;

-- 7. Ver el detalle completo de un pedido
SELECT 
    pe.id_pedido, 
    pr.nombre AS producto, 
    pr.tamano,
    dp.cantidad, 
    dp.precio_unitario, 
    dp.subtotal_linea
FROM detalle_pedido dp
INNER JOIN pedido pe ON dp.id_pedido = pe.id_pedido
INNER JOIN producto pr ON dp.id_producto = pr.id_producto
WHERE pe.id_pedido = 1;

-- 8. Calcular el total vendido por cada pedido
SELECT 
    id_pedido, 
    SUM(subtotal_linea) AS total_productos
FROM detalle_pedido
GROUP BY id_pedido;

-- 9. Obtener ingresos totales de pedidos aprobados
SELECT 
    SUM(total) AS ingresos_totales
FROM pedido
WHERE estado_pago = 'aprobado';

-- 10. Contar pedidos por estado
SELECT 
    estado_pedido, 
    COUNT(*) AS cantidad_pedidos
FROM pedido
GROUP BY estado_pedido;

-- 11. Productos más vendidos
SELECT 
    pr.nombre, 
    pr.tamano, 
    SUM(dp.cantidad) AS unidades_vendidas
FROM detalle_pedido dp
INNER JOIN producto pr ON dp.id_producto = pr.id_producto
GROUP BY pr.id_producto, pr.nombre, pr.tamano
ORDER BY unidades_vendidas DESC;

-- 12. Promedio de compra por cliente
SELECT 
    c.nombre, 
    AVG(p.total) AS promedio_compra
FROM pedido p
INNER JOIN cliente c ON p.id_cliente = c.id_cliente
WHERE p.estado_pago = 'aprobado'
GROUP BY c.id_cliente, c.nombre;

-- 13. Clientes que realizaron más de un pedido
SELECT 
    c.nombre, 
    c.email, 
    COUNT(p.id_pedido) AS cantidad_pedidos
FROM cliente c
INNER JOIN pedido p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre, c.email
HAVING COUNT(p.id_pedido) > 1;

-- 14. Categorías con más de 1 producto
SELECT 
    c.nombre_categoria, 
    COUNT(p.id_producto) AS cantidad_productos
FROM categoria c
INNER JOIN producto p ON c.id_categoria = p.id_categoria
GROUP BY c.id_categoria, c.nombre_categoria
HAVING COUNT(p.id_producto) > 1;

-- 15. Pedidos con envío a sucursal OCA
SELECT 
    pe.id_pedido, 
    cl.nombre AS cliente, 
    e.ciudad, 
    e.provincia,
    e.sucursal_oca, 
    e.numero_tracking
FROM envio e
INNER JOIN pedido pe ON e.id_pedido = pe.id_pedido
INNER JOIN cliente cl ON pe.id_cliente = cl.id_cliente
INNER JOIN metodo_envio me ON e.id_metodo_envio = me.id_metodo_envio
WHERE me.nombre_metodo = 'OCA sucursal a sucursal';

-- 16. Subconsulta: productos con precio mayor al promedio
SELECT 
    nombre, 
    tamano, 
    precio
FROM producto
WHERE precio > (
    SELECT AVG(precio)
    FROM producto
);

-- 17. Subconsulta con IN: clientes que realizaron pedidos aprobados
SELECT 
    nombre, 
    email
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM pedido
    WHERE estado_pago = 'aprobado'
);

-- 18. Subconsulta con EXISTS: productos que fueron vendidos al menos una vez
SELECT 
    p.nombre, 
    p.tamano
FROM producto p
WHERE EXISTS (
    SELECT 1
    FROM detalle_pedido dp
    WHERE dp.id_producto = p.id_producto
);

-- 19. Subconsulta correlacionada: productos cuyo stock es menor que la cantidad total vendida
SELECT 
    p.nombre, 
    p.tamano, 
    p.stock
FROM producto p
WHERE p.stock < (
    SELECT ISNULL(SUM(dp.cantidad), 0)
    FROM detalle_pedido dp
    WHERE dp.id_producto = p.id_producto
);

-- 20. Ventas por mes
SELECT 
    DATEFROMPARTS(YEAR(fecha_pedido), MONTH(fecha_pedido), 1) AS mes,
    SUM(total) AS total_vendido,
    COUNT(*) AS cantidad_pedidos
FROM pedido
WHERE estado_pago = 'aprobado'
GROUP BY DATEFROMPARTS(YEAR(fecha_pedido), MONTH(fecha_pedido), 1)
ORDER BY mes ASC;