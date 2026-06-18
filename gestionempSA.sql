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
);
GO

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

-- =========================================================================
-- 4. GESTIÓN DE CONTRATOS
-- =========================================================================
CREATE TABLE GestionEmpresa.Contratos (
    CodigoContrato INT IDENTITY(1,1),
    TipoContrato VARCHAR(50) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFinalizacion DATE NULL,
    SalarioAcordado DECIMAL(12,2) NOT NULL,
    EstadoContrato VARCHAR(20) DEFAULT 'Activo',
    CodigoEmpleado INT NOT NULL,
    createdAt DATE DEFAULT GETDATE()
	, updatedAt DATE DEFAULT GETDATE()
	, deletedAt DATE NULL
    
    CONSTRAINT PK_Contratos PRIMARY KEY (CodigoContrato),
    CONSTRAINT CHK_Contrato_Tipo CHECK (TipoContrato IN ('Temporal', 'Permanente', 'Por proyecto')),
    CONSTRAINT CHK_Contrato_Salario CHECK (SalarioAcordado > 0),
    CONSTRAINT CHK_Contrato_Estado CHECK (EstadoContrato IN ('Activo', 'Vencido', 'Rescindido')),
    CONSTRAINT FK_Contratos_Empleados FOREIGN KEY (CodigoEmpleado) 
        REFERENCES GestionEmpleados.Empleados(CodigoEmpleado)
);
GO

-- =========================================================================
-- 5. GESTIÓN DE ASISTENCIA
-- =========================================================================
CREATE TABLE GestionEmpresa.Asistencia (
    CodigoAsistencia INT IDENTITY(1,1),
    Fecha DATE NOT NULL,
    HoraEntrada TIME NOT NULL,
    HoraSalida TIME NULL,
    EstadoAsistencia VARCHAR(20) NOT NULL,
    CodigoEmpleado INT NOT NULL,
    createdAt DATE DEFAULT GETDATE()
	, updatedAt DATE DEFAULT GETDATE()
	, deletedAt DATE NULL
    
    CONSTRAINT PK_Asistencia PRIMARY KEY (CodigoAsistencia),
    CONSTRAINT CHK_Asistencia_Estado CHECK (EstadoAsistencia IN ('Presente', 'Ausente', 'Permiso', 'Incapacidad')),
    CONSTRAINT FK_Asistencia_Empleados FOREIGN KEY (CodigoEmpleado) 
        REFERENCES GestionEmpleados.Empleados(CodigoEmpleado)
);
GO

-- =========================================================================
-- 6. GESTIÓN DE EVALUACIONES DE DESEMPEÑO
-- =========================================================================
CREATE TABLE GestionEmpresa.EvaluacionesDesempenio (
    CodigoEvaluacion INT IDENTITY(1,1),
    FechaEvaluacion DATE NOT NULL,
    PeriodoEvaluado VARCHAR(50) NOT NULL,
    CalificacionObtenida INT NOT NULL,
    Comentarios VARCHAR(500) NULL,
    CodigoEmpleado INT NOT NULL,
    createdAt DATE DEFAULT GETDATE()
	, updatedAt DATE DEFAULT GETDATE()
	, deletedAt DATE NULL
    
    CONSTRAINT PK_Evaluaciones PRIMARY KEY (CodigoEvaluacion),
    CONSTRAINT CHK_Evaluacion_Calificacion CHECK (CalificacionObtenida BETWEEN 1 AND 100),
    CONSTRAINT FK_Evaluaciones_Empleados FOREIGN KEY (CodigoEmpleado) 
        REFERENCES GestionEmpleados.Empleados(CodigoEmpleado)
);
GO

CREATE TABLE GestionCapacitaciones.Capacitaciones (
    CodigoCapacitacion INT IDENTITY(1,1),
    NombreCapacitacion VARCHAR(150) NOT NULL,
    InstitucionResponsable VARCHAR(150) NOT NULL,
    DuracionHoras INT NOT NULL,
    FechaRealizacion DATE NOT NULL,
    createdAt DATE DEFAULT GETDATE()
	, updatedAt DATE DEFAULT GETDATE()
	, deletedAt DATE NULL
    
    CONSTRAINT PK_Capacitaciones PRIMARY KEY (CodigoCapacitacion),
    CONSTRAINT CHK_Capacitacion_Duracion CHECK (DuracionHoras > 0)
);
GO

-- Tabla Intermedia: Empleado_Capacitación
CREATE TABLE GestionCapacitaciones.Empleado_Capacitacion (
    CodigoEmpleado INT NOT NULL,
    CodigoCapacitacion INT NOT NULL,
    FechaParticipacion DATE NOT NULL,
    ResultadoObtenido VARCHAR(100) NULL,
    createdAt DATE DEFAULT GETDATE()
	, updatedAt DATE DEFAULT GETDATE()
	, deletedAt DATE NULL
    
    CONSTRAINT PK_Empleado_Capacitacion PRIMARY KEY (CodigoEmpleado, CodigoCapacitacion),
    CONSTRAINT FK_EmpCap_Empleados FOREIGN KEY (CodigoEmpleado) 
        REFERENCES GestionEmpleados.Empleados(CodigoEmpleado),
    CONSTRAINT FK_EmpCap_Capacitaciones FOREIGN KEY (CodigoCapacitacion) 
        REFERENCES GestionCapacitaciones.Capacitaciones(CodigoCapacitacion)
);
GO

-- =========================================================================
-- 7. GESTIÓN DE CAPACITACIONES (Bajo esquema GestionCapacitaciones)
-- =========================================================================
CREATE TABLE GestionCapacitaciones.Capacitaciones (
    CodigoCapacitacion INT IDENTITY(1,1),
    NombreCapacitacion VARCHAR(150) NOT NULL,
    InstitucionResponsable VARCHAR(150) NOT NULL,
    DuracionHoras INT NOT NULL,
    FechaRealizacion DATE NOT NULL,
    createdAt DATE DEFAULT GETDATE()
	, updatedAt DATE DEFAULT GETDATE()
	, deletedAt DATE NULL
    
    CONSTRAINT PK_Capacitaciones PRIMARY KEY (CodigoCapacitacion),
    CONSTRAINT CHK_Capacitacion_Duracion CHECK (DuracionHoras > 0)
);
GO

-- Tabla Intermedia: Empleado_Capacitación
CREATE TABLE GestionCapacitaciones.Empleado_Capacitacion (
    CodigoEmpleado INT NOT NULL,
    CodigoCapacitacion INT NOT NULL,
    FechaParticipacion DATE NOT NULL,
    ResultadoObtenido VARCHAR(100) NULL,
    createdAt DATE DEFAULT GETDATE()
	, updatedAt DATE DEFAULT GETDATE()
	, deletedAt DATE NULL
    
    CONSTRAINT PK_Empleado_Capacitacion PRIMARY KEY (CodigoEmpleado, CodigoCapacitacion),
    CONSTRAINT FK_EmpCap_Empleados FOREIGN KEY (CodigoEmpleado) 
        REFERENCES GestionEmpleados.Empleados(CodigoEmpleado),
    CONSTRAINT FK_EmpCap_Capacitaciones FOREIGN KEY (CodigoCapacitacion) 
        REFERENCES GestionCapacitaciones.Capacitaciones(CodigoCapacitacion)
);
GO