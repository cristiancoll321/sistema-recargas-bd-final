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
SELECT id_tarjeta, COUNT(*) AS cantidad_cambios
FROM tarjeta_estado_auditoria
GROUP BY id_tarjeta
ORDER BY cantidad_cambios DESC
LIMIT 5;

--2. Promociones aplicadas en recargas
--Recargas con descripcion de la promocion aplicada
SELECT r.id_recarga, r.monto, p.nombre AS promocion, p.descripcion
FROM recarga r
LEFT JOIN promocion p ON r.id_promocion = p.id_promocion
WHERE r.id_promocion IS NOT NULL;

--Monto total recargado por cada tipo de promocion en los ultimos 3 meses
SELECT 
    p.tipo,
    SUM(r.monto) AS total_recargado
FROM recarga r
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
FROM viaje
WHERE id_dispositivo IS NULL;

--Consulta: Validaciones realizadas por dispositivos de tipo movil en abril de 2025
SELECT v.*
FROM viaje v
JOIN dispositivo_validacion d ON v.id_dispositivo = d.id_dispositivo
WHERE d.tipo = 'movil'
  AND v.fecha BETWEEN '2025-04-01' AND '2025-04-30';

--Consulta: Dispositivo con mayor cantidad de validaciones
SELECT 
    v.id_dispositivo,
    d.tipo,
    d.descripcion,
    COUNT(*) AS cantidad_validaciones
FROM viaje v
JOIN dispositivo_validacion d ON v.id_dispositivo = d.id_dispositivo
GROUP BY v.id_dispositivo, d.tipo, d.descripcion
ORDER BY cantidad_validaciones DESC
LIMIT 1;

--4. Historial de saldo de tarjetas
--Registrar el historial de saldos de cada tarjeta permite analizar patrones de uso, detectar fraudes, y mejorar la gestion financiera del sistema.

--Evolucion del saldo de una tarjeta especifica (JOIN con tarjeta)
SELECT 
    tsh.fecha,
    tsh.saldo,
    tsh.motivo,
    t.numero_tarjeta
FROM tarjeta_saldo_historial tsh
JOIN tarjeta t ON tsh.id_tarjeta = t.id_tarjeta
WHERE t.id_tarjeta = :id_tarjeta
ORDER BY tsh.fecha;

--Saldos promedio por mes y motivo (JOIN con tarjeta)
SELECT 
    EXTRACT(YEAR FROM tsh.fecha) AS anio,
    EXTRACT(MONTH FROM tsh.fecha) AS mes,
    tsh.motivo,
    AVG(tsh.saldo) AS saldo_promedio
FROM tarjeta_saldo_historial tsh
JOIN tarjeta t ON tsh.id_tarjeta = t.id_tarjeta
GROUP BY EXTRACT(YEAR FROM tsh.fecha), EXTRACT(MONTH FROM tsh.fecha), tsh.motivo
ORDER BY anio DESC, mes DESC;

--Tarjetas que han tenido saldo negativo alguna vez
SELECT DISTINCT t.id_tarjeta, t.numero_tarjeta
FROM tarjeta_saldo_historial tsh
JOIN tarjeta t ON tsh.id_tarjeta = t.id_tarjeta
WHERE tsh.saldo < 0;