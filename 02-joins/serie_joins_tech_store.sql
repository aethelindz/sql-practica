use tech_store_db;

## Ejercicio 1
/* Muestra el venta_id, la fecha_venta, el monto_total y el nombre del cliente, junto con su ciudad. Muestra solo las ventas 
con un monto_total mayor o igual a $300 y ordena los resultados de la venta más reciente a la más antigua.*/

SELECT
	v.venta_id as 'ID de venta',
    v.fecha_venta as 'Fecha de venta',
    v.monto_total as 'Monto total',
    c.nombre as 'Nombre de cliente',
    c.ciudad as 'Ciudad'
FROM ventas as v
INNER JOIN clientes as c
ON v.cliente_id = c.cliente_id
where v.monto_total >= 300
order by v.fecha_venta DESC;

## Ejercicio 2
/* Obtén el nombre, email y ciudad de todos los clientes registrados que no hayan realizado ninguna compra hasta el momento.*/
SELECT
    c.nombre as 'Nombre de cliente',
    c.email as 'Correo electronico',
    c.ciudad as 'Ciudad'
FROM clientes as c
LEFT JOIN ventas as v
ON c.cliente_id = v.cliente_id
where v.venta_id is NULL;

## Ejercicio 3
/* Calcula el nombre del cliente y el monto total acumulado gastado (SUM(monto_total)). Considera únicamente a los 
clientes que viven en la ciudad de 'Bogotá'. Filtra con HAVING para mostrar únicamente a aquellos cuyo gasto total acumulado supere los $1,000.*/

SELECT
    c.nombre as 'Nombre de cliente',
    c.ciudad as 'ciudad',
    sum(v.monto_total) as 'Gasto total'
FROM clientes as c
INNER JOIN ventas as v
ON c.cliente_id = v.cliente_id
where c.ciudad = 'Bogotá'
group by c.cliente_id, c.nombre, c.ciudad
having sum(v.monto_total) > 1000;

## Ejercicio 4
/* Genera una lista de todos los productos registrados (nombre_producto y categoria), junto con la cantidad total de unidades vendidas (SUM(cantidad) de la tabla detalle_ventas). 
Asegúrate de que los productos que nunca se han vendido también aparezcan en la lista (deben mostrar NULL o 0 en el acumulado). Ordena por la cantidad vendida de mayor a menor.*/

SELECT
    p.nombre_producto as 'Nombre de producto',
    p.categoria as 'Categoria',
    COALESCE(SUM(d.cantidad), 0) as 'Unidades vendidas'
FROM productos as p
LEFT JOIN detalle_ventas as d
ON p.producto_id = d.producto_id
GROUP BY p.producto_id, p.nombre_producto, p.categoria
ORDER BY `Unidades vendidas` DESC;

## Ejercicio 5
/* Relaciona las tablas productos, detalle_ventas y ventas. Muestra la categoria del producto, la cantidad total de unidades vendidas (SUM(cantidad)) y la suma total alcanzada 
por las ventas de esa categoría (SUM(cantidad * precio_unitario)). Incluye únicamente las transacciones realizadas a partir del '2024-02-01' en adelante.*/

SELECT 
    p.categoria AS 'Categoría',
    SUM(d.cantidad) AS 'Unidades vendidas',
    SUM(d.cantidad * d.precio_unitario) AS 'Monto total vendido'
FROM productos AS p
INNER JOIN detalle_ventas AS d 
    ON p.producto_id = d.producto_id
INNER JOIN ventas AS v 
    ON d.venta_id = v.venta_id
WHERE v.fecha_venta >= '2024-02-01'
GROUP BY p.categoria
ORDER BY `Monto total vendido` DESC;

## Ejercicio 6
/* Muestra el nombre de cada ciudad y el monto promedio que gastan sus clientes por venta (AVG(v.monto_total)). 
Redondea o renombra la columna como 'Gasto Promedio'. Ordena las ciudades de mayor a menor según su promedio.*/

SELECT
	c.ciudad AS 'Ciudad',
    AVG(v.monto_total) AS 'Gasto Promedio'
FROM clientes AS c
INNER JOIN ventas AS v
ON c.cliente_id = v.cliente_id
GROUP BY c.ciudad
ORDER BY `Gasto Promedio` DESC;
    
## Ejercicio 7
/* Identifica cuáles productos tienen actualmente un stock igual a 0 (p.stock = 0), pero que aun así registran ventas en la tabla detalle_ventas. 
Muestra el nombre_producto, la categoria y el stock actual. Evita duplicados en la lista de resultados usando DISTINCT o GROUP BY.*/

SELECT
	p.nombre_producto AS 'Nombre de Producto',
    p.categoria AS 'Categoria',
    p.stock AS 'stock',
    COUNT(d.venta_id) AS 'Ventas'
FROM productos AS p
INNER JOIN detalle_ventas AS d
ON p.producto_id = d.producto_id
WHERE p.stock = 0
GROUP BY p.nombre_producto,p.categoria,p.stock;

## Ejercicio 8
/* Genera un listado de todos los clientes (nombre y email) junto con la cantidad total de compras que ha realizado cada uno (COUNT(v.venta_id)). 
Si un cliente no ha comprado nada, debe aparecer con valor 0 (puedes apoyarte en COUNT que ignora los valores NULL).*/

SELECT
	c.nombre AS 'Nombre de Cliente',
    c.email AS 'Correo Electronico',
    COUNT(v.venta_id) AS 'Total Compras'
FROM clientes AS c
LEFT JOIN ventas AS v
ON c.cliente_id = v.cliente_id
GROUP BY c.cliente_id, c.nombre, c.email
ORDER BY COUNT(v.venta_id) DESC;

## Ejercicio 9
/* Une las tablas productos, detalle_ventas y ventas. Calcula la suma total vendida por cada categoría (SUM(d.cantidad * d.precio_unitario)). 
Filtra el resultado final usando HAVING para mostrar únicamente las categorías cuyo monto acumulado total sea estrictamente mayor a $1,500.*/

SELECT
	p.categoria AS 'Categoria',
    SUM(d.cantidad * d.precio_unitario) AS 'Suma total vendida'
FROM productos AS p
INNER JOIN detalle_ventas AS d
	ON p.producto_id = d.producto_id
INNER JOIN ventas AS v
	ON  v.venta_id = d.venta_id
GROUP BY p.categoria
HAVING SUM(d.cantidad * d.precio_unitario) > 1500;

## Ejercicio 10
/* Relaciona las 4 tablas de la base de datos (clientes, ventas, detalle_ventas y productos). Muestra el nombre del cliente, la ciudad 
y la cantidad total de productos comprados (SUM(d.cantidad)) únicamente para la categoría 'Accesorios'. 
Ordena los resultados de mayor a menor según la cantidad total comprada.*/

SELECT
	c.nombre AS 'Nombre de Cliente',
    c.ciudad AS 'Ciudad',
    SUM(d.cantidad) AS 'Total productos comprados'
FROM clientes AS c
INNER JOIN ventas AS v
	ON c.cliente_id = v.cliente_id  -- Corregido: antes comparaba c.cliente_id consigo mismo
INNER JOIN detalle_ventas AS d
	ON d.venta_id = v.venta_id
INNER JOIN productos AS p
	ON p.producto_id = d.producto_id
WHERE p.categoria = 'Accesorios'
GROUP BY c.cliente_id, c.nombre, c.ciudad
ORDER BY SUM(d.cantidad) DESC;
