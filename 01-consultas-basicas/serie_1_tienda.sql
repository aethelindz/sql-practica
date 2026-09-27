use tienda_practica;

## Modulo 1

## Muestra el nombre y el precio de todos los productos que cuesten más de $50, ordenados del más caro al más barato.
select nombre_producto, precio from productos
where precio > 50
ORDER BY precio DESC;

## Obtén una lista sin duplicados de todos los países de donde provienen los clientes registrados.
select distinct pais from clientes;

## Encuentra el nombre y stock de los 5 productos con menor cantidad disponible en inventario (excluyendo aquellos cuyo stock sea 0).
SELECT nombre_producto, stock 
FROM productos
WHERE stock > 0
ORDER BY stock ASC
LIMIT 5;

## Selecciona el nombre y la ciudad de todos los clientes que sean de 'Colombia' o 'México', pero que no tengan estatus VIP (es_vip = 0).
select nombre, ciudad from clientes
where pais in ('Colombia','México') and es_vip = FALSE;
-- Nota: se escribe 'México' con tilde, tal como está guardado en los datos.


## Modulo 2
## Selecciona todos los productos cuyo precio esté entre $20 y $100 y que pertenezcan a las categorías
SELECT nombre_producto, precio FROM productos
WHERE categoria IN ('Electrónica','Hogar','Deportes')
  AND precio BETWEEN 20 AND 100;

## Encuentra todos los productos cuyo nombre comience con la palabra 'Smart' o termine con 'Pro'
SELECT nombre_producto FROM productos
WHERE nombre_producto LIKE 'Smart%' 
   OR nombre_producto LIKE '%Pro';

## Obtén la lista de clientes cuya ciudad no sea 'Bogotá', 'Medellín' ni 'Cali'.
select nombre, ciudad from clientes
where ciudad not in ('Bogotá','Medellín','Cali');


## Modulo 3
## Calcula el total general de ingresos por ventas (SUM), el precio promedio de los productos vendidos (AVG) y el número total de transacciones realizadas (COUNT).
Select sum(monto_total) as total_ingresos, avg(monto_total) as promedio, count(venta_id) as N_transacciones from ventas;

## Muestra el precio promedio y el número total de productos disponibles por cada categoría.
SELECT categoria, 
       AVG(precio) AS precio_promedio, 
       SUM(stock) AS total_unidades_stock
FROM productos
GROUP BY categoria;

## Obtén el cliente_id y la suma total que ha gastado cada cliente, considerando únicamente las ventas individuales cuyo monto_total supere los $30.
select cliente_id, sum(monto_total) as total from ventas
where monto_total > 30
group by cliente_id
order by total DESC;

## Identifica las categorías de productos que tengan un stock total sumado mayor a 150 unidades y un precio promedio inferior a $80.
SELECT categoria, 
       SUM(stock) AS stock_total, 
       AVG(precio) AS precio_promedio
FROM productos
GROUP BY categoria
HAVING SUM(stock) > 150 AND AVG(precio) < 80;


## Muestra los 3 clientes (cliente_id) que hayan acumulado el mayor monto total en compras, pero muestra solo aquellos que hayan realizado más de 2 compras en total.
SELECT cliente_id, 
       SUM(monto_total) AS total_gastado,
       COUNT(venta_id) AS total_compras
FROM ventas
GROUP BY cliente_id
HAVING COUNT(venta_id) > 2
ORDER BY total_gastado DESC
LIMIT 3;
select * from ventas;