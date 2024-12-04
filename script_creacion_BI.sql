USE GD2C2024;
GO

CREATE TABLE GESTORES_DE_DATOS.BI_dimension_tiempo(
	id DECIMAL(18,0) IDENTITY(1,1),
	mes DECIMAL(2,0),
	anio DECIMAL(4,0),
	cuatrimestre DECIMAL(1,0),
	PRIMARY KEY (id)
)
GO

CREATE TABLE GESTORES_DE_DATOS.BI_dimension_ubicacion(
	id DECIMAL(18,0) IDENTITY(1,1),
	localidad NVARCHAR(50),
	provincia NVARCHAR(50),
	PRIMARY KEY (id)
)
GO

CREATE TABLE GESTORES_DE_DATOS.BI_dimension_rango_etario(
	id DECIMAL(18,0) IDENTITY(1,1),
	rango NVARCHAR(50),
	PRIMARY KEY(id)
)
GO

CREATE TABLE GESTORES_DE_DATOS.BI_dimension_rubro_subRubro_publicacion(
	id DECIMAL(18,0) IDENTITY(1,1),
	rubro NVARCHAR(50),
	subRubro NVARCHAR(50),
	marca NVARCHAR(50),
	PRIMARY KEY(id)
)
GO

CREATE TABLE GESTORES_DE_DATOS.BI_dimension_concepto(
	id DECIMAL(18,0) IDENTITY(1,1),
	concepto NVARCHAR(50),
	PRIMARY KEY (id)
)
GO

CREATE TABLE GESTORES_DE_DATOS.BI_dimension_rango_horario(
	id DECIMAL(18,0) IDENTITY(1,1),
	rango NVARCHAR(50),
	PRIMARY KEY(id)
)
GO

CREATE TABLE GESTORES_DE_DATOS.BI_dimension_tipo_envio(
	id DECIMAL(18,0) IDENTITY(1,1),
	tipo_envio NVARCHAR(50),
	PRIMARY KEY(id)
)
GO

CREATE TABLE GESTORES_DE_DATOS.BI_dimension_tipo_medio_pago(
	id DECIMAL(18,0) IDENTITY(1,1),
	tipo_medio_pago NVARCHAR(50),
	PRIMARY KEY(id)
)
GO

CREATE TABLE GESTORES_DE_DATOS.BI_hecho_venta(
	id DECIMAL(18,0) IDENTITY(1,1),
	id_tiempo DECIMAL(18,0),
	id_rubro_subRubro_publicacion DECIMAL(18,0),
	id_ubicacion_almacen DECIMAL(18,0),
	id_rango_etario DECIMAL(18,0),
	id_rango_horario DECIMAL(18,0),
	id_ubicacion_cliente DECIMAL(18,0),
	id_ubicacion_vendedor DECIMAL(18,0),
	monto_total_venta DECIMAL(12,2),
	PRIMARY KEY (id),
	FOREIGN KEY (id_tiempo) REFERENCES GESTORES_DE_DATOS.BI_dimension_tiempo(id),
	FOREIGN KEY (id_rubro_subRubro_publicacion) REFERENCES GESTORES_DE_DATOS.BI_dimension_rubro_subRubro_publicacion(id),
	FOREIGN KEY (id_ubicacion_almacen) REFERENCES GESTORES_DE_DATOS.BI_dimension_ubicacion(id),
	FOREIGN KEY (id_rango_etario) REFERENCES GESTORES_DE_DATOS.BI_dimension_rango_etario(id),
	FOREIGN KEY (id_rango_horario) REFERENCES GESTORES_DE_DATOS.BI_dimension_rango_horario(id),
	FOREIGN KEY (id_ubicacion_cliente) REFERENCES GESTORES_DE_DATOS.BI_dimension_ubicacion(id),
	FOREIGN KEY (id_ubicacion_vendedor) REFERENCES GESTORES_DE_DATOS.BI_dimension_ubicacion(id)
)
GO

CREATE TABLE GESTORES_DE_DATOS.BI_hecho_facturacion(
	id DECIMAL(18,0) IDENTITY(1,1),
	id_tiempo DECIMAL(18,0),
	id_concepto DECIMAL(18,0),
	id_ubicacion_vendedor DECIMAL(18,0),
	monto DECIMAL(12,2),
	PRIMARY KEY (id),
	FOREIGN KEY (id_tiempo) REFERENCES GESTORES_DE_DATOS.BI_dimension_tiempo(id),
	FOREIGN KEY (id_concepto) REFERENCES GESTORES_DE_DATOS.BI_dimension_concepto(id),
	FOREIGN KEY (id_ubicacion_vendedor) REFERENCES GESTORES_DE_DATOS.BI_dimension_ubicacion(id),
)
GO

CREATE TABLE GESTORES_DE_DATOS.BI_hecho_publicacion(
	id DECIMAL(18,0) IDENTITY(1,1),
	id_rubro_subRubro_publicacion DECIMAL(18,0),
	id_tiempo DECIMAL(18,0),
	tiempo_publicacion DECIMAL(6,0),
	stock_inicial DECIMAL(6,0),
	PRIMARY KEY (id),
	FOREIGN KEY (id_rubro_subRubro_publicacion) REFERENCES GESTORES_DE_DATOS.BI_dimension_rubro_subRubro_publicacion(id),
	FOREIGN KEY (id_tiempo) REFERENCES GESTORES_DE_DATOS.BI_dimension_tiempo(id)
)
GO

CREATE TABLE GESTORES_DE_DATOS.BI_hecho_pago (
    id DECIMAL(18,0) IDENTITY(1,1),
    id_tiempo DECIMAL(18,0),
    id_tipo_medio_pago DECIMAL(18,0),
    id_ubicacion_cliente DECIMAL(18,0),
    monto_en_cuotas DECIMAL(6,0),
    monto_pago DECIMAL(12,2),
    PRIMARY KEY (id),
    FOREIGN KEY (id_tiempo) REFERENCES GESTORES_DE_DATOS.BI_dimension_tiempo(id),
    FOREIGN KEY (id_tipo_medio_pago) REFERENCES GESTORES_DE_DATOS.BI_dimension_tipo_medio_pago(id),
    FOREIGN KEY (id_ubicacion_cliente) REFERENCES GESTORES_DE_DATOS.BI_dimension_ubicacion(id)
)
GO


CREATE TABLE GESTORES_DE_DATOS.BI_hecho_envio(
	id DECIMAL(18,0) IDENTITY(1,1),
	id_tiempo DECIMAL(18,0),
	id_tipo_envio DECIMAL(18,0),
	id_ubicacion_almacen DECIMAL(18,0),
	id_ubicacion_cliente DECIMAL(18,0),
	monto_envio DECIMAL(12,2),
	cant_envios_cumplidos DECIMAL(18,0),
	cant_envios_totales DECIMAL(18,0),
	PRIMARY KEY (id),
    FOREIGN KEY (id_tiempo) REFERENCES GESTORES_DE_DATOS.BI_dimension_tiempo(id),
	FOREIGN KEY (id_tipo_envio) REFERENCES GESTORES_DE_DATOS.BI_dimension_tipo_envio(id),
	FOREIGN KEY (id_ubicacion_almacen) REFERENCES GESTORES_DE_DATOS.BI_dimension_ubicacion(id),
	FOREIGN KEY (id_ubicacion_cliente) REFERENCES GESTORES_DE_DATOS.BI_dimension_ubicacion(id)
)
GO
--24
INSERT INTO GESTORES_DE_DATOS.BI_dimension_tiempo(mes,cuatrimestre,anio)
	SELECT distinct MONTH(venta_fecha) 'mes',(CASE 
									WHEN MONTH(venta_fecha) BETWEEN 1 AND 4 THEN 1
									WHEN MONTH(venta_fecha) BETWEEN 5 AND 8 THEN 2   
									WHEN MONTH(venta_fecha) BETWEEN 9 AND 12 THEN 3  
								END) 'cuatrimestre',YEAR(venta_fecha) 'anio' FROM GESTORES_DE_DATOS.Venta
			ORDER BY 3,2,1
GO
---16918
INSERT INTO GESTORES_DE_DATOS.BI_dimension_ubicacion(localidad,provincia)
	SELECT l.localidad,p.provincia
		FROM GESTORES_DE_DATOS.Localidad l 
		JOIN GESTORES_DE_DATOS.Provincia p ON p.provincia_id = l.provincia_id
GO
--4
INSERT INTO GESTORES_DE_DATOS.BI_dimension_rango_etario(rango)
	SELECT DISTINCT (CASE
						WHEN DATEDIFF(YEAR,c.cliente_fecha_nac,GETDATE()) < 25 THEN '<25'
						WHEN DATEDIFF(YEAR,c.cliente_fecha_nac,GETDATE()) BETWEEN 25 AND 34 THEN '25-35'
						WHEN DATEDIFF(YEAR,c.cliente_fecha_nac,GETDATE()) BETWEEN 35 AND 49 THEN '35-50'
						WHEN DATEDIFF(YEAR,c.cliente_fecha_nac,GETDATE()) > 50 THEN '>50'
					END) FROM GESTORES_DE_DATOS.Cliente c
GO

--2971
INSERT INTO GESTORES_DE_DATOS.BI_dimension_rubro_subRubro_publicacion(rubro,subRubro,marca)
	SELECT DISTINCT r.rubro_descripcion,sr.sub_rubro,m.marca
		FROM GESTORES_DE_DATOS.Producto pr
			JOIN GESTORES_DE_DATOS.Sub_rubro sr ON sr.sub_rubro_id = pr.sub_rubro_id
			JOIN GESTORES_DE_DATOS.Rubro r ON r.rubro_id = sr.rubro_id
			JOIN GESTORES_DE_DATOS.Marca_Modelo_Producto mmp ON mmp.producto_id = pr.producto_id
			JOIN GESTORES_DE_DATOS.Marca m ON m.marca_id = mmp.marca_id
GO
--3
INSERT INTO GESTORES_DE_DATOS.BI_dimension_concepto(concepto)
	SELECT c.concepto FROM GESTORES_DE_DATOS.Concepto c
GO
--3
INSERT INTO GESTORES_DE_DATOS.BI_dimension_rango_horario(rango)
	SELECT DISTINCT (CASE 
				WHEN hora BETWEEN 0 and 5 THEN '00:00-06:00'
				WHEN hora BETWEEN 6 and 11 THEN '06:00-12:00'
				WHEN hora BETWEEN 12 and 17 THEN '12:00-18:00'
				WHEN hora BETWEEN 18 and 23 THEN '18:00-24:00'
			END) FROM (SELECT e.envio_hora_inicio hora  FROM GESTORES_DE_DATOS.Envio e
					UNION
					SELECT e.envio_hora_fin hora FROM GESTORES_DE_DATOS.Envio e) aux
GO
--3
INSERT INTO GESTORES_DE_DATOS.BI_dimension_tipo_envio(tipo_envio)
	SELECT tipo_envio FROM GESTORES_DE_DATOS.Tipo_Envio
GO
--2
INSERT INTO GESTORES_DE_DATOS.BI_dimension_tipo_medio_pago(tipo_medio_pago)
	SELECT tipo_medio_pago FROM GESTORES_DE_DATOS.Tipo_medio_pago
GO
--4539
INSERT INTO GESTORES_DE_DATOS.BI_hecho_facturacion
	(id_concepto,id_tiempo,id_ubicacion_vendedor,monto)
	SELECT con.concepto_id,t.id 'tiempo ID',ub.id 'ubicacion vendedor', sum(i.item_cantidad*i.item_precio) FROM GESTORES_DE_DATOS.Factura f
		JOIN GESTORES_DE_DATOS.Item_factura i ON i.factura_numero = f.factura_numero
		JOIN GESTORES_DE_DATOS.Concepto con ON i.concepto_id = con.concepto_id
		JOIN GESTORES_DE_DATOS.BI_dimension_concepto c ON c.concepto = con.concepto
		JOIN GESTORES_DE_DATOS.BI_dimension_tiempo t ON t.mes = MONTH(f.factura_fecha) AND t.anio = YEAR(f.factura_fecha)
		JOIN GESTORES_DE_DATOS.Usuario u ON u.usuario_id = f.usuario_id
		JOIN GESTORES_DE_DATOS.Domicilio d ON d.usuario_id = u.usuario_id
		JOIN GESTORES_DE_DATOS.Localidad l ON l.localidad_id = d.localidad_id
		JOIN GESTORES_DE_DATOS.Provincia p ON p.provincia_id = d.provincia_id AND p.provincia_id = l.provincia_id
		JOIN GESTORES_DE_DATOS.BI_dimension_ubicacion ub ON ub.localidad = l.localidad AND ub.provincia = p.provincia
	GROUP BY con.concepto_id,t.id,ub.id
GO
--23017
INSERT INTO GESTORES_DE_DATOS.BI_hecho_publicacion(id_rubro_subRubro_publicacion,id_tiempo,tiempo_publicacion,stock_inicial)
	SELECT rsp.id,t.id,AVG(DATEDIFF(DAY,pub.publicacion_fecha_inicio,pub.publicacion_fecha_fin)), SUM(pub.publicacion_stock)
		FROM GESTORES_DE_DATOS.Publicacion pub
		JOIN GESTORES_DE_DATOS.Producto p ON p.producto_id = pub.producto_id
		JOIN GESTORES_DE_DATOS.Sub_rubro sr ON sr.sub_rubro_id = p.sub_rubro_id
		JOIN GESTORES_DE_DATOS.Rubro r ON r.rubro_id = sr.rubro_id
		JOIN GESTORES_DE_DATOS.Marca_Modelo_Producto mmp ON mmp.producto_id = p.producto_id
		JOIN GESTORES_DE_DATOS.Marca m ON m.marca_id = mmp.marca_id
		JOIN GESTORES_DE_DATOS.BI_dimension_rubro_subRubro_publicacion rsp 
			ON rsp.subRubro = sr.sub_rubro AND rsp.rubro = r.rubro_descripcion AND rsp.marca = m.marca
		JOIN GESTORES_DE_DATOS.BI_dimension_tiempo t ON t.mes = MONTH(pub.publicacion_fecha_inicio) AND t.anio = YEAR(pub.publicacion_fecha_inicio)
		GROUP BY t.id,rsp.id
GO

--101.283
INSERT INTO GESTORES_DE_DATOS.BI_hecho_venta(id_tiempo,id_rubro_subRubro_publicacion,id_ubicacion_almacen,
	id_rango_etario,id_rango_horario,id_ubicacion_cliente,id_ubicacion_vendedor,
	monto_total_venta)
	SELECT dt.id 'tiempo',rsp.id 'rubro sub pub',ub.id 'ubicacion alacen',re.id 'rango etario',
		1 'rango horario',ubCli.id 'ubicacion cliente',ubVend.id 'ubicacion venderor', sum(v.venta_total)
		FROM GESTORES_DE_DATOS.Venta v
		JOIN GESTORES_DE_DATOS.BI_dimension_tiempo dt ON dt.mes = MONTH(v.venta_fecha) AND dt.anio = YEAR(v.venta_fecha)
		JOIN GESTORES_DE_DATOS.Venta_Detalle vd ON vd.venta_codigo = v.venta_codigo
		JOIN GESTORES_DE_DATOS.Publicacion pub ON pub.publicacion_codigo = vd.publicacion_codigo
		JOIN GESTORES_DE_DATOS.Producto p ON p.producto_id = pub.producto_id
		JOIN GESTORES_DE_DATOS.Sub_rubro sr ON sr.sub_rubro_id = p.sub_rubro_id
		JOIN GESTORES_DE_DATOS.Rubro r ON r.rubro_id = sr.rubro_id
		JOIN GESTORES_DE_DATOS.Marca_Modelo_Producto mmp ON	p.producto_id = mmp.producto_id
		JOIN GESTORES_DE_DATOS.Marca m ON m.marca_id = mmp.marca_id
		JOIN GESTORES_DE_DATOS.BI_dimension_rubro_subRubro_publicacion rsp 
			ON rsp.subRubro = sr.sub_rubro AND rsp.rubro = r.rubro_descripcion AND rsp.marca = m.marca
		JOIN GESTORES_DE_DATOS.Almacen a ON a.almacen_codigo = pub.almacen_codigo
		JOIN GESTORES_DE_DATOS.Localidad l ON l.localidad_id = a.localidad_id
		JOIN GESTORES_DE_DATOS.Provincia prov ON prov.provincia_id = a.provincia_id AND prov.provincia_id = l.provincia_id
		JOIN GESTORES_DE_DATOS.BI_dimension_ubicacion ub ON ub.localidad = l.localidad AND ub.provincia = prov.provincia
		JOIN GESTORES_DE_DATOS.Cliente c ON c.cliente_id = v.cliente_id
		JOIN GESTORES_DE_DATOS.BI_dimension_rango_etario re 
			ON re.rango = (CASE
							WHEN DATEDIFF(YEAR,c.cliente_fecha_nac,GETDATE()) < 25 THEN '<25'
							WHEN DATEDIFF(YEAR,c.cliente_fecha_nac,GETDATE()) BETWEEN 25 AND 34 THEN '25-35'
							WHEN DATEDIFF(YEAR,c.cliente_fecha_nac,GETDATE()) BETWEEN 35 AND 49 THEN '35-50'
							WHEN DATEDIFF(YEAR,c.cliente_fecha_nac,GETDATE()) > 50 THEN '>50'
						   END)
		JOIN GESTORES_DE_DATOS.Usuario uCli ON uCli.cliente_id = v.cliente_id
		JOIN GESTORES_DE_DATOS.Domicilio dCli ON dCli.usuario_id = uCli.usuario_id
		JOIN GESTORES_DE_DATOS.Localidad lCli ON lCLi.localidad_id = dCli.localidad_id
		JOIN GESTORES_DE_DATOS.Provincia provCli 
			ON provCli.provincia_id = dCli.provincia_id AND provCli.provincia_id = lCli.provincia_id
		JOIN GESTORES_DE_DATOS.BI_dimension_ubicacion ubCli 
			ON ubCli.localidad = lCli.localidad AND ubCli.provincia = provCli.provincia
		JOIN GESTORES_DE_DATOS.Pago pago ON pago.venta_codigo = v.venta_codigo
		JOIN GESTORES_DE_DATOS.Usuario uVende ON uVende.vendedor_id = pub.vendedor_id
		JOIN GESTORES_DE_DATOS.Domicilio dVend ON dVend.usuario_id = uVende.usuario_id
		JOIN GESTORES_DE_DATOS.Localidad lVend ON lVend.localidad_id = dVend.localidad_id
		JOIN GESTORES_DE_DATOS.Provincia provVend
			ON provVend.provincia_id = dVend.provincia_id AND provVend.provincia_id = lVend.provincia_id
		JOIN GESTORES_DE_DATOS.BI_dimension_ubicacion ubVend
			ON ubVend.localidad = lVend.localidad AND ubVend.provincia = provVend.provincia
		GROUP BY dt.id,rsp.id,ub.id,re.id,ubCli.id,ubVend.id;
GO
--82186
INSERT INTO GESTORES_DE_DATOS.BI_hecho_pago(id_tiempo,id_tipo_medio_pago,id_ubicacion_cliente,monto_en_cuotas,monto_pago)
	SELECT dt.id, dtmp.id, du.id, SUM((CASE
			WHEN p.pago_cant_cuotas > 1 THEN p.pago_importe
			WHEN p.pago_cant_cuotas <= 1 THEN 0
		END)), SUM(p.pago_importe)
		FROM GESTORES_DE_DATOS.Pago p
		JOIN GESTORES_DE_DATOS.BI_dimension_tiempo dt ON dt.mes = MONTH(p.pago_fecha) AND dt.anio = YEAR(p.pago_fecha)
		JOIN GESTORES_DE_DATOS.Tipo_medio_pago tmp ON tmp.tipo_medio_pago_id = p.tipo_medio_pago_id
		JOIN GESTORES_DE_DATOS.BI_dimension_tipo_medio_pago dtmp ON dtmp.tipo_medio_pago = tmp.tipo_medio_pago
		JOIN GESTORES_DE_DATOS.Venta v ON v.venta_codigo = p.venta_codigo
		JOIN GESTORES_DE_DATOS.Cliente c ON v.cliente_id = c.cliente_id
		JOIN GESTORES_DE_DATOS.Usuario u ON u.cliente_id = c.cliente_id
		JOIN GESTORES_DE_DATOS.Domicilio dom ON dom.usuario_id = u.usuario_id
		JOIN GESTORES_DE_DATOS.Provincia prov ON prov.provincia_id = dom.provincia_id
		JOIN GESTORES_DE_DATOS.Localidad l ON l.provincia_id = dom.provincia_id AND l.localidad_id = dom.localidad_id
		JOIN GESTORES_DE_DATOS.BI_dimension_ubicacion du ON du.localidad = l.localidad AND du.provincia = prov.provincia
		GROUP BY dt.id,dtmp.id,du.id;
GO
--103308
INSERT INTO GESTORES_DE_DATOS.BI_hecho_envio(id_tiempo,id_ubicacion_almacen,id_ubicacion_cliente,
	id_tipo_envio,cant_envios_cumplidos,cant_envios_totales,monto_envio)
	SELECT dt.id 'tiempo',dua.id 'almacen',duc.id 'cliente',dte.id 'tipoEnvio',
		COUNT((CASE
			WHEN DATEPART(HOUR,e.envio_fecha_entrega) BETWEEN e.envio_hora_inicio AND e.envio_hora_fin THEN 1
			WHEN DATEPART(HOUR,e.envio_fecha_entrega) NOT BETWEEN e.envio_hora_inicio AND e.envio_hora_fin THEN 0
		END)),COUNT(*) 'Total Envios',SUM(e.envio_costo) 'monto Total'
		FROM GESTORES_DE_DATOS.Envio e
		JOIN GESTORES_DE_DATOS.BI_dimension_tiempo dt 
			ON dt.mes = MONTH(e.envio_fecha_programada) AND dt.anio = YEAR(e.envio_fecha_programada)
		JOIN GESTORES_DE_DATOS.Venta v ON v.venta_codigo = e.venta_codigo
		JOIN GESTORES_DE_DATOS.Venta_Detalle vd ON vd.venta_codigo = v.venta_codigo
		JOIN GESTORES_DE_DATOS.Publicacion pub ON pub.publicacion_codigo = vd.publicacion_codigo
		JOIN GESTORES_DE_DATOS.Almacen a ON a.almacen_codigo = pub.almacen_codigo
		JOIN GESTORES_DE_DATOS.Provincia pa ON pa.provincia_id = a.provincia_id
		JOIN GESTORES_DE_DATOS.Localidad la ON la.localidad_id = a.localidad_id AND la.provincia_id = a.provincia_id
		JOIN GESTORES_DE_DATOS.BI_dimension_ubicacion dua ON dua.localidad = la.localidad AND dua.provincia = pa.provincia
		JOIN GESTORES_DE_DATOS.Cliente c ON v.cliente_id = c.cliente_id
		JOIN GESTORES_DE_DATOS.Usuario u ON u.cliente_id = c.cliente_id
		JOIN GESTORES_DE_DATOS.Domicilio dom ON dom.usuario_id = u.usuario_id
		JOIN GESTORES_DE_DATOS.Provincia prov ON prov.provincia_id = dom.provincia_id
		JOIN GESTORES_DE_DATOS.Localidad l ON l.provincia_id = dom.provincia_id AND l.localidad_id = dom.localidad_id
		JOIN GESTORES_DE_DATOS.BI_dimension_ubicacion duc ON duc.localidad = l.localidad AND duc.provincia = prov.provincia
		JOIN GESTORES_DE_DATOS.Tipo_Envio te ON te.tipo_envio_id = e.tipo_envio_id
		JOIN GESTORES_DE_DATOS.BI_dimension_tipo_envio dte ON dte.tipo_envio = te.tipo_envio
		GROUP BY dt.id,dua.id,duc.id,dte.id;
GO

--VIEW 1
CREATE VIEW GESTORES_DE_DATOS.Promedio_de_tiempo_de_publicaciones
(subRubro,cuatrimestre,anio,promedioTiempoPublicacion)
AS
SELECT drsp.subRubro, dt.cuatrimestre,dt.anio, AVG(hp.tiempo_publicacion)
	FROM GESTORES_DE_DATOS.BI_hecho_publicacion hp
	JOIN GESTORES_DE_DATOS.BI_dimension_rubro_subRubro_publicacion drsp ON drsp.id = hp.id_rubro_subRubro_publicacion
	JOIN GESTORES_DE_DATOS.BI_dimension_tiempo dt ON dt.id = hp.id_tiempo
	GROUP BY drsp.subRubro, dt.cuatrimestre,dt.anio;
GO

--VIEW 2
CREATE VIEW GESTORES_DE_DATOS.Promedio_de_stock_inicial
(marca,anio,promedioStock)
AS
SELECT drsp.marca,dt.anio, AVG(hp.stock_inicial)
	FROM GESTORES_DE_DATOS.BI_hecho_publicacion hp
	JOIN GESTORES_DE_DATOS.BI_dimension_rubro_subRubro_publicacion drsp ON drsp.id = hp.id_rubro_subRubro_publicacion
	JOIN GESTORES_DE_DATOS.BI_dimension_tiempo dt ON dt.id = hp.id_tiempo
	GROUP BY drsp.marca,dt.anio;
GO

--VIEW 3
CREATE VIEW GESTORES_DE_DATOS.Venta_promedio_mensual
(promedio,localida,provincia,mes,anio)
AS
SELECT AVG(hv.monto_total_venta),du.localidad,du.provincia,dt.mes,dt.anio
	FROM GESTORES_DE_DATOS.BI_hecho_venta hv
	JOIN GESTORES_DE_DATOS.BI_dimension_ubicacion du ON du.id = hv.id_ubicacion_almacen
	JOIN GESTORES_DE_DATOS.BI_dimension_tiempo dt ON dt.id = hv.id_tiempo
	GROUP BY du.localidad,du.provincia,dt.mes,dt.anio;
GO

--VIEW 4 
CREATE VIEW GESTORES_DE_DATOS.Rendimiento_de_rubros
(rubro,cuatrimestre,anio,localidad,rangoEtario)
AS
WITH RubroTop AS (
    SELECT dru.rubro,du.localidad,dt.cuatrimestre,dt.anio,hv2.id_rango_etario,
        SUM(hv2.monto_total_venta) AS total_venta,
        ROW_NUMBER() OVER (
            PARTITION BY du.localidad,hv2.id_rango_etario,dt.cuatrimestre,dt.anio
            ORDER BY SUM(hv2.monto_total_venta) DESC
        ) AS rn
    FROM GESTORES_DE_DATOS.BI_hecho_venta hv2
	JOIN GESTORES_DE_DATOS.BI_dimension_ubicacion du ON du.id = hv2.id_ubicacion_cliente
	JOIN GESTORES_DE_DATOS.BI_dimension_tiempo dt ON dt.id = hv2.id_tiempo
    JOIN GESTORES_DE_DATOS.BI_dimension_rubro_subRubro_publicacion dru ON dru.id = hv2.id_rubro_subRubro_publicacion
    GROUP BY dru.rubro,du.localidad,dt.cuatrimestre,dt.anio,hv2.id_rango_etario
)
SELECT drsp.rubro,dt.cuatrimestre,dt.anio,du.localidad,dre.rango
	FROM GESTORES_DE_DATOS.BI_hecho_venta hv
	JOIN GESTORES_DE_DATOS.BI_dimension_ubicacion du ON du.id = hv.id_ubicacion_cliente
	JOIN GESTORES_DE_DATOS.BI_dimension_tiempo dt ON dt.id = hv.id_tiempo
	JOIN GESTORES_DE_DATOS.BI_dimension_rango_etario dre ON dre.id = hv.id_rango_etario
	JOIN GESTORES_DE_DATOS.BI_dimension_rubro_subRubro_publicacion drsp ON drsp.id = hv.id_rubro_subRubro_publicacion
	WHERE drsp.rubro IN (
      SELECT rubro
      FROM RubroTop rt
      WHERE rn <= 5 AND du.localidad = rt.localidad AND rt.cuatrimestre = dt.cuatrimestre AND
		rt.anio = dt.anio AND rt.id_rango_etario = dre.id
  )
GROUP BY drsp.rubro,dt.cuatrimestre,dt.anio,du.localidad,dre.rango;
GO

--VIEW 6
CREATE VIEW GESTORES_DE_DATOS.Pago_en_cuotas
(localidad,tipoMedioPago,mes,anio)
AS
WITH LocalidadesTop3 AS (
    SELECT 
        du2.localidad,
        hp2.id_tiempo,
        hp2.id_tipo_medio_pago,
        SUM(hp2.monto_en_cuotas) AS total_venta,
        ROW_NUMBER() OVER (
            PARTITION BY hp2.id_tiempo, hp2.id_tipo_medio_pago
            ORDER BY SUM(hp2.monto_en_cuotas) DESC
        ) AS rn
    FROM GESTORES_DE_DATOS.BI_hecho_pago hp2
    JOIN GESTORES_DE_DATOS.BI_dimension_ubicacion du2 ON du2.id = hp2.id_ubicacion_cliente
    GROUP BY du2.localidad, hp2.id_tiempo, hp2.id_tipo_medio_pago
)
SELECT 
    du.localidad,
    dtmp.tipo_medio_pago,
    dt.mes,
    dt.anio
FROM GESTORES_DE_DATOS.BI_hecho_pago hp
JOIN GESTORES_DE_DATOS.BI_dimension_tipo_medio_pago dtmp ON dtmp.id = hp.id_tipo_medio_pago
JOIN GESTORES_DE_DATOS.BI_dimension_tiempo dt ON dt.id = hp.id_tiempo
JOIN GESTORES_DE_DATOS.BI_dimension_ubicacion du ON du.id = hp.id_ubicacion_cliente
WHERE du.localidad IN (
      SELECT localidad
      FROM LocalidadesTop3
      WHERE rn <= 3
        AND id_tipo_medio_pago = hp.id_tipo_medio_pago
        AND id_tiempo = hp.id_tiempo
  )
GROUP BY du.localidad, dtmp.tipo_medio_pago, dt.mes, dt.anio;
GO

--VIEW 7
CREATE VIEW GESTORES_DE_DATOS.Porcentaje_de_cumplimiento_de_envios
(porcentaje,provinciaAlmacen,mes,anio)
AS
SELECT (CAST(sum(he.cant_envios_cumplidos) AS decimal(18,4))/ SUM(he.cant_envios_totales))*100
	,du.provincia,dt.mes,dt.anio
	FROM GESTORES_DE_DATOS.BI_hecho_envio he
	JOIN GESTORES_DE_DATOS.BI_dimension_ubicacion du ON du.id = he.id_ubicacion_almacen
	JOIN GESTORES_DE_DATOS.BI_dimension_tiempo dt ON dt.id = he.id_tiempo
	GROUP BY du.provincia,dt.mes,dt.anio;
GO

--VIEW 8
CREATE VIEW GESTORES_DE_DATOS.Localidades_que_pagan_mayor_costo_envio
(localidad)
AS
SELECT TOP 5 du.localidad
	FROM GESTORES_DE_DATOS.BI_hecho_envio he
	JOIN GESTORES_DE_DATOS.BI_dimension_ubicacion du ON du.id = he.id_ubicacion_cliente
	GROUP BY du.localidad
	ORDER BY sum(he.monto_envio) DESC
GO

--VIEW 9
CREATE VIEW GESTORES_DE_DATOS.Porcentaje_facturacion_por_concepto
(porcentaje,concepto,mes,anio)
AS
SELECT (SUM(hf.monto)/aux.montoTotal)*100,dc.concepto,dt.mes,dt.anio
	FROM GESTORES_DE_DATOS.BI_hecho_facturacion hf
	JOIN GESTORES_DE_DATOS.BI_dimension_concepto dc ON dc.id = hf.id_concepto
	JOIN GESTORES_DE_DATOS.BI_dimension_tiempo dt ON dt.id = hf.id_tiempo
	JOIN (SELECT SUM(hf.monto) montoTotal, dt.mes,dt.anio
				FROM GESTORES_DE_DATOS.BI_hecho_facturacion hf
				JOIN GESTORES_DE_DATOS.BI_dimension_tiempo dt ON dt.id = hf.id_tiempo
				GROUP BY dt.mes, dt.anio) aux ON aux.anio = dt.anio AND aux.mes = dt.mes
	GROUP BY dc.concepto,dt.mes,dt.anio,aux.montoTotal
GO

--VIEW 10
CREATE VIEW GESTORES_DE_DATOS.Facturacion_por_provincia
(monto,provincia,cuatrimestre,anio)
AS
SELECT SUM(hf.monto),du.provincia,dt.cuatrimestre,dt.anio
	FROM GESTORES_DE_DATOS.BI_hecho_facturacion hf
	JOIN GESTORES_DE_DATOS.BI_dimension_ubicacion du ON du.id = hf.id_ubicacion_vendedor
	JOIN GESTORES_DE_DATOS.BI_dimension_tiempo dt ON dt.id = hf.id_tiempo
	GROUP BY du.provincia,dt.cuatrimestre,dt.anio
GO