USE GD2C2024;
GO

CREATE TABLE GESTORES_DE_DATOS.Provincia (
	provincia_id DECIMAL(18,0),
	provincia NVARCHAR(50),
	PRIMARY KEY( provincia_id));
CREATE TABLE GESTORES_DE_DATOS.Localidad (
	localidad_id DECIMAL(18,0),
	provincia_id DECIMAL(18,0),
	localidad NVARCHAR(50),
	PRIMARY KEY (localidad_id),
	FOREIGN KEY (provincia_id) REFERENCES GESTORES_DE_DATOS.Provincia(provincia_id));
CREATE TABLE GESTORES_DE_DATOS.Vendedor(
	vendedor_id DECIMAL(18,0),
	vendedor_razon_social NVARCHAR(50),
	vendedor_CUIT NVARCHAR(50),
	vendedor_MAIL NVARCHAR(50),
	PRIMARY KEY (vendedor_id));
CREATE TABLE GESTORES_DE_DATOS.Cliente(
	cliente_id DECIMAL(18,0),
	cliente_nombre NVARCHAR(50),
	cliente_apellido NVARCHAR(50),
	cliente_fecha_nac DATE,
	cliente_dni DECIMAL(18,0),
	PRIMARY KEY (cliente_id));
CREATE TABLE GESTORES_DE_DATOS.Usuario(
	usuario_id DECIMAL(18,0),
	usuario_nombre NVARCHAR(50),
	usuario_pass NVARCHAR(50), 
	usuario_fecha_creacion DATE DEFAULT GETDATE(),
	vendedor_id DECIMAL(18,0),
	cliente_id DECIMAL(18,0),
	PRIMARY KEY (usuario_id),
	FOREIGN KEY (vendedor_id) REFERENCES GESTORES_DE_DATOS.Vendedor(vendedor_id),
	FOREIGN KEY (cliente_id) REFERENCES GESTORES_DE_DATOS.Cliente(cliente_id));
CREATE TABLE GESTORES_DE_DATOS.Domicilio(
	domicilio_id DECIMAL(18,0),
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
	marca_id DECIMAL(18,0),
	marca NVARCHAR(50),
	PRIMARY KEY (marca_id));
CREATE TABLE GESTORES_DE_DATOS.Modelo(
	modelo_id DECIMAL(18,0),
	modelo_codigo NVARCHAR(50),
	modelo_descripcion NVARCHAR(50),
	PRIMARY KEY (modelo_id));
CREATE TABLE GESTORES_DE_DATOS.Rubro(
	rubro_id DECIMAL(18,0),
	rubro_descripcion NVARCHAR(50),
	PRIMARY KEY (rubro_id));
CREATE TABLE GESTORES_DE_DATOS.Sub_rubro(
	sub_rubro_id DECIMAL(18,0),
	sub_rubro NVARCHAR(50),
	PRIMARY KEY (sub_rubro_id));
CREATE TABLE GESTORES_DE_DATOS.Producto(
	producto_id DECIMAL(18,0),
	producto_codigo NVARCHAR(50),
	producto_descripcion NVARCHAR(50),
	PRIMARY KEY (producto_id));
CREATE TABLE GESTORES_DE_DATOS.Marca_Modelo_Producto(
	marca_id DECIMAL(18,0),
	modelo_id DECIMAL(18,0),
	producto_id DECIMAL(18,0),
	producto_precio DECIMAL(18,2),
	PRIMARY KEY (marca_id,modelo_id,producto_id),
	FOREIGN KEY (marca_id) REFERENCES GESTORES_DE_DATOS.Marca(marca_id),
	FOREIGN KEY (modelo_id) REFERENCES GESTORES_DE_DATOS.Modelo(modelo_id),
	FOREIGN KEY (producto_id) REFERENCES GESTORES_DE_DATOS.Producto(producto_id));
CREATE TABLE GESTORES_DE_DATOS.Producto_SubRubro_Rubro(
	producto_id DECIMAL(18,0),
	sub_rubro_id DECIMAL(18,0),
	rubro_id DECIMAL(18,0)
	PRIMARY KEY (producto_id,sub_rubro_id,rubro_id),
	FOREIGN KEY (sub_rubro_id) REFERENCES GESTORES_DE_DATOS.Sub_rubro(sub_rubro_id),
	FOREIGN KEY (rubro_id) REFERENCES GESTORES_DE_DATOS.Rubro(rubro_id),
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
	concepto_id DECIMAL(18,0),
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
	tipo_medio_pago_id DECIMAL(18,0),
	tipo_medio_pago NVARCHAR(50)
	PRIMARY KEY (Tipo_medio_pago_id));
CREATE TABLE GESTORES_DE_DATOS.Medio_pago(
	medio_pago_id DECIMAL(18,0),
	medio_pago NVARCHAR(50),
	tipo_medio_pago_id DECIMAL(18,0),
	PRIMARY KEY (medio_pago_id),
	FOREIGN KEY (tipo_medio_pago_id) REFERENCES GESTORES_DE_DATOS.Tipo_medio_pago(tipo_medio_pago_id));
CREATE TABLE GESTORES_DE_DATOS.Pago(
	pago_id DECIMAL(18,0),
	pago_fecha DATE,
	pago_importe DECIMAL(18,2),
	pago_nro_tarjeta NVARCHAR(50),
	pago_fecha_vvenc_tarjets DATE,
	pago_cant_cuotas DECIMAL(18,0),
	medio_pago_id DECIMAL(18,0),
	tipo_medio_pago_id DECIMAL(18,0),
	venta_codigo DECIMAL(18,0),
	PRIMARY KEY (pago_id),
	FOREIGN KEY (medio_pago_id) REFERENCES GESTORES_DE_DATOS.Medio_pago(medio_pago_id),
	FOREIGN KEY (tipo_medio_pago_id) REFERENCES GESTORES_DE_DATOS.Tipo_medio_pago(tipo_medio_pago_id),
	FOREIGN KEY (venta_codigo) REFERENCES GESTORES_DE_DATOS.Venta(Venta_codigo));
CREATE TABLE GESTORES_DE_DATOS.Tipo_Envio(
	tipo_envio_id DECIMAL(18,0),
	tipo_envio NVARCHAR(50),
	PRIMARY KEY (tipo_envio_id));
CREATE TABLE GESTORES_DE_DATOS.Envio(
	envio_id DECIMAL(18,0),
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