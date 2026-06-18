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
