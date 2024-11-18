USE GD2C2024;
GO

CREATE TABLE GESTORES_DE_DATOS.dimension_tiempo(
	id DECIMAL(18,0) IDENTITY(1,1),
	mes DECIMAL(2,0),
	anio DECIMAL(4,0),
	cuatrimestre DECIMAL(1,0),
	PRIMARY KEY (id)
)

CREATE TABLE GESTORES_DE_DATOS.dimension_ubicacion(
	id DECIMAL(18,0) IDENTITY(1,1),
	localidad NVARCHAR(50),
	provincia NVARCHAR(50),
	PRIMARY KEY (id)
)

CREATE TABLE GESTORES_DE_DATOS.dimension_rango_etario(
	id DECIMAL(18,0) IDENTITY(1,1),
	rango NVARCHAR(50),
	PRIMARY KEY(id)
)

CREATE TABLE GESTORES_DE_DATOS.dimension_rubro_subRubro_publicacion(
	id DECIMAL(18,0) IDENTITY(1,1),
	rubro NVARCHAR(50),
	subRubro NVARCHAR(50),
	publicacion NVARCHAR(50),
	marca NVARCHAR(50),
	PRIMARY KEY(id)
)

CREATE TABLE GESTORES_DE_DATOS.dimension_concepto(
	id DECIMAL(18,0) IDENTITY(1,1),
	concepto NVARCHAR(50),
	PRIMARY KEY (id)
)

CREATE TABLE GESTORES_DE_DATOS.dimension_rango_horario(
	id DECIMAL(18,0) IDENTITY(1,1),
	rango NVARCHAR(50),
	PRIMARY KEY(id)
)

CREATE TABLE GESTORES_DE_DATOS.dimension_tipo_envio(
	id DECIMAL(18,0) IDENTITY(1,1),
	tipo_envio NVARCHAR(50),
	PRIMARY KEY(id)
)

CREATE TABLE GESTORES_DE_DATOS.dimension_tipo_medio_pago(
	id DECIMAL(18,0) IDENTITY(1,1),
	tipo_medio_pago NVARCHAR(50),
	PRIMARY KEY(id)
)

CREATE TABLE GESTORES_DE_DATOS.hecho_venta(
	id DECIMAL(18,0) IDENTITY(1,1),
	id_tiempo DECIMAL(18,0),
	id_rubro_subRubro_publicacion DECIMAL(18,0),
	id_ubicacion_almacen DECIMAL(18,0),
	id_rango_etario DECIMAL(18,0),
	id_rango_horario DECIMAL(18,0),
	id_ubicacion_cliente DECIMAL(18,0),
	id_tipo_medio_pago DECIMAL(18,0),
	id_tipo_envio DECIMAL(18,0),
	id_ubicacion_vendedor DECIMAL(18,0),
	monto_total_venta DECIMAL(12,2),
	cantidad_cuotas DECIMAL(6,0),
	monto_envio DECIMAL(12,2),
	precio_producto DECIMAL(12,2),
	cantidad_producto DECIMAL(6,0),
	cumplimiento_envio DECIMAL(1,0),
	PRIMARY KEY (id),
	FOREIGN KEY (id_tiempo) REFERENCES GESTORES_DE_DATOS.dimension_tiempo(id),
	FOREIGN KEY (id_rubro_subRubro_publicacion) REFERENCES GESTORES_DE_DATOS.dimension_rubro_subRubro_publicacion(id),
	FOREIGN KEY (id_ubicacion_almacen) REFERENCES GESTORES_DE_DATOS.dimension_ubicacion(id),
	FOREIGN KEY (id_rango_etario) REFERENCES GESTORES_DE_DATOS.dimension_rango_etario(id),
	FOREIGN KEY (id_rango_horario) REFERENCES GESTORES_DE_DATOS.dimension_rango_horario(id),
	FOREIGN KEY (id_ubicacion_cliente) REFERENCES GESTORES_DE_DATOS.dimension_ubicacion(id),
	FOREIGN KEY (id_tipo_medio_pago) REFERENCES GESTORES_DE_DATOS.dimension_tipo_medio_pago(id),
	FOREIGN KEY (id_tipo_envio) REFERENCES GESTORES_DE_DATOS.dimension_tipo_envio(id),
	FOREIGN KEY (id_ubicacion_vendedor) REFERENCES GESTORES_DE_DATOS.dimension_ubicacion(id)
)

CREATE TABLE GESTORES_DE_DATOS.hecho_facturacion(
	id DECIMAL(18,0) IDENTITY(1,1),
	id_tiempo DECIMAL(18,0),
	id_concepto DECIMAL(18,0),
	id_ubicacion_vendedor DECIMAL(18,0),
	monto DECIMAL(12,2),
	PRIMARY KEY (id),
	FOREIGN KEY (id_tiempo) REFERENCES GESTORES_DE_DATOS.dimension_tiempo(id),
	FOREIGN KEY (id_concepto) REFERENCES GESTORES_DE_DATOS.dimension_concepto(id),
	FOREIGN KEY (id_ubicacion_vendedor) REFERENCES GESTORES_DE_DATOS.dimension_ubicacion(id),
)

CREATE TABLE GESTORES_DE_DATOS.hecho_publicacion(
	id DECIMAL(18,0) IDENTITY(1,1),
	id_rubro_subRubro_publicacion DECIMAL(18,0),
	id_tiempo DECIMAL(18,0),
	tiempo_publicacion DECIMAL(6,0),
	stock_inicial DECIMAL(6,0),
	PRIMARY KEY (id),
	FOREIGN KEY (id_rubro_subRubro_publicacion) REFERENCES GESTORES_DE_DATOS.dimension_rubro_subRubro_publicacion(id),
	FOREIGN KEY (id_tiempo) REFERENCES GESTORES_DE_DATOS.dimension_tiempo(id)
)

INSERT INTO GESTORES_DE_DATOS.dimension_tiempo(mes,cuatrimestre,anio)
	SELECT distinct MONTH(venta_fecha) 'mes',(CASE 
									WHEN MONTH(venta_fecha) BETWEEN 1 AND 4 THEN 1
									WHEN MONTH(venta_fecha) BETWEEN 5 AND 8 THEN 2   
									WHEN MONTH(venta_fecha) BETWEEN 9 AND 12 THEN 3  
								END) 'cuatrimestre',YEAR(venta_fecha) 'anio' FROM GESTORES_DE_DATOS.Venta
			ORDER BY 3,2,1

INSERT INTO GESTORES_DE_DATOS.dimension_ubicacion(localidad,provincia)
	SELECT l.localidad,p.provincia
		FROM GESTORES_DE_DATOS.Localidad l 
		JOIN GESTORES_DE_DATOS.Provincia p ON p.provincia_id = l.provincia_id

INSERT INTO GESTORES_DE_DATOS.dimension_rango_etario(rango)
	SELECT DISTINCT (CASE
						WHEN DATEDIFF(YEAR,c.cliente_fecha_nac,GETDATE()) < 25 THEN '<25'
						WHEN DATEDIFF(YEAR,c.cliente_fecha_nac,GETDATE()) BETWEEN 25 AND 34 THEN '25-35'
						WHEN DATEDIFF(YEAR,c.cliente_fecha_nac,GETDATE()) BETWEEN 35 AND 49 THEN '35-50'
						WHEN DATEDIFF(YEAR,c.cliente_fecha_nac,GETDATE()) > 50 THEN '>50'
					END) FROM GESTORES_DE_DATOS.Cliente c


	
INSERT INTO GESTORES_DE_DATOS.dimension_rubro_subRubro_publicacion(rubro,subRubro,publicacion,marca)
	SELECT DISTINCT r.rubro_descripcion,sr.sub_rubro,p.publicacion_codigo,m.marca
		FROM GESTORES_DE_DATOS.Publicacion p
			JOIN GESTORES_DE_DATOS.Producto pr ON pr.producto_id = p.producto_id
			JOIN GESTORES_DE_DATOS.Sub_rubro sr ON sr.sub_rubro_id = pr.sub_rubro_id
			JOIN GESTORES_DE_DATOS.Rubro r ON r.rubro_id = sr.rubro_id
			JOIN GESTORES_DE_DATOS.Marca_Modelo_Producto mmp ON mmp.producto_id = p.producto_id
			JOIN GESTORES_DE_DATOS.Marca m ON m.marca_id = mmp.marca_id

INSERT INTO GESTORES_DE_DATOS.dimension_concepto(concepto)
	SELECT c.concepto FROM GESTORES_DE_DATOS.Concepto c

INSERT INTO GESTORES_DE_DATOS.dimension_rango_horario(rango)
	SELECT DISTINCT (CASE 
				WHEN hora BETWEEN 0 and 5 THEN '00:00-06:00'
				WHEN hora BETWEEN 6 and 11 THEN '06:00-12:00'
				WHEN hora BETWEEN 12 and 17 THEN '12:00-18:00'
				WHEN hora BETWEEN 18 and 23 THEN '18:00-24:00'
			END) FROM (SELECT e.envio_hora_inicio hora  FROM GESTORES_DE_DATOS.Envio e
					UNION
					SELECT e.envio_hora_fin hora FROM GESTORES_DE_DATOS.Envio e) aux

INSERT INTO GESTORES_DE_DATOS.dimension_tipo_envio(tipo_envio)
	SELECT tipo_envio FROM GESTORES_DE_DATOS.Tipo_Envio

INSERT INTO GESTORES_DE_DATOS.dimension_tipo_medio_pago(tipo_medio_pago)
	SELECT tipo_medio_pago FROM GESTORES_DE_DATOS.Tipo_medio_pago

INSERT INTO GESTORES_DE_DATOS.hecho_facturacion
	(id_concepto,id_tiempo,id_ubicacion_vendedor,monto)
	SELECT con.concepto_id,t.id 'tiempo ID',ub.id 'ubicacion vendedor', sum(i.item_cantidad*i.item_precio) FROM GESTORES_DE_DATOS.Factura f
		JOIN GESTORES_DE_DATOS.Item_factura i ON i.factura_numero = f.factura_numero
		JOIN GESTORES_DE_DATOS.Concepto con ON i.concepto_id = con.concepto_id
		JOIN GESTORES_DE_DATOS.dimension_concepto c ON c.concepto = con.concepto
		JOIN GESTORES_DE_DATOS.dimension_tiempo t ON t.mes = MONTH(f.factura_fecha) AND t.anio = YEAR(f.factura_fecha)
		JOIN GESTORES_DE_DATOS.Usuario u ON u.usuario_id = f.usuario_id
		JOIN GESTORES_DE_DATOS.Domicilio d ON d.usuario_id = u.usuario_id
		JOIN GESTORES_DE_DATOS.Localidad l ON l.localidad_id = d.localidad_id
		JOIN GESTORES_DE_DATOS.Provincia p ON p.provincia_id = d.provincia_id AND p.provincia_id = l.provincia_id
		JOIN GESTORES_DE_DATOS.dimension_ubicacion ub ON ub.localidad = l.localidad AND ub.provincia = p.provincia
	GROUP BY con.concepto_id,t.id,ub.id

INSERT INTO GESTORES_DE_DATOS.hecho_publicacion(id_rubro_subRubro_publicacion,id_tiempo,tiempo_publicacion,stock_inicial)
	SELECT rsp.id,t.id,DATEDIFF(DAY,pub.publicacion_fecha_inicio,pub.publicacion_fecha_fin), pub.publicacion_stock
		FROM GESTORES_DE_DATOS.Publicacion pub
		JOIN GESTORES_DE_DATOS.Producto p ON p.producto_id = pub.producto_id
		JOIN GESTORES_DE_DATOS.Sub_rubro sr ON sr.sub_rubro_id = p.sub_rubro_id
		JOIN GESTORES_DE_DATOS.Rubro r ON r.rubro_id = sr.rubro_id
		JOIN GESTORES_DE_DATOS.dimension_rubro_subRubro_publicacion rsp 
			ON rsp.publicacion = pub.publicacion_codigo AND rsp.subRubro = sr.sub_rubro AND rsp.rubro = r.rubro_descripcion
		JOIN GESTORES_DE_DATOS.dimension_tiempo t ON t.mes = MONTH(pub.publicacion_fecha_inicio) AND t.anio = YEAR(pub.publicacion_fecha_inicio)

--EL ID DEL RANGO HORARIO SE ENCUENTRA HARDCODEADO YA QUE NO HAY HORARIO, A MENOS Q ACEPTEN EL DEL ENVIO
--101.324
INSERT INTO GESTORES_DE_DATOS.hecho_venta(id_tiempo,id_rubro_subRubro_publicacion,id_ubicacion_almacen,
	id_rango_etario,id_rango_horario,id_ubicacion_cliente,id_tipo_medio_pago,id_tipo_envio,id_ubicacion_vendedor,
	monto_total_venta,cantidad_cuotas,monto_envio,precio_producto,cantidad_producto,cumplimiento_envio)
	SELECT dt.id 'tiempo',rsp.id 'rubro sub pub',ub.id 'ubicacion alacen',re.id 'rango etario',
		1 'rango horario',ubCli.id 'ubicacion cliente',dtmp.id 'tipo medio pago',dte.id 'tipo envio',
		ubVend.id 'ubicacion venderor', v.venta_total,pago.pago_cant_cuotas,e.envio_costo,vd.venta_det_precio,
		vd.venta_det_cant,
		(CASE
			WHEN DATEPART(HOUR,e.envio_fecha_entrega) BETWEEN e.envio_hora_inicio AND e.envio_hora_fin THEN 1
			WHEN DATEPART(HOUR,e.envio_fecha_entrega) NOT BETWEEN e.envio_hora_inicio AND e.envio_hora_fin THEN 0
		END) 'cumplimiento envio'
		FROM GESTORES_DE_DATOS.Venta v
		JOIN GESTORES_DE_DATOS.dimension_tiempo dt ON dt.mes = MONTH(v.venta_fecha) AND dt.anio = YEAR(v.venta_fecha)
		JOIN GESTORES_DE_DATOS.Venta_Detalle vd ON vd.venta_codigo = v.venta_codigo
		JOIN GESTORES_DE_DATOS.Publicacion pub ON pub.publicacion_codigo = vd.publicacion_codigo
		JOIN GESTORES_DE_DATOS.Producto p ON p.producto_id = pub.producto_id
		JOIN GESTORES_DE_DATOS.Sub_rubro sr ON sr.sub_rubro_id = p.sub_rubro_id
		JOIN GESTORES_DE_DATOS.Rubro r ON r.rubro_id = sr.rubro_id
		JOIN GESTORES_DE_DATOS.dimension_rubro_subRubro_publicacion rsp 
			ON rsp.publicacion = pub.publicacion_codigo AND rsp.subRubro = sr.sub_rubro AND rsp.rubro = r.rubro_descripcion
		JOIN GESTORES_DE_DATOS.Almacen a ON a.almacen_codigo = pub.almacen_codigo
		JOIN GESTORES_DE_DATOS.Localidad l ON l.localidad_id = a.localidad_id
		JOIN GESTORES_DE_DATOS.Provincia prov ON prov.provincia_id = a.provincia_id AND prov.provincia_id = l.provincia_id
		JOIN GESTORES_DE_DATOS.dimension_ubicacion ub ON ub.localidad = l.localidad AND ub.provincia = prov.provincia
		JOIN GESTORES_DE_DATOS.Cliente c ON c.cliente_id = v.cliente_id
		JOIN GESTORES_DE_DATOS.dimension_rango_etario re 
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
		JOIN GESTORES_DE_DATOS.dimension_ubicacion ubCli 
			ON ubCli.localidad = lCli.localidad AND ubCli.provincia = provCli.provincia
		JOIN GESTORES_DE_DATOS.Pago pago ON pago.venta_codigo = v.venta_codigo
		JOIN GESTORES_DE_DATOS.Tipo_medio_pago tmp ON tmp.tipo_medio_pago_id = pago.tipo_medio_pago_id
		JOIN GESTORES_DE_DATOS.dimension_tipo_medio_pago dtmp ON dtmp.tipo_medio_pago = tmp.tipo_medio_pago
		JOIN GESTORES_DE_DATOS.Envio e ON e.venta_codigo = v.venta_codigo
		JOIN GESTORES_DE_DATOS.Tipo_Envio te ON te.tipo_envio_id = e.tipo_envio_id
		JOIN GESTORES_DE_DATOS.dimension_tipo_envio dte ON dte.tipo_envio = te.tipo_envio
		JOIN GESTORES_DE_DATOS.Usuario uVende ON uVende.vendedor_id = pub.vendedor_id
		JOIN GESTORES_DE_DATOS.Domicilio dVend ON dVend.usuario_id = uVende.usuario_id
		JOIN GESTORES_DE_DATOS.Localidad lVend ON lVend.localidad_id = dVend.localidad_id
		JOIN GESTORES_DE_DATOS.Provincia provVend
			ON provVend.provincia_id = dVend.provincia_id AND provVend.provincia_id = lVend.provincia_id
		JOIN GESTORES_DE_DATOS.dimension_ubicacion ubVend
			ON ubVend.localidad = lVend.localidad AND ubVend.provincia = provVend.provincia;

--VIEW 1
CREATE VIEW GESTORES_DE_DATOS.Promedio_de_tiempo_de_publicaciones
(subRubro,cuatrimestre,anio,promedioTiempoPublicacion)
AS
SELECT drsp.subRubro, dt.cuatrimestre,dt.anio, AVG(hp.tiempo_publicacion)
	FROM GESTORES_DE_DATOS.hecho_publicacion hp
	JOIN GESTORES_DE_DATOS.dimension_rubro_subRubro_publicacion drsp ON drsp.id = hp.id_rubro_subRubro_publicacion
	JOIN GESTORES_DE_DATOS.dimension_tiempo dt ON dt.id = hp.id_tiempo
	GROUP BY drsp.subRubro, dt.cuatrimestre,dt.anio;

--VIEW 2
CREATE VIEW GESTORES_DE_DATOS.Promedio_de_stock_inicial
(marca,anio,promedioStock)
AS
SELECT drsp.marca,dt.anio, AVG(hp.stock_inicial)
	FROM GESTORES_DE_DATOS.hecho_publicacion hp
	JOIN GESTORES_DE_DATOS.dimension_rubro_subRubro_publicacion drsp ON drsp.id = hp.id_rubro_subRubro_publicacion
	JOIN GESTORES_DE_DATOS.dimension_tiempo dt ON dt.id = hp.id_tiempo
	GROUP BY drsp.marca,dt.anio;


--VIEW 3
--VIEW 4
--VIEW 5
--VIEW 6
--VIEW 7
--VIEW 8
--VIEW 9
--VIEW 10