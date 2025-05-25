-- Modificación de la tabla RECARGAS para asociar promociones
ALTER TABLE RECARGAS ADD id_promocion INT NULL;
ALTER TABLE RECARGAS ADD CONSTRAINT fk_recarga_promocion 
    FOREIGN KEY (id_promocion) REFERENCES promocion(id_promocion);

-- Modificación de la tabla VIAJES para asociar dispositivo de validación
ALTER TABLE VIAJES ADD id_dispositivo INT NULL;
ALTER TABLE VIAJES ADD CONSTRAINT fk_viaje_dispositivo 
    FOREIGN KEY (id_dispositivo) REFERENCES dispositivo_validacion(id_dispositivo);