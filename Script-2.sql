DROP SCHEMA IF EXISTS GestionConciertos;
CREATE DATABASE GestionConciertos;
USE GestionConciertos;

CREATE TABLE bandas (
    id_banda INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    genero VARCHAR(50),
    pais_origen VARCHAR(50)
);

CREATE TABLE conciertos (
    id_concierto INT AUTO_INCREMENT PRIMARY KEY,
    id_banda INT NOT NULL,
    fecha DATE NOT NULL,
    lugar VARCHAR(100),
    capacidad INT,
    FOREIGN KEY (id_banda) REFERENCES bandas(id_banda)
);

CREATE TABLE asistentes (
    id_asistente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    edad INT NOT NULL,
    email VARCHAR(100),
    telefono VARCHAR(15),
    pais_origen VARCHAR(50)
);

CREATE TABLE ventas_entradas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_concierto INT NOT NULL,
    id_asistente INT NOT NULL,
    precio DECIMAL(10, 2),
    fecha_compra DATE NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    FOREIGN KEY (id_concierto) REFERENCES conciertos(id_concierto),
    FOREIGN KEY (id_asistente) REFERENCES asistentes(id_asistente)
);

CREATE TABLE patrocinadores (
    id_patrocinador INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    industria VARCHAR(50),
    contacto VARCHAR(100),
    id_concierto INT NOT NULL,
    FOREIGN KEY (id_concierto) REFERENCES conciertos(id_concierto)
);

CREATE TABLE ventas_merchandising (
    id_venta_merch INT AUTO_INCREMENT PRIMARY KEY,
    id_concierto INT NOT NULL,
    producto VARCHAR(100),
    cantidad INT,
    precio_unitario DECIMAL(10, 2),
    FOREIGN KEY (id_concierto) REFERENCES conciertos(id_concierto)
);

/* INSERTAMOS DATOS */
INSERT INTO bandas (nombre, genero, pais_origen)
VALUES
('GAMBARDELLA', 'HardJazz', 'SPAIN'),
('REBUIG', 'HardRock', 'SPAIN'),
('TWELVE', 'HardJazz', 'SPAIN'),
('PANTALEON', 'PsicoBoleros', 'SPAIN');

/* INSERTAMOS DATOS CONCIERTOS */
INSERT INTO conciertos (id_banda, fecha, lugar, capacidad)
VALUES
(1, '2024-05-01', 'Barcelona', 50000),
(2, '2023-07-15', 'Madrid', 50000),
(3, '2012-05-01', 'Huesca', 500),
(4, '2025-01-15', 'Galicia', 500);

/* DATOS ASISTENTES */
INSERT INTO asistentes (nombre, edad, email, telefono, pais_origen)
VALUES
('Juan Pérez', 15, 'juan.perez@example.com', '000000000', 'Spain'),
('Ana Gómez', 25, 'ana.gomez@example.com', '111111111', 'Polish'),
('Luis Torres', 22, 'luis.torres@example.com', '222222222', 'England');

/* DATOS VENTA DE ENTRADAS */
INSERT INTO ventas_entradas (id_concierto, id_asistente, precio, fecha_compra, cantidad)
VALUES
(1, 1, 120.00, '2025-04-01', 1),
(2, 2, 80.00, '2023-05-10', 1),
(3, 3, 50.00, '2011-11-01', 1),
(4, 3, 50.00, '2024-12-01', 1);

/* DATOS PATROCINADORES */
INSERT INTO patrocinadores (nombre, industria, contacto, id_concierto)
VALUES 
('Coca-Cola', 'Bebidas', 'contacto@coca-cola.com', 1),
('Sony Music', 'Entretenimiento', 'info@sonymusic.com', 2),
('Nike', 'Ropa Deportiva', 'marketing@nike.com', 3);

/* INSERTAMOS PRODUCTOS */
INSERT INTO ventas_merchandising (id_concierto, producto, cantidad, precio_unitario)
VALUES 
(1, 'Camiseta Rockers United', 50, 25.00),
(2, 'Gorra Electro Beats', 30, 20.00),
(3, 'CD Jazz Masters', 20, 15.00);

/* CONSULTA 1, LISTADO DE TODAS LAS BANDAS */
SELECT nombre, pais_origen
FROM bandas;

/* CONSULTA 2 ASISTENTES MENORES DE 30 AÑOS */
SELECT nombre, edad, email, telefono
FROM asistentes
WHERE edad < 30;

/* CONSULTA 3 BANDAS QUE HAN TOCADO EN MADRID */
SELECT b.nombre AS Banda
FROM bandas b
JOIN conciertos c ON b.id_banda = c.id_banda
WHERE c.lugar LIKE '%Madrid%';

/* CONSULTA 4 EN UNA FECHA ESPECÍFICA */
SELECT lugar, capacidad
FROM conciertos
WHERE fecha = '2025-01-15';

/* CONSULTA 5 CANTIDAD DE ENTRADAS CONCIERTO BARCELONA */
SELECT COUNT(*) AS EntradasVendidas
FROM ventas_entradas v
JOIN conciertos c ON v.id_concierto = c.id_concierto
WHERE c.lugar LIKE '%Barcelona%';

/* CONSULTA 6 PRECIO PROMEDIO DE ENTRADAS POR CONCIERTO CAMBIO TOKIO POR GALICIA */
SELECT AVG(v.precio) AS PrecioPromedio
FROM ventas_entradas v
JOIN conciertos c ON v.id_concierto = c.id_concierto
WHERE c.lugar LIKE '%Galicia%';

/* CONSULTA 7 Número de asistentes por país de origen */
SELECT pais_origen, COUNT(*) AS NumeroAsistentes
FROM asistentes
GROUP BY pais_origen;

/* CONSULTA 8 Bandas de HardRock que tocaron, cambio londres por spain */
SELECT b.nombre AS Banda
FROM bandas b
JOIN conciertos c ON b.id_banda = c.id_banda
WHERE b.genero = 'HardRock' AND c.lugar LIKE '%Spain%';

/* CONSULTA 9 PATROCINADORES DEL CONCIERTO DE HUESCA */
SELECT p.nombre AS Patrocinador, p.contacto
FROM patrocinadores p
JOIN conciertos c ON p.id_concierto = c.id_concierto
WHERE c.lugar LIKE '%Huesca%';

/* CONSULTA 10 conciertos con ventas en merchandasisn mayores de 7000 euros */
SELECT c.lugar AS LugarConcierto, SUM(vm.cantidad * vm.precio_unitario) AS IngresosMerchandising
FROM conciertos c
JOIN ventas_merchandising vm ON c.id_concierto = vm.id_concierto
GROUP BY c.lugar
HAVING SUM(vm.cantidad * vm.precio_unitario) > 7000;

/* CONSULTA 11 Asistentes que compraron entrada para más de un concierto */
SELECT a.nombre, COUNT(v.id_concierto) AS ConciertosComprados
FROM asistentes a
JOIN ventas_entradas v ON a.id_asistente = v.id_asistente
GROUP BY a.nombre, a.email, a.telefono
HAVING COUNT(v.id_concierto) > 1;

/* CONSULTA 12 conciertos donde no hubo ventas de merchandasing */
SELECT c.lugar AS LugarConcierto, c.fecha AS FechaConcierto
FROM conciertos c
LEFT JOIN ventas_merchandising vm ON c.id_concierto = vm.id_concierto
WHERE vm.id_venta_merch IS NULL;

/* CONSULTA 13 ciudades donde tocaron más de tres bandas */
SELECT lugar AS Ciudad, COUNT(DISTINCT id_banda) AS BandasTocaron
FROM conciertos
GROUP BY lugar
HAVING COUNT(DISTINCT id_banda) > 3;

/* CONSULTA 14 bandas que no tocaron en Barcelona utilizando EXISTS */
SELECT b.nombre AS Banda
FROM bandas b
WHERE NOT EXISTS (
    SELECT 1
    FROM conciertos c
    WHERE b.id_banda = c.id_banda AND c.lugar LIKE '%Barcelona%'
);

/* CONSULTA 16 Patrocinadores que solo patrocinaron en una ciudad */
SELECT p.nombre AS Patrocinador
FROM patrocinadores p
JOIN conciertos c ON p.id_concierto = c.id_concierto
GROUP BY p.nombre
HAVING COUNT(DISTINCT c.lugar) = 1;

/* CONSULTA 17 Listado de ingresos totales por concierto (entrada y merchandising) utilizando with */
WITH IngresosTotales AS (
    SELECT
        c.lugar AS LugarConcierto,
        SUM(v.precio * v.cantidad) AS IngresosEntradas,
        SUM(vm.cantidad * vm.precio_unitario) AS IngresosMerchandising,
        SUM(v.precio * v.cantidad) + SUM(vm.cantidad * vm.precio_unitario) AS TotalIngresos
    FROM conciertos c
    LEFT JOIN ventas_entradas v ON c.id_concierto = v.id_concierto
    LEFT JOIN ventas_merchandising vm ON c.id_concierto = vm.id_concierto
    GROUP BY c.lugar
)
SELECT * FROM IngresosTotales;

/* CONSULTA 18 Primer concierto de cada banda utilizando PARTITION BY */
WITH PrimerConcierto AS (
    SELECT 
        id_banda, 
        lugar, 
        fecha,
        ROW_NUMBER() OVER (PARTITION BY id_banda ORDER BY fecha ASC) AS NumeroConcierto
    FROM conciertos
)
SELECT id_banda, lugar, fecha
FROM PrimerConcierto
WHERE NumeroConcierto = 1;

/* CONSULTA 19 Asistentes que compraron entradas con precio mayor al promedio de todas las entradas */
WITH PromedioEntradas AS (
    SELECT AVG(precio) AS PrecioPromedio
    FROM ventas_entradas
)
SELECT a.nombre, v.precio
FROM asistentes a
JOIN ventas_entradas v ON a.id_asistente = v.id_asistente
WHERE v.precio > (SELECT PrecioPromedio FROM PromedioEntradas);

/* CONSULTA 20 Ventas de merchandising por artículo agrupadas por concierto */
SELECT 
    vm.producto, 
    SUM(vm.cantidad) AS CantidadTotal, 
    SUM(vm.cantidad * vm.precio_unitario) AS TotalIngresos,
    vm.id_concierto
FROM ventas_merchandising vm
GROUP BY vm.producto, vm.id_concierto;
