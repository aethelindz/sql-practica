-- 1. Reiniciar la base de datos
DROP DATABASE IF EXISTS aseguradora_db;
CREATE DATABASE aseguradora_db;
USE aseguradora_db;

-- 2. Tabla: clientes
CREATE TABLE clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    fecha_registro DATE NOT NULL
);

-- 3. Tabla: ramos
CREATE TABLE ramos (
    ramo_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_ramo VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- 4. Tabla: polizas
CREATE TABLE polizas (
    poliza_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    ramo_id INT NOT NULL,
    codigo_cobertura VARCHAR(20) NOT NULL,
    prima_anual DECIMAL(10,2) NOT NULL,
    fecha_emision DATE NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
    FOREIGN KEY (ramo_id) REFERENCES ramos(ramo_id)
);

-- 5. Tabla: siniestros (reclamos)
CREATE TABLE siniestros (
    siniestro_id INT AUTO_INCREMENT PRIMARY KEY,
    poliza_id INT NOT NULL,
    monto_reclamado DECIMAL(10,2) NOT NULL,
    estado VARCHAR(20) NOT NULL, -- 'Aprobado', 'Rechazado', 'En Revision'
    fecha_siniestro DATE NOT NULL,
    FOREIGN KEY (poliza_id) REFERENCES polizas(poliza_id)
);

-- ========================================================
-- INSERCIÓN DE DATOS
-- ========================================================

-- Insertar Ramos
INSERT INTO ramos (nombre_ramo, descripcion) VALUES
('Salud', 'Cobertura médica integral y hospitalaria'),
('Vehículos', 'Protección contra colisiones, robo y responsabilidad civil'),
('Hogar', 'Seguro de estructura y enseres domésticos'),
('Vida', 'Seguro de vida individual y colectivo'),
('Pyme', 'Protección patrimonial para pequeñas y medianas empresas');

-- Insertar 150 Clientes mediante CTE recursivo
INSERT INTO clientes (nombre, email, ciudad, fecha_registro)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 150
)
SELECT 
    CONCAT('Cliente_', n) AS nombre,
    CONCAT('usuario_', n, '@email.com') AS email,
    CASE (n % 4)
        WHEN 0 THEN 'Bogotá'
        WHEN 1 THEN 'Medellín'
        WHEN 2 THEN 'Cali'
        ELSE 'Barranquilla'
    END AS ciudad,
    DATE_ADD('2022-01-01', INTERVAL (n * 5) DAY) AS fecha_registro
FROM seq;

-- Insertar 500 Pólizas asociadas a los clientes y ramos
INSERT INTO polizas (cliente_id, ramo_id, codigo_cobertura, prima_anual, fecha_emision)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 500
)
SELECT 
    ((n * 7) % 150) + 1 AS cliente_id,
    ((n % 5) + 1) AS ramo_id,
    CONCAT('POL-', 100 + (n % 50), '-', CHAR(65 + (n % 6))) AS codigo_cobertura,
    ROUND(300 + ((n * 37) % 4700) + (n % 3) * 50, 2) AS prima_anual,
    DATE_ADD('2023-01-01', INTERVAL (n * 2) DAY) AS fecha_emision
FROM seq;

-- Insertar 200 Siniestros/Reclamos vinculados a las pólizas
INSERT INTO siniestros (poliza_id, monto_reclamado, estado, fecha_siniestro)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 200
)
SELECT 
    ((n * 13) % 500) + 1 AS poliza_id,
    ROUND(500 + ((n * 97) % 12000), 2) AS monto_reclamado,
    CASE (n % 3)
        WHEN 0 THEN 'Aprobado'
        WHEN 1 THEN 'En Revision'
        ELSE 'Rechazado'
    END AS estado,
    DATE_ADD('2023-06-01', INTERVAL (n * 4) DAY) AS fecha_siniestro
FROM seq;