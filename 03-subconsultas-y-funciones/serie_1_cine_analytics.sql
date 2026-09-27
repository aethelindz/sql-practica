use cine_analytics_db;
## Reto 1 Formateo de Usuarios y Antigüedad (Cadenas y Fechas)
/* Genera un listado de usuarios que muestre:
El nombre en mayúsculas.
El dominio del correo electrónico extraído usando funciones de cadena (ejemplo: email.com).
El año y mes de su registro.
Los días de antigüedad transcurridos desde su registro hasta la fecha de hoy (CURDATE()).*/

SELECT
	UPPER(nombre) AS 'Nombre de usuario',
    SUBSTRING_INDEX(email, '@', -1) AS 'Dominio email',
    YEAR(fecha_registro) AS 'Año de Registro',
    MONTH(fecha_registro) AS 'Mes de Registro',
    DATEDIFF(CURDATE(), fecha_registro) AS 'Dias de antigüedad'
 FROM usuarios;

## Reto 2 Clasificación de Películas por Duración y Redondeo (Matemáticas y Condicionales)
/* Unifica las películas con sus visualizaciones. Muestra el título en minúsculas, la duración en horas calculada como decimal 
redondeado a 2 posiciones (ROUND), las horas completas sin decimales hacia arriba (CEILING), y crea una columna llamada 
'Categoria_Duracion' usando IF que clasifique:
'Larga' si la duración supera los 150 minutos.
'Estandard' si dura 150 minutos o menos.*/

SELECT
	LOWER(p.titulo) AS 'Titulo Pelicula',
    ROUND(v.duracion_minutos/60.0, 2) AS 'Duracion en Horas',
    CEILING(v.duracion_minutos/60.0) AS 'Horas Completas',
    IF(v.duracion_minutos > 150, 'Larga', 'Estandard') AS 'Categoria_Duracion'
FROM peliculas AS p
INNER JOIN visualizaciones AS v
ON p.pelicula_id = v.pelicula_id;


## Reto 3 Matriz de Retención por Suscripción (CASE y Agregaciones)
/* Calcula para cada tipo de suscripción:
La cantidad total de usuarios.
El promedio de rating que otorgan redondeado a 1 decimal.
Usando un CASE, crea una etiqueta de negocio:
	'Suscripción Clave' si el promedio de rating es $\ge 8.8$.
    'Suscripción Regular' si está entre $8.0$ y $8.7$.
    'En Riesgo' si es menor a $8.0$.*/
    
SELECT 
    u.tipo_suscripcion AS 'Tipo de Suscripción',
    COUNT(DISTINCT u.usuario_id) AS 'Cantidad total de usuarios',
    ROUND(AVG(v.rating_usuario), 1) AS 'Rating',
    CASE 
        WHEN AVG(v.rating_usuario) >= 8.8 THEN 'Suscripción Clave'
        WHEN AVG(v.rating_usuario) >= 8.0 THEN 'Suscripción Regular'
        ELSE 'En Riesgo'
    END AS 'Etiqueta de negocio'
FROM usuarios AS u
INNER JOIN visualizaciones AS v 
    ON u.usuario_id = v.usuario_id
GROUP BY u.tipo_suscripcion;
	

## Reto 4 Proyección de Fechas de Renovación (Funciones de Fecha)
/* La empresa planea una campaña de fidelización. Selecciona a los usuarios con suscripción 'Premium' y muestra su 
fecha de registro junto con la fecha exacta en la que se cumplirán 6 meses de su registro (utilizando DATE_ADD e INTERVAL). 
Ordena los resultados del registro más reciente al más antiguo.*/

SELECT
	usuario_id,
    nombre AS 'Nombre de Usuario',
    tipo_suscripcion AS 'Suscripcion',
    fecha_registro AS 'Fecha de Registro',
    DATE_ADD(fecha_registro, INTERVAL 6 MONTH) AS '6 Meses para cumplimiento'
FROM usuarios
WHERE tipo_suscripcion = 'Premium'
ORDER BY fecha_registro DESC;
    
## Reto 5 Top Directores de Alto Presupuesto (Subconsultas y JOINs)
/* Encuentra los nombres de los directores y su país de origen que hayan dirigido películas cuyo presupuesto sea estrictamente 
mayor al presupuesto promedio de todas las películas registradas en la base de datos. Pista: 
debes usar una subconsulta escalar en la cláusula WHERE.*/

SELECT 
    DISTINCT d.nombre AS 'Nombre de Director',
    d.pais_origen AS 'Pais de Origen'
FROM directores AS d
INNER JOIN peliculas AS p 
    ON d.director_id = p.director_id
WHERE p.presupuesto_millones > (SELECT AVG(presupuesto_millones) FROM peliculas);
						

## Reto 6 Análisis de Géneros Populares por Rating (Subconsultas Avanzadas y Conversión)
/* Identifica los títulos, presupuesto y rating promedio de las películas que pertenecen únicamente a los 2 géneros que tienen 
la mayor cantidad de reproducciones registrados en la tabla visualizaciones.
Utiliza una subconsulta con tabla derivada para encontrar esos 2 géneros top.
Convierte la columna presupuesto_millones a tipo CHAR usando CAST y concaténale la palabra ' USD' al final.*/

SELECT 
    p.titulo AS 'Titulo Pelicula',
    CONCAT(CAST(p.presupuesto_millones AS CHAR), ' USD') AS 'Presupuesto USD',
    ROUND(AVG(v.rating_usuario), 1) AS 'Rating Promedio'
FROM peliculas AS p
INNER JOIN visualizaciones AS v 
    ON p.pelicula_id = v.pelicula_id
WHERE p.genero IN (
    SELECT genero FROM (
        SELECT p2.genero, COUNT(*) AS total_reproducciones
        FROM visualizaciones AS v2
        INNER JOIN peliculas AS p2 ON v2.pelicula_id = p2.pelicula_id
        GROUP BY p2.genero
        ORDER BY total_reproducciones DESC
        LIMIT 2
    ) AS generos_top
)
GROUP BY p.pelicula_id, p.titulo, p.presupuesto_millones;


## Reto 7 Normalización de Dominios y Formatos (Cadenas y Fechas)
/* La gerencia requiere auditoría de los usuarios. Muestra:

-El correo electrónico todo en minúsculas.
-Una columna llamada 'Nombre_Servidor' que extraiga únicamente la parte del correo que está entre el '@' y el primer '.' 
(por ejemplo, si el correo es carlos.gomez@email.com, debe extraer email).
-La fecha de registro en formato de texto concatenado que diga: 'Registrado en el año YYYY, mes MM' (usando CONCAT, YEAR y MONTH).*/

SELECT
	LOWER(email) AS 'Correo electronico',
    SUBSTRING_INDEX(SUBSTRING_INDEX(email, '@', -1), '.', 1) AS 'Nombre_Servidor',
    CONCAT('Registrado en el año ',YEAR(fecha_registro), ', mes ', MONTH(fecha_registro)) AS 'Fecha de Registro'
FROM usuarios;


