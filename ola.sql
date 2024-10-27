USE GD2C2024;
GO

-- Tablas independientes - Sin FK

INSERT INTO GESTORES_DE_DATOS.Provincia (provincia_id, provincia)
	SELECT DISTINCT
		row_number() over (order by CLI_USUARIO_DOMICILIO_PROVINCIA),
		CLI_USUARIO_DOMICILIO_PROVINCIA
	FROM gd_esquema.Maestra
	WHERE
		CLI_USUARIO_DOMICILIO_PROVINCIA IS NOT NULL
	GROUP BY
		CLI_USUARIO_DOMICILIO_PROVINCIA

-- Marca

INSERT INTO GESTORES_DE_DATOS.Marca(marca_id, marca)
	SELECT DISTINCT
		row_number() over (order by PRODUCTO_MARCA),
		PRODUCTO_MARCA
	FROM gd_esquema.Maestra
	WHERE
		PRODUCTO_MARCA IS NOT NULL
	GROUP BY
		PRODUCTO_MARCA

-- Modelo

INSERT INTO GESTORES_DE_DATOS.Modelo(modelo_id, modelo_codigo, modelo_descripcion)
	SELECT DISTINCT
		row_number() over (order by PRODUCTO_MOD_CODIGO),
		PRODUCTO_MOD_CODIGO,
		PRODUCTO_MOD_DESCRIPCION
	FROM gd_esquema.Maestra
	WHERE
		PRODUCTO_MOD_CODIGO IS NOT NULL
	GROUP BY
		PRODUCTO_MOD_CODIGO,
		PRODUCTO_MOD_DESCRIPCION

-- Concepto

INSERT INTO GESTORES_DE_DATOS.Concepto(concepto_id, concepto)
    SELECT DISTINCT
        row_number() over (order by FACTURA_DET_TIPO),
        FACTURA_DET_TIPO
    FROM gd_esquema.Maestra
    WHERE
        FACTURA_DET_TIPO IS NOT NULL
    GROUP BY
        FACTURA_DET_TIPO

-- Tipo_Envio

INSERT INTO GESTORES_DE_DATOS.Tipo_Envio(tipo_envio_id, tipo_envio)
    SELECT DISTINCT
        row_number() over (order by ENVIO_TIPO),
        ENVIO_TIPO
    FROM gd_esquema.Maestra
    WHERE
        ENVIO_TIPO IS NOT NULL
    GROUP BY
        ENVIO_TIPO

-- Tipo_medio_pago
INSERT INTO GESTORES_DE_DATOS.Tipo_medio_pago(tipo_medio_pago_id, tipo_medio_pago)
	SELECT DISTINCT row_number() over (order by PAGO_TIPO_MEDIO_PAGO),
        PAGO_TIPO_MEDIO_PAGO
    FROM gd_esquema.Maestra
    WHERE
        PAGO_TIPO_MEDIO_PAGO IS NOT NULL
    GROUP BY
        PAGO_TIPO_MEDIO_PAGO

-- Rubro

INSERT INTO GESTORES_DE_DATOS.Rubro(rubro_id, rubro_descripcion)
    SELECT DISTINCT
        row_number() over (order by PRODUCTO_RUBRO_DESCRIPCION),
        PRODUCTO_RUBRO_DESCRIPCION
    FROM gd_esquema.Maestra
    WHERE
        PRODUCTO_RUBRO_DESCRIPCION IS NOT NULL
    GROUP BY
        PRODUCTO_RUBRO_DESCRIPCION

-- Sub_rubro

INSERT INTO GESTORES_DE_DATOS.Sub_rubro(sub_rubro_id, sub_rubro)
    SELECT DISTINCT
        row_number() over (order by PRODUCTO_SUB_RUBRO),
        PRODUCTO_SUB_RUBRO
    FROM gd_esquema.Maestra
    WHERE
        PRODUCTO_SUB_RUBRO IS NOT NULL
    GROUP BY
        PRODUCTO_SUB_RUBRO

-- Cliente

INSERT INTO GESTORES_DE_DATOS.Cliente(cliente_id, cliente_nombre, cliente_apellido, cliente_fecha_nac, cliente_dni)
    SELECT DISTINCT
       row_number() over (order by CLIENTE_DNI),
        CLIENTE_NOMBRE,
        CLIENTE_APELLIDO,
        CLIENTE_FECHA_NAC,
        CLIENTE_DNI
    FROM gd_esquema.Maestra
    WHERE
        CLIENTE_DNI IS NOT NULL
    GROUP BY
        CLIENTE_NOMBRE,
        CLIENTE_APELLIDO,
        CLIENTE_FECHA_NAC,
        CLIENTE_DNI

-- Vendedor

INSERT INTO GESTORES_DE_DATOS.Vendedor(vendedor_id, vendedor_razon_social, vendedor_CUIT, vendedor_MAIL)
    SELECT DISTINCT
        row_number() over (order by VENDEDOR_CUIT),
        VENDEDOR_RAZON_SOCIAL,
        VENDEDOR_CUIT,
        VENDEDOR_MAIL
    FROM gd_esquema.Maestra
    WHERE
        VENDEDOR_CUIT IS NOT NULL
    GROUP BY
        VENDEDOR_RAZON_SOCIAL,
        VENDEDOR_CUIT,
        VENDEDOR_MAIL

-- Producto

INSERT INTO GESTORES_DE_DATOS.Producto(producto_codigo, producto_descripcion,producto_precio)
    SELECT DISTINCT
        PRODUCTO_CODIGO,
        PRODUCTO_DESCRIPCION,
		PRODUCTO_PRECIO
    FROM gd_esquema.Maestra
    WHERE
        PRODUCTO_CODIGO IS NOT NULL

/*
Segundo nivel - Depende del primero

Localidad (depende de Provincia)*/

INSERT INTO GESTORES_DE_DATOS.Localidad(localidad_id,localidad,provincia_id)
	SELECT row_number() over (order by aux.localidad),aux.localidad,aux.provincia_id
	FROM (
		SELECT DISTINCT CLI_USUARIO_DOMICILIO_LOCALIDAD localidad, p.provincia_id
		FROM gd_esquema.Maestra
			JOIN GESTORES_DE_DATOS.Provincia p ON p.provincia = CLI_USUARIO_DOMICILIO_PROVINCIA
		WHERE CLI_USUARIO_DOMICILIO_LOCALIDAD IS NOT NULL
	UNION
		SELECT DISTINCT VEN_USUARIO_DOMICILIO_LOCALIDAD localidad, p.provincia_id
		FROM gd_esquema.Maestra 
			JOIN GESTORES_DE_DATOS.Provincia p ON p.provincia = VEN_USUARIO_DOMICILIO_PROVINCIA
		WHERE VEN_USUARIO_DOMICILIO_LOCALIDAD IS NOT NULL
	UNION
		SELECT DISTINCT ALMACEN_Localidad localidad, p.provincia_id
		FROM gd_esquema.Maestra
			JOIN GESTORES_DE_DATOS.Provincia p ON p.provincia = ALMACEN_PROVINCIA
		WHERE ALMACEN_Localidad IS NOT NULL) as aux

/*
Medio_pago (depende de Tipo_medio_pago)*/
INSERT INTO GESTORES_DE_DATOS.Medio_pago(medio_pago_id,medio_pago,tipo_medio_pago_id)
	SELECT row_number() over (order by aux.tipo_medio_pago_id), aux.PAGO_MEDIO_PAGO, aux.tipo_medio_pago_id FROM
		(SELECT DISTINCT PAGO_MEDIO_PAGO, t.tipo_medio_pago_id
		FROM gd_esquema.Maestra
			JOIN GESTORES_DE_DATOS.Tipo_medio_pago t ON t.tipo_medio_pago = PAGO_TIPO_MEDIO_PAGO
		WHERE PAGO_MEDIO_PAGO IS NOT NULL) as aux

/*Usuario (depende de Cliente, Vendedor)*/ 

INSERT INTO GESTORES_DE_DATOS.Usuario(usuario_id,usuario_nombre,usuario_pass,usuario_fecha_creacion,cliente_id,vendedor_id)
	SELECT row_number() over (order by aux.usuario_nombre), aux.usuario_nombre,aux.usuario_pass,
		aux.usuario_fecha_creacion,aux.cliente_id,aux.vendedor_id  FROM
			(SELECT DISTINCT CLI_USUARIO_NOMBRE usuario_nombre
					,CLI_USUARIO_PASS usuario_pass
					,CLI_USUARIO_FECHA_CREACION usuario_fecha_creacion
					,c.cliente_id
					,NULL vendedor_id
				FROM [GD2C2024].[gd_esquema].[Maestra] m
					JOIN GESTORES_DE_DATOS.Cliente c ON c.cliente_nombre = m.CLIENTE_NOMBRE AND c.cliente_apellido = m.CLIENTE_APELLIDO
						AND c.cliente_dni = m.CLIENTE_DNI
				WHERE CLI_USUARIO_NOMBRE IS NOT NULL
			UNION
			SELECT DISTINCT [VEN_USUARIO_NOMBRE] usuario_nombre
					,[VEN_USUARIO_PASS] usuario_pass
					,VEN_USUARIO_FECHA_CREACION usuario_fecha_creacion
					,NULL cliente_id
					,v.vendedor_id
						FROM [GD2C2024].[gd_esquema].[Maestra] m
							JOIN GESTORES_DE_DATOS.Vendedor v ON v.vendedor_CUIT = m.VENDEDOR_CUIT AND v.vendedor_MAIL = m.VENDEDOR_MAIL
						WHERE VEN_USUARIO_NOMBRE IS NOT NULl) as aux

/*Venta (depende de Cliente)*/

INSERT INTO GESTORES_DE_DATOS.Venta(venta_codigo,venta_fecha,venta_total,cliente_id)
	SELECT VENTA_CODIGO,VENTA_FECHA,VENTA_TOTAL,c.cliente_id
		FROM gd_esquema.Maestra m
		JOIN GESTORES_DE_DATOS.Cliente c ON c.cliente_nombre = m.cliente_nombre 
			AND c.cliente_apellido = m.CLIENTE_APELLIDO AND c.cliente_dni = m.CLIENTE_DNI 

/*Marca_Modelo_Producto (depende de Marca, Modelo, Producto) NO SE SI EL PRECIO ESTA DEL TODO BIEN, REVISAR ESTO, TIRA ERRPR DE PK DUPLICADA*/

INSERT INTO GESTORES_DE_DATOS.Marca_Modelo_Producto(marca_id,modelo_id,producto_id)
		SELECT DISTINCT ma.marca_id,mo.modelo_id,p.producto_id
			FROM gd_esquema.Maestra m
			JOIN GESTORES_DE_DATOS.Modelo mo ON mo.modelo_codigo = m.PRODUCTO_MOD_CODIGO AND mo.modelo_descripcion = m.PRODUCTO_MOD_DESCRIPCION
			JOIN GESTORES_DE_DATOS.Marca ma ON ma.marca = m.PRODUCTO_MARCA
			JOIN GESTORES_DE_DATOS.Producto p ON p.producto_codigo = m.PRODUCTO_CODIGO AND p.producto_descripcion = m.PRODUCTO_DESCRIPCION
				AND p.producto_precio = m.PRODUCTO_PRECIO

/*Producto_SubRubro_Rubro (depende de Producto, Sub_rubro, Rubro)*/ --25.924.001

INSERT INTO GESTORES_DE_DATOS.Producto_SubRubro_Rubro(producto_id,sub_rubro_id,rubro_id)
	SELECT DISTINCT p.producto_id,su.sub_rubro_id,ru.rubro_id
		FROM gd_esquema.Maestra m
		JOIN GESTORES_DE_DATOS.Rubro ru ON ru.rubro_descripcion = m.PRODUCTO_RUBRO_DESCRIPCION
		JOIN GESTORES_DE_DATOS.Sub_rubro su ON su.sub_rubro = m.PRODUCTO_SUB_RUBRO
		JOIN GESTORES_DE_DATOS.Producto p ON p.producto_codigo = m.PRODUCTO_CODIGO AND p.producto_descripcion = m.PRODUCTO_DESCRIPCION
			AND p.producto_precio = m.PRODUCTO_PRECIO
		WHERE m.PRODUCTO_CODIGO IS NOT NULL

/*Tercer nivel - Depende del segundo

Almacen (depende de Localidad, Provincia)*/

INSERT INTO GESTORES_DE_DATOS.Almacen(almacen_codigo,almacen_calle,almacen_nro_calle,almacen_costo_al_dia,localidad_id,provincia_id)
	SELECT DISTINCT ALMACEN_CODIGO,ALMACEN_CALLE,ALMACEN_NRO_CALLE,ALMACEN_COSTO_DIA_AL,l.localidad_id,p.provincia_id
		FROM gd_esquema.Maestra
		JOIN GESTORES_DE_DATOS.Provincia p ON p.provincia = ALMACEN_PROVINCIA
		JOIN GESTORES_DE_DATOS.Localidad l ON l.localidad = ALMACEN_Localidad AND p.provincia_id = l.provincia_id
		WHERE ALMACEN_CODIGO IS NOT NULL

/*Domicilio (depende de Usuario, Localidad, Provincia)*/

INSERT INTO GESTORES_DE_DATOS.Domicilio(domicilio_id,domicilio_calle,domicilio_cp,domicilio_depto,localidad_id,
	domicilio_nro_calle,domicilio_piso,provincia_id,usuario_id)
	SELECT row_number() over (order by aux.calle),aux.calle, aux.cp,aux.depto,aux.loc,aux.nro,aux.piso,aux.prov,aux.usuario_id FROM
		((SELECT DISTINCT CLI_USUARIO_DOMICILIO_CALLE calle,CLI_USUARIO_DOMICILIO_CP cp, CLI_USUARIO_DOMICILIO_DEPTO depto,l.localidad_id loc,
			CLI_USUARIO_DOMICILIO_NRO_CALLE nro,CLI_USUARIO_DOMICILIO_PISO piso,l.provincia_id prov, u.usuario_id
			FROM gd_esquema.Maestra m
			JOIN GESTORES_DE_DATOS.Provincia p ON p.provincia = CLI_USUARIO_DOMICILIO_PROVINCIA
			JOIN GESTORES_DE_DATOS.Localidad l ON l.localidad = CLI_USUARIO_DOMICILIO_LOCALIDAD AND l.provincia_id = p.provincia_id
			JOIN GESTORES_DE_DATOS.Cliente c ON c.cliente_nombre = m.CLIENTE_NOMBRE AND c.cliente_apellido = m.CLIENTE_APELLIDO AND c.cliente_dni = m.CLIENTE_DNI
			JOIN GESTORES_DE_DATOS.Usuario u ON u.cliente_id = c.cliente_id
			WHERE CLI_USUARIO_DOMICILIO_CALLE IS NOT NULL)
		UNION
		(SELECT DISTINCT VEN_USUARIO_DOMICILIO_CALLE calle,VEN_USUARIO_DOMICILIO_CP, VEN_USUARIO_DOMICILIO_DEPTO,l.localidad_id,
			VEN_USUARIO_DOMICILIO_NRO_CALLE,VEN_USUARIO_DOMICILIO_PISO,l.provincia_id, u.usuario_id
			FROM gd_esquema.Maestra m
			JOIN GESTORES_DE_DATOS.Provincia p ON p.provincia = VEN_USUARIO_DOMICILIO_PROVINCIA
			JOIN GESTORES_DE_DATOS.Localidad l ON l.localidad = VEN_USUARIO_DOMICILIO_LOCALIDAD AND l.provincia_id = p.provincia_id
			JOIN GESTORES_DE_DATOS.Vendedor v ON v.vendedor_CUIT = m.VENDEDOR_CUIT AND v.vendedor_MAIL = m.VENDEDOR_MAIL AND v.vendedor_razon_social = m.VENDEDOR_RAZON_SOCIAL
			JOIN GESTORES_DE_DATOS.Usuario u ON u.vendedor_id = v.vendedor_id
			WHERE VEN_USUARIO_DOMICILIO_CALLE IS NOT NULL)) as aux

/*Pago (depende de Venta, Medio_pago, Tipo_medio_pago)*/

INSERT INTO GESTORES_DE_DATOS.Pago(pago_id,pago_fecha,pago_importe,pago_nro_tarjeta,pago_fecha_venc_tarjets,
	pago_cant_cuotas,medio_pago_id,tipo_medio_pago_id,venta_codigo)
	SELECT row_number() over (order by PAGO_IMPORTE), PAGO_FECHA,PAGO_IMPORTE,PAGO_NRO_TARJETA,PAGO_FECHA_VENC_TARJETA,PAGO_CANT_CUOTAS,med.medio_pago_id,med.tipo_medio_pago_id,venta.venta_codigo
		FROM gd_esquema.Maestra m
		JOIN GESTORES_DE_DATOS.Medio_pago med ON med.medio_pago = PAGO_MEDIO_PAGO
		JOIN GESTORES_DE_DATOS.Venta venta ON venta.venta_codigo = m.VENTA_CODIGO


/*Cuarto nivel:

Publicacion (depende de Producto, Vendedor, Almacen) REVVISAR ESTo*/
INSERT INTO GESTORES_DE_DATOS.Publicacion(publicacion_codigo,publicacion_descripcion,publicacion_stock,publicacion_fecha_inicio,
	publicacion_fecha_fin,publicacion_precio,publicacion_costo,publicacion_porc_venta,producto_id,vendedor_id,almacen_codigo)
	SELECT DISTINCT PUBLICACION_CODIGO,PUBLICACION_DESCRIPCION,PUBLICACION_STOCK,PUBLICACION_FECHA,PUBLICACION_FECHA_V,
		PUBLICACION_PRECIO,PUBLICACION_COSTO,PUBLICACION_PORC_VENTA,p.producto_id,v.vendedor_id,a.almacen_codigo
		FROM gd_esquema.Maestra m
		JOIN GESTORES_DE_DATOS.Producto p ON p.producto_codigo = m.PRODUCTO_CODIGO AND p.producto_descripcion = m.PRODUCTO_DESCRIPCION AND p.producto_precio = m.PRODUCTO_PRECIO
		JOIN GESTORES_DE_DATOS.Vendedor v ON v.vendedor_CUIT = m.VENDEDOR_CUIT AND v.vendedor_MAIL = m.VENDEDOR_MAIL 
		JOIN GESTORES_DE_DATOS.Almacen a ON a.almacen_codigo = m.ALMACEN_CODIGO


/*Envio (depende de Venta, Domicilio, Tipo_Envio)*/

INSERT INTO GESTORES_DE_DATOS.Envio(envio_id,envio_fecha_programada,envio_hora_inicio,envio_hora_fin,envio_fecha_entrega,envio_costo, 
venta_codigo,domicilio_id,tipo_envio_id)
	SELECT row_number() over (order by ENVIO_FECHA_PROGAMADA),m.ENVIO_FECHA_PROGAMADA,m.ENVIO_HORA_INICIO,m.ENVIO_HORA_FIN_INICIO,m.ENVIO_FECHA_ENTREGA,m.ENVIO_COSTO,
		v.venta_codigo,d.domicilio_id,t.tipo_envio_id
		FROM gd_esquema.Maestra m
		JOIN GESTORES_DE_DATOS.Venta v ON v.venta_codigo = m.VENTA_CODIGO
		JOIN GESTORES_DE_DATOS.Domicilio d ON d.domicilio_calle = m.CLI_USUARIO_DOMICILIO_CALLE AND d.domicilio_cp = m.CLI_USUARIO_DOMICILIO_CP AND
			d.domicilio_depto = m.CLI_USUARIO_DOMICILIO_DEPTO AND d.domicilio_nro_calle = m.CLI_USUARIO_DOMICILIO_NRO_CALLE
		JOIN GESTORES_DE_DATOS.Tipo_Envio t ON t.tipo_envio = m.ENVIO_TIPO

/*Factura (depende de Usuario)*/
INSERT INTO GESTORES_DE_DATOS.Factura(factura_numero,factura_fecha,factura_total,usuario_id)
	SELECT DISTINCT FACTURA_NUMERO,FACTURA_FECHA,FACTURA_TOTAL,u.usuario_id
		FROM gd_esquema.Maestra m
		JOIN GESTORES_DE_DATOS.Publicacion p ON m.PUBLICACION_CODIGO = p.publicacion_codigo
		JOIN GESTORES_DE_DATOS.Vendedor v ON v.vendedor_id = p.vendedor_id
		JOIN GESTORES_DE_DATOS.Usuario u ON u.vendedor_id = v.vendedor_id
		WHERE FACTURA_NUMERO IS NOT NULL

/*Quinto nivel:

Venta_Detalle (depende de Venta, Publicacion) ESTA MAL LA NUMERACION DEL DETALLE La parte del item RESOLVER CON TRIGGER*/
INSERT INTO GESTORES_DE_DATOS.Venta_Detalle(venta_codigo,detalle_item,venta_det_cant,venta_det_precio,venta_det_sub_total,publicacion_codigo)
	SELECT DISTINCT m.VENTA_CODIGO,COUNT(m.VENTA_CODIGO),m.VENTA_DET_CANT,m.VENTA_DET_PRECIO,m.VENTA_DET_SUB_TOTAL,m.PUBLICACION_CODIGO
		FROM gd_esquema.Maestra m
		WHERE VENTA_CODIGO IS NOT NULL
		GROUP BY m.VENTA_CODIGO,m.VENTA_DET_CANT,m.VENTA_DET_PRECIO,m.VENTA_DET_SUB_TOTAL,m.PUBLICACION_CODIGO

/*Item_factura (depende de Factura, Publicacion, Concepto) ESTA MAL LA NUMERACION DEL DETALLE La parte del item RESOLVER CON TRIGGER*/

INSERT INTO GESTORES_DE_DATOS.Item_factura(factura_numero,publicacion_codigo,concepto_id,item_precio,item_cantidad,item_subtotal)
	SELECT m.FACTURA_NUMERO,m.PUBLICACION_CODIGO,c.concepto_id,m.FACTURA_DET_PRECIO,m.FACTURA_DET_CANTIDAD,m.FACTURA_DET_SUBTOTAL
		FROM gd_esquema.Maestra m
		JOIN GESTORES_DE_DATOS.Concepto c ON c.concepto = m.FACTURA_DET_TIPO

--SELECT * FROM gd_esquema.Maestra