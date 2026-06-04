use master
go

use aromasLuminar
go

--Actualizar estado de pedido
CREATE PROCEDURE actualizar_estado_pedido
    @p_id_pedido INT,
    @p_nuevo_estado NVARCHAR(30)
AS
BEGIN
    UPDATE pedido
    SET estado_pedido = @p_nuevo_estado
    WHERE id_pedido = @p_id_pedido;
END;


--Registrar número de tracking
CREATE PROCEDURE registrar_tracking_envio
    @p_id_pedido INT,
    @p_tracking NVARCHAR(80)
AS
BEGIN
    UPDATE envio
    SET numero_tracking = @p_tracking,
        estado_envio = 'en camino'
    WHERE id_pedido = @p_id_pedido;

    UPDATE pedido
    SET estado_pedido = 'enviado'
    WHERE id_pedido = @p_id_pedido;
END;


--Consultar pedidos por estado
CREATE PROCEDURE consultar_pedidos_por_estado
    @p_estado NVARCHAR(30)
AS
BEGIN
    SELECT 
        pe.id_pedido,
        cl.nombre AS cliente,
        pe.fecha_pedido,
        pe.total,
        pe.estado_pedido
    FROM pedido pe
    INNER JOIN cliente cl ON pe.id_cliente = cl.id_cliente
    WHERE pe.estado_pedido = @p_estado;
END;