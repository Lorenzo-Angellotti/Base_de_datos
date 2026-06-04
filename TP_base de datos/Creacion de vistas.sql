use master
go

use aromasLuminar
go

CREATE VIEW vista_resumen_pedidos AS
SELECT 
    p.id_pedido, 
    c.nombre AS cliente, 
    c.email, 
    p.fecha_pedido,
    p.subtotal, 
    p.costo_envio, 
    p.descuento_total, 
    p.total,
    p.estado_pedido, 
    p.estado_pago
FROM pedido p
INNER JOIN cliente c ON p.id_cliente = c.id_cliente;


CREATE VIEW vista_productos_categoria AS
SELECT 
    p.id_producto, 
    p.sku, 
    p.nombre, 
    p.tamano, 
    p.precio,
    p.stock, 
    c.nombre_categoria, 
    p.activo
FROM producto p
INNER JOIN categoria c ON p.id_categoria = c.id_categoria;


CREATE VIEW vista_ventas_por_producto AS
SELECT 
    pr.id_producto, 
    pr.nombre, 
    pr.tamano,
    SUM(dp.cantidad) AS unidades_vendidas,
    SUM(dp.subtotal_linea) AS total_recaudado
FROM detalle_pedido dp
INNER JOIN producto pr ON dp.id_producto = pr.id_producto
INNER JOIN pedido pe ON dp.id_pedido = pe.id_pedido
WHERE pe.estado_pago = 'aprobado'
GROUP BY pr.id_producto, pr.nombre, pr.tamano;


CREATE VIEW vista_pedidos_envio AS
SELECT 
    p.id_pedido, 
    c.nombre AS cliente, 
    me.nombre_metodo,
    e.codigo_postal, 
    e.provincia, 
    e.ciudad, 
    e.direccion,
    e.sucursal_oca, 
    e.numero_tracking, 
    e.estado_envio
FROM pedido p
INNER JOIN cliente c ON p.id_cliente = c.id_cliente
INNER JOIN envio e ON p.id_pedido = e.id_pedido
INNER JOIN metodo_envio me ON e.id_metodo_envio = me.id_metodo_envio;
