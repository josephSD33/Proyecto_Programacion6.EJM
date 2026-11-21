CREATE DATABASE [PVI_ProyectoFinal]
GO

USE [PVI_ProyectoFinal]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categorias](
	[id_categoria] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[descripcion] [text] NULL,
	[estado] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_categoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
--hola--

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Persona](
	[id_persona] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[apellido] [varchar](100) NOT NULL,
	[email] [varchar](150) NOT NULL,
	[telefono] [varchar](15) NULL,
	[direccion] [varchar](255) NULL,
	[fecha_nacimiento] [date] NULL,
	[contrasena] [varchar](255) NULL,
	[estado] [bit] NULL,
	[tipo_persona] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_persona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Servicios](
	[id_servicio] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[descripcion] [text] NULL,
	[precio] [decimal](10, 2) NOT NULL,
	[id_categoria] [int] NOT NULL,
	[estado] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_servicio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Casas](
	[id_casa] [int] IDENTITY(1,1) NOT NULL,
	[nombre_casa] [nvarchar](255) NOT NULL,
	[metros_cuadrados] [int] NOT NULL,
	[numero_habitaciones] [int] NOT NULL,
	[numero_banos] [int] NOT NULL,
	[precio] [decimal](15, 2) NOT NULL,
	[id_persona] [int] NOT NULL,
	[fecha_construccion] [date] NOT NULL,
	[estado] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_casa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cobros](
	[id_cobro] [int] IDENTITY(1,1) NOT NULL,
	[id_casa] [int] NOT NULL,
	[mes] [int] NOT NULL,
	[anno] [int] NOT NULL,
	[id_bitacora] [int] NULL,
	[estado] [varchar](50) NOT NULL,   -- 'Pendiente' | 'Pagado' | 'Eliminado'
	[monto] [decimal](15, 2) NOT NULL,
	[fecha_pagada] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_cobro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bitacora](
	[id_bitacora] [int] IDENTITY(1,1) NOT NULL,
	[detalle] [varchar](255) NULL,
	[id_cobro] [int] NOT NULL,         -- se liga al cobro (antes estaba id_casa)
	[id_user] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_bitacora] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleCobro](
	[id_servicio] [int] NOT NULL,
	[id_cobro] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_servicio] ASC,
	[id_cobro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
---------------------------------------------------
SET IDENTITY_INSERT [dbo].[Persona] ON 
GO
INSERT [dbo].[Persona] ([id_persona], [nombre], [apellido], [email], [telefono], [direccion], [fecha_nacimiento], [contrasena], [estado], [tipo_persona]) VALUES (1, N'Nadia', N'Fonseca', N'nfonseca1498@hotmail.com', N'87654321', N'Desamparados, San José', CAST(N'1989-12-12' AS Date), N'12345', 1, N'Cliente')
GO
INSERT [dbo].[Persona] ([id_persona], [nombre], [apellido], [email], [telefono], [direccion], [fecha_nacimiento], [contrasena], [estado], [tipo_persona]) VALUES (2, N'Alberto', N'Rivera', N'alberto9684@msn.com', N'88965423', N'Barva, Heredia', CAST(N'1990-01-01' AS Date), N'12345', 1, N'Cliente')
GO
INSERT [dbo].[Persona] ([id_persona], [nombre], [apellido], [email], [telefono], [direccion], [fecha_nacimiento], [contrasena], [estado], [tipo_persona]) VALUES (3, N'Olga', N'Avila', N'oaflores23@gmail.com', N'87903285', N'Mercedes, Heredia', CAST(N'1992-02-26' AS Date), N'12345', 0, N'Empleado')
GO
INSERT [dbo].[Persona] ([id_persona], [nombre], [apellido], [email], [telefono], [direccion], [fecha_nacimiento], [contrasena], [estado], [tipo_persona]) VALUES (4, N'Roger', N'Pineda', N'rpinedag46@outlook.com', N'87642332', N'Hatillo, San José', CAST(N'1994-01-11' AS Date), N'12345', 0, N'Cliente')
GO
INSERT [dbo].[Persona] ([id_persona], [nombre], [apellido], [email], [telefono], [direccion], [fecha_nacimiento], [contrasena], [estado], [tipo_persona]) VALUES (5, N'Keren', N'Martinez', N'kmartinez32@hotmail.com', N'87901123', N'San Rafael, Heredia', CAST(N'1970-06-24' AS Date), N'12345', 1, N'Empleado')
GO
-----
INSERT [dbo].[Persona] ([id_persona], [nombre], [apellido], [email], [telefono], [direccion], [fecha_nacimiento], [contrasena], [estado], [tipo_persona]) VALUES (6, N'Rodrigo', N'Segura', N'rodri@gmail.com', N'88001122', N'Heredia', CAST(N'1998-03-15' AS Date), N'12345', 1, N'Empleado')
GO
INSERT [dbo].[Persona] ([id_persona], [nombre], [apellido], [email], [telefono], [direccion], [fecha_nacimiento], [contrasena], [estado], [tipo_persona]) VALUES (7, N'Admin', N'Sistema', N'admin@correo.com', N'88888888', N'San José', CAST(N'1990-01-01' AS Date), N'admin123', 1, N'Empleado')
GO
INSERT [dbo].[Persona] ([id_persona], [nombre], [apellido], [email], [telefono], [direccion], [fecha_nacimiento], [contrasena], [estado], [tipo_persona]) VALUES (8, N'Juan', N'Pérez', N'cliente@correo.com', N'87777777', N'Alajuela', CAST(N'1995-05-10' AS Date), N'cliente123', 1, N'Cliente')
GO
SET IDENTITY_INSERT [dbo].[Persona] OFF
GO

SET IDENTITY_INSERT [dbo].[Categorias] ON 
GO
INSERT [dbo].[Categorias] ([id_categoria], [nombre], [descripcion], [estado]) VALUES (1, N'Operativo', N'Todo aquello que requiera mano de obra no especializada y se realiza por un periodo definido.', 1)
GO
INSERT [dbo].[Categorias] ([id_categoria], [nombre], [descripcion], [estado]) VALUES (2, N'Recreativo', N'Todo aquello que implica uso de instalaciones dentro del condominio por un tiempo definido.', 1)
GO
INSERT [dbo].[Categorias] ([id_categoria], [nombre], [descripcion], [estado]) VALUES (3, N'Básicos', N'Todos aquellos servicios que son de uso permanente dentro del condominio.', 1)
GO
INSERT [dbo].[Categorias] ([id_categoria], [nombre], [descripcion], [estado]) VALUES (4, N'Administrativo', N'Servicios de personal con funciones en el condominio que se encuentra en planilla.', 0)
GO
-----
INSERT [dbo].[Categorias] ([id_categoria], [nombre], [descripcion], [estado]) VALUES (5, N'Mantenimiento', N'Reparaciones y mantenimiento preventivo de las áreas comunes.', 1)
GO
SET IDENTITY_INSERT [dbo].[Categorias] OFF
GO

SET IDENTITY_INSERT [dbo].[Servicios] ON 
GO
INSERT [dbo].[Servicios] ([id_servicio], [nombre], [descripcion], [precio], [id_categoria], [estado]) VALUES (1, N'Seguridad', N'Servicio de vigilancia en el condominio 24/7.', CAST(15000.00 AS Decimal(10, 2)), 1, 1)
GO
INSERT [dbo].[Servicios] ([id_servicio], [nombre], [descripcion], [precio], [id_categoria], [estado]) VALUES (2, N'Mantenimiento General', N'Servicio de limpieza y arreglos de instalaciones eléctricas y pluviales.', CAST(20000.00 AS Decimal(10, 2)), 1, 1)
GO
INSERT [dbo].[Servicios] ([id_servicio], [nombre], [descripcion], [precio], [id_categoria], [estado]) VALUES (3, N'Cortar Zacate', N'Servicio de limpieza y orden en las áreas verdes.', CAST(7000.00 AS Decimal(10, 2)), 1, 1)
GO
INSERT [dbo].[Servicios] ([id_servicio], [nombre], [descripcion], [precio], [id_categoria], [estado]) VALUES (4, N'Gimnasio', N'Servicio de uso de las instalaciones del gimnasio.', CAST(25000.00 AS Decimal(10, 2)), 2, 1)
GO
INSERT [dbo].[Servicios] ([id_servicio], [nombre], [descripcion], [precio], [id_categoria], [estado]) VALUES (5, N'Piscinas', N'Servicio de uso de las piscinas del condominio por mes.', CAST(5000.00 AS Decimal(10, 2)), 2, 1)
GO
INSERT [dbo].[Servicios] ([id_servicio], [nombre], [descripcion], [precio], [id_categoria], [estado]) VALUES (6, N'Canchas', N'Servicio de uso de las canchas.', CAST(20000.00 AS Decimal(10, 2)), 2, 0)
GO
INSERT [dbo].[Servicios] ([id_servicio], [nombre], [descripcion], [precio], [id_categoria], [estado]) VALUES (7, N'Salón Multiuso', N'Servicio de uso del salón del condominio.', CAST(50000.00 AS Decimal(10, 2)), 2, 1)
GO
INSERT [dbo].[Servicios] ([id_servicio], [nombre], [descripcion], [precio], [id_categoria], [estado]) VALUES (8, N'Agua', N'Servicio de agua.', CAST(3500.00 AS Decimal(10, 2)), 3, 1)
GO
INSERT [dbo].[Servicios] ([id_servicio], [nombre], [descripcion], [precio], [id_categoria], [estado]) VALUES (9, N'Luz', N'Servicio de luz.', CAST(20000.00 AS Decimal(10, 2)), 3, 1)
GO
INSERT [dbo].[Servicios] ([id_servicio], [nombre], [descripcion], [precio], [id_categoria], [estado]) VALUES (10, N'Internet', N'Servicio de uso del internet.', CAST(30000.00 AS Decimal(10, 2)), 3, 1)
GO
SET IDENTITY_INSERT [dbo].[Servicios] OFF
GO
----------

SET ANSI_PADDING ON
GO

ALTER TABLE [dbo].[Persona] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
-- El nombre de la casa no puede repetirse
ALTER TABLE [dbo].[Casas] ADD UNIQUE NONCLUSTERED 
(
	[nombre_casa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Categorias] ADD  DEFAULT ((1)) FOR [estado]
GO
ALTER TABLE [dbo].[Persona] ADD  DEFAULT ((1)) FOR [estado]
GO
ALTER TABLE [dbo].[Servicios] ADD  DEFAULT ((1)) FOR [estado]
GO
ALTER TABLE [dbo].[Casas] ADD  DEFAULT ((1)) FOR [estado]
GO
ALTER TABLE [dbo].[Cobros] ADD  DEFAULT ('Pendiente') FOR [estado]
GO
ALTER TABLE [dbo].[Bitacora] ADD  DEFAULT (getdate()) FOR [fecha]
GO

ALTER TABLE [dbo].[Servicios]  WITH CHECK ADD FOREIGN KEY([id_categoria])
REFERENCES [dbo].[Categorias] ([id_categoria])
GO
ALTER TABLE [dbo].[Casas]  WITH CHECK ADD FOREIGN KEY([id_persona])
REFERENCES [dbo].[Persona] ([id_persona])
GO
ALTER TABLE [dbo].[Cobros]  WITH CHECK ADD FOREIGN KEY([id_casa])
REFERENCES [dbo].[Casas] ([id_casa])
GO
ALTER TABLE [dbo].[Bitacora]  WITH CHECK ADD FOREIGN KEY([id_cobro])
REFERENCES [dbo].[Cobros] ([id_cobro])
GO
ALTER TABLE [dbo].[Bitacora]  WITH CHECK ADD FOREIGN KEY([id_user])
REFERENCES [dbo].[Persona] ([id_persona])
GO
-- Cobros.id_bitacora es NULL al crear el cobro; luego se actualiza con el registro de bitacora
ALTER TABLE [dbo].[Cobros]  WITH CHECK ADD FOREIGN KEY([id_bitacora])
REFERENCES [dbo].[Bitacora] ([id_bitacora])
GO
ALTER TABLE [dbo].[DetalleCobro]  WITH CHECK ADD FOREIGN KEY([id_servicio])
REFERENCES [dbo].[Servicios] ([id_servicio])
GO
ALTER TABLE [dbo].[DetalleCobro]  WITH CHECK ADD FOREIGN KEY([id_cobro])
REFERENCES [dbo].[Cobros] ([id_cobro])
GO

----

SET IDENTITY_INSERT [dbo].[Casas] ON 
GO
INSERT [dbo].[Casas] ([id_casa], [nombre_casa], [metros_cuadrados], [numero_habitaciones], [numero_banos], [precio], [id_persona], [fecha_construccion], [estado]) VALUES
(1, N'A1',   120, 3, 2, 37061440.00, 1, CAST(N'1995-03-15' AS Date), 1),
(2, N'A2',    95, 2, 1, 24548640.00, 2, CAST(N'1982-07-20' AS Date), 1),
(3, N'B1',   150, 4, 3, 49576800.00, 8, CAST(N'2012-11-05' AS Date), 1),
(4, N'B2',    80, 2, 2, 35040960.00, 1, CAST(N'2005-01-10' AS Date), 1),
(5, N'C101', 200, 5, 3, 51602400.00, 5, CAST(N'2018-06-30' AS Date), 1),
(6, N'C102', 110, 3, 2, 27056320.00, 2, CAST(N'1975-09-12' AS Date), 0)
GO
SET IDENTITY_INSERT [dbo].[Casas] OFF
GO

-- Monto = (precio de la casa / metros cuadrados) + precio de cada servicio seleccionado
SET IDENTITY_INSERT [dbo].[Cobros] ON 
GO
INSERT [dbo].[Cobros] ([id_cobro], [id_casa], [mes], [anno], [id_bitacora], [estado], [monto], [fecha_pagada]) VALUES
(1, 1, 10, 2024, NULL, 'Pagado',    347345.33, CAST(N'2024-10-15' AS Date)),  
(2, 2, 11, 2024, NULL, 'Pendiente', 288406.74, NULL),                         
(3, 3, 11, 2024, NULL, 'Pagado',    384012.00, CAST(N'2024-11-20' AS Date)),   
(4, 4, 12, 2024, NULL, 'Pendiente', 460012.00, NULL),                          
(5, 5, 12, 2024, NULL, 'Eliminado', 328012.00, NULL),                          
(6, 1,  1, 2027, NULL, 'Pendiente', 353845.33, NULL),                          
(7, 3,  2, 2027, NULL, 'Pendiente', 354012.00, NULL)                           
GO
SET IDENTITY_INSERT [dbo].[Cobros] OFF
GO

INSERT [dbo].[DetalleCobro] ([id_servicio], [id_cobro]) VALUES
(1,1),(8,1),(9,1),
(4,2),(5,2),
(8,3),(9,3),(10,3),
(1,4),(3,4),
(2,5),(7,5),
(1,6),(10,6),
(8,7),(9,7)
GO

SET IDENTITY_INSERT [dbo].[Bitacora] ON 
GO
INSERT [dbo].[Bitacora] ([id_bitacora], [detalle], [id_cobro], [id_user], [fecha]) VALUES
(1, 'CREACION - Se crea el cobro de octubre 2024 de la casa A1 con los servicios Seguridad, Agua y Luz.', 1, 5, '20241001 09:00'),
(2, 'PAGADO - Se cancela el cobro de octubre 2024 de la casa A1.', 1, 1, '20241015 14:30'),
(3, 'CREACION - Se crea el cobro de noviembre 2024 de la casa A2 con los servicios Gimnasio y Piscinas.', 2, 2, '20241102 10:15'),
(4, 'CREACION - Se crea el cobro de noviembre 2024 de la casa B1 con los servicios Agua, Luz e Internet.', 3, 6, '20241103 11:00'),
(5, 'PAGADO - Se cancela el cobro de noviembre 2024 de la casa B1.', 3, 6, '20241120 16:45'),
(6, 'CREACION - Se crea el cobro de diciembre 2024 de la casa B2 con los servicios Seguridad y Cortar Zacate.', 4, 5, '20241201 08:30'),
(7, 'CREACION - Se crea el cobro de diciembre 2024 de la casa C101 con Mantenimiento General y Salón Multiuso.', 5, 6, '20241202 09:20'),
(8, 'ELIMINACION - Se elimina el cobro de diciembre 2024 de la casa C101.', 5, 5, '20241205 13:10'),
(9, 'CREACION - Se crea el cobro de enero 2027 de la casa A1 con los servicios Seguridad e Internet.', 6, 1, '20261110 10:00'),
(10, 'CREACION - Se crea el cobro de febrero 2027 de la casa B1 con los servicios Agua y Luz.', 7, 8, '20261111 15:20'),
(11, 'MODIFICACION - Se modifican los servicios del cobro de enero 2027 de la casa A1: Seguridad e Internet.', 6, 5, '20261112 09:05')
GO
SET IDENTITY_INSERT [dbo].[Bitacora] OFF
GO

-- Cada cobro apunta a su primer registro de bitacora (la CREACION)
UPDATE c
SET c.id_bitacora = (SELECT MIN(b.id_bitacora) FROM [dbo].[Bitacora] b WHERE b.id_cobro = c.id_cobro)
FROM [dbo].[Cobros] c
GO

---PROCEDIMIENTOS ALMACENADOS

-- SELECT 1: Cobros de una persona, con el nombre de la casa (Cobros + Casas + Persona)

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ObtenerCobrosPorPersona]
	@id_persona INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		c.id_cobro,
		ca.nombre_casa,
		c.mes,
		c.anno,
		c.monto,
		c.estado,
		c.fecha_pagada
	FROM [dbo].[Cobros] c
	INNER JOIN [dbo].[Casas] ca ON c.id_casa = ca.id_casa
	INNER JOIN [dbo].[Persona] p ON ca.id_persona = p.id_persona
	WHERE p.id_persona = @id_persona
	ORDER BY c.anno DESC, c.mes DESC;
END
GO
--

-- SELECT 2: Servicios de una categoria, mostrando el nombre de la categoria (Servicios + Categorias)

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ObtenerServiciosPorCategoria]
	@id_categoria INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		s.id_servicio,
		s.nombre,
		s.descripcion,
		s.precio,
		cat.nombre AS categoria,
		s.estado
	FROM [dbo].[Servicios] s
	INNER JOIN [dbo].[Categorias] cat ON s.id_categoria = cat.id_categoria
	WHERE cat.id_categoria = @id_categoria
	ORDER BY s.nombre;
END
GO

--
-- Objeto: StoredProcedure [dbo].[sp_insertCasa] 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_insertCasa]
    @nombre NVARCHAR(255),
    @metros INT,
    @habitaciones INT,
    @banos INT,
    @id_cliente INT,
    @fecha DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @anno INT = YEAR(@fecha);
    DECLARE @base DECIMAL(15, 2);

    IF EXISTS (SELECT 1 FROM dbo.Casas WHERE nombre_casa = LTRIM(RTRIM(@nombre)))
        THROW 50040, 'Ya existe una casa con ese nombre.', 1;

    IF @metros <= 0 OR @habitaciones NOT BETWEEN 1 AND 8 OR @banos NOT BETWEEN 1 AND 4
        THROW 50041, 'Los datos de la casa no son válidos.', 1;

    SET @base = CASE
        WHEN @anno BETWEEN 1970 AND 1989 THEN 20000000
        WHEN @anno BETWEEN 1990 AND 2009 THEN 30000000
        WHEN @anno BETWEEN 2010 AND 2029 THEN 40000000
        ELSE NULL END;

    IF @base IS NULL
        THROW 50042, 'La fecha de construcción debe estar entre 1970 y 2029.', 1;

    INSERT INTO dbo.Casas (nombre_casa, metros_cuadrados, numero_habitaciones, numero_banos,
                           precio, id_persona, fecha_construccion, estado)
    VALUES (LTRIM(RTRIM(@nombre)), @metros, @habitaciones, @banos,
            @base + (@metros * 512) + (@habitaciones * 2000000) + (@banos * 500000),
            @id_cliente, @fecha, 1);
END
GO


-- INSERT 2: Registrar un cobro nuevo (queda 'Pendiente')
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertarCobro]
	@id_casa INT,
	@mes INT,
	@anno INT,
	@monto DECIMAL(15, 2),
	@id_bitacora INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[Cobros]
		([id_casa], [mes], [anno], [id_bitacora], [estado], [monto], [fecha_pagada])
	VALUES
		(@id_casa, @mes, @anno, @id_bitacora, 'Pendiente', @monto, NULL);

	SELECT SCOPE_IDENTITY() AS id_cobro_creado;
END
GO
--
-- UPDATE 1: Cambiar el estado de un cobro ('Pagado' o 'Eliminado')

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ActualizarEstadoCobro]
	@id_cobro INT,
	@estado VARCHAR(50),
	@fecha_pagada DATE = NULL
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[Cobros]
	SET
		[estado] = @estado,
		[fecha_pagada] = ISNULL(@fecha_pagada, [fecha_pagada])
	WHERE [id_cobro] = @id_cobro;
END
GO
--

-- UPDATE 2: Actualizar el precio de un servicio

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ActualizarPrecioServicio]
	@id_servicio INT,
	@precio DECIMAL(10, 2)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[Servicios]
	SET [precio] = @precio
	WHERE [id_servicio] = @id_servicio;
END
GO

--------------------------------------
--------------------------------------
----RF-001----------------------------
--------------------------------------
--------------------------------------
CREATE PROCEDURE [dbo].[sp_Login]
    @email      VARCHAR(150),
    @contrasena VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        id_persona,
        nombre + ' ' + apellido AS nombre_completo,
        email,
        CAST(CASE WHEN tipo_persona = 'Empleado' THEN 1 ELSE 0 END AS BIT) AS es_empleado
    FROM Persona
    WHERE email = @email
      AND contrasena = @contrasena
      AND estado = 1;
END
GO
--------------------------------------
--------------------------------------
----RF-002----------------------------
--------------------------------------
--------------------------------------
CREATE PROCEDURE [dbo].[sp_ListarCobros]
    @id_persona INT = NULL,
    @mes        INT = NULL,
    @anno       INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        c.id_cobro AS IdCobro,
        p.nombre + ' ' + p.apellido AS Cliente,
        ca.nombre_casa AS Casa,
        RIGHT('0' + CAST(c.mes AS VARCHAR(2)), 2) + '-' + CAST(c.anno AS VARCHAR(4)) AS Periodo,
        c.estado AS Estado
    FROM Cobros c
    INNER JOIN Casas ca ON c.id_casa = ca.id_casa
    INNER JOIN Persona p ON ca.id_persona = p.id_persona
    WHERE (@id_persona IS NULL OR p.id_persona = @id_persona)
      AND (@mes  IS NULL OR c.mes  = @mes)
      AND (@anno IS NULL OR c.anno = @anno)
    ORDER BY c.anno DESC, c.mes DESC, c.id_cobro DESC;
END
GO
---
-- Lista desplegable del filtro: usuarios activos, ordenados por nombre
CREATE PROCEDURE [dbo].[sp_ListarPersonasActivas]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT p.id_persona AS Id, p.nombre + ' ' + p.apellido AS Nombre
    FROM Persona p
    WHERE p.estado = 1
    ORDER BY p.nombre, p.apellido;
END
GO

------Datos del cobro para el modal de detalle--

CREATE PROCEDURE [dbo].[sp_ObtenerDetalleCobro]
	@id_cobro INT 
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		c.id_cobro AS IdCobro,
		ca.id_persona AS IdPersona,
		ca.nombre_casa AS Casa,
		p.nombre + ' ' + p.apellido AS Cliente,
		c.mes AS Mes,
		c.anno AS Anno,
		c.estado AS Estado,
		c.fecha_pagada AS FechaPagada,
		c.monto AS Monto

	FROM Cobros c
	INNER JOIN Casas ca on c.id_casa= ca.id_casa
	INNER JOIN Persona p ON ca.id_persona = p.id_persona
	WHERE c.id_cobro = @id_cobro


END
GO
------ servicio incluido en el cobro-----

CREATE OR Alter PROCEDURE [dbo].[sp_ObtenerServiciosPorCobro]
	@id_cobro INT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
		s.id_servicio AS IdServicio,
		s.nombre AS Nombre,
		s.precio AS Precio
	FROM DetalleCobro d
	INNER JOIN Servicios s on d.id_servicio= s.id_servicio
	WHERE d.id_cobro = @id_cobro
	ORDER BY s.nombre;
		

END
GO
----------bitacora del cobro, descendente por id de bitacora----
CREATE PROCEDURE [dbo].[sp_ObtenerBitacoraPorCobro]
	@id_cobro INT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
		b.id_bitacora AS IdBitacora,
		b.fecha AS Fecha,
		b.detalle AS Detalle,
		p.nombre + ' ' + p.apellido AS Persona
	FROM Bitacora b
	INNER JOIN Persona p on b.id_user = p.id_persona
	WHERE b.id_cobro = @id_cobro
	ORDER BY b.id_bitacora desc;
		
		
END
GO

/*CREATE PROCEDURE [dbo].[sp_ObtenerBitacoraPorCobro]
	@id_cobro INT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
		b.id_bitacora AS IdBitacora,
		b.fecha AS Fecha,
		b.detalle AS Detalle,
		p.nombre + ' ' + p.apellido AS Persona
	FROM Bitacora b
	INNER JOIN Persona p on b.id_user = p.id_persona
	WHERE b.id_cobro = @id_cobro
	ORDER BY b.id_bitacora desc;
		
		
END
GO*/

-------------Agregar a base de datos----------------
USE [PVI_ProyectoFinal]
GO

CREATE PROCEDURE [dbo].[sp_ReadServicios]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT s.id_servicio AS Id_servicio, s.nombre AS Nombre, s.descripcion AS Descripcion,
           s.precio AS Precio, c.nombre AS Categoria, s.estado AS Estado
    FROM dbo.Servicios s
    INNER JOIN dbo.Categorias c ON s.id_categoria = c.id_categoria
    ORDER BY s.nombre;
END
GO

CREATE PROCEDURE [dbo].[sp_ReadServicioById]
    @id_servicio INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT s.id_servicio AS Id_servicio, s.nombre AS Nombre, s.descripcion AS Descripcion,
           s.precio AS Precio, s.id_categoria AS Id_categoria, c.nombre AS Categoria,
           s.estado AS Estado
    FROM dbo.Servicios s
    INNER JOIN dbo.Categorias c ON s.id_categoria = c.id_categoria
    WHERE s.id_servicio = @id_servicio;
END
GO

CREATE PROCEDURE [dbo].[sp_InsertServicio]
    @nombre VARCHAR(100),
    @descripcion NVARCHAR(MAX),
    @precio DECIMAL(10, 2),
    @id_categoria INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Servicios (nombre, descripcion, precio, id_categoria, estado)
    VALUES (@nombre, @descripcion, @precio, @id_categoria, 1);
END
GO

CREATE PROCEDURE [dbo].[sp_UpdateServicio]
    @id_servicio INT,
    @descripcion NVARCHAR(MAX),
    @precio DECIMAL(10, 2)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Servicios
    SET descripcion = @descripcion,
        precio = @precio
    WHERE id_servicio = @id_servicio;
END
GO

CREATE PROCEDURE [dbo].[sp_InactivarServicio]
    @id_servicio INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Servicios
    SET estado = 0
    WHERE id_servicio = @id_servicio;
END
GO

CREATE PROCEDURE [dbo].[sp_ReadCategorias]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_categoria AS IdCategoria, nombre AS Nombre
    FROM dbo.Categorias
    WHERE estado = 1
    ORDER BY nombre;
END
GO

CREATE PROCEDURE [dbo].[sp_ReadServiciosByCliente]
    @id_persona INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT s.id_servicio AS Id_servicio, s.nombre AS Nombre, s.descripcion AS Descripcion,
           s.precio AS Precio, c.nombre AS Categoria
    FROM dbo.Servicios s
    INNER JOIN dbo.Categorias c ON s.id_categoria = c.id_categoria
    WHERE EXISTS (
        SELECT 1
        FROM dbo.DetalleCobro d
        INNER JOIN dbo.Cobros co ON d.id_cobro = co.id_cobro
        INNER JOIN dbo.Casas ca ON co.id_casa = ca.id_casa
        WHERE d.id_servicio = s.id_servicio
          AND ca.id_persona = @id_persona
    )
    ORDER BY s.nombre;
END
GO

-------------2 Agregar a base de datos----------------
USE PVI_ProyectoFinal;
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_ListarCasasPorPersona]
    @id_persona INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_casa AS IdCasa, nombre_casa AS NombreCasa
    FROM dbo.Casas
    WHERE id_persona = @id_persona AND estado = 1
    ORDER BY nombre_casa;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_ObtenerCasaPorId]
    @id_casa INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_casa AS IdCasa, nombre_casa AS NombreCasa, id_persona AS IdPersona,
           metros_cuadrados AS MetrosCuadrados, precio AS Precio
    FROM dbo.Casas
    WHERE id_casa = @id_casa;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_ExisteCobroPendiente]
    @id_casa INT,
    @mes INT,
    @anno INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COUNT(*) AS Cantidad
    FROM dbo.Cobros
    WHERE id_casa = @id_casa AND mes = @mes AND anno = @anno AND estado = 'Pendiente';
END
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_ObtenerCobroBase]
    @id_cobro INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.id_cobro AS IdCobro, c.id_casa AS IdCasa, ca.nombre_casa AS NombreCasa,
           ca.id_persona AS IdPersona, c.mes AS Mes, c.anno AS Anno, c.estado AS Estado,
           ca.precio AS PrecioCasa, ca.metros_cuadrados AS MetrosCuadrados, c.monto AS Monto
    FROM dbo.Cobros c
    INNER JOIN dbo.Casas ca ON ca.id_casa = c.id_casa
    WHERE c.id_cobro = @id_cobro;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_InsertarDetalleCobro]
    @id_servicio INT,
    @id_cobro INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.DetalleCobro (id_servicio, id_cobro) VALUES (@id_servicio, @id_cobro);
END
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_EliminarDetalleCobro]
    @id_cobro INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.DetalleCobro WHERE id_cobro = @id_cobro;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_ActualizarMontoCobro]
    @id_cobro INT,
    @monto DECIMAL(15,2)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Cobros SET monto = @monto WHERE id_cobro = @id_cobro;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_InsertarBitacora]
    @detalle VARCHAR(255),
    @id_cobro INT,
    @id_user INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Bitacora (detalle, id_cobro, id_user, fecha)
    VALUES (@detalle, @id_cobro, @id_user, GETDATE());
END
GO

--Rf00-7 casas--
CREATE PROCEDURE dbo.sp_readCasas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT c.id_casa, c.nombre_casa, c.metros_cuadrados, c.numero_habitaciones,
           c.numero_banos, c.id_persona AS NumeroPropietario,
           c.fecha_construccion, c.estado
    FROM dbo.Casas c
    ORDER BY c.nombre_casa ASC;
END
GO

exec sp_readCasas;