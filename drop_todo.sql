USE GD2C2024;
GO

DROP TABLE GESTORES_DE_DATOS.Envio
DROP TABLE GESTORES_DE_DATOS.Tipo_Envio
DROP TABLE GESTORES_DE_DATOS.Pago
DROP TABLE GESTORES_DE_DATOS.Medio_pago
DROP TABLE GESTORES_DE_DATOS.Tipo_medio_pago
DROP TABLE GESTORES_DE_DATOS.Venta_Detalle
DROP TABLE GESTORES_DE_DATOS.Venta
DROP TABLE GESTORES_DE_DATOS.Item_factura
DROP TABLE GESTORES_DE_DATOS.Concepto
DROP TABLE GESTORES_DE_DATOS.Factura
DROP TABLE GESTORES_DE_DATOS.Publicacion
DROP TABLE GESTORES_DE_DATOS.Marca_Modelo_Producto
DROP TABLE GESTORES_DE_DATOS.Producto
DROP TABLE GESTORES_DE_DATOS.Sub_rubro
DROP TABLE GESTORES_DE_DATOS.Rubro
DROP TABLE GESTORES_DE_DATOS.Modelo
DROP TABLE GESTORES_DE_DATOS.Marca
DROP TABLE GESTORES_DE_DATOS.Almacen
DROP TABLE GESTORES_DE_DATOS.Domicilio
DROP TABLE GESTORES_DE_DATOS.Usuario
DROP TABLE GESTORES_DE_DATOS.Cliente
DROP TABLE GESTORES_DE_DATOS.Vendedor
DROP TABLE GESTORES_DE_DATOS.Localidad
DROP TABLE GESTORES_DE_DATOS.Provincia 

DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Item_factura; 
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Venta_Detalle; 
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Factura; 
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Envio;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Publicacion;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Pago;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Domicilio;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Almacen;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Marca_Modelo_Producto;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Venta;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Usuario;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Medio_pago;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Localidad;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Provincia;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Modelo;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Concepto;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Tipo_Envio;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Tipo_medio_pago;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Rubro;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Sub_rubro;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Cliente;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Vendedor;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Producto;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Cliente;
DROP PROCEDURE GESTORES_DE_DATOS.Migrar_Marca;

DROP SCHEMA GESTORES_DE_DATOS


