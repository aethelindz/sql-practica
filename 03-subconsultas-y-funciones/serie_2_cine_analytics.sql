use cine_analytics_db;
/*Reto 3: Auditoría de Presupuestos e Impuestos (CASE y Redondeos)
Analiza el presupuesto de las películas. 
Muestra el título, la categoría de género y calcula el 
impuesto proyectado sobre el presupuesto según las siguientes reglas usando CASE:
	-Si el género es 'Ciencia Ficción' o 'Acción', el impuesto es del $15\%$ (presupuesto_millones * 0.15).
	-Si el género es 'Drama' o 'Comedia', el impuesto es del $10\%$ (presupuesto_millones * 0.10).
    -Para cualquier otro género, el impuesto es del $5\%$ (presupuesto_millones * 0.05).
    Asegúrate de redondear el impuesto calculado a 2 decimales usando ROUND.*/

SELECT
	titulo AS 'Titulo Pelicula',
    genero AS 'Genero',
    CASE
		WHEN genero IN('Ciencia Ficción', 'Acción') THEN ROUND((presupuesto_millones * 0.15), 2)
        WHEN genero IN('Drama', 'Comedia') THEN ROUND((presupuesto_millones * 0.10), 2)
        ELSE ROUND((presupuesto_millones * 0.05), 2)
        END AS 'Impuesto Proyectado'
FROM peliculas;


/*Reto 4: Ventanas de Inactividad y Próximo Control (Funciones de Fecha)
Identifica a los usuarios con suscripción 'Standard' o 'Basic'. 
Muestra su nombre, tipo de suscripción, su fecha de registro y calcula una fecha límite de verificación agregándole 90 días a su fecha de registro (DATE_ADD e INTERVAL). 
Filtra únicamente a los usuarios registrados en el año 2024.*/

SELECT
	nombre AS 'Nombre de Usuario',
    tipo_suscripcion AS 'Tipo de Suscripcion',
    fecha_registro AS 'Fecha de Registro',
    DATE_ADD(fecha_registro, INTERVAL 90 DAY) AS 'Limite de verificacion',
    YEAR(fecha_registro) AS 'Año de Registro'
FROM usuarios
WHERE YEAR(fecha_registro) = 2024
AND tipo_suscripcion IN('Standard', 'Basic');
    
/*Reto 5: Películas por Encima de la Duración Promedio (Subconsulta Escalar)
Obtén el título, género y duración de las visualizaciones cuya duracion_minutos 
sea estrictamente mayor a la duración promedio de todas las visualizaciones registradas.

Pista: Usa una subconsulta escalar simple con AVG(duracion_minutos) dentro de la cláusula WHERE.*/

SELECT 
    p.titulo AS 'Titulo Pelicula',
    p.genero AS 'Genero Pelicula',
    v.duracion_minutos AS 'Duracion Minutos'
FROM peliculas AS p
INNER JOIN visualizaciones AS v 
    ON p.pelicula_id = v.pelicula_id
WHERE v.duracion_minutos > (SELECT AVG(duracion_minutos) FROM visualizaciones);

/*Reto 6: Directores con Producciones en el Top 2 de Países con Más Directores (Subconsulta Avanzada)
Identifica los nombres de las películas y el nombre de su director, pero únicamente para aquellos directores que 
provengan de los 2 países con mayor cantidad de directores registrados en la tabla directores.

Pista: Construye primero una subconsulta sobre directores que agrupe por pais_origen, 
ordene por el conteo descendente y aplique LIMIT 2 con una tabla derivada.*/

SELECT 
    p.titulo AS 'Titulo de Pelicula',
    d.nombre AS 'Nombre de Director',
    d.pais_origen AS 'Pais Origen'
FROM peliculas AS p
INNER JOIN directores AS d 
    ON p.director_id = d.director_id
WHERE d.pais_origen IN (
    SELECT pais_origen FROM (
        SELECT d1.pais_origen
        FROM directores AS d1
        GROUP BY d1.pais_origen
        ORDER BY COUNT(d1.director_id) DESC
        LIMIT 2
    ) AS Pais_Mayor_Directores
);