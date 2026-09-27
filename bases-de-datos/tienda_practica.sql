-- 1. CREACIÓN DE LA BASE DE DATOS Y USO
CREATE DATABASE IF NOT EXISTS tienda_practica;
USE tienda_practica;

-- Limpieza previa en caso de reejecución
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;

-- 2. CREACIÓN DE TABLAS

-- Tabla: clientes
CREATE TABLE clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    fecha_registro DATE NOT NULL,
    es_vip TINYINT(1) DEFAULT 0
);

-- Tabla: productos
CREATE TABLE productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL
);

-- Tabla: ventas
CREATE TABLE ventas (
    venta_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    monto_total DECIMAL(10, 2) NOT NULL,
    fecha_venta DATE NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
    FOREIGN KEY (producto_id) REFERENCES productos(producto_id)
);

-- 3. INSERCIÓN DE DATOS DE PRUEBA

-- Datos para clientes
INSERT INTO clientes (nombre, pais, ciudad, fecha_registro, es_vip) VALUES
('Carlos Mendoza', 'Colombia', 'Bogotá', '2023-01-15', 1),
('Ana Gómez', 'Colombia', 'Medellín', '2023-02-20', 0),
('Luis Hernández', 'México', 'Ciudad de México', '2023-03-10', 1),
('Mariana López', 'Colombia', 'Cali', '2023-04-05', 0),
('Javier Torres', 'Argentina', 'Buenos Aires', '2023-05-12', 0),
('Sofía Ramírez', 'México', 'Guadalajara', '2023-06-18', 0),
('Diego Morales', 'Colombia', 'Barranquilla', '2023-07-22', 1),
('Elena Rostova', 'Chile', 'Santiago', '2023-08-30', 0);

-- Datos para productos
INSERT INTO productos (nombre_producto, categoria, precio, stock) VALUES
('Smart TV 55', 'Electrónica', 450.00, 15),
('SmartWatch Fit', 'Electrónica', 85.00, 40),
('Teclado Pro', 'Electrónica', 65.00, 5),
('Silla Gamer Pro', 'Hogar', 180.00, 8),
('Cafetera Espresso', 'Hogar', 120.00, 25),
('Mesa de Centro', 'Hogar', 45.00, 60),
('Balón de Fútbol Pro', 'Deportes', 30.00, 100),
('Mancuernas 10kg', 'Deportes', 55.00, 3),
('Audífonos Wireless', 'Electrónica', 95.00, 2),
('Lámpara Smart', 'Hogar', 25.00, 50);

-- Datos para ventas
INSERT INTO ventas (cliente_id, producto_id, cantidad, monto_total, fecha_venta) VALUES
(1, 1, 1, 450.00, '2024-01-10'),
(1, 3, 2, 130.00, '2024-01-15'),
(1, 9, 1, 95.00,  '2024-02-01'),
(2, 2, 1, 85.00,  '2024-01-12'),
(2, 7, 2, 60.00,  '2024-02-10'),
(3, 4, 1, 180.00, '2024-01-20'),
(3, 5, 1, 120.00, '2024-02-05'),
(3, 2, 2, 170.00, '2024-02-18'),
(4, 10, 2, 50.00, '2024-01-22'),
(5, 6, 1, 45.00,  '2024-01-25'),
(6, 8, 2, 110.00, '2024-02-02'),
(7, 1, 1, 450.00, '2024-02-12'),
(7, 3, 1, 65.00,  '2024-02-14'),
(2, 10, 1, 25.00, '2024-02-20');