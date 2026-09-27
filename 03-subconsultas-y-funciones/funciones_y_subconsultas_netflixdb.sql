use netflixdb;

## Subconsultas SQL
SELECT titulo FROM series
WHERE serie_id IN (SELECT serie_id
	FROM episodios
	GROUP BY serie_id
    HAVING AVG(rating_imdb) > 8);
    
## Condicional IF
SELECT
    titulo,
    rating_imdb,
    IF(rating_imdb >= 8, 'Alto', 'Bajo') AS 'Categoria de Rating'
FROM episodios;

SELECT
    nombre,
    YEAR(fecha_nacimiento) AS año_nacimiento,
    IF(YEAR(fecha_nacimiento) > 2000, 'Young', 'Old') AS 'Categoria de actores'
FROM actores;

## Condicional CASE y ELSE
SELECT
    titulo,
    año_lanzamiento,
    CASE
        WHEN año_lanzamiento >= 2020 THEN 'Nueva'
        WHEN año_lanzamiento >= 2010 AND año_lanzamiento <= 2019 THEN 'Clasica'
        ELSE 'Antigua'
		END AS categoria
    FROM series;

SELECT 
	titulo,
    CASE
		WHEN año_lanzamiento < 2010 THEN 'Antigua'
        WHEN año_lanzamiento >= 2010 THEN 'Reciente'
        ELSE 'Otro'
		END AS Antigüedad
	FROM series;

SELECT
	titulo,
    CASE
		WHEN genero = 'Drama' THEN 'Dramático'
        WHEN genero = 'Comedia' THEN 'Divertido'
        ELSE 'Otro'
        END AS 'Categoría de Género'
	FROM series;
    
## Funcion de Conversion CAST
DESCRIBE episodios; -- Permite saber el tipo de dato de cada columna
SELECT * FROM episodios
WHERE CAST(fecha_estreno AS DATE) > '2010-01-01';

DESCRIBE series;
SELECT
	titulo,
    CAST(año_lanzamiento AS CHAR) AS año_como_texto
FROM series;

## Funciones de fecha
SELECT fecha_estreno, YEAR(fecha_estreno), MONTH(fecha_estreno) FROM episodios;

SELECT fecha_estreno,
DATE_ADD(fecha_estreno, INTERVAL 30 DAY)
FROM episodios;

SELECT *,
DATEDIFF(CURDATE(), fecha_estreno) AS diasdesdeestreno
FROM episodios;

## Manipulacion de cadenas de texto
SELECT UPPER(titulo) AS Titulo_Mayusculas FROM Series;

SELECT LOWER(nombre) AS nombre_en_minusculas FROM Actores;

SELECT CONCAT(titulo, ' (', año_lanzamiento, ')') AS Titulo_Año FROM Series;

SELECT SUBSTRING(titulo, 1, 5) AS Extracto_Titulo FROM Episodios;

SELECT titulo, LENGTH(titulo) AS Longitud_Titulo FROM Series;

SELECT
    titulo,
    LEFT(titulo, 3) AS Inicio_Titulo,
    RIGHT(titulo, 3) AS Fin_Titulo
FROM Series;

## Funciones Matematicas
SELECT titulo, duracion/60.0 AS Horas_Completa, ROUND(duracion/60.0, 0) AS Horas_Completa_Redondeado FROM Episodios;

SELECT titulo, duracion, CEILING(duracion/60.0) AS Horas_Completas FROM Episodios;

SELECT titulo, duracion, FLOOR(duracion/60) AS Horas_Completas FROM Episodios;

SELECT CEILING(rating_imdb) AS rating_redondeado FROM Episodios;

## Actividad
/* Utiliza una subconsulta para identificar los tres géneros más populares (en función de la cantidad de series)
Para cada género, identifica titulo de la serie, año de lanzamiento y rating de imdb promedio*/

SELECT 
    Series.titulo AS 'Título de la Serie', 
    Series.año_lanzamiento AS 'Año de Lanzamiento', 
    Series.genero AS 'Género', 
    AVG(Episodios.rating_imdb) AS 'Rating Promedio IMDb'
FROM 
    Series
JOIN 
    Episodios ON Series.serie_id = Episodios.serie_id
WHERE 
    Series.genero IN (SELECT genero FROM (
					  SELECT genero, COUNT(*) AS cantidad_de_series
					  FROM Series 
					  GROUP BY genero 
                      ORDER BY cantidad_de_series DESC
                      LIMIT 3) AS top3)
GROUP BY 
    Series.serie_id
ORDER BY 
    `Rating Promedio IMDb` DESC;
    