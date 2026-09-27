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


/* Reto 2: Varias CTEs encadenadas
Crea una primera CTE con las ventas totales por mes (usa DATE_FORMAT(fecha_venta, '%Y-%m')),
y una segunda CTE que calcule el promedio de esas ventas mensuales.
Muestra solo los meses cuyas ventas superen el promedio mensual. */


/* Reto 3: ROW_NUMBER
El equipo de marketing quiere conocer la PRIMERA compra de cada cliente.
Muestra el nombre del cliente, la fecha y el monto de su primera compra.
Pista: ROW_NUMBER() OVER (PARTITION BY cliente_id ORDER BY fecha_venta) y luego filtra la posición 1. */


/* Reto 4: RANK por grupo
Para cada categoría, identifica el producto más vendido en unidades (SUM(cantidad) de detalle_ventas).
Muestra categoría, producto, unidades y su posición en el ranking.
Usa RANK() para que, si hay empate, aparezcan ambos productos.
Pregunta extra: ¿qué diferencia verías si usaras ROW_NUMBER() o DENSE_RANK()? */


/* Reto 5: LAG y acumulados (análisis de tendencia)
Muestra por cada mes:
  - Las ventas totales del mes.
  - La diferencia frente al mes anterior (LAG).
  - La variación porcentual frente al mes anterior, redondeada a 1 decimal.
  - Las ventas acumuladas desde el primer mes (SUM() OVER (ORDER BY ...)).
Pista: calcula primero las ventas por mes en una CTE. */


-- ---------------------------------------------------------
-- PARTE 2: cine_analytics_db
-- ---------------------------------------------------------
USE cine_analytics_db;

/* Reto 6: La película más costosa de cada director
Muestra el nombre de cada director, el título de su película con mayor presupuesto y ese presupuesto.
Usa una función de ventana con PARTITION BY director. */


/* Reto 7: Participación dentro del grupo
Para cada usuario, calcula cuántas visualizaciones tiene y qué porcentaje representan del total
de visualizaciones de su mismo tipo de suscripción.
Pista: SUM(...) OVER (PARTITION BY tipo_suscripcion) sin GROUP BY adicional. */


/* Reto 8: Integrador (pregunta de negocio)
El equipo de contenido quiere saber, por cada género, cuál es la película mejor calificada
(promedio de rating_usuario) y cuántas visualizaciones tiene.
Muestra solo las películas que ocupan el primer lugar de su género.
Escribe al final, en un comentario, una conclusión de negocio en 1 o 2 líneas basada en el resultado. */
