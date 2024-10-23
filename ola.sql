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

INSERT INTO GESTORES_DE_DATOS.Producto(producto_id, producto_codigo, producto_descripcion, producto_precio)
    SELECT DISTINCT
        row_number() over (order by PRODUCTO_CODIGO),
        PRODUCTO_CODIGO,
        PRODUCTO_DESCRIPCION,
        PRODUCTO_PRECIO
    FROM gd_esquema.Maestra
    WHERE
        PRODUCTO_CODIGO IS NOT NULL
    GROUP BY
        PRODUCTO_CODIGO,
        PRODUCTO_DESCRIPCION,
        PRODUCTO_PRECIO

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

/*Venta (depende de Cliente)*/

INSERT INTO GESTORES_DE_DATOS.Venta(venta_codigo,venta_fecha,venta_total,cliente_id)
	SELECT VENTA_CODIGO,VENTA_FECHA,VENTA_TOTAL,u.cliente_id
		FROM gd_esquema.Maestra
		JOIN GESTORES_DE_DATOS.Usuario u ON u.usuario_nombre = CLI_USUARIO_NOMBRE

/*Marca_Modelo_Producto (depende de Marca, Modelo, Producto)
Producto_SubRubro_Rubro (depende de Producto, Sub_rubro, Rubro)

Tercer nivel - Depende del segundo

Almacen (depende de Localidad, Provincia)
Domicilio (depende de Usuario, Localidad, Provincia)
Factura (depende de Usuario)
Pago (depende de Venta, Medio_pago, Tipo_medio_pago)

Cuarto nivel:

Publicacion (depende de Producto, Vendedor, Almacen)
Envio (depende de Venta, Domicilio, Tipo_Envio)

Quinto nivel:

Venta_Detalle (depende de Venta, Publicacion)
Item_factura (depende de Factura, Publicacion, Concepto)
*/

SELECT * FROM gd_esquema.Maestra