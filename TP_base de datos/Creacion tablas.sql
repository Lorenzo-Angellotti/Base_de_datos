use master
go

create database aromasLuminar

use aromasLuminar
go

CREATE TABLE cliente (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    email NVARCHAR(120) UNIQUE NOT NULL,
    telefono NVARCHAR(30),
    fecha_registro DATETIME DEFAULT GETDATE()
);


CREATE TABLE categoria (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria NVARCHAR(80) NOT NULL,
    descripcion NVARCHAR(MAX)
);


CREATE TABLE producto (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    sku NVARCHAR(50) UNIQUE NOT NULL,
    nombre NVARCHAR(120) NOT NULL,
    descripcion NVARCHAR(MAX),
    id_categoria INT NOT NULL,
    tamano NVARCHAR(50),
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    peso_gramos DECIMAL(10,2),
    alto_cm DECIMAL(10,2),
    ancho_cm DECIMAL(10,2),
    largo_cm DECIMAL(10,2),
    imagen NVARCHAR(MAX),
    activo BIT DEFAULT 1,

    CONSTRAINT FK_producto_categoria 
        FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),

    CONSTRAINT CK_producto_precio 
        CHECK (precio > 0),

    CONSTRAINT CK_producto_stock 
        CHECK (stock >= 0)
);


CREATE TABLE pedido (
    id_pedido INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_pedido DATETIME DEFAULT GETDATE(),
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0,
    costo_envio DECIMAL(10,2) NOT NULL DEFAULT 0,
    descuento_total DECIMAL(10,2) NOT NULL DEFAULT 0,
    total DECIMAL(10,2) NOT NULL DEFAULT 0,
    estado_pedido NVARCHAR(30) NOT NULL DEFAULT 'pendiente',
    estado_pago NVARCHAR(30) NOT NULL DEFAULT 'pendiente',

    CONSTRAINT FK_pedido_cliente 
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),

    CONSTRAINT CK_pedido_estado 
        CHECK (estado_pedido IN ('pendiente', 'aprobado', 'enviado', 'entregado', 'cancelado')),

    CONSTRAINT CK_pedido_pago 
        CHECK (estado_pago IN ('pendiente', 'aprobado', 'rechazado'))
);


CREATE TABLE detalle_pedido (
    id_detalle INT IDENTITY(1,1) PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal_linea DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_detalle_pedido 
        FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE,

    CONSTRAINT FK_detalle_producto 
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto),

    CONSTRAINT CK_detalle_cantidad 
        CHECK (cantidad > 0),

    CONSTRAINT CK_detalle_precio 
        CHECK (precio_unitario > 0),

    CONSTRAINT CK_detalle_subtotal 
        CHECK (subtotal_linea >= 0)
);


CREATE TABLE metodo_envio (
    id_metodo_envio INT IDENTITY(1,1) PRIMARY KEY,
    nombre_metodo NVARCHAR(80) NOT NULL,
    descripcion NVARCHAR(MAX)
);


CREATE TABLE envio (
    id_envio INT IDENTITY(1,1) PRIMARY KEY,
    id_pedido INT UNIQUE NOT NULL,
    id_metodo_envio INT NOT NULL,
    codigo_postal NVARCHAR(20),
    provincia NVARCHAR(80),
    ciudad NVARCHAR(80),
    direccion NVARCHAR(150),
    sucursal_oca NVARCHAR(120),
    orden_retiro_oca NVARCHAR(80),
    numero_tracking NVARCHAR(80),
    estado_envio NVARCHAR(40) DEFAULT 'pendiente',

    CONSTRAINT FK_envio_pedido 
        FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE,

    CONSTRAINT FK_envio_metodo 
        FOREIGN KEY (id_metodo_envio) REFERENCES metodo_envio(id_metodo_envio)
);


CREATE TABLE pago (
    id_pago INT IDENTITY(1,1) PRIMARY KEY,
    id_pedido INT UNIQUE NOT NULL,
    metodo_pago NVARCHAR(80) NOT NULL,
    proveedor_pago NVARCHAR(80),
    id_transaccion NVARCHAR(120),
    estado_pago NVARCHAR(30) NOT NULL,
    monto_pagado DECIMAL(10,2) NOT NULL,
    fecha_pago DATETIME,

    CONSTRAINT FK_pago_pedido 
        FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE,

    CONSTRAINT CK_pago_estado 
        CHECK (estado_pago IN ('pendiente', 'aprobado', 'rechazado')),

    CONSTRAINT CK_pago_monto 
        CHECK (monto_pagado >= 0)
);


CREATE TABLE descuento (
    id_descuento INT IDENTITY(1,1) PRIMARY KEY,
    nombre_descuento NVARCHAR(100) NOT NULL,
    porcentaje DECIMAL(5,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    activo BIT DEFAULT 1,

    CONSTRAINT CK_descuento_porcentaje 
        CHECK (porcentaje > 0 AND porcentaje <= 100)
);


CREATE TABLE producto_descuento (
    id_producto INT NOT NULL,
    id_descuento INT NOT NULL,

    CONSTRAINT PK_producto_descuento 
        PRIMARY KEY (id_producto, id_descuento),

    CONSTRAINT FK_producto_descuento_producto 
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE,

    CONSTRAINT FK_producto_descuento_descuento 
        FOREIGN KEY (id_descuento) REFERENCES descuento(id_descuento) ON DELETE CASCADE
);
