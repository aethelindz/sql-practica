use tienda_practica;

/* Muestra el producto_id, la cantidad total de unidades vendidas (SUM(cantidad)) y el monto total generado (SUM(monto_total)) 
para todos los productos en la tabla ventas. Ordena los resultados de mayor a menor según la cantidad total vendida y muestra solo los 3 primeros.*/

select producto_id, sum(cantidad) as cantidad_vendidas, sum(monto_total) as total_generado
from ventas
group by producto_id
order by cantidad_vendidas DESC
limit 3;

/* Muestra el nombre, categoría y precio de todos los productos cuyo precio no esté entre $50 y $150, 
y cuyo stock sea mayor a 10 unidades.*/

select nombre_producto, categoria, precio, stock from productos
where precio not between 50 and 150
and stock > 10; 

/* Obtén el cliente_id y el monto total gastado por cada cliente considerando únicamente las transacciones realizadas durante el 
mes de enero de 2024 (fecha_venta entre '2024-01-01' y '2024-01-31'). Muestra solo a los clientes que hayan gastado más de $100 en total durante ese mes.*/

SELECT cliente_id, SUM(monto_total) AS compras FROM ventas
WHERE fecha_venta BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY cliente_id
HAVING SUM(monto_total) > 100;

/* Encuentra el nombre y la categoría de los productos cuyo nombre contenga la palabra 'Fit' o la palabra 'Gamer', 
pero excluyendo aquellos que pertenezcan a la categoría 'Deportes'.*/

SELECT nombre_producto, categoria FROM productos
WHERE categoria NOT IN ('Deportes')
and (nombre_producto LIKE '%Fit%' OR nombre_producto LIKE '%Gamer%');

/* Identifica las categorías de productos cuyo precio máximo (MAX(precio)) sea menor a $200 y cuyo stock total sumado (SUM(stock)) 
supere las 50 unidades. Muestra la categoría, el precio máximo y el stock total.*/

select categoria, max(precio) as max_precio, sum(stock) as stock_total
from productos
group by categoria
having max(precio) < 200 and sum(stock) > 50;