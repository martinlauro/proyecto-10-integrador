-- ================================================
-- PROYECTO 10: Sistema de Análisis de Ventas
-- Proyecto Integrador — SQL + Python + Power BI
-- Autor: Martin Lauro
-- Base de datos: SQL Server
-- ================================================

-- 1. CREAR BASE DE DATOS
CREATE DATABASE integrador_analytics;
GO
USE integrador_analytics;
GO

-- ================================================
-- 2. CREAR TABLAS
-- ================================================

CREATE TABLE regiones (
    id_region    INT PRIMARY KEY IDENTITY(1,1),
    nombre       VARCHAR(50) NOT NULL,
    pais         VARCHAR(50) NOT NULL
);

CREATE TABLE categorias (
    id_categoria  INT PRIMARY KEY IDENTITY(1,1),
    nombre        VARCHAR(50) NOT NULL
);

CREATE TABLE productos (
    id_producto   INT PRIMARY KEY IDENTITY(1,1),
    codigo        VARCHAR(20) NOT NULL UNIQUE,
    nombre        VARCHAR(100) NOT NULL,
    id_categoria  INT NOT NULL,
    precio_costo  DECIMAL(10,2) NOT NULL,
    precio_venta  DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE vendedores (
    id_vendedor   INT PRIMARY KEY IDENTITY(1,1),
    nombre        VARCHAR(50) NOT NULL,
    apellido      VARCHAR(50) NOT NULL,
    id_region     INT NOT NULL,
    meta_mensual  DECIMAL(10,2),
    FOREIGN KEY (id_region) REFERENCES regiones(id_region)
);

CREATE TABLE clientes (
    id_cliente    INT PRIMARY KEY IDENTITY(1,1),
    razon_social  VARCHAR(100) NOT NULL,
    id_region     INT NOT NULL,
    segmento      VARCHAR(20) CHECK (segmento IN ('Premium','Estándar','Básico')),
    FOREIGN KEY (id_region) REFERENCES regiones(id_region)
);

CREATE TABLE ventas (
    id_venta      INT PRIMARY KEY IDENTITY(1,1),
    id_cliente    INT NOT NULL,
    id_vendedor   INT NOT NULL,
    fecha         DATE NOT NULL,
    FOREIGN KEY (id_cliente)  REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor)
);

CREATE TABLE venta_detalle (
    id_detalle    INT PRIMARY KEY IDENTITY(1,1),
    id_venta      INT NOT NULL,
    id_producto   INT NOT NULL,
    cantidad      INT NOT NULL,
    precio_venta  DECIMAL(10,2) NOT NULL,
    precio_costo  DECIMAL(10,2) NOT NULL,
    subtotal      AS (cantidad * precio_venta),
    costo         AS (cantidad * precio_costo),
    FOREIGN KEY (id_venta)    REFERENCES ventas(id_venta),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- ================================================
-- 3. INSERTAR DATOS
-- ================================================

INSERT INTO regiones (nombre, pais) VALUES
('Buenos Aires', 'Argentina'),
('Córdoba',      'Argentina'),
('Rosario',      'Argentina'),
('Madrid',       'España'),
('Barcelona',    'España');

INSERT INTO categorias (nombre) VALUES
('Electrónica'),('Software'),('Servicios'),('Mobiliario'),('Insumos');

INSERT INTO productos (codigo, nombre, id_categoria, precio_costo, precio_venta) VALUES
('ELEC001', 'Notebook HP 15"',          1, 150000, 220000),
('ELEC002', 'Monitor 24" Full HD',      1,  80000, 120000),
('ELEC003', 'Teclado + Mouse Wireless', 1,  15000,  28000),
('SOFT001', 'Licencia Office 365',      2,  12000,  22000),
('SOFT002', 'Antivirus Empresarial',    2,   8000,  15000),
('SERV001', 'Consultoría IT (hora)',    3,   5000,  12000),
('SERV002', 'Soporte Técnico (hora)',   3,   3000,   8000),
('MOBI001', 'Silla Ergonómica',         4,  45000,  75000),
('MOBI002', 'Escritorio Regulable',     4,  60000,  95000),
('INSU001', 'Resma A4 x500',            5,   1200,   2500);

INSERT INTO clientes (razon_social, id_region, segmento) VALUES
('Grupo Techno SA',        1, 'Premium'),
('Distribuidora Norte',    2, 'Estándar'),
('Servicios del Sur SRL',  3, 'Estándar'),
('Madrid Digital SL',      4, 'Premium'),
('Barcelona Tech SL',      5, 'Premium'),
('Consultora ABC',         1, 'Básico'),
('Industrias del Este SA', 2, 'Premium'),
('Retail Moderno SRL',     3, 'Estándar'),
('Tech Startup Madrid',    4, 'Básico'),
('Corporación Norte',      1, 'Premium');

INSERT INTO vendedores (nombre, apellido, id_region, meta_mensual) VALUES
('Lucas',    'García',    1, 800000),
('Martina',  'López',     2, 600000),
('Santiago', 'Pérez',     3, 600000),
('Carlos',   'Rodríguez', 4, 700000),
('Ana',      'Martínez',  5, 700000);

INSERT INTO ventas (id_cliente, id_vendedor, fecha) VALUES
(1,1,'2026-01-05'),(2,2,'2026-01-08'),(3,3,'2026-01-10'),
(4,4,'2026-01-12'),(5,5,'2026-01-15'),(6,1,'2026-01-18'),
(7,2,'2026-01-20'),(8,3,'2026-01-22'),(9,4,'2026-01-25'),
(10,5,'2026-01-28'),(1,1,'2026-02-03'),(2,2,'2026-02-06'),
(3,3,'2026-02-10'),(4,4,'2026-02-12'),(5,5,'2026-02-15'),
(6,1,'2026-02-18'),(7,2,'2026-02-20'),(8,3,'2026-02-24'),
(9,4,'2026-02-26'),(10,5,'2026-03-01'),(1,1,'2026-03-05'),
(2,2,'2026-03-08'),(3,3,'2026-03-10'),(4,4,'2026-03-12'),
(5,5,'2026-03-15'),(6,1,'2026-03-18'),(7,2,'2026-03-20'),
(8,3,'2026-03-22'),(9,4,'2026-03-25'),(10,5,'2026-03-28'),
(1,1,'2026-04-02'),(2,2,'2026-04-05'),(3,3,'2026-04-08'),
(4,4,'2026-04-10'),(5,5,'2026-04-14'),(6,1,'2026-04-16'),
(7,2,'2026-04-18'),(8,3,'2026-04-22'),(9,4,'2026-04-24'),
(10,5,'2026-04-28'),(1,1,'2026-05-02'),(2,2,'2026-05-05'),
(3,3,'2026-05-08'),(4,4,'2026-05-10'),(5,5,'2026-05-12'),
(6,1,'2026-05-14'),(7,2,'2026-05-16'),(8,3,'2026-05-18'),
(9,4,'2026-05-20'),(10,5,'2026-05-22');

INSERT INTO venta_detalle (id_venta, id_producto, cantidad, precio_venta, precio_costo) VALUES
(1,1,1,220000,150000),(1,4,2,22000,12000),(2,2,1,120000,80000),
(3,3,3,28000,15000),(4,1,2,220000,150000),(4,8,1,75000,45000),
(5,5,5,15000,8000),(6,6,4,12000,5000),(7,2,1,120000,80000),
(7,9,1,95000,60000),(8,3,2,28000,15000),(9,4,3,22000,12000),
(10,1,1,220000,150000),(10,7,2,8000,3000),(11,1,1,220000,150000),
(11,4,1,22000,12000),(12,2,2,120000,80000),(13,3,4,28000,15000),
(14,1,1,220000,150000),(14,5,3,15000,8000),(15,8,2,75000,45000),
(16,6,5,12000,5000),(17,2,1,120000,80000),(18,3,2,28000,15000),
(19,9,1,95000,60000),(20,1,2,220000,150000),(21,4,4,22000,12000),
(22,2,1,120000,80000),(23,1,1,220000,150000),(24,5,5,15000,8000),
(25,8,1,75000,45000),(26,6,3,12000,5000),(27,2,2,120000,80000),
(28,3,3,28000,15000),(29,7,4,8000,3000),(30,1,1,220000,150000),
(31,4,2,22000,12000),(32,2,1,120000,80000),(33,9,1,95000,60000),
(34,1,2,220000,150000),(35,5,3,15000,8000),(36,6,4,12000,5000),
(37,8,1,75000,45000),(38,3,2,28000,15000),(39,4,3,22000,12000),
(40,1,1,220000,150000),(41,2,2,120000,80000),(42,7,5,8000,3000),
(43,1,1,220000,150000),(44,5,4,15000,8000),(45,8,2,75000,45000),
(46,6,3,12000,5000),(47,2,1,120000,80000),(48,3,4,28000,15000),
(49,9,1,95000,60000),(50,1,2,220000,150000);

-- ================================================
-- 4. VIEWS
-- ================================================

GO
CREATE VIEW vw_ventas AS
SELECT
    v.id_venta,
    v.fecha,
    YEAR(v.fecha)                  AS anio,
    MONTH(v.fecha)                 AS mes,
    DATENAME(MONTH, v.fecha)       AS nombre_mes,
    c.razon_social                 AS cliente,
    c.segmento,
    r.nombre                       AS region,
    r.pais,
    vd.nombre + ' ' + vd.apellido  AS vendedor,
    p.nombre                       AS producto,
    cat.nombre                     AS categoria,
    vdet.cantidad,
    vdet.subtotal                  AS ingreso,
    vdet.costo,
    vdet.subtotal - vdet.costo     AS ganancia,
    CAST((vdet.subtotal - vdet.costo) * 100.0
         / vdet.subtotal AS DECIMAL(5,2)) AS margen_pct
FROM ventas v
JOIN clientes c         ON v.id_cliente    = c.id_cliente
JOIN regiones r         ON c.id_region     = r.id_region
JOIN vendedores vd      ON v.id_vendedor   = vd.id_vendedor
JOIN venta_detalle vdet ON v.id_venta      = vdet.id_venta
JOIN productos p        ON vdet.id_producto = p.id_producto
JOIN categorias cat     ON p.id_categoria  = cat.id_categoria;

GO
CREATE VIEW vw_vendedores AS
SELECT
    vd.nombre + ' ' + vd.apellido  AS vendedor,
    r.nombre                        AS region,
    r.pais,
    COUNT(DISTINCT v.id_venta)      AS total_ventas,
    SUM(vdet.subtotal)              AS ingresos,
    SUM(vdet.subtotal - vdet.costo) AS ganancia,
    vd.meta_mensual
FROM vendedores vd
JOIN regiones r         ON vd.id_region    = r.id_region
JOIN ventas v           ON v.id_vendedor   = vd.id_vendedor
JOIN venta_detalle vdet ON v.id_venta      = vdet.id_venta
GROUP BY vd.nombre, vd.apellido, r.nombre, r.pais, vd.meta_mensual;

-- ================================================
-- 5. CONSULTAS DE ANÁLISIS
-- ================================================

-- Ranking vendedores vs meta
SELECT
    vendedor, region, ingresos,
    meta_mensual * 5 AS meta_total,
    CAST(ingresos * 100.0 / (meta_mensual * 5) AS DECIMAL(5,2)) AS cumplimiento_pct,
    CASE
        WHEN ingresos >= meta_mensual * 5 THEN 'Meta cumplida'
        WHEN ingresos >= meta_mensual * 4 THEN 'Cerca de meta'
        ELSE 'Bajo rendimiento'
    END AS estado
FROM vw_vendedores
ORDER BY cumplimiento_pct DESC;

-- Top productos por ganancia
SELECT
    categoria, producto,
    SUM(cantidad)   AS unidades,
    SUM(ingreso)    AS ingresos,
    SUM(ganancia)   AS ganancia,
    AVG(margen_pct) AS margen_prom
FROM vw_ventas
GROUP BY categoria, producto
ORDER BY ganancia DESC;

-- Ventas por región y mes
SELECT
    pais, region, nombre_mes, mes,
    SUM(ingreso)  AS ingresos,
    SUM(ganancia) AS ganancia
FROM vw_ventas
GROUP BY pais, region, nombre_mes, mes
ORDER BY pais, mes;