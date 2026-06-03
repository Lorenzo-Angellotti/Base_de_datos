use master
go

use aromasLuminar
go

CREATE TRIGGER trg_validar_stock
ON detalle_pedido
INSTEAD OF INSERT
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

    INSERT INTO detalle_pedido 
    (id_pedido, id_producto, cantidad, precio_unitario, subtotal_linea)
    SELECT 
        id_pedido, 
        id_producto, 
        cantidad, 
        precio_unitario, 
        subtotal_linea
    FROM inserted;
END;


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


CREATE TRIGGER trg_pago_aprobado
ON pago
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE pe
    SET 
        pe.estado_pago = 'aprobado',
        pe.estado_pedido = 'aprobado'
    FROM pedido pe
    INNER JOIN inserted i ON pe.id_pedido = i.id_pedido
    WHERE i.estado_pago = 'aprobado';
END;