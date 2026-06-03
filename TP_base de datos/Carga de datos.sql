use master
go

use aromasLuminar
go

INSERT INTO categoria (nombre_categoria, descripcion) VALUES
('Esencias', 'Esencias aromáticas para velas y perfumería.'),
('Insumos', 'Materiales para elaboración de velas.'),
('Ceras', 'Ceras vegetales y parafina.'),
('Envases', 'Frascos, vasos y recipientes para velas.'),
('Perfumería fina', 'Productos aromáticos de uso personal y ambiental.');


INSERT INTO producto 
(sku, nombre, descripcion, id_categoria, tamano, precio, stock, peso_gramos, alto_cm, ancho_cm, largo_cm, imagen, activo) 
VALUES
('ESC-VAN-100', 'Esencia de Vainilla', 'Esencia aromática para velas.', 1, '100 ml', 3500, 20, 100, 12, 5, 5, 'vainilla.jpg', 1),
('ESC-LAV-100', 'Esencia de Lavanda', 'Esencia relajante para velas.', 1, '100 ml', 3700, 15, 100, 12, 5, 5, 'lavanda.jpg', 1),
('ESC-COC-250', 'Esencia de Coco', 'Esencia tropical para velas.', 1, '250 ml', 7200, 8, 250, 18, 7, 7, 'coco.jpg', 1),
('CER-SOJ-1KG', 'Cera de Soja', 'Cera vegetal para elaboración de velas.', 3, '1 kg', 6200, 25, 1000, 20, 15, 8, 'cera_soja.jpg', 1),
('CER-PAR-1KG', 'Parafina Premium', 'Parafina refinada para velas.', 3, '1 kg', 5400, 12, 1000, 20, 15, 8, 'parafina.jpg', 1),
('PAB-ALG-10M', 'Pabilo de Algodón', 'Rollo de pabilo para velas.', 2, '10 metros', 2500, 30, 80, 10, 8, 4, 'pabilo.jpg', 1),
('ENV-VAS-200', 'Vaso de Vidrio 200 ml', 'Envase de vidrio para vela aromática.', 4, '200 ml', 1800, 50, 200, 9, 7, 7, 'vaso_vidrio.jpg', 1),
('ENV-LAT-150', 'Lata Metálica 150 ml', 'Lata para vela decorativa.', 4, '150 ml', 1600, 40, 150, 6, 8, 8, 'lata.jpg', 1),
('PER-TEX-250', 'Perfume Textil Jazmín', 'Perfume textil para ropa y ambientes.', 5, '250 ml', 4800, 10, 250, 18, 6, 6, 'perfume_textil.jpg', 1),
('DIF-AMB-500', 'Difusor Ambiental', 'Difusor aromático para ambientes.', 5, '500 ml', 9500, 4, 500, 22, 8, 8, 'difusor.jpg', 1);


INSERT INTO cliente (nombre, email, telefono, fecha_registro) VALUES
('Sofía Martínez', 'sofia.martinez@gmail.com', '1123456789', '2026-05-01 10:30:00'),
('Lucas Fernández', 'lucas.fernandez@gmail.com', '1134567890', '2026-05-03 15:20:00'),
('Camila Rodríguez', 'camila.rodriguez@gmail.com', '1145678901', '2026-05-05 09:10:00'),
('Martín González', 'martin.gonzalez@gmail.com', '1156789012', '2026-05-07 18:45:00');


INSERT INTO metodo_envio (nombre_metodo, descripcion) VALUES
('Retiro por local', 'El cliente retira su pedido por el local.'),
('OCA a domicilio', 'Envío del pedido al domicilio del cliente mediante OCA.'),
('OCA sucursal a sucursal', 'Envío del pedido a una sucursal OCA seleccionada.');


INSERT INTO pedido 
(id_cliente, fecha_pedido, subtotal, costo_envio, descuento_total, total, estado_pedido, estado_pago) 
VALUES
(1, '2026-05-10 11:00:00', 9700, 1500, 0, 11200, 'aprobado', 'aprobado'),
(2, '2026-05-12 14:30:00', 12300, 0, 1000, 11300, 'pendiente', 'pendiente'),
(3, '2026-05-15 16:20:00', 14200, 1800, 0, 16000, 'enviado', 'aprobado'),
(1, '2026-05-20 12:10:00', 9500, 2000, 500, 11000, 'aprobado', 'aprobado');


INSERT INTO detalle_pedido 
(id_pedido, id_producto, cantidad, precio_unitario, subtotal_linea) 
VALUES
(1, 1, 1, 3500, 3500),
(1, 4, 1, 6200, 6200),
(2, 2, 1, 3700, 3700),
(2, 6, 2, 2500, 5000),
(2, 7, 2, 1800, 3600),
(3, 3, 1, 7200, 7200),
(3, 5, 1, 5400, 5400),
(3, 8, 1, 1600, 1600),
(4, 10, 1, 9500, 9500);


INSERT INTO envio 
(id_pedido, id_metodo_envio, codigo_postal, provincia, ciudad, direccion, sucursal_oca, orden_retiro_oca, numero_tracking, estado_envio) 
VALUES
(1, 2, '1646', 'Buenos Aires', 'San Fernando', 'Av. Libertador 1200', NULL, NULL, 'OCA123456', 'entregado'),
(2, 1, NULL, 'Buenos Aires', 'Tigre', NULL, NULL, NULL, NULL, 'pendiente'),
(3, 3, '5000', 'Córdoba', 'Córdoba Capital', NULL, 'Sucursal OCA Centro', 'ORD78910', 'OCA78910', 'en camino'),
(4, 2, '2000', 'Santa Fe', 'Rosario', 'Bv. Oroño 850', NULL, NULL, 'OCA456789', 'pendiente');


INSERT INTO pago 
(id_pedido, metodo_pago, proveedor_pago, id_transaccion, estado_pago, monto_pagado, fecha_pago) 
VALUES
(1, 'Tarjeta de crédito', 'Mercado Pago', 'MP-1001', 'aprobado', 11200, '2026-05-10 11:05:00'),
(2, 'Transferencia bancaria', 'Banco Nación', NULL, 'pendiente', 0, NULL),
(3, 'Tarjeta de débito', 'Mercado Pago', 'MP-1003', 'aprobado', 16000, '2026-05-15 16:25:00'),
(4, 'Tarjeta de crédito', 'Mercado Pago', 'MP-1004', 'aprobado', 11000, '2026-05-20 12:15:00');


INSERT INTO descuento 
(nombre_descuento, porcentaje, fecha_inicio, fecha_fin, activo) 
VALUES
('Promo Aromas de Invierno', 10, '2026-06-01', '2026-06-30', 1),
('Descuento Perfumería Fina', 15, '2026-05-01', '2026-05-31', 0);


INSERT INTO producto_descuento (id_producto, id_descuento) VALUES
(1, 1),
(2, 1),
(9, 2),
(10, 2);
