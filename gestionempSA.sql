USE master
GO

IF EXISTS(SELECT * FROM sys.databases WHERE NAME = 'gestionempSA')
	BEGIN
		DROP DATABASE gestionempSA
	END
GO

CREATE DATABASE gestionempSA
GO

USE gestionempSA
GO

CREATE SCHEMA GestionEmpresa
GO --1. Gestión de Departamentos

CREATE SCHEMA GestionEmpleados
GO --4. Gestión de Contratos, 5. Gestión de Asistencia, 6. Gestión de Evaluaciones de Desempeño

CREATE SCHEMA GestionCapacitaciones
GO	--7. Gestión de Capacitaciones, INTERMEDIA: Empleado_Capacitación

CREATE TABLE GestionEmpleados.Cargos (
	idCargo INT IDENTITY(1,1) CONSTRAINT PK_idcargo PRIMARY KEY
	, nombre NVARCHAR(40) NOT NULL
	, descripcion NVARCHAR(120) NOT NULL
	, salarioBase DECIMAL(6,2) NOT NULL
	, nivel NVARCHAR(40) NOT NULL
	, createdAt DATE DEFAULT GETDATE()
	, updatedAt DATE DEFAULT GETDATE()
	, deletedAt DATE NULL
)
GO

CREATE TABLE GestionEmpleados.Empleados (
	idEmpleado INT IDENTITY(1,1) CONSTRAINT PK_idempleado PRIMARY KEY
	, identificacion NVARCHAR(20) NOT NULL
	, nombres NVARCHAR(50) NOT NULL
	, apellidos NVARCHAR(50) NOT NULL
	, fechaNac DATE NOT NULL
	, sexo CHAR NOT NULL
	, telefono NVARCHAR(20) NOT NULL
	, correo NVARCHAR(80) NOT NULL
	, direccion NVARCHAR(120) NOT NULL
	, fechaContratacion DATE DEFAULT GETDATE()
	, estadoLaboral NVARCHAR(30) NOT NULL
	, 
)
GO