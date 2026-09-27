use plataforma_educativa_db;
/*Reto 1: Subconsulta Escalar Simple
Queremos promocionar los cursos prémium. 
Obtén el titulo, la categoria y el precio de todos los cursos cuyo precio sea estrictamente mayor al precio promedio de todos los cursos de la plataforma. 
Muestra además una columna calculada llamada diferencia_con_promedio (precio del curso menos el precio promedio general).*/

SELECT
	titulo AS 'Nombre del Curso',
    categoria AS 'Categoria del Curso',
    precio AS 'Precio del Curso',
    ROUND(precio - (SELECT AVG(precio) FROM cursos), 2) AS 'Diferencia Promedio'
FROM cursos
WHERE precio > (SELECT AVG(precio) FROM cursos);

/*Reto 2: Subconsulta con IN
El equipo de marketing necesita contactar a los usuarios activos en la categoría de programación. 
Encuentra el nombre y pais de todos los usuarios que se han inscrito a al menos un curso de la categoría 'Programación'.

(Pista: Usa WHERE usuario_id IN (subconsulta) buscando en la tabla inscripciones unida o filtrada por esa categoría).*/

SELECT 
    nombre AS 'Nombre de Usuario',
    pais AS 'Pais'
FROM usuarios
WHERE usuario_id IN (
    SELECT i1.usuario_id
    FROM inscripciones AS i1
    INNER JOIN cursos AS c1 
        ON c1.curso_id = i1.curso_id
    WHERE c1.categoria = 'Programación'
);

/*Reto 3: Subconsulta Correlacionada (Comparación por Grupo)
Queremos detectar los cursos más costosos dentro de su propia categoría. Obtén el titulo, 
la categoria y el precio de aquellos cursos cuyo precio sea mayor al precio promedio de su MISMA categoría.

(Pista: En la subconsulta dentro del WHERE, debes igualar la categoría del curso externo con la categoría del curso interno, 
por ejemplo WHERE c2.categoria = c1.categoria).*/

SELECT 
    c.titulo AS 'Nombre de Curso',
    c.categoria AS 'Categoria de Curso',
    c.precio AS 'Precio del Curso'
FROM cursos AS c
WHERE c.precio > (
    SELECT AVG(c1.precio)
    FROM cursos AS c1
    WHERE c1.categoria = c.categoria
);

/*Reto 4: Subconsulta en el FROM (Tabla Derivada y Agregación)
Queremos analizar el comportamiento de los usuarios más activos. Calcula el promedio general de inscripciones por usuario. 
Es decir, primero debes saber cuántas inscripciones tiene cada usuario, y luego sacarle el promedio a esos totales.

(Pista: Crea una subconsulta en la cláusula FROM que devuelva usuario_id y COUNT(inscripcion_id) AS total_inscripciones. 
Luego, en el SELECT principal, calcula el AVG(total_inscripciones) de esa tabla derivada).*/

SELECT 
    ROUND(AVG(conteo_usuarios.total_inscripciones), 2) AS 'Promedio Inscripciones por Usuario'
FROM (
    SELECT 
        usuario_id, 
        COUNT(inscripcion_id) AS total_inscripciones
    FROM inscripciones
    GROUP BY usuario_id
) AS conteo_usuarios;
	

/*Reto 5: Subconsulta con EXISTS
Identifica a los usuarios "inactivos" o sin interacciones. Muestra el nombre, pais y 
tipo_suscripcion de todos los usuarios que NUNCA se han inscrito a ningún curso.
(Pista: Utiliza WHERE NOT EXISTS (subconsulta que busque en la tabla inscripciones coincidiendo el usuario_id))*/

SELECT 
    u.nombre AS 'Nombre de Usuario',
    u.pais AS 'Pais',
    u.tipo_suscripcion AS 'Tipo de Suscripcion'
FROM usuarios AS u
WHERE NOT EXISTS (
    SELECT 1 
    FROM inscripciones AS i 
    WHERE i.usuario_id = u.usuario_id
);

/*Reto 6: (Nivel Escalar)
Queremos identificar qué usuarios han otorgado calificaciones por encima del promedio general. 
Muestra el usuario_id, fecha_inscripcion y calificacion_dada de las inscripciones cuya calificación 
dada sea mayor al promedio global de calificaciones de toda la tabla inscripciones.*/

SELECT
	usuario_id AS 'ID de Usuario',
    fecha_inscripcion AS 'Fecha de Inscripcion',
	calificacion_dada AS 'Calificacion Mayor al Promedio Global'
FROM inscripciones
WHERE calificacion_dada > (SELECT 
	AVG(i.calificacion_dada)
FROM inscripciones AS i);

/*Reto 7: (Nivel Escalar)
Queremos obtener el titulo y el precio de todos los cursos que pertenecen a las 
categorías donde al menos un usuario ha dado una calificación igual a 5.*/

SELECT 
    c.titulo AS 'Titulo de Curso',
    c.precio AS 'Precio del Curso'
FROM cursos AS c
WHERE c.categoria IN (
    SELECT DISTINCT c1.categoria
    FROM inscripciones AS i1
    INNER JOIN cursos AS c1 
        ON i1.curso_id = c1.curso_id
    WHERE i1.calificacion_dada = 5
);

/*Reto 8: (Subconsulta Correlacionada)
El equipo académico quiere premiar la satisfacción. Obtén el titulo, la categoria 
y el precio de todos los cursos cuya calificación promedio recibida sea estrictamente 
mayor al promedio de calificaciones de su MISMA categoría.*/

SELECT 
    c.titulo AS 'Titulo de Curso',
    c.categoria AS 'Categoria del Curso',
    c.precio AS 'Precio del Curso'
FROM cursos AS c
INNER JOIN inscripciones AS i ON c.curso_id = i.curso_id
GROUP BY c.curso_id, c.titulo, c.categoria, c.precio
HAVING AVG(i.calificacion_dada) > (
    SELECT AVG(i1.calificacion_dada)
    FROM inscripciones AS i1
    INNER JOIN cursos AS c1 ON i1.curso_id = c1.curso_id
    WHERE c1.categoria = c.categoria
);

/*Reto 9: (Dominio de WHERE con subconsulta)
El equipo de retención necesita identificar a los usuarios con suscripción de pago que están aprovechando al máximo la plataforma.

Obtén el nombre, pais y tipo_suscripcion de todos los usuarios con suscripción 'Premium' o 'Estándar' que se hayan inscrito a al 
menos un curso cuyo precio sea estrictamente superior a $100.00.*/

SELECT 
    u.nombre AS 'Nombre de Usuario',
    u.pais AS 'Pais',
    u.tipo_suscripcion AS 'Tipo de Suscripcion'
FROM usuarios AS u
WHERE u.tipo_suscripcion IN ('Premium', 'Estándar')
  AND u.usuario_id IN (
      SELECT i1.usuario_id
      FROM inscripciones AS i1
      INNER JOIN cursos AS c1 
          ON c1.curso_id = i1.curso_id
      WHERE c1.precio > 100
  );