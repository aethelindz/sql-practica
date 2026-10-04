USE aseguradora_db;
/*Reto 1: Clasificación de Pólizas por Ramo
Obtener el Top 3 de pólizas con las primas anuales más altas por cada ramo de seguro, 
incluyendo el nombre del cliente y el nombre del ramo.

Resultado esperado: Una tabla con 5 columnas:
nombre_ramo, nombre (del cliente), codigo_cobertura, prima_anual, y posicion_ramo.

Condiciones:

Usa un CTE donde hagas los JOIN correspondientes entre polizas, clientes y ramos.
Calcula la posición usando DENSE_RANK() OVER (PARTITION BY r.ramo_id ORDER BY p.prima_anual DESC).
En la consulta principal fuera del CTE, filtra solo los registros con posicion_ramo <= 3.*/


WITH PolizasRamo AS (
	SELECT 
		r.nombre_ramo,
        c.nombre,
        p.codigo_cobertura,
        p.prima_anual,
        DENSE_RANK() OVER (PARTITION BY r.ramo_id ORDER BY p.prima_anual DESC) AS posicion_ramo
	FROM ramos AS r
    INNER JOIN polizas AS p ON r.ramo_id = p.ramo_id
    INNER JOIN clientes AS c ON c.cliente_id = p.cliente_id)
    
SELECT 
	pl.nombre_ramo AS 'Nombre de Ramo',
	pl.nombre AS 'Nombre de Cliente',
	pl.codigo_cobertura AS 'Codigo de Cobertura',
	pl.prima_anual AS 'Prima Anual',
    pl.posicion_ramo AS 'Posicion Ramo'
FROM PolizasRamo AS pl
WHERE pl.posicion_ramo <=3;

/*Reto 2: Sector Financiero (Banca)
El equipo de auditoría quiere detectar la primera póliza emitida para cada cliente 
cuyos correos tengan dominios corporativos o patrones específicos.

Filtra los clientes cuyo email termine exactamente en @email.com utilizando REGEXP.

Utiliza ROW_NUMBER() dentro de un CTE para asignar una secuencia numérica a las pólizas 
de cada cliente, ordenada por fecha_emision ASC (la más antigua primero).

En la consulta principal, muestra solo la primera póliza de cada cliente (orden_emision = 1).

Campos a mostrar: nombre (del cliente), email, codigo_cobertura, fecha_emision y prima_anual.*/

WITH PrimPoliza AS (
	SELECT
		c.nombre,
        c.email,
        p.codigo_cobertura,
        p.fecha_emision,
        ROW_NUMBER() OVER (PARTITION BY c.cliente_id ORDER BY p.fecha_emision ASC) AS orden_emision,
        p.prima_anual
	FROM clientes AS c
    INNER JOIN polizas AS p ON c.cliente_id = p.cliente_id
    WHERE c.email REGEXP '@email\\.com$'  -- \\. = punto literal; la comparación ya ignora mayúsculas por defecto
)

SELECT
	pr.nombre,
	pr.email,
	pr.codigo_cobertura,
    pr.fecha_emision,
	pr.prima_anual
FROM PrimPoliza AS pr
WHERE pr.orden_emision = 1;


/*Reto 3: Sector Financiero (Banca)
Queremos un reporte que identifique los siniestros o reclamos de mayor monto 
dentro de cada ciudad, pero filtrando solo los reclamos en estado 'Aprobado'.

Tu tarea:

Crea un CTE que una las tablas clientes, polizas y siniestros.

Filtra dentro del CTE solo los siniestros donde s.estado = 'Aprobado'.

Utiliza RANK() para clasificar los siniestros por monto de mayor a menor 
(monto_reclamado DESC), particionando por la ciudad del cliente (c.ciudad).

En la consulta externa, filtra para obtener solo el Top 2 de siniestros
más altos por ciudad (ranking_monto <= 2).

Campos a devolver: ciudad, nombre (del cliente), monto_reclamado, 
estado, y ranking_monto.*/

WITH RecMayorMonto AS (
	SELECT
		c.ciudad,
        c.nombre,
        s.monto_reclamado,
        s.estado,
        RANK() OVER (PARTITION BY c.ciudad ORDER BY s.monto_reclamado DESC) AS ranking_monto
	FROM clientes AS c
    INNER JOIN polizas AS p ON c.cliente_id = p.cliente_id
    INNER JOIN siniestros AS s ON s.poliza_id = p.poliza_id
    WHERE s.estado = 'Aprobado'
    )

SELECT
	re.ciudad,
    re.nombre,
    re.monto_reclamado,
    re.estado,
    re.ranking_monto
FROM RecMayorMonto AS re
WHERE re.ranking_monto <= 2;

/*Reto 4: Integración Avanzada (Financiero / Riesgo)
El departamento de Riesgo quiere auditar a los clientes corporativos o de dominios 
específicos que tienen un historial de reclamaciones representativo.

Considera únicamente a los clientes cuyo email contenga dominios que terminen en .com 
(utiliza REGEXP para asegurarte de capturar el patrón \.com$ ignorando mayúsculas/minúsculas).

Crea un CTE que calcule para cada póliza de estos clientes:

El total reclamado por póliza (SUM(s.monto_reclamado)).

La posición o ranking de la póliza dentro de su propio ramo (ramo_id) 
usando DENSE_RANK() en función del total reclamado descendente.

En la consulta principal, filtra únicamente las pólizas que ocupen 
el puesto 1 (posicion_riesgo = 1) en total reclamado por ramo.

Campos a mostrar: nombre_ramo, nombre (del cliente), 
email, codigo_cobertura, total_reclamado y posicion_riesgo.*/

WITH AuditorClientes AS (
	SELECT
		r.nombre_ramo,
        c.nombre,
        c.email,
        p.poliza_id,
        p.codigo_cobertura,
        SUM(s.monto_reclamado) AS total_reclamado,
        DENSE_RANK() OVER (PARTITION BY r.ramo_id ORDER BY SUM(s.monto_reclamado) DESC) AS posicion_riesgo
	FROM ramos AS r
    INNER JOIN polizas AS p ON r.ramo_id = p.ramo_id
    INNER JOIN clientes AS c ON c.cliente_id = p.cliente_id
    INNER JOIN siniestros AS s ON s.poliza_id = p.poliza_id
    WHERE c.email REGEXP '\\.com$'
    -- Se agrupa por poliza_id: el código de cobertura no identifica una póliza única,
    -- y sin el ID se sumaban los siniestros de varias pólizas del mismo cliente
    GROUP BY r.ramo_id, r.nombre_ramo, p.poliza_id, c.nombre, c.email, p.codigo_cobertura
	)
    
    SELECT
		a.nombre_ramo,
        a.nombre,
        a.email,
        a.codigo_cobertura,
        a.total_reclamado,
        a.posicion_riesgo
	FROM AuditorClientes AS a
    WHERE posicion_riesgo = 1;
    
/*Reto 5: Análisis de Frecuencia y Retención con ROW_NUMBER() y LAG()
Queremos medir el tiempo transcurrido entre compras de un mismo cliente para identificar si su frecuencia está disminuyendo.

Tu tarea:
Crea un CTE utilizando la tabla polizas (o simula pedidos) donde para cada cliente (cliente_id):
-Obtengas poliza_id, cliente_id, fecha_emision y prima_anual.
-Utilices ROW_NUMBER() asignando una secuencia de compra por 
cliente ordenada por fecha_emision ASC (numero_compra).
-En el mismo CTE (o en uno anidado/secundario), calcula la fecha de la compra anterior 
utilizando la función de ventana LAG(fecha_emision) OVER (PARTITION BY cliente_id ORDER BY fecha_emision ASC).

En la consulta principal:
Muestra únicamente las compras a partir de la segunda en adelante (numero_compra > 1).
Calcula los días transcurridos entre la compra actual y la anterior usando DATEDIFF(fecha_emision, fecha_anterior).
Campos a devolver: cliente_id, numero_compra, fecha_emision (actual), fecha_anterior y dias_entre_compras.*/

WITH AnalisisFrecuencia AS (
	SELECT 
		cliente_id,
        poliza_id,
        fecha_emision,
        prima_anual,
        ROW_NUMBER() OVER(PARTITION BY cliente_id ORDER BY fecha_emision) AS numero_compra,
        LAG(fecha_emision) OVER (PARTITION BY cliente_id ORDER BY fecha_emision ASC) AS fecha_compra_anterior
	FROM polizas)
    
SELECT
	cliente_id AS 'ID de Cliente',
    numero_compra AS 'Numero de Compra',
    fecha_emision AS 'Fecha de Emision',
    fecha_compra_anterior AS 'Fecha de compra anterior',
    DATEDIFF(fecha_emision,fecha_compra_anterior) AS 'Dias entre compras'
FROM AnalisisFrecuencia
WHERE numero_compra > 1;

/*Reto 6: Análisis de Valor de Vida del Cliente (LTV) y Cumulativo (Retail / E-commerce)
Queremos construir un reporte que muestre la evolución del monto acumulado gastado (LTV progresivo) 
por cada cliente a lo largo del tiempo.

Tu tarea:
Crea un CTE basado en la tabla polizas donde extraigas:
cliente_id, poliza_id, fecha_emision y prima_anual.

La suma acumulada de la prima anual por cliente ordenada por fecha de emisión:
SUM(prima_anual) OVER (PARTITION BY cliente_id ORDER BY fecha_emision ASC) AS ltv_acumulado.
En el mismo CTE (o mediante otro cálculo en la ventana), obtiene el LTV acumulado de la 
compra anterior utilizando LAG() sobre la columna/cálculo de la suma acumulada (o recalculándolo).

En la consulta principal:
Muestra cliente_id, fecha_emision, prima_anual (de la compra actual), ltv_acumulado.
Opcional: Filtra o muestra cómo la cuenta del cliente va creciendo a lo largo de sus distintas compras.
Campos a devolver: cliente_id, fecha_emision, prima_anual, y ltv_acumulado.*/

WITH AnalisisLTV AS (
    SELECT 
        cliente_id,
        poliza_id,
        fecha_emision,
        prima_anual,
        SUM(prima_anual) OVER (PARTITION BY cliente_id ORDER BY fecha_emision ASC) AS ltv_acumulado
    FROM polizas
),
LTVConCompraAnterior AS (
    SELECT
        cliente_id,
        fecha_emision,
        prima_anual,
        ltv_acumulado,
        LAG(ltv_acumulado) OVER (PARTITION BY cliente_id ORDER BY fecha_emision ASC) AS ltv_compra_anterior
    FROM AnalisisLTV
)
SELECT 
    cliente_id,
    fecha_emision,
    prima_anual,
    ltv_acumulado,
    ltv_compra_anterior
FROM LTVConCompraAnterior;