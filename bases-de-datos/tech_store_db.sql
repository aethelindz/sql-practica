CREATE DATABASE IF NOT EXISTS tech_store_db;
USE tech_store_db;

DROP TABLE IF EXISTS detalle_ventas;
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL
);

CREATE TABLE productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL
);

CREATE TABLE ventas (
    venta_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    fecha_venta DATE NOT NULL,
    monto_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

CREATE TABLE detalle_ventas (
    detalle_id INT AUTO_INCREMENT PRIMARY KEY,
    venta_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (venta_id) REFERENCES ventas(venta_id),
    FOREIGN KEY (producto_id) REFERENCES productos(producto_id)
);

-- Inserción de 20 Clientes
INSERT INTO clientes (nombre, ciudad, email) VALUES
('Carlos Mendoza', 'Bogotá', 'carlos@mail.com'),
('Ana María Gómez', 'Medellín', 'ana@mail.com'),
('Luis Fernando López', 'Cali', 'luis@mail.com'),
('Diana Marcela Torres', 'Bogotá', 'diana@mail.com'),
('Jorge Ramírez', 'Barranquilla', 'jorge@mail.com'),
('Sofia Ruiz', 'Medellín', 'sofia@mail.com'),
('Mateo Morales', 'Bucaramanga', 'mateo@mail.com'),
('Valentina Espinal', 'Bogotá', 'valentina@mail.com'),
('Andrés Felipe Caro', 'Cali', 'andres@mail.com'),
('Camila Ospina', 'Pereira', 'camila@mail.com'),
('Esteban Arias', 'Medellín', 'esteban@mail.com'),
('Mariana Castro', 'Bogotá', 'mariana@mail.com'),
('Daniela Marín', 'Manizales', 'daniela@mail.com'),
('Gabriel Silva', 'Cartagena', 'gabriel@mail.com'),
('Lucía Fernández', 'Bogotá', 'lucia@mail.com'),
('Santiago Herrera', 'Medellín', 'santiago@mail.com'),
('Paula Andrea Rojas', 'Cali', 'paula@mail.com'),
('Nicolás Vargas', 'Ibagué', 'nicolas@mail.com'),
('Isabella Gutiérrez', 'Bogotá', 'isabella@mail.com'),
('Alejandro Ríos', 'Cúcuta', 'alejandro@mail.com');

-- Inserción de 15 Productos
INSERT INTO productos (nombre_producto, categoria, precio, stock) VALUES
('Laptop Pro 15', 'Computadores', 1200.00, 15),
('Mouse Inalámbrico', 'Accesorios', 25.00, 100),
('Teclado Mecánico RGB', 'Accesorios', 75.00, 45),
('Monitor Gamer 27', 'Monitores', 350.00, 20),
('Audífonos Bluetooth', 'Audio', 80.00, 60),
('Smartphone X10', 'Celulares', 900.00, 10),
('Tablet Pad 10', 'Tablets', 400.00, 0),
('Disco Duro Externo 1TB', 'Almacenamiento', 60.00, 80),
('Silla Gamer Pro', 'Muebles', 250.00, 12),
('Webcam HD 1080p', 'Accesorios', 50.00, 35),
('Impresora Láser', 'Oficina', 180.00, 5),
('Cargador Carga Rápida', 'Accesorios', 20.00, 150),
('Micrófono USB Studio', 'Audio', 110.00, 18),
('Escáner de Escritorio', 'Oficina', 210.00, 0),
('Base Enfriadora Laptop', 'Accesorios', 30.00, 40);

-- Inserción de 30 Ventas (Algunos clientes no tienen compras registradas)
INSERT INTO ventas (cliente_id, fecha_venta, monto_total) VALUES
(1, '2024-01-05', 1225.00), (2, '2024-01-10', 350.00), (3, '2024-01-12', 150.00),
(1, '2024-01-15', 80.00),   (5, '2024-01-20', 900.00), (6, '2024-01-22', 250.00),
(8, '2024-02-01', 400.00),  (9, '2024-02-03', 135.00), (2, '2024-02-05', 1200.00),
(11, '2024-02-10', 60.00),  (12, '2024-02-14', 210.00),(1, '2024-02-18', 350.00),
(14, '2024-02-20', 75.00),  (15, '2024-02-25', 110.00),(16, '2024-03-01', 900.00),
(3, '2024-03-05', 50.00),   (5, '2024-03-08', 25.00),  (8, '2024-03-12', 1200.00),
(9, '2024-03-15', 80.00),   (11, '2024-03-18', 250.00),(12, '2024-03-22', 160.00),
(14, '2024-03-25', 1200.00),(16, '2024-04-02', 350.00),(1, '2024-04-05', 75.00),
(2, '2024-04-10', 80.00),   (6, '2024-04-12', 400.00), (8, '2024-04-15', 900.00),
(11, '2024-04-18', 30.00),  (15, '2024-04-20', 120.00),(16, '2024-04-25', 60.00);

-- Inserción de 40 Registros en Detalle de Ventas
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario) VALUES
(1, 1, 1, 1200.00), (1, 2, 1, 25.00), (2, 4, 1, 350.00), (3, 3, 2, 75.00),
(4, 5, 1, 80.00),   (5, 6, 1, 900.00), (6, 9, 1, 250.00), (7, 7, 1, 400.00),
(8, 3, 1, 75.00),   (8, 8, 1, 60.00),  (9, 1, 1, 1200.00),(10, 8, 1, 60.00),
(11, 14, 1, 210.00),(12, 4, 1, 350.00),(13, 3, 1, 75.00), (14, 13, 1, 110.00),
(15, 6, 1, 900.00), (16, 10, 1, 50.00), (17, 2, 1, 25.00), (18, 1, 1, 1200.00),
(19, 5, 1, 80.00),  (20, 9, 1, 250.00),(21, 8, 2, 80.00),  (22, 1, 1, 1200.00),
(23, 4, 1, 350.00), (24, 3, 1, 75.00), (25, 5, 1, 80.00),  (26, 7, 1, 400.00),
(27, 6, 1, 900.00), (28, 15, 1, 30.00), (29, 8, 2, 60.00), (30, 8, 1, 60.00);