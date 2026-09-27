## Los JOINS permiten consultar información de en otras tablas y unirlas en una misma tabla
##INNER JOIN
use netflixdb;
SELECT
s.titulo,
a.personaje
FROM Series AS s
INNER JOIN Actuaciones AS a
ON s.serie_id = a.serie_id
where s.titulo = 'The Crown';

select s.titulo as titulo_serie, e.titulo as titulo_episodio, e.duracion
from Series as s
inner join Episodios as e
on s.serie_id = e.serie_id
where s.titulo = 'Stranger Things';

##LEFT JOIN Sirve para incluir los registros de la primera tabla
SELECT series.titulo AS 'Título de la serie',
       episodios.titulo AS 'Título de Episodio'
FROM series
LEFT JOIN episodios
ON series.serie_id = episodios.serie_id
ORDER BY series.titulo;

SELECT 
    Series.titulo AS 'Título de la Serie', 
    Episodios.titulo AS 'Título del Episodio', 
    Episodios.rating_imdb AS 'Rating IMDB'
FROM Series
LEFT JOIN Episodios ON Series.serie_id = Episodios.serie_id
ORDER BY Series.titulo ASC;

SELECT 
    Series.titulo AS 'Título de la Serie', 
    Episodios.titulo AS 'Título del Episodio', 
    Episodios.rating_imdb AS 'Rating IMDB'
FROM Series
LEFT JOIN Episodios ON Series.serie_id = Episodios.serie_id
WHERE Series.titulo = 'Stranger Things'
ORDER BY Episodios.rating_imdb DESC;

##RIGHT JOIN
SELECT
    series.titulo AS 'Titulo de la serie',
    episodios.titulo AS 'Titulo del Episodio'
FROM episodios
RIGHT JOIN series
ON episodios.serie_id = series.serie_id
ORDER BY series.titulo;

SELECT
    series.titulo AS 'Titulo de la serie',
    episodios.titulo AS 'Titulo del Episodio',
    episodios.duracion 'Duración'
FROM episodios
RIGHT JOIN series
ON episodios.serie_id = series.serie_id
WHERE episodios.duracion > 30
ORDER BY series.titulo;
-- Nota: filtrar en WHERE una columna de la tabla 'episodios' elimina las series sin episodios,
-- por lo que este RIGHT JOIN se comporta como un INNER JOIN. Para conservarlas,
-- la condición debe ir en el ON: RIGHT JOIN series ON ... AND episodios.duracion > 30

## UNION ALL
SELECT * FROM series
WHERE genero = 'Ciencia ficción'

UNION ALL

SELECT * FROM series
WHERE genero = 'Drama'

UNION ALL

SELECT * FROM series
WHERE genero = 'Drama';

## UNION
SELECT titulo, genero FROM series
WHERE genero = 'Ciencia ficción'

UNION

SELECT titulo, genero FROM series
WHERE genero = 'Drama'

UNION

SELECT titulo, genero FROM series
WHERE genero = 'Drama';

SELECT titulo FROM episodios
WHERE duracion > 20

UNION

SELECT titulo FROM episodios
WHERE rating_imdb > 9;

## Proyecto 4
/*¿Qué géneros de series son más prevalentes en la tabla Series?*/
select genero, count(serie_id) as 'Cantidad de Series' from series
group by genero
order by count(serie_id) DESC;

/*¿Cuáles son las tres series con mayor rating promedio de IMDB y cuántos episodios tiene cada una?*/
SELECT
	s.titulo as 'Titulo Serie',
    count(e.titulo) as 'Cantidad de Episodios',
    avg(e.rating_imdb) as 'Rating'
FROM series AS s
INNER JOIN episodios AS e
ON s.serie_id = e.serie_id
group by s.serie_id, s.titulo
order by avg(e.rating_imdb) DESC
limit 3;


/* ¿Cuál es la duración total de todos los episodios de la serie "Stranger Things"?*/
SELECT
	s.titulo as 'Titulo Serie',
    sum(e.duracion) as 'Duracion Total'
FROM series AS s
INNER JOIN episodios AS e
ON s.serie_id = e.serie_id
where s.titulo = 'Stranger Things'
group by s.serie_id, s.titulo;
