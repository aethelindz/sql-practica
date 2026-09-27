# Práctica de SQL

Repositorio con mis ejercicios de SQL, organizados por tema y nivel de dificultad. Forma parte de mi ruta de formación en análisis de datos.

**Motor:** MySQL 8 (compatible con MariaDB)

## Contenido

| Carpeta | Temas |
| --- | --- |
| `bases-de-datos/` | Scripts para crear y poblar las bases de datos de práctica |
| `01-consultas-basicas/` | SELECT, WHERE, ORDER BY, LIMIT, LIKE, IN, BETWEEN, funciones de agregación, GROUP BY y HAVING |
| `02-joins/` | INNER, LEFT y RIGHT JOIN, uniones de hasta 4 tablas, UNION y UNION ALL |
| `03-subconsultas-y-funciones/` | Subconsultas escalares, con IN, correlacionadas, tablas derivadas y EXISTS; IF y CASE; funciones de texto, fecha, conversión y matemáticas |
| `04-ctes-y-funciones-de-ventana/` | CTEs (WITH), ROW_NUMBER, RANK, LAG y acumulados *(en progreso)* |

## Bases de datos

| Base de datos | Descripción | Script |
| --- | --- | --- |
| `tienda_practica` | Tienda con clientes, productos y ventas | `bases-de-datos/tienda_practica.sql` |
| `tech_store_db` | Tienda de tecnología con detalle de ventas (4 tablas) | `bases-de-datos/tech_store_db.sql` |
| `cine_analytics_db` | Plataforma de cine con directores, películas, usuarios y visualizaciones | `bases-de-datos/cine_analytics_db.sql` |

Algunos ejercicios usan las bases `netflixdb` y `plataforma_educativa_db`, cuyos scripts de creación no están incluidos en este repositorio.

## Cómo ejecutar

1. Ejecuta el script de la base de datos correspondiente en `bases-de-datos/`.
2. Abre el archivo de ejercicios y ejecuta las consultas en MySQL Workbench u otro cliente SQL.

## Buenas prácticas aplicadas

- Agrupar por la llave primaria (ID) y no solo por nombres, para no mezclar registros con el mismo nombre.
- Responder la pregunta de negocio completa: mostrar nombres legibles, ordenar y limitar resultados cuando se pide "el mayor" o "el mejor".
- Usar `COALESCE` para mostrar 0 en lugar de NULL en conteos y sumas de LEFT JOIN.

---

Autor: [Ivan Arango](https://github.com/aethelindz)
