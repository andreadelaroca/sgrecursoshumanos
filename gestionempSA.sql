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
GO --2. Gestión de Cargos, 3. Gestión de Empleados, 4. Gestión de Contratos, 5. Gestión de Asistencia, 6. Gestión de Evaluaciones de Desempeño

CREATE SCHEMA GestionCapacitaciones
GO	--7. Gestión de Capacitaciones, INTERMEDIA: Empleado_Capacitación