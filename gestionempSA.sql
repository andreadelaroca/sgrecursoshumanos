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
GO

CREATE SCHEMA GestionEmpleados
GO

CREATE SCHEMA GestionCapacitaciones
GO

CREATE TABLE GestionEmpresa.Departamentos (
	idDepartamento INT IDENTITY(1,1) CONSTRAINT PK_iddepartamento PRIMARY KEY
	, nombre NVARCHAR(40) NOT NULL
	, descripcion NVARCHAR(120) NOT NULL
	, ubicacion NVARCHAR(120) NOT NULL
	, estado NVARCHAR(30) NOT NULL CONSTRAINT DF_dept_estado DEFAULT 'Activo'
	, createdAt DATE DEFAULT GETDATE()
	, updatedAt DATE DEFAULT GETDATE()
	, deletedAt DATE NULL
	, CONSTRAINT CHK_dept_estado CHECK (estado IN ('Activo', 'Inactivo'))
)
GO

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
	, idDepartamento INT CONSTRAINT FK_iddep FOREIGN KEY REFERENCES GestionEmpresa.Departamentos(idDepartamento)
    , idCargo INT CONSTRAINT FK_idcargo FOREIGN KEY REFERENCES GestionEmpleados.Cargos(idCargo)
)
GO

CREATE TABLE GestionEmpresa.Contratos (
    idContrato INT IDENTITY(1,1),
    tipo VARCHAR(50) NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaFinalizacion DATE NULL,
    salarioAcordado DECIMAL(12,2) NOT NULL,
    estado VARCHAR(20) DEFAULT 'Activo',
    idEmpleado INT CONSTRAINT FK_idemp FOREIGN KEY REFERENCES GestionEmpleados.Empleados(idEmpleado)
    , createdAt DATE DEFAULT GETDATE()
	, updatedAt DATE DEFAULT GETDATE()
	, deletedAt DATE NULL
    
    CONSTRAINT PK_Contratos PRIMARY KEY (idContrato),
    CONSTRAINT CHK_Contrato_Tipo CHECK (tipo IN ('Temporal', 'Permanente', 'Por proyecto')),
    CONSTRAINT CHK_Contrato_Salario CHECK (salarioAcordado > 0),
    CONSTRAINT CHK_Contrato_Estado CHECK (estado IN ('Activo', 'Vencido', 'Rescindido')),
)
GO

CREATE TABLE GestionEmpresa.Asistencia (
    idAsistencia INT IDENTITY(1,1),
    fecha DATE NOT NULL,
    horaEntrada TIME NOT NULL,
    horaSalida TIME NULL,
    estado VARCHAR(20) NOT NULL,
    idEmpleado INT NOT NULL,
    createdAt DATE DEFAULT GETDATE()
	, updatedAt DATE DEFAULT GETDATE()
	, deletedAt DATE NULL
    
    CONSTRAINT PK_Asistencia PRIMARY KEY (idAsistencia),
    CONSTRAINT CHK_Asistencia_Estado CHECK (estado IN ('Presente', 'Ausente', 'Permiso', 'Incapacidad')),
    CONSTRAINT FK_Asistencia_Empleados FOREIGN KEY (idEmpleado) 
        REFERENCES GestionEmpleados.Empleados(idEmpleado)
)
GO

CREATE TABLE GestionEmpresa.EvaluacionesDesempenio (
    idEvaluacion INT IDENTITY(1,1),
    fechaEvaluacion DATE NOT NULL,
    periodoEvaluado VARCHAR(50) NOT NULL,
    calificacionObtenida INT NOT NULL,
    comentarios VARCHAR(500) NULL,
    idEmpleado INT NOT NULL,
    createdAt DATE DEFAULT GETDATE()
	, updatedAt DATE DEFAULT GETDATE()
	, deletedAt DATE NULL
    CONSTRAINT PK_Evaluaciones PRIMARY KEY (idEvaluacion),
    CONSTRAINT CHK_Evaluacion_Calificacion CHECK (calificacionObtenida BETWEEN 1 AND 100),
    CONSTRAINT FK_Evaluaciones_Empleados FOREIGN KEY (idEmpleado) 
        REFERENCES GestionEmpleados.Empleados(idEmpleado)
)
GO

CREATE TABLE GestionCapacitaciones.Capacitaciones (
    idCapacitacion INT IDENTITY(1,1),
    nombre VARCHAR(150) NOT NULL,
    institucionResponsable VARCHAR(150) NOT NULL,
    duracionHoras INT NOT NULL,
    fechaRealizacion DATE NOT NULL,
    createdAt DATE DEFAULT GETDATE()
	, updatedAt DATE DEFAULT GETDATE()
	, deletedAt DATE NULL
    CONSTRAINT PK_Capacitaciones PRIMARY KEY (idCapacitacion),
    CONSTRAINT CHK_Capacitacion_Duracion CHECK (duracionHoras > 0)
)
GO

-- Tabla Intermedia: Empleado_Capacitación
CREATE TABLE GestionCapacitaciones.Empleado_Capacitacion (
    idEmpleado INT NOT NULL,
    idCapacitacion INT NOT NULL,
    fechaParticipacion DATE NOT NULL,
    resultadoObtenido VARCHAR(100) NULL,
    createdAt DATE DEFAULT GETDATE()
	, updatedAt DATE DEFAULT GETDATE()
	, deletedAt DATE NULL
    
    CONSTRAINT PK_Empleado_Capacitacion PRIMARY KEY (idEmpleado, idCapacitacion),
    CONSTRAINT FK_EmpCap_Empleados FOREIGN KEY (idEmpleado) 
        REFERENCES GestionEmpleados.Empleados(idEmpleado),
    CONSTRAINT FK_EmpCap_Capacitaciones FOREIGN KEY (idCapacitacion) 
        REFERENCES GestionCapacitaciones.Capacitaciones(idCapacitacion)
)
GO


USE gestionempSA
GO

INSERT INTO GestionEmpresa.Departamentos (nombre, descripcion, ubicacion, estado)
VALUES 
('Recursos Humanos', 'Gestion de talento y personal', 'Piso 1 - Ala Norte', 'Activo'),
('Tecnologia', 'Desarrollo y soporte de sistemas', 'Piso 3 - Ala Este', 'Activo'),
('Finanzas', 'Contabilidad y gestion financiera', 'Piso 2 - Ala Sur', 'Activo'),
('Ventas', 'Comercializacion y atencion al cliente', 'Piso 1 - Ala Oeste', 'Activo'),
('Logistica', 'Distribucion y gestion de inventario', 'Planta Baja', 'Inactivo')
GO

INSERT INTO GestionEmpleados.Cargos (nombre, descripcion, salarioBase, nivel)
VALUES 
('Analista de RRHH', 'Seleccion y contratacion', 1200.00, 'Junior'),
('Desarrollador Senior', 'Programacion y arquitectura', 3500.00, 'Senior'),
('Contador General', 'Auditorias y balances', 2200.00, 'Medio'),
('Ejecutivo de Ventas', 'Cierre de contratos comerciales', 1000.00, 'Junior'),
('Gerente de Operaciones', 'Planificacion estrategica', 4500.00, 'Directivo')
GO

INSERT INTO GestionEmpleados.Empleados (identificacion, nombres, apellidos, fechaNac, sexo, telefono, correo, direccion, fechaContratacion, estadoLaboral, idDepartamento, idCargo)
VALUES 
('10123456', 'Ana Maria', 'Gomez Ruiz', '1990-05-12', 'F', '555-0192', 'ana.gomez@empresa.com', 'Calle 45 #12-34', '2020-01-15', 'Activo', 1, 1),
('20345678', 'Carlos Alberto', 'Rojas Sosa', '1985-08-22', 'M', '555-0234', 'carlos.rojas@empresa.com', 'Av. Siempre Viva 742', '2018-03-01', 'Activo', 2, 2),
('30567890', 'Luisa Fernanda', 'Perez Mora', '1993-11-02', 'F', '555-0345', 'luisa.perez@empresa.com', 'Carrera 10 #5-20', '2021-07-10', 'Activo', 3, 3),
('40789012', 'Jorge Eliecer', 'Diaz Castro', '1988-03-30', 'M', '555-0456', 'jorge.diaz@empresa.com', 'Calle Falsa 123', '2019-11-20', 'Activo', 4, 4),
('50901234', 'Martha Lucia', 'Nieto Vega', '1979-06-14', 'F', '555-0567', 'martha.nieto@empresa.com', 'Transversal 5 #8-90', '2015-05-05', 'Activo', 5, 5)
GO

INSERT INTO GestionEmpresa.Contratos (tipo, fechaInicio, fechaFinalizacion, salarioAcordado, estado, idEmpleado)
VALUES 
('Permanente', '2020-01-15', NULL, 1200.00, 'Activo', 1),
('Permanente', '2018-03-01', NULL, 3700.00, 'Activo', 2),
('Temporal', '2021-07-10', '2022-07-10', 2200.00, 'Vencido', 3),
('Por proyecto', '2019-11-20', '2020-05-20', 1100.00, 'Rescindido', 4),
('Permanente', '2015-05-05', NULL, 4800.00, 'Activo', 5)
GO

INSERT INTO GestionEmpresa.Asistencia (fecha, horaEntrada, horaSalida, estado, idEmpleado)
VALUES 
('2026-06-15', '08:00:00', '17:00:00', 'Presente', 1),
('2026-06-15', '08:15:00', '17:30:00', 'Presente', 2),
('2026-06-15', '00:00:00', NULL, 'Ausente', 3),
('2026-06-15', '08:05:00', '12:00:00', 'Permiso', 4),
('2026-06-15', '00:00:00', NULL, 'Incapacidad', 5)
GO

INSERT INTO GestionEmpresa.EvaluacionesDesempenio (fechaEvaluacion, periodoEvaluado, calificacionObtenida, comentarios, idEmpleado)
VALUES 
('2025-12-20', 'Año 2025', 92, 'Excelente desempeño y trabajo en equipo.', 1),
('2025-12-20', 'Año 2025', 98, 'Liderazgo técnico sobresaliente en los proyectos.', 2),
('2025-12-20', 'Año 2025', 85, 'Cumple con los objetivos financieros establecidos.', 3),
('2025-12-20', 'Año 2025', 74, 'Debe mejorar el volumen de ventas en el último trimestre.', 4),
('2025-12-20', 'Año 2025', 90, 'Gestion optima del departamento a su cargo.', 5)
GO

INSERT INTO GestionCapacitaciones.Capacitaciones (nombre, institucionResponsable, duracionHoras, fechaRealizacion)
VALUES 
('Liderazgo y Gestion de Equipos', 'Sena', 24, '2025-04-10'),
('Desarrollo Avanzado en SQL Server', 'Microsoft Partner', 40, '2025-06-15'),
('Actualizacion de Normas NIIF', 'Consejo Contable', 16, '2025-08-22'),
('Estrategias de Negociacion Efectiva', 'Sales Academy', 20, '2025-10-05'),
('Seguridad y Salud en el Trabajo', 'Aseguradora Global', 8, '2025-11-12')
GO

INSERT INTO GestionCapacitaciones.Empleado_Capacitacion (idEmpleado, idCapacitacion, fechaParticipacion, resultadoObtenido)
VALUES 
(1, 1, '2025-04-10', 'Aprobado - 95/100'),
(2, 2, '2025-06-15', 'Certificado Excelencia'),
(3, 3, '2025-08-22', 'Aprobado'),
(4, 4, '2025-10-05', 'Asistió'),
(5, 5, '2025-11-12', 'Aprobado')
GO