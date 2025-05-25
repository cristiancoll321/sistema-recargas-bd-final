--1. Auditoria del estado de las tarjetas
--Cantidad de cambios de estado por mes durante el ultimo anio
SELECT 
    EXTRACT(YEAR FROM fecha_cambio) AS anio,
    EXTRACT(MONTH FROM fecha_cambio) AS mes,
    COUNT(*) AS cantidad_cambios
FROM tarjeta_estado_auditoria
WHERE fecha_cambio >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY EXTRACT(YEAR FROM fecha_cambio), EXTRACT(MONTH FROM fecha_cambio)
ORDER BY anio DESC, mes DESC;

--Las 5 tarjetas con mayor numero de cambios de estado
SELECT tarjeta_id, COUNT(*) AS cantidad_cambios
FROM tarjeta_estado_auditoria
GROUP BY tarjeta_id
ORDER BY cantidad_cambios DESC
LIMIT 5;

--2. Promociones aplicadas en recargas
--Recargas con descripcion de la promocion aplicada
SELECT r.id_recarga, r.monto, p.nombre AS promocion, p.descripcion
FROM recarga r
LEFT JOIN promocion p ON r.id_promocion = p.id_promocion
WHERE r.id_promocion IS NOT NULL;

--Monto total recargado por cada tipo de promocion en los ultimos 3 meses
SELECT p.tipo, SUM(r.monto) AS total_recargado
FROM recargas r
JOIN promocion p ON r.id_promocion = p.id_promocion
WHERE r.fecha >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY p.tipo;

--Promociones cuyo nombre contenga la palabra "bonus"
SELECT *
FROM promocion
WHERE nombre ILIKE '%bonus%';

--3. Registro de dispositivos de validacion
--Consulta: Viajes sin registro de validacion
SELECT *
FROM viajes
WHERE id_dispositivo IS NULL
LIMIT 10;

--Consulta: Validaciones realizadas por dispositivos de tipo movil en abril de 2025
SELECT v.*
FROM viajes v
JOIN dispositivo_validacion d ON v.id_dispositivo = d.id_dispositivo
WHERE d.tipo = 'movil'
  AND v.fecha BETWEEN '2025-04-01' AND '2025-04-30';

--Consulta: Dispositivo con mayor cantidad de validaciones
SELECT v.id_dispositivo, d.tipo, d.descripcion, COUNT(*) AS cantidad_validaciones
FROM viajes v
JOIN dispositivo_validacion d ON v.id_dispositivo = d.id_dispositivo
GROUP BY v.id_dispositivo, d.tipo, d.descripcion
ORDER BY cantidad_validaciones DESC
LIMIT 1;

--4. Historial de saldo de tarjetas
--Registrar el historial de saldos de cada tarjeta permite analizar patrones de uso, detectar fraudes, y mejorar la gestion financiera del sistema.

--Buscar si hay algun saldo específico
SELECT *
FROM tarjeta_saldo_historial
WHERE saldo > 0
LIMIT 5;

--Historial de saldo con información del usuario (usando LEFT JOIN)
SELECT t.tarjeta_id, u.nombre, u.apellido, tsh.saldo, tsh.fecha, tsh.motivo
FROM tarjetas t
LEFT JOIN usuarios u ON t.usuario_id = u.usuario_id
LEFT JOIN tarjeta_saldo_historial tsh ON t.tarjeta_id = tsh.tarjeta_id
ORDER BY t.tarjeta_id
LIMIT 10;

--Tarjetas con su historial de saldo más reciente
SELECT 
    t.tarjeta_id,
    t.estado as estado_tarjeta,
    t.fecha_adquisicion,
    tsh.saldo,
    tsh.fecha as fecha_saldo,
    tsh.motivo
FROM tarjetas t
LEFT JOIN tarjeta_saldo_historial tsh ON t.tarjeta_id = tsh.tarjeta_id
WHERE tsh.fecha = (
    SELECT MAX(fecha) 
    FROM tarjeta_saldo_historial tsh2 
    WHERE tsh2.tarjeta_id = t.tarjeta_id
)
OR tsh.fecha IS NULL
ORDER BY t.tarjeta_id
LIMIT 10;
