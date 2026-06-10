use master
go

use aromasLuminar
go

-- Validar stock antes de insertar un detalle de pedido

CREATE TRIGGER trg_validar_stock
ON detalle_pedido
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN producto p ON i.id_producto = p.id_producto
        WHERE p.stock < i.cantidad
    )
    BEGIN
        RAISERROR('No hay stock suficiente para este producto', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
GO


-- Descontar stock cuando se registra un detalle de pedido

CREATE TRIGGER trg_descontar_stock
ON detalle_pedido
AFTER INSERT
AS
BEGIN
    UPDATE p
    SET p.stock = p.stock - i.cantidad
    FROM producto p
    INNER JOIN inserted i ON p.id_producto = i.id_producto;
END;
GO


-- Evitar precios negativos

CREATE TRIGGER trg_validar_precio
ON producto
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE precio <= 0
    )
    BEGIN
        RAISERROR('El precio del producto debe ser mayor a cero', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
GO


-- Actualizar estado del pedido cuando el pago se aprueba

DROP TRIGGER IF EXISTS trg_pago_aprobado;
GO

CREATE TRIGGER trg_pago_aprobado
ON pago
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE pe
    SET pe.estado_pago = 'aprobado',
        pe.estado_pedido = 'aprobado'
    FROM pedido pe
    INNER JOIN inserted i ON pe.id_pedido = i.id_pedido
    WHERE i.estado_pago = 'aprobado';
END;
GO