use tienda_practica;

## Seccion A
/* El equipo de marketing quiere saber el precio promedio de los productos vendidos en transacciones donde la cantidad comprada sea mayor a 1 unidad.
Sin embargo, solo les interesan las categorías que tengan al menos 2 ventas de este tipo. Muestra la categoría y el precio promedio de esos productos.*/

-- Corregido: el resultado se agrupa por categoría, por lo que se une ventas con productos
SELECT p.categoria, AVG(p.precio) AS precio_promedio
FROM ventas AS v
INNER JOIN productos AS p ON v.producto_id = p.producto_id
WHERE v.cantidad > 1
GROUP BY p.categoria
HAVING COUNT(*) >= 2;


/* Finanzas necesita identificar las categorías cuyo valor total retenido en inventario (es decir, precio * stock) 
supere los $1,000. Muestra la categoría y el valor total del inventario ordenado de mayor a menor.*/

select categoria, sum(precio * stock) as total from productos
group by categoria
having sum(precio * stock) > 1000
order by sum(precio * stock) DESC;


/* Muestra los países que cuentan con más de 1 cliente registrado que no sea VIP. 
Muestra el país y la cantidad de clientes no VIP.*/

select pais, count(*) as No_VIP from clientes
where es_vip = 0
group by pais
having count(*) > 1;


## Seccion B
/* Muestra el nombre, categoría y precio de los productos cuyo nombre contenga la palabra 'Pro', 
pero que no pertenezcan a la categoría 'Deportes' ni cuesten más de $100.*/

select nombre_producto, categoria, precio from productos
where nombre_producto like '%Pro%'
and categoria not in ('Deportes')
and precio <= 100;


/* Obtén los nombres y ciudades de los clientes cuya ciudad empiece con las 
letras 'B' o 'C', pero excluyendo a todos aquellos cuyo país sea 'México'.*/

SELECT nombre, ciudad FROM clientes
WHERE pais NOT IN ('México')
  AND (ciudad LIKE 'B%' OR ciudad LIKE 'C%');


## Seccion C
/* Genera un reporte de los cliente_id que hayan realizado compras por un monto acumulado igual o superior a $200, 
considerando únicamente las transacciones ocurridas durante el mes de febrero de 2024 
(fecha_venta entre '2024-02-01' y '2024-02-29').*/

SELECT cliente_id, SUM(monto_total) AS compras FROM ventas
WHERE fecha_venta BETWEEN '2024-02-01' AND '2024-02-29'
GROUP BY cliente_id
HAVING SUM(monto_total) >= 200;

/* Identifica las categorías cuyo precio promedio por producto sea menor a $100, 
pero que sumen entre todas sus unidades un stock total superior a 80 unidades.*/

SELECT categoria, AVG(precio) AS precio_promedio, SUM(stock) AS unidades
FROM productos
GROUP BY categoria
HAVING AVG(precio) < 100 AND SUM(stock) > 80;


/* Muestra para cada cliente (cliente_id) la cantidad total de unidades compradas (SUM(cantidad)), 
el monto máximo pagado en una sola venta (MAX(monto_total)) y el número de transacciones (COUNT). 
Ordena los resultados por el monto máximo pagado de forma descendente.*/

SELECT cliente_id, SUM(cantidad) AS U_compradas, MAX(monto_total) AS max_pagado,
       COUNT(venta_id) AS total_transacciones FROM ventas
GROUP BY cliente_id
ORDER BY max_pagado DESC;