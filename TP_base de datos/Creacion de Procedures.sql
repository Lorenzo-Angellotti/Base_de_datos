use master
go

use aromasLuminar
go

-- Actualizar estado de pedido

CREATE PROCEDURE actualizar_estado_pedido
    @p_id_pedido INT,
    @p_nuevo_estado NVARCHAR(30)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE pedido
        SET estado_pedido = @p_nuevo_estado
        WHERE id_pedido = @p_id_pedido;

        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO

-- Registrar número de tracking de envío

CREATE PROCEDURE registrar_tracking_envio
    @p_id_pedido INT,
    @p_tracking NVARCHAR(80)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE envio
        SET numero_tracking = @p_tracking,
            estado_envio = 'en camino'
        WHERE id_pedido = @p_id_pedido;

        UPDATE pedido
        SET estado_pedido = 'enviado'
        WHERE id_pedido = @p_id_pedido;

        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO

-- Consultar pedidos por estado

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
GO