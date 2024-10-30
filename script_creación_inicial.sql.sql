USE GD2C2024;
GO

CREATE SCHEMA GESTORES_DE_DATOS;
GO

/* Creacion de Tablas */

CREATE TABLE GESTORES_DE_DATOS.Provincia (
	provincia_id DECIMAL(18,0) IDENTITY(1,1),
	provincia NVARCHAR(50),
	PRIMARY KEY( provincia_id));
CREATE TABLE GESTORES_DE_DATOS.Localidad (
	localidad_id DECIMAL(18,0) IDENTITY(1,1),
	provincia_id DECIMAL(18,0),
	localidad NVARCHAR(50),
	PRIMARY KEY (localidad_id),
	FOREIGN KEY (provincia_id) REFERENCES GESTORES_DE_DATOS.Provincia(provincia_id));
CREATE TABLE GESTORES_DE_DATOS.Vendedor(
	vendedor_id DECIMAL(18,0) IDENTITY(1,1),
	vendedor_razon_social NVARCHAR(50),
	vendedor_CUIT NVARCHAR(50),
	vendedor_MAIL NVARCHAR(50),
	PRIMARY KEY (vendedor_id));
CREATE TABLE GESTORES_DE_DATOS.Cliente(
	cliente_id DECIMAL(18,0) IDENTITY(1,1),
	cliente_nombre NVARCHAR(50),
	cliente_apellido NVARCHAR(50),
	cliente_fecha_nac DATE,
	cliente_dni DECIMAL(18,0),
	cliente_MAIL NVARCHAR(50),
	PRIMARY KEY (cliente_id));
CREATE TABLE GESTORES_DE_DATOS.Usuario(
	usuario_id DECIMAL(18,0) IDENTITY(1,1),
	usuario_nombre NVARCHAR(50),
	usuario_pass NVARCHAR(50), 
	usuario_fecha_creacion DATE DEFAULT GETDATE(),
	vendedor_id DECIMAL(18,0),
	cliente_id DECIMAL(18,0),
	PRIMARY KEY (usuario_id),
	FOREIGN KEY (vendedor_id) REFERENCES GESTORES_DE_DATOS.Vendedor(vendedor_id),
	FOREIGN KEY (cliente_id) REFERENCES GESTORES_DE_DATOS.Cliente(cliente_id));
CREATE TABLE GESTORES_DE_DATOS.Domicilio(
	domicilio_id DECIMAL(18,0) IDENTITY(1,1),
	domicilio_calle NVARCHAR(50),
	domicilio_nro_calle DECIMAL(18,0),
	domicilio_piso DECIMAL(18,0),
	domicilio_depto NVARCHAR(50),
	domicilio_cp NVARCHAR(50),
	localidad_id DECIMAL(18,0),
	provincia_id DECIMAL(18,0),
	usuario_id DECIMAL(18,0),
	PRIMARY KEY (domicilio_id),
	FOREIGN KEY (localidad_id) REFERENCES GESTORES_DE_DATOS.Localidad(localidad_id),
	FOREIGN KEY (provincia_id) REFERENCES GESTORES_DE_DATOS.Provincia(provincia_id),
	FOREIGN KEY (usuario_id) REFERENCES GESTORES_DE_DATOS.Usuario(usuario_id));
CREATE TABLE GESTORES_DE_DATOS.Almacen(
	almacen_codigo DECIMAL(18,0),
	almacen_calle NVARCHAR(50),
	almacen_nro_calle DECIMAL(18,0),
	almacen_costo_al_dia DECIMAL(18,2),
	localidad_id DECIMAL(18,0),
	provincia_id DECIMAL(18,0),
	PRIMARY KEY (almacen_codigo),
	FOREIGN KEY (localidad_id) REFERENCES GESTORES_DE_DATOS.Localidad(localidad_id),
	FOREIGN KEY (provincia_id) REFERENCES GESTORES_DE_DATOS.Provincia(provincia_id));
CREATE TABLE GESTORES_DE_DATOS.Marca(
	marca_id DECIMAL(18,0) IDENTITY(1,1),
	marca NVARCHAR(50),
	PRIMARY KEY (marca_id));
CREATE TABLE GESTORES_DE_DATOS.Modelo(
	modelo_id DECIMAL(18,0) IDENTITY(1,1),
	modelo_codigo NVARCHAR(50),
	modelo_descripcion NVARCHAR(50),
	PRIMARY KEY (modelo_id));
CREATE TABLE GESTORES_DE_DATOS.Rubro(
	rubro_id DECIMAL(18,0) IDENTITY(1,1),
	rubro_descripcion NVARCHAR(50),
	PRIMARY KEY (rubro_id));
CREATE TABLE GESTORES_DE_DATOS.Sub_rubro(
	sub_rubro_id DECIMAL(18,0) IDENTITY(1,1),
	sub_rubro NVARCHAR(50),
	rubro_id DECIMAL(18,0),
	PRIMARY KEY (sub_rubro_id),
	FOREIGN KEY (rubro_id) REFERENCES GESTORES_DE_DATOS.Rubro(rubro_id));
CREATE TABLE GESTORES_DE_DATOS.Producto(
	producto_id DECIMAL(18,0) IDENTITY(1,1),
	producto_codigo NVARCHAR(50),
	producto_descripcion NVARCHAR(50),
	producto_precio DECIMAL(18,2),
	sub_rubro_id DECIMAL(18,0),
	PRIMARY KEY (producto_id),
	FOREIGN KEY (sub_rubro_id) REFERENCES GESTORES_DE_DATOS.Sub_rubro(sub_rubro_id));
CREATE TABLE GESTORES_DE_DATOS.Marca_Modelo_Producto(
	marca_id DECIMAL(18,0),
	modelo_id DECIMAL(18,0),
	producto_id DECIMAL(18,0),
	PRIMARY KEY (marca_id,modelo_id,producto_id),
	FOREIGN KEY (marca_id) REFERENCES GESTORES_DE_DATOS.Marca(marca_id),
	FOREIGN KEY (modelo_id) REFERENCES GESTORES_DE_DATOS.Modelo(modelo_id),
	FOREIGN KEY (producto_id) REFERENCES GESTORES_DE_DATOS.Producto(producto_id));
CREATE TABLE GESTORES_DE_DATOS.Publicacion(
	publicacion_codigo DECIMAL(18,0),
	publicacion_descripcion NVARCHAR(50),
	publicacion_stock DECIMAL(18,0),
	publicacion_fecha_inicio DATE,
	publicacion_fecha_fin DATE,
	publicacion_precio DECIMAL(18,2),
	publicacion_costo DECIMAL(18,2),
	publicacion_porc_venta DECIMAL(18,2),
	producto_id DECIMAL(18,0),
	vendedor_id DECIMAL(18,0),
	almacen_codigo DECIMAL(18,0),
	PRIMARY KEY (publicacion_codigo),
	FOREIGN KEY (producto_id) REFERENCES GESTORES_DE_DATOS.Producto(producto_id),
	FOREIGN KEY (vendedor_id) REFERENCES GESTORES_DE_DATOS.Vendedor(vendedor_id),
	FOREIGN KEY (almacen_codigo) REFERENCES GESTORES_DE_DATOS.Almacen(almacen_codigo));
CREATE TABLE GESTORES_DE_DATOS.Factura(
	factura_numero DECIMAL(18,0),
	factura_fecha DATE,
	factura_total decimal(18,2),
	usuario_id DECIMAL(18,0),
	PRIMARY KEY (factura_numero),
	FOREIGN KEY (usuario_id) REFERENCES GESTORES_DE_DATOS.Usuario(usuario_id));
CREATE TABLE GESTORES_DE_DATOS.Concepto(
	concepto_id DECIMAL(18,0) IDENTITY(1,1),
	concepto NVARCHAR(50),
	PRIMARY KEY (concepto_id));
CREATE TABLE GESTORES_DE_DATOS.Item_factura(
	factura_numero DECIMAL(18,0),
	item_numero DECIMAL(18,0),
	publicacion_codigo DECIMAL(18,0),
	concepto_id DECIMAL(18,0),
	item_precio DECIMAL(18,2),
	item_cantidad DECIMAL(18,0),
	item_subtotal DECIMAL(18,2),
	PRIMARY KEY (factura_numero,item_numero),
	FOREIGN KEY (factura_numero) REFERENCES GESTORES_DE_DATOS.Factura(factura_numero),
	FOREIGN KEY (publicacion_codigo) REFERENCES GESTORES_DE_DATOS.Publicacion(publicacion_codigo),
	FOREIGN KEY (concepto_id) REFERENCES GESTORES_DE_DATOS.Concepto(concepto_id));
CREATE TABLE GESTORES_DE_DATOS.Venta(
	venta_codigo DECIMAL(18,0),
	venta_fecha DATE,
	venta_total DECIMAL(18,2),
	cliente_id DECIMAL(18,0),
	PRIMARY KEY (venta_codigo),
	FOREIGN KEY (cliente_id) REFERENCES GESTORES_DE_DATOS.Cliente(cliente_id));
CREATE TABLE GESTORES_DE_DATOS.Venta_Detalle(
	venta_codigo DECIMAL(18,0),
	detalle_item DECIMAL(18,0),
	venta_det_cant DECIMAL(18,0),
	venta_det_precio DECIMAL(18,2),
	venta_det_sub_total DECIMAL(18,2),
	publicacion_codigo DECIMAL(18,0),
	PRIMARY KEY (venta_codigo, detalle_item),
	FOREIGN KEY (venta_codigo) REFERENCES GESTORES_DE_DATOS.Venta(venta_codigo),
	FOREIGN KEY (publicacion_codigo) REFERENCES GESTORES_DE_DATOS.Publicacion(publicacion_codigo));
CREATE TABLE GESTORES_DE_DATOS.Tipo_medio_pago(
	tipo_medio_pago_id DECIMAL(18,0) IDENTITY(1,1),
	tipo_medio_pago NVARCHAR(50)
	PRIMARY KEY (Tipo_medio_pago_id));
CREATE TABLE GESTORES_DE_DATOS.Medio_pago(
	medio_pago_id DECIMAL(18,0) IDENTITY(1,1),
	medio_pago NVARCHAR(50),
	tipo_medio_pago_id DECIMAL(18,0),
	PRIMARY KEY (medio_pago_id),
	FOREIGN KEY (tipo_medio_pago_id) REFERENCES GESTORES_DE_DATOS.Tipo_medio_pago(tipo_medio_pago_id));
CREATE TABLE GESTORES_DE_DATOS.Pago(
	pago_id DECIMAL(18,0) IDENTITY(1,1),
	pago_fecha DATE,
	pago_importe DECIMAL(18,2),
	pago_nro_tarjeta NVARCHAR(50),
	pago_fecha_venc_tarjets DATE,
	pago_cant_cuotas DECIMAL(18,0),
	medio_pago_id DECIMAL(18,0),
	tipo_medio_pago_id DECIMAL(18,0),
	venta_codigo DECIMAL(18,0),
	PRIMARY KEY (pago_id),
	FOREIGN KEY (medio_pago_id) REFERENCES GESTORES_DE_DATOS.Medio_pago(medio_pago_id),
	FOREIGN KEY (tipo_medio_pago_id) REFERENCES GESTORES_DE_DATOS.Tipo_medio_pago(tipo_medio_pago_id),
	FOREIGN KEY (venta_codigo) REFERENCES GESTORES_DE_DATOS.Venta(Venta_codigo));
CREATE TABLE GESTORES_DE_DATOS.Tipo_Envio(
	tipo_envio_id DECIMAL(18,0) IDENTITY(1,1),
	tipo_envio NVARCHAR(50),
	PRIMARY KEY (tipo_envio_id));
CREATE TABLE GESTORES_DE_DATOS.Envio(
	envio_id DECIMAL(18,0) IDENTITY(1,1),
	envio_fecha_programada DATE,
	envio_hora_inicio DECIMAL(18,0),
	envio_hora_fin DECIMAL(18,0),
	envio_fecha_entrega DATETIME,
	envio_costo DECIMAL(18,2),
	venta_codigo DECIMAL(18,0),
	domicilio_id DECIMAL(18,0),
	tipo_envio_id DECIMAL(18,0),
	PRIMARY KEY (envio_id),
	FOREIGN KEY (venta_codigo) REFERENCES GESTORES_DE_DATOS.Venta(venta_codigo),
	FOREIGN KEY (domicilio_id) REFERENCES GESTORES_DE_DATOS.Domicilio(domicilio_id),
	FOREIGN KEY (tipo_envio_id) REFERENCES GESTORES_DE_DATOS.Tipo_Envio(tipo_envio_id));

PRINT '**** Tablas creadas correctamente ****';
GO


/* Inicio de la migración */

-- Primer nivel - Tablas independientes (sin FK)
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Provincia
	AS
		BEGIN
		INSERT INTO GESTORES_DE_DATOS.Provincia (provincia)
			SELECT DISTINCT CLI_USUARIO_DOMICILIO_PROVINCIA
				FROM gd_esquema.Maestra
				WHERE CLI_USUARIO_DOMICILIO_PROVINCIA IS NOT NULL
	END
	GO

-- Marca
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Marca
	AS
		BEGIN
			INSERT INTO GESTORES_DE_DATOS.Marca(marca)
			SELECT DISTINCT PRODUCTO_MARCA
					FROM gd_esquema.Maestra
					WHERE PRODUCTO_MARCA IS NOT NULL
	END
	GO

-- Modelo
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Modelo
	AS
		BEGIN
			INSERT INTO GESTORES_DE_DATOS.Modelo(modelo_codigo, modelo_descripcion)
				SELECT DISTINCT PRODUCTO_MOD_CODIGO, PRODUCTO_MOD_DESCRIPCION
					FROM gd_esquema.Maestra
					WHERE PRODUCTO_MOD_CODIGO IS NOT NULL
		END
		GO

-- Concepto
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Concepto
	AS
	BEGIN
			INSERT INTO GESTORES_DE_DATOS.Concepto(concepto)
				SELECT DISTINCT FACTURA_DET_TIPO
					FROM gd_esquema.Maestra
					WHERE FACTURA_DET_TIPO IS NOT NULL
	END
	GO

-- Tipo_Envio
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Tipo_Envio
	AS
		BEGIN
			INSERT INTO GESTORES_DE_DATOS.Tipo_Envio(tipo_envio)
				SELECT DISTINCT ENVIO_TIPO
					FROM gd_esquema.Maestra
					WHERE ENVIO_TIPO IS NOT NULL
		END
		GO

-- Tipo_medio_pago
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Tipo_medio_pago
AS
BEGIN
INSERT INTO GESTORES_DE_DATOS.Tipo_medio_pago(tipo_medio_pago)
	SELECT DISTINCT PAGO_TIPO_MEDIO_PAGO
		FROM gd_esquema.Maestra
		WHERE PAGO_TIPO_MEDIO_PAGO IS NOT NULL
END
GO

-- Rubro
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Rubro
AS
BEGIN
INSERT INTO GESTORES_DE_DATOS.Rubro(rubro_descripcion)
    SELECT DISTINCT PRODUCTO_RUBRO_DESCRIPCION
		FROM gd_esquema.Maestra
		WHERE PRODUCTO_RUBRO_DESCRIPCION IS NOT NULL
END
GO

-- Sub_rubro
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Sub_rubro
AS
BEGIN
INSERT INTO GESTORES_DE_DATOS.Sub_rubro(sub_rubro, rubro_id)
    SELECT DISTINCT PRODUCTO_SUB_RUBRO,r.rubro_id
		FROM gd_esquema.Maestra m
		JOIN GESTORES_DE_DATOS.Rubro r ON r.rubro_descripcion = m.PRODUCTO_RUBRO_DESCRIPCION
		WHERE PRODUCTO_SUB_RUBRO IS NOT NULL
END
GO

-- Cliente 41298
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Cliente
AS
BEGIN
INSERT INTO GESTORES_DE_DATOS.Cliente(cliente_nombre, cliente_apellido, cliente_fecha_nac, cliente_dni)
    SELECT DISTINCT CLIENTE_NOMBRE,CLIENTE_APELLIDO,CLIENTE_FECHA_NAC,CLIENTE_DNI
		FROM gd_esquema.Maestra
		WHERE CLIENTE_DNI IS NOT NULL
END
GO

-- Vendedor 89
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Vendedor
AS
BEGIN
INSERT INTO GESTORES_DE_DATOS.Vendedor(vendedor_razon_social, vendedor_CUIT, vendedor_MAIL)
    SELECT DISTINCT VENDEDOR_RAZON_SOCIAL,VENDEDOR_CUIT,VENDEDOR_MAIL
		FROM gd_esquema.Maestra
		WHERE VENDEDOR_CUIT IS NOT NULL
END
GO

-- Producto
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Producto
AS
BEGIN
INSERT INTO GESTORES_DE_DATOS.Producto(producto_codigo, producto_descripcion,producto_precio)
    SELECT DISTINCT PRODUCTO_CODIGO,PRODUCTO_DESCRIPCION,PRODUCTO_PRECIO
		FROM gd_esquema.Maestra
		WHERE PRODUCTO_CODIGO IS NOT NULL
END
GO


/*
Segundo nivel - Depende del primero

Localidad (depende de Provincia) 16918*/
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Localidad
AS
BEGIN
INSERT INTO GESTORES_DE_DATOS.Localidad(localidad,provincia_id)
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
		WHERE ALMACEN_Localidad IS NOT NULL
END
GO

/*
Medio_pago (depende de Tipo_medio_pago)*/
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Medio_pago
AS
BEGIN 
	INSERT INTO GESTORES_DE_DATOS.Medio_pago(medio_pago,tipo_medio_pago_id)
	SELECT DISTINCT PAGO_MEDIO_PAGO, t.tipo_medio_pago_id
		FROM gd_esquema.Maestra
			JOIN GESTORES_DE_DATOS.Tipo_medio_pago t ON t.tipo_medio_pago = PAGO_TIPO_MEDIO_PAGO
		WHERE PAGO_MEDIO_PAGO IS NOT NULL
END
GO

/*Usuario (depende de Cliente, Vendedor) 41387*/ 
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Usuario
AS
BEGIN 
	INSERT INTO GESTORES_DE_DATOS.Usuario(usuario_nombre,usuario_pass,usuario_fecha_creacion,cliente_id,vendedor_id)
		SELECT DISTINCT CLI_USUARIO_NOMBRE usuario_nombre
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
			WHERE VEN_USUARIO_NOMBRE IS NOT NULl
END
GO


/*Venta (depende de Cliente)*/
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Venta
AS
BEGIN 
	INSERT INTO GESTORES_DE_DATOS.Venta(venta_codigo,venta_fecha,venta_total,cliente_id)
	SELECT VENTA_CODIGO,VENTA_FECHA,VENTA_TOTAL,c.cliente_id
		FROM gd_esquema.Maestra m
		JOIN GESTORES_DE_DATOS.Cliente c ON c.cliente_nombre = m.cliente_nombre 
			AND c.cliente_apellido = m.CLIENTE_APELLIDO AND c.cliente_dni = m.CLIENTE_DNI 
END
GO


/*Marca_Modelo_Producto (depende de Marca, Modelo, Producto) NO SE SI EL PRECIO ESTA DEL TODO BIEN, REVISAR ESTO, TIRA ERRPR DE PK DUPLICADA*/
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Marca_Modelo_Producto
AS
BEGIN 
INSERT INTO GESTORES_DE_DATOS.Marca_Modelo_Producto(marca_id,modelo_id,producto_id)
		SELECT DISTINCT ma.marca_id,mo.modelo_id,p.producto_id
			FROM gd_esquema.Maestra m
			JOIN GESTORES_DE_DATOS.Modelo mo ON mo.modelo_codigo = m.PRODUCTO_MOD_CODIGO AND mo.modelo_descripcion = m.PRODUCTO_MOD_DESCRIPCION
			JOIN GESTORES_DE_DATOS.Marca ma ON ma.marca = m.PRODUCTO_MARCA
			JOIN GESTORES_DE_DATOS.Producto p ON p.producto_codigo = m.PRODUCTO_CODIGO AND p.producto_descripcion = m.PRODUCTO_DESCRIPCION
				AND p.producto_precio = m.PRODUCTO_PRECIO
END
GO


/*Tercer nivel - Depende del segundo

Almacen (depende de Localidad, Provincia)*/
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Almacen
AS
BEGIN 
	INSERT INTO GESTORES_DE_DATOS.Almacen(almacen_codigo,almacen_calle,almacen_nro_calle,almacen_costo_al_dia,localidad_id,provincia_id)
	SELECT DISTINCT ALMACEN_CODIGO,ALMACEN_CALLE,ALMACEN_NRO_CALLE,ALMACEN_COSTO_DIA_AL,l.localidad_id,p.provincia_id
		FROM gd_esquema.Maestra
		JOIN GESTORES_DE_DATOS.Provincia p ON p.provincia = ALMACEN_PROVINCIA
		JOIN GESTORES_DE_DATOS.Localidad l ON l.localidad = ALMACEN_Localidad AND p.provincia_id = l.provincia_id
		WHERE ALMACEN_CODIGO IS NOT NULL
END
GO

/*Domicilio (depende de Usuario, Localidad, Provincia) 41387*/
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Domicilio
AS
BEGIN 
INSERT INTO GESTORES_DE_DATOS.Domicilio(domicilio_calle,domicilio_cp,domicilio_depto,localidad_id,
	domicilio_nro_calle,domicilio_piso,provincia_id,usuario_id)
	(SELECT DISTINCT CLI_USUARIO_DOMICILIO_CALLE calle,CLI_USUARIO_DOMICILIO_CP cp, CLI_USUARIO_DOMICILIO_DEPTO depto,l.localidad_id loc,
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
		WHERE VEN_USUARIO_DOMICILIO_CALLE IS NOT NULL)
END
GO

/*Pago (depende de Venta, Medio_pago, Tipo_medio_pago) 103592*/
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Pago
AS
BEGIN 
	INSERT INTO GESTORES_DE_DATOS.Pago(pago_fecha,pago_importe,pago_nro_tarjeta,pago_fecha_venc_tarjets,
	pago_cant_cuotas,medio_pago_id,tipo_medio_pago_id,venta_codigo)
	SELECT PAGO_FECHA,PAGO_IMPORTE,PAGO_NRO_TARJETA,PAGO_FECHA_VENC_TARJETA,PAGO_CANT_CUOTAS,med.medio_pago_id,med.tipo_medio_pago_id,venta.venta_codigo
		FROM gd_esquema.Maestra m
		JOIN GESTORES_DE_DATOS.Medio_pago med ON med.medio_pago = PAGO_MEDIO_PAGO
		JOIN GESTORES_DE_DATOS.Venta venta ON venta.venta_codigo = m.VENTA_CODIGO
END
GO


/*Cuarto nivel:

Publicacion (depende de Producto, Vendedor, Almacen)*/
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Publicacion
AS
BEGIN 
	INSERT INTO GESTORES_DE_DATOS.Publicacion(publicacion_codigo,publicacion_descripcion,publicacion_stock,publicacion_fecha_inicio,
	publicacion_fecha_fin,publicacion_precio,publicacion_costo,publicacion_porc_venta,producto_id,vendedor_id,almacen_codigo)
	SELECT DISTINCT PUBLICACION_CODIGO,PUBLICACION_DESCRIPCION,PUBLICACION_STOCK,PUBLICACION_FECHA,PUBLICACION_FECHA_V,
		PUBLICACION_PRECIO,PUBLICACION_COSTO,PUBLICACION_PORC_VENTA,p.producto_id,v.vendedor_id,a.almacen_codigo
		FROM gd_esquema.Maestra m
		JOIN GESTORES_DE_DATOS.Producto p ON p.producto_codigo = m.PRODUCTO_CODIGO AND p.producto_descripcion = m.PRODUCTO_DESCRIPCION AND p.producto_precio = m.PRODUCTO_PRECIO
		JOIN GESTORES_DE_DATOS.Vendedor v ON v.vendedor_CUIT = m.VENDEDOR_CUIT AND v.vendedor_MAIL = m.VENDEDOR_MAIL 
		JOIN GESTORES_DE_DATOS.Almacen a ON a.almacen_codigo = m.ALMACEN_CODIGO
END
GO

/*Envio (depende de Venta, Domicilio, Tipo_Envio) 103592*/
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Envio
AS
BEGIN 
	INSERT INTO GESTORES_DE_DATOS.Envio(envio_fecha_programada,envio_hora_inicio,envio_hora_fin,envio_fecha_entrega,envio_costo, 
										venta_codigo,domicilio_id,tipo_envio_id)
	SELECT m.ENVIO_FECHA_PROGAMADA,m.ENVIO_HORA_INICIO,m.ENVIO_HORA_FIN_INICIO,m.ENVIO_FECHA_ENTREGA,m.ENVIO_COSTO,
		v.venta_codigo,d.domicilio_id,t.tipo_envio_id
		FROM gd_esquema.Maestra m
		JOIN GESTORES_DE_DATOS.Venta v ON v.venta_codigo = m.VENTA_CODIGO
		JOIN GESTORES_DE_DATOS.Domicilio d ON d.domicilio_calle = m.CLI_USUARIO_DOMICILIO_CALLE AND d.domicilio_cp = m.CLI_USUARIO_DOMICILIO_CP AND
			d.domicilio_depto = m.CLI_USUARIO_DOMICILIO_DEPTO AND d.domicilio_nro_calle = m.CLI_USUARIO_DOMICILIO_NRO_CALLE
		JOIN GESTORES_DE_DATOS.Tipo_Envio t ON t.tipo_envio = m.ENVIO_TIPO
END
GO

/*Factura (depende de Usuario)*/
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Factura
AS
BEGIN 
	INSERT INTO GESTORES_DE_DATOS.Factura(factura_numero,factura_fecha,factura_total,usuario_id)
	SELECT DISTINCT FACTURA_NUMERO,FACTURA_FECHA,FACTURA_TOTAL,u.usuario_id
		FROM gd_esquema.Maestra m
		JOIN GESTORES_DE_DATOS.Publicacion p ON m.PUBLICACION_CODIGO = p.publicacion_codigo
		JOIN GESTORES_DE_DATOS.Vendedor v ON v.vendedor_id = p.vendedor_id
		JOIN GESTORES_DE_DATOS.Usuario u ON u.vendedor_id = v.vendedor_id
		WHERE FACTURA_NUMERO IS NOT NULL
END
GO


/*Quinto nivel:

Venta_Detalle (depende de Venta, Publicacion)*/
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Venta_Detalle
AS
BEGIN 
	INSERT INTO GESTORES_DE_DATOS.Venta_Detalle(venta_codigo,detalle_item,venta_det_cant,venta_det_precio,venta_det_sub_total,publicacion_codigo)
	SELECT DISTINCT m.VENTA_CODIGO,ROW_NUMBER() OVER (PARTITION BY VENTA_CODIGO ORDER BY VENTA_CODIGO)
		,m.VENTA_DET_CANT,m.VENTA_DET_PRECIO,m.VENTA_DET_SUB_TOTAL,m.PUBLICACION_CODIGO
		FROM gd_esquema.Maestra m
		WHERE VENTA_CODIGO IS NOT NULL
		GROUP BY m.VENTA_CODIGO,m.VENTA_DET_CANT,m.VENTA_DET_PRECIO,m.VENTA_DET_SUB_TOTAL,m.PUBLICACION_CODIGO
END
GO

/*Item_factura (depende de Factura, Publicacion, Concepto)*/
CREATE PROCEDURE GESTORES_DE_DATOS.Migrar_Item_factura
AS
BEGIN 
  INSERT INTO GESTORES_DE_DATOS.Item_factura(factura_numero,item_numero,publicacion_codigo,concepto_id,item_precio,item_cantidad,item_subtotal)
	SELECT m.FACTURA_NUMERO, ROW_NUMBER() OVER (PARTITION BY FACTURA_NUMERO ORDER BY FACTURA_NUMERO),
		m.PUBLICACION_CODIGO,c.concepto_id,m.FACTURA_DET_PRECIO,m.FACTURA_DET_CANTIDAD,m.FACTURA_DET_SUBTOTAL
		FROM gd_esquema.Maestra m
		JOIN GESTORES_DE_DATOS.Concepto c ON c.concepto = m.FACTURA_DET_TIPO
END
GO



/* Ejecución de los procedures */

/* PRIMER NIVEL */
EXECUTE GESTORES_DE_DATOS.Migrar_Provincia;
    print ' Migración de Provincia exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Marca;
    print ' Migración de Marca exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Modelo;
    print ' Migración de Modelo exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Concepto;
    print ' Migración de Concepto exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Tipo_Envio;
    print ' Migración de Tipo_Envio exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Tipo_medio_pago;
    print ' Migración de Tipo_medio_pago exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Rubro;
    print ' Migración de Rubro exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Sub_rubro;
    print ' Migración de Sub_rubro exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Cliente;
    print ' Migración de Cliente exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Vendedor;
    print ' Migración de Vendedor exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Producto;
    print ' Migración de Producto exitosa';

/*SEGUNDO NIVEL*/
EXECUTE GESTORES_DE_DATOS.Migrar_Localidad;
    print ' Migración de Localidad Exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Medio_pago;
    print ' Migración de Medio_pago Exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Usuario;
    print ' Migración de Usuario Exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Venta;
    print ' Migración de Venta Exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Marca_Modelo_Producto;
    print ' Migración de Marca_Modelo_Producto Exitosa';

/* Tercer nivel */ 
EXECUTE GESTORES_DE_DATOS.Migrar_Almacen;
    print 'Migración de Almacen exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Domicilio;
    print 'Migración de Domicilio exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Pago;
    print 'Migración de Pago exitosa';

/* Cuarto nivel*/
EXECUTE GESTORES_DE_DATOS.Migrar_Publicacion;
    print 'Migración de Publicacion exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Envio;
    print 'Migración de Envio exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Factura;
    print 'Migración de Factura exitosa';

/* Quinto nivel */
EXECUTE GESTORES_DE_DATOS.Migrar_Venta_Detalle;
    print ' Migración de Venta_Detalle Exitosa';
EXECUTE GESTORES_DE_DATOS.Migrar_Item_factura;
    print ' Migración de item factura Exitosa';
