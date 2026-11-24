--Consulta 1 — Resumen ejecutivo mensual--

SELECT 
MONTH(fecha_venta) AS MES,
SUM (precio_unitario*cantidad) AS TOTAL_FACTURADO,
COUNT (id_venta) AS TOTAL_VENTAS,
AVG(precio_unitario*cantidad) AS TICKET_PROMEDIO
FROM ventas
GROUP BY MONTH(fecha_venta);

--Consulta 2 — Ranking de productos--

SELECT TOP 5
id_producto,
SUM(cantidad) AS TOTAL_VENTAS,
SUM (precio_unitario*cantidad) AS TOTAL_FACTURADO
FROM ventas
GROUP BY id_producto
ORDER BY TOTAL_FACTURADO DESC;

--Consulta 3 — Clientes recurrentes--

SELECT
id_cliente,
COUNT (id_venta) AS CANTIDAD_PEDIDOS,
SUM(precio_unitario*cantidad) AS TOTAL_GASTADO
FROM ventas
GROUP BY id_cliente	
HAVING COUNT(*) > 1;


--Consulta 4 — Productos por encima/por debajo del promedio--

WITH Facturacion_por_producto AS (
SELECT id_producto,
SUM(precio_unitario*cantidad) AS TOTAL_FACTURADO
FROM ventas
GROUP BY id_producto
)

SELECT id_producto, 
		TOTAL_FACTURADO,
CASE 
WHEN TOTAL_FACTURADO > (SELECT AVG(TOTAL_FACTURADO)
FROM Facturacion_por_producto) THEN 'Por encima'

ELSE 'Por debajo'
END AS CLASIFICACION

FROM Facturacion_por_producto;


--HALLAZGOS--

1. --El producto 1 y el 5 tienen la misma cantidad de ventas, pero la diferencia de la facturacion es de mas de 3000--
2. --Todos los clientes compraron igual de veces (2 cada uno) pero no gastaron lo mismo--
3. --Mas de la mitad de los productos quedaron por debajo del promedio. 4 para ser mas precisos --
