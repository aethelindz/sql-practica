CREATE DATABASE IF NOT EXISTS cine_analytics_db;
USE cine_analytics_db;

DROP TABLE IF EXISTS visualizaciones;
DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS peliculas;
DROP TABLE IF EXISTS directores;

CREATE TABLE directores (
    director_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    pais_origen VARCHAR(50) NOT NULL
);

CREATE TABLE peliculas (
    pelicula_id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    genero VARCHAR(50) NOT NULL,
    año_estreno INT NOT NULL,
    presupuesto_millones DECIMAL(8,2) NOT NULL,
    director_id INT,
    FOREIGN KEY (director_id) REFERENCES directores(director_id)
);

CREATE TABLE usuarios (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    tipo_suscripcion VARCHAR(20) NOT NULL,
    fecha_registro DATE NOT NULL
);

CREATE TABLE visualizaciones (
    visualizacion_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    pelicula_id INT NOT NULL,
    fecha_view DATE NOT NULL,
    duracion_minutos INT NOT NULL,
    rating_usuario INT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
    FOREIGN KEY (pelicula_id) REFERENCES peliculas(pelicula_id)
);

-- Inserción de 10 Directores
INSERT INTO directores (nombre, pais_origen) VALUES
('Christopher Nolan', 'Reino Unido'), ('Quentin Tarantino', 'Estados Unidos'),
('Greta Gerwig', 'Estados Unidos'), ('Guillermo del Toro', 'México'),
('Denis Villeneuve', 'Canadá'), ('Bong Joon-ho', 'Corea del Sur'),
('Steven Spielberg', 'Estados Unidos'), ('Martin Scorsese', 'Estados Unidos'),
('Pedro Almodóvar', 'España'), ('Hayao Miyazaki', 'Japón');

-- Inserción de 40 Películas
INSERT INTO peliculas (titulo, genero, año_estreno, presupuesto_millones, director_id) VALUES
('Inception', 'Ciencia Ficción', 2010, 160.00, 1), ('Interstellar', 'Ciencia Ficción', 2014, 165.00, 1),
('Oppenheimer', 'Historia', 2023, 100.00, 1), ('Dunkirk', 'Historia', 2017, 100.00, 1),
('Pulp Fiction', 'Crimen', 1994, 8.50, 2), ('Django Unchained', 'Western', 2012, 100.00, 2),
('Inglourious Basterds', 'Bélico', 2009, 70.00, 2), ('Kill Bill Vol 1', 'Acción', 2003, 30.00, 2),
('Lady Bird', 'Drama', 2017, 10.00, 3), ('Little Women', 'Drama', 2019, 40.00, 3),
('Barbie', 'Comedia', 2023, 145.00, 3), ('Pan Labyrinth', 'Fantasía', 2006, 19.00, 4),
('Shape of Water', 'Fantasía', 2017, 19.50, 4), ('Pacific Rim', 'Acción', 2013, 190.00, 4),
('Dune', 'Ciencia Ficción', 2021, 165.00, 5), ('Dune Part Two', 'Ciencia Ficción', 2024, 190.00, 5),
('Arrival', 'Ciencia Ficción', 2016, 47.00, 5), ('Blade Runner 2049', 'Ciencia Ficción', 2017, 150.00, 5),
('Parasite', 'Thriller', 2019, 15.50, 6), ('Snowpiercer', 'Ciencia Ficción', 2013, 40.00, 6),
('Memories of Murder', 'Crimen', 2003, 5.00, 6), ('Jurassic Park', 'Ciencia Ficción', 1993, 63.00, 7),
('Schindler List', 'Historia', 1993, 22.00, 7), ('Saving Private Ryan', 'Bélico', 1998, 70.00, 7),
('Ready Player One', 'Ciencia Ficción', 2018, 175.00, 7), ('Goodfellas', 'Crimen', 1990, 25.00, 8),
('The Wolf of Wall Street', 'Biografía', 2013, 100.00, 8), ('The Irishman', 'Crimen', 2019, 159.00, 8),
('Taxi Driver', 'Drama', 1976, 1.30, 8), ('Dolor y Gloria', 'Drama', 2019, 10.00, 9),
('Volver', 'Drama', 2006, 10.00, 9), ('Spirited Away', 'Animación', 2001, 19.00, 10),
('Princess Mononoke', 'Animación', 1997, 24.00, 10), ('Howl Moving Castle', 'Animación', 2004, 24.00, 10),
('The Boy and the Heron', 'Animación', 2023, 30.00, 10), ('Tenet', 'Ciencia Ficción', 2020, 205.00, 1),
('The Hateful Eight', 'Western', 2015, 44.00, 2), ('Hugo', 'Aventura', 2011, 150.00, 8),
('Catch Me If You Can', 'Biografía', 2002, 52.00, 7), ('Jaws', 'Terror', 1975, 9.00, 7);

-- Inserción de 50 Usuarios
INSERT INTO usuarios (nombre, email, tipo_suscripcion, fecha_registro) VALUES
('Carlos Gomez', 'carlos.gomez@email.com', 'Premium', '2023-01-15'), ('Ana Martinez', 'ana.m@email.com', 'Basic', '2023-02-20'),
('Luis Rodriguez', 'luis.r@email.com', 'Standard', '2023-03-10'), ('Sofia Lopez', 'sofia.l@email.com', 'Premium', '2023-04-05'),
('Mateo Fernandez', 'mateo.f@email.com', 'Basic', '2023-05-12'), ('Valentina Diaz', 'valen.d@email.com', 'Standard', '2023-06-18'),
('Camila Torres', 'camila.t@email.com', 'Premium', '2023-07-22'), ('Javier Ruiz', 'javier.r@email.com', 'Basic', '2023-08-30'),
('Daniela Morales', 'daniela.m@email.com', 'Standard', '2023-09-14'), ('Alejandro Castro', 'alejo.c@email.com', 'Premium', '2023-10-01'),
('Mariana Ortiz', 'mariana.o@email.com', 'Basic', '2023-11-11'), ('Gabriel Silva', 'gabriel.s@email.com', 'Standard', '2023-12-05'),
('Lucia Vargas', 'lucia.v@email.com', 'Premium', '2024-01-08'), ('Diego Mendoza', 'diego.m@email.com', 'Basic', '2024-01-20'),
('Paula Guerrero', 'paula.g@email.com', 'Standard', '2024-02-02'), ('Sebastian Rojas', 'sebas.r@email.com', 'Premium', '2024-02-15'),
('Isabella Cruz', 'isa.cruz@email.com', 'Basic', '2024-03-01'), ('Nicolas Medina', 'nico.m@email.com', 'Standard', '2024-03-18'),
('Elena Herrera', 'elena.h@email.com', 'Premium', '2024-04-10'), ('Samuel Jimenes', 'samuel.j@email.com', 'Basic', '2024-04-25'),
('Valeria Gutierrez', 'valeria.g@email.com', 'Standard', '2024-05-05'), ('Joaquin Romero', 'joaco.r@email.com', 'Premium', '2024-05-20'),
('Victoria Navarro', 'vicky.n@email.com', 'Basic', '2024-06-01'), ('Emmanuel Gil', 'emma.g@email.com', 'Standard', '2024-06-15'),
('Mia Serrato', 'mia.s@email.com', 'Premium', '2024-07-04'), ('Thiago Paredes', 'thiago.p@email.com', 'Basic', '2024-07-19'),
('Renata Acosta', 'renata.a@email.com', 'Standard', '2024-08-02'), ('Agustin Pena', 'agus.p@email.com', 'Premium', '2024-08-22'),
('Antonella Cabrera', 'anto.c@email.com', 'Basic', '2024-09-01'), ('Tomas Benitez', 'tomas.b@email.com', 'Standard', '2024-09-10'),
('Martina Campos', 'martina.c@email.com', 'Premium', '2024-10-05'), ('Leo Molina', 'leo.m@email.com', 'Basic', '2024-10-18'),
('Zoe Delgado', 'zoe.d@email.com', 'Standard', '2024-11-01'), ('Felipe Miranda', 'pipe.m@email.com', 'Premium', '2024-11-15'),
('Emilia Soler', 'emilia.s@email.com', 'Basic', '2024-12-01'), ('Lucas Cardenas', 'lucas.c@email.com', 'Standard', '2024-12-20'),
('Sara Marin', 'sara.m@email.com', 'Premium', '2025-01-05'), ('Bruno Blanco', 'bruno.b@email.com', 'Basic', '2025-01-18'),
('Ximena Padilla', 'xime.p@email.com', 'Standard', '2025-02-01'), ('Ian Iglesias', 'ian.i@email.com', 'Premium', '2025-02-14'),
('Abril Cortes', 'abril.c@email.com', 'Basic', '2025-03-01'), ('Oliver Nuñez', 'oliver.n@email.com', 'Standard', '2025-03-15'),
('Clara Santamaria', 'clara.s@email.com', 'Premium', '2025-04-02'), ('Gael Fuentes', 'gael.f@email.com', 'Basic', '2025-04-20'),
('Alma Valenzuela', 'alma.v@email.com', 'Standard', '2025-05-10'), ('Esteban Rios', 'esteban.r@email.com', 'Premium', '2025-05-25'),
('Juana Lara', 'juana.l@email.com', 'Basic', '2025-06-01'), ('Martin Bravo', 'tin.b@email.com', 'Standard', '2025-06-18'),
('Guadalupe Vera', 'lupe.v@email.com', 'Premium', '2025-07-07'), ('Santino Soto', 'santi.s@email.com', 'Basic', '2025-07-21');

-- Inserción de 100 Visualizaciones
INSERT INTO visualizaciones (usuario_id, pelicula_id, fecha_view, duracion_minutos, rating_usuario) VALUES
(1, 1, '2026-01-05', 148, 9), (1, 2, '2026-01-12', 169, 10), (2, 5, '2026-01-15', 154, 8),
(3, 11, '2026-01-18', 114, 7), (4, 15, '2026-01-20', 155, 9), (5, 19, '2026-01-22', 132, 10),
(6, 22, '2026-01-25', 127, 8), (7, 27, '2026-01-28', 180, 9), (8, 32, '2026-02-01', 125, 10),
(9, 3, '2026-02-03', 180, 10), (10, 6, '2026-02-05', 165, 9), (11, 12, '2026-02-08', 118, 8),
(12, 16, '2026-02-10', 166, 9), (13, 18, '2026-02-14', 164, 7), (14, 23, '2026-02-16', 195, 10),
(15, 26, '2026-02-20', 146, 9), (16, 31, '2026-02-22', 121, 8), (17, 36, '2026-02-25', 150, 6),
(18, 4, '2026-03-01', 106, 8), (19, 7, '2026-03-03', 153, 9), (20, 9, '2026-03-05', 94, 7),
(21, 13, '2026-03-08', 123, 8), (22, 17, '2026-03-10', 116, 9), (23, 20, '2026-03-12', 126, 8),
(24, 24, '2026-03-15', 170, 9), (25, 28, '2026-03-18', 209, 8), (26, 33, '2026-03-20', 134, 10),
(27, 37, '2026-03-22', 168, 7), (28, 8, '2026-03-25', 111, 8), (29, 10, '2026-03-28', 135, 9),
(30, 14, '2026-04-01', 131, 7), (31, 21, '2026-04-03', 132, 9), (32, 25, '2026-04-05', 140, 8),
(33, 29, '2026-04-08', 114, 9), (34, 30, '2026-04-10', 113, 8), (35, 34, '2026-04-12', 119, 9),
(36, 35, '2026-04-15', 124, 8), (37, 38, '2026-04-18', 126, 7), (38, 39, '2026-04-20', 141, 9),
(39, 40, '2026-04-22', 124, 8), (40, 1, '2026-04-25', 148, 10), (41, 2, '2026-04-28', 169, 9),
(42, 5, '2026-05-01', 154, 9), (43, 11, '2026-05-03', 114, 8), (44, 15, '2026-05-05', 155, 10),
(45, 19, '2026-05-08', 132, 9), (46, 22, '2026-05-10', 127, 8), (47, 27, '2026-05-12', 180, 8),
(48, 32, '2026-05-15', 125, 10), (49, 3, '2026-05-18', 180, 9), (50, 6, '2026-05-20', 165, 8),
(1, 15, '2026-05-22', 155, 9), (2, 19, '2026-05-25', 132, 10), (3, 22, '2026-05-28', 127, 7),
(4, 27, '2026-06-01', 180, 9), (5, 32, '2026-06-03', 125, 9), (6, 3, '2026-06-05', 180, 10),
(7, 6, '2026-06-08', 165, 8), (8, 11, '2026-06-10', 114, 7), (9, 16, '2026-06-12', 166, 9),
(10, 18, '2026-06-15', 164, 8), (11, 23, '2026-06-18', 195, 9), (12, 26, '2026-06-20', 146, 9),
(13, 31, '2026-06-22', 121, 8), (14, 36, '2026-06-25', 150, 5), (15, 4, '2026-06-28', 106, 7),
(16, 7, '2026-07-01', 153, 9), (17, 9, '2026-07-03', 94, 8), (18, 13, '2026-07-05', 123, 7),
(19, 17, '2026-07-08', 116, 9), (20, 20, '2026-07-10', 126, 8), (21, 24, '2026-07-12', 170, 9),
(22, 28, '2026-07-15', 209, 8), (23, 33, '2026-07-18', 134, 10), (24, 37, '2026-07-20', 168, 6),
(25, 8, '2026-07-22', 111, 8), (26, 10, '2026-07-25', 135, 9), (27, 14, '2026-07-28', 131, 8),
(28, 21, '2026-08-01', 132, 9), (29, 25, '2026-08-03', 140, 8), (30, 29, '2026-08-05', 114, 8),
(31, 30, '2026-08-08', 113, 7), (32, 34, '2026-08-10', 119, 9), (33, 35, '2026-08-12', 124, 8),
(34, 38, '2026-08-15', 126, 7), (35, 39, '2026-08-18', 141, 9), (36, 40, '2026-08-20', 124, 8),
(37, 1, '2026-08-22', 148, 9), (38, 2, '2026-08-25', 169, 10), (39, 5, '2026-08-28', 154, 9),
(40, 11, '2026-09-01', 114, 8), (41, 15, '2026-09-03', 155, 9), (42, 19, '2026-09-05', 132, 10),
(43, 22, '2026-09-08', 127, 8), (44, 27, '2026-09-10', 180, 8), (45, 32, '2026-09-12', 125, 10);