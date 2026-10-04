/* =========================================================
   RETOS: CTEs (WITH) Y FUNCIONES DE VENTANA
   Bases de datos: tech_store_db y cine_analytics_db
   Motor: MySQL 8+ (o MariaDB 10.2+)
   ========================================================= */

-- ---------------------------------------------------------
-- PARTE 1: tech_store_db
-- ---------------------------------------------------------
USE tech_store_db;

/* Reto 1: CTE simple
Crea una CTE llamada gasto_por_cliente con el cliente_id y el gasto total (SUM(monto_total)).
Luego muestra el nombre del cliente y su gasto total, únicamente para los clientes cuyo gasto
sea mayor al promedio de gasto de todos los clientes que han comprado.
Pista: puedes consultar la misma CTE dentro de una subconsulta escalar. */

WITH gasto_por_cliente AS (
    SELECT
        c.cliente_id,
        c.nombre,
        SUM(v.monto_total) AS gasto_total
    FROM clientes AS c
    INNER JOIN ventas AS v ON c.cliente_id = v.cliente_id
    GROUP BY c.cliente_id, c.nombre
)
SELECT
    nombre AS 'Nombre de Cliente',
    gasto_total AS 'Gasto total'
FROM gasto_por_cliente
WHERE gasto_total > (SELECT AVG(gasto_total) FROM gasto_por_cliente)
ORDER BY gasto_total DESC;

/* Reto 2: Varias CTEs encadenadas
Crea una primera CTE con las ventas totales por mes (usa DATE_FORMAT(fecha_venta, '%Y-%m')),
y una segunda CTE que calcule el promedio de esas ventas mensuales.
Muestra solo los meses cuyas ventas superen el promedio mensual. */

WITH VentasTotalesMes AS (
    SELECT 
        DATE_FORMAT(fecha_venta, '%Y-%m') AS Mes,
        SUM(monto_total) AS Total_Mensual
    FROM ventas
    GROUP BY DATE_FORMAT(fecha_venta, '%Y-%m')
),

PromedioMensual AS (
    SELECT 
        AVG(Total_Mensual) AS Promedio_Global
    FROM VentasTotalesMes
)

SELECT 
    v.Mes AS 'Mes',
    v.Total_Mensual AS 'Ventas'
FROM VentasTotalesMes AS v
INNER JOIN PromedioMensual AS p
WHERE v.Total_Mensual > p.Promedio_Global;


/* Reto 3: ROW_NUMBER
El equipo de marketing quiere conocer la PRIMERA compra de cada cliente.
Muestra el nombre del cliente, la fecha y el monto de su primera compra.
Pista: ROW_NUMBER() OVER (PARTITION BY cliente_id ORDER BY fecha_venta) y luego filtra la posición 1. */
WITH PrimeraCompra AS (
    SELECT
        c.nombre,
        c.cliente_id,
        v.fecha_venta,
        ROW_NUMBER() OVER (PARTITION BY c.cliente_id ORDER BY v.fecha_venta) AS Primer_compra,
        v.monto_total
    FROM clientes AS c
    INNER JOIN ventas AS v ON c.cliente_id = v.cliente_id
)

SELECT
    pc.nombre AS 'Nombre de Cliente',
    pc.fecha_venta AS 'Fecha de Venta',
    pc.monto_total AS 'Valor de Compra'
FROM PrimeraCompra AS pc
WHERE pc.Primer_compra = 1;


/* Reto 4: RANK por grupo
Para cada categoría, identifica el producto más vendido en unidades (SUM(cantidad) de detalle_ventas).
Muestra categoría, producto, unidades y su posición en el ranking.
Usa RANK() para que, si hay empate, aparezcan ambos productos.
Pregunta extra: ¿qué diferencia verías si usaras ROW_NUMBER() o DENSE_RANK()? */

WITH CategoriaVentas AS (
    SELECT
        p.categoria,
        p.nombre_producto,
        SUM(d.cantidad) AS total_cantidad,
        RANK() OVER(PARTITION BY p.categoria ORDER BY SUM(d.cantidad) DESC) AS num_ranking
    FROM productos AS p
    INNER JOIN detalle_ventas AS d ON p.producto_id = d.producto_id
    GROUP BY p.categoria, p.nombre_producto, p.producto_id
    )

SELECT
    cv.categoria,
    cv.nombre_producto,
    cv.total_cantidad,
    cv.num_ranking
FROM CategoriaVentas AS cv
WHERE cv.num_ranking = 1
ORDER BY cv.categoria;

/* Reto 5: LAG y acumulados (análisis de tendencia)
Muestra por cada mes:
  - Las ventas totales del mes.
  - La diferencia frente al mes anterior (LAG).
  - La variación porcentual frente al mes anterior, redondeada a 1 decimal.
  - Las ventas acumuladas desde el primer mes (SUM() OVER (ORDER BY ...)).
Pista: calcula primero las ventas por mes en una CTE. */

WITH ventas_mes AS (
    SELECT DATE_FORMAT(fecha_venta, '%Y-%m') AS mes,
           SUM(monto_total) AS venta_total
    FROM ventas
    GROUP BY DATE_FORMAT(fecha_venta, '%Y-%m')
),
con_anterior AS (
    SELECT mes, venta_total,
           LAG(venta_total) OVER (ORDER BY mes) AS venta_mes_anterior,
           SUM(venta_total) OVER (ORDER BY mes) AS ventas_acumuladas
    FROM ventas_mes
)
SELECT mes, venta_total,
       venta_total - venta_mes_anterior AS diferencia_mes,
       ROUND((venta_total - venta_mes_anterior) / NULLIF(venta_mes_anterior, 0) * 100, 1) AS variacion_porcentual,
       ventas_acumuladas
FROM con_anterior
ORDER BY mes;


-- ---------------------------------------------------------
-- PARTE 2: cine_analytics_db
-- ---------------------------------------------------------
USE cine_analytics_db;

/* Reto 6: La película más costosa de cada director
Muestra el nombre de cada director, el título de su película con mayor presupuesto y ese presupuesto.
Usa una función de ventana con PARTITION BY director. */

WITH PeliculaCostosa AS (
	SELECT
		d.nombre,
		p.titulo,
        p.presupuesto_millones,
        ROW_NUMBER () OVER (PARTITION BY d.nombre ORDER BY p.presupuesto_millones DESC) AS ranking_pelicula
	FROM directores AS d
    INNER JOIN peliculas AS p ON d.director_id = p.director_id
        )

SELECT
	nombre AS 'Nombre Director',
    titulo AS 'Pelicula con mayor presupuesto',
    presupuesto_millones 'Presupuesto'
FROM PeliculaCostosa
WHERE ranking_pelicula = 1;

/* Reto 7: Participación dentro del grupo
Para cada usuario, calcula cuántas visualizaciones tiene y qué porcentaje representan del total
de visualizaciones de su mismo tipo de suscripción.
Pista: SUM(...) OVER (PARTITION BY tipo_suscripcion) sin GROUP BY adicional. */

WITH VisualizacionesPorUsuario AS (
    SELECT 
        u.usuario_id,
        u.nombre,
        u.tipo_suscripcion,
        COUNT(v.visualizacion_id) AS visualizaciones_usuario
    FROM usuarios AS u
    INNER JOIN visualizaciones AS v ON u.usuario_id = v.usuario_id
    GROUP BY u.usuario_id, u.nombre, u.tipo_suscripcion
)
SELECT 
    nombre,
    visualizaciones_usuario,
    SUM(visualizaciones_usuario) OVER (PARTITION BY tipo_suscripcion) AS total_por_suscripcion,
    ROUND((visualizaciones_usuario / SUM(visualizaciones_usuario) OVER (PARTITION BY tipo_suscripcion)) * 100, 1) AS porcentaje
FROM VisualizacionesPorUsuario;

    

/* Reto 8: Integrador (pregunta de negocio)
El equipo de contenido quiere saber, por cada género, cuál es la película mejor calificada
(promedio de rating_usuario) y cuántas visualizaciones tiene.
Muestra solo las películas que ocupan el primer lugar de su género.
Escribe al final, en un comentario, una conclusión de negocio en 1 o 2 líneas basada en el resultado. */

WITH IntegradorPeliculas AS (
	SELECT 
		p.titulo,
        p.genero,
        ROW_NUMBER() OVER (PARTITION BY p.genero ORDER BY AVG(v.rating_usuario) DESC) AS pelicula_mejor_calificada,
        COUNT(v.visualizacion_id) AS numero_visualizaciones
	FROM peliculas AS p
    INNER JOIN visualizaciones AS v ON p.pelicula_id = v.pelicula_id
	GROUP BY p.genero,p.titulo
        )
        
SELECT
	titulo,
    genero,
    numero_visualizaciones
FROM IntegradorPeliculas
WHERE pelicula_mejor_calificada = 1;

/* 
El análisis permite identificar los contenidos más exitosos en calidad y volumen por categoría, 
detectando qué géneros retienen mejor a la audiencia para priorizar futuras producciones o licencias similares.
*/
	
