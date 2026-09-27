use netflixdb;
select * from episodios;
select distinct genero from series; # Sirve para obtener valores unicos de una columna
select titulo, duracion from episodios order by duracion;
select distinct año_lanzamiento from Series order by año_lanzamiento DESC;
SELECT titulo FROM Episodios LIMIT 5;
select * from Series where genero = 'Drama';

select * from Series where año_lanzamiento > 2010 order by año_lanzamiento;
select titulo, duracion, rating_imdb from episodios
where duracion > 45 and rating_imdb >= 9;

select * from series
where (genero = 'Comedia' OR genero = 'Animación');
 
 select * from series
 where genero NOT IN ('Comedia'); # Sirve para que la consulta no incluya el genero descrito
 select * from series where genero not in ('Drama', 'Drama histórico');
 
 
 select * from series where titulo like '%The%'; # Permite que solo arroje resultados los titulos que contengan dicho texto
 select * from series where titulo like 'The%'; # Permite que solo arroje resultados los titulos que comiencen con dicho texto
 select * from series where titulo like '%The'; # Permite que solo arroje resultados los titulos que terminen con dicho texto
 select * from series where titulo not like '%The%'; # Permite que solo arroje resultados los titulos que NO contengan dicho texto
 
 select sum(duracion) as suma_duracion from episodios
 where serie_id = 5;
 select count(*) from episodios
 where serie_id = 2;
 select max(duracion) from episodios
 where serie_id = 2;
 select min(duracion) from episodios
 where serie_id = 2;
 select AVG(duracion) from episodios
 where serie_id IN (1,2);
 
 select serie_id, AVG(duracion) AS Promedio, sum(duracion) AS suma_duracion from episodios
 where serie_id IN (1,2)
 group by serie_id;
 
 SELECT serie_id, COUNT(episodio_id) AS count_episodios FROM Episodios GROUP BY serie_id;
 SELECT serie_id, MAX(duracion) FROM Episodios GROUP BY 1;
 select año_lanzamiento, count(serie_id) as cantidad_de_series from Series group by año_lanzamiento;
 
 select serie_id, count(episodio_id) as numero_episodios
 from episodios
 where serie_id in (2,12) # Where se utiliza antes de group by
 group by serie_id
 having count(episodio_id) > 11; # HAVING se utiliza sobre funciones de agregación
 
select temporada, sum(duracion) as duracion_total from Episodios
where serie_id = 2
group by temporada
having sum(duracion) > 400;

## EJERCICIOS DE PRACTICA

-- Pregunta 1
-- ¿Quien es el actor o actriz que ha participado en la mayor cantidad de series?
SELECT a.nombre, COUNT(DISTINCT ac.serie_id) AS numero_de_series
FROM actuaciones AS ac
INNER JOIN actores AS a ON a.actor_id = ac.actor_id
GROUP BY a.actor_id, a.nombre
ORDER BY numero_de_series DESC
LIMIT 1;

-- Pregunta 2
-- ¿Cual es la serie con mejor rating promedio segun imdb?
SELECT s.titulo, AVG(e.rating_imdb) AS rating_promedio
FROM episodios AS e
INNER JOIN series AS s ON s.serie_id = e.serie_id
GROUP BY s.serie_id, s.titulo
ORDER BY rating_promedio DESC
LIMIT 1;

-- Pregunta 3
-- ¿Cual es el episodio con la duración más larga?
SELECT titulo, duracion FROM episodios
ORDER BY duracion DESC
LIMIT 1;