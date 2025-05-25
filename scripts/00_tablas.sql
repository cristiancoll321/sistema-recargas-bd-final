DROP TABLE IF EXISTS tarjeta_saldo_historial;
DROP TABLE IF EXISTS tarjeta_estado_auditoria;
DROP TABLE IF EXISTS dispositivo_validacion;
DROP TABLE IF EXISTS promocion;
DROP TABLE IF EXISTS VIAJES;
DROP TABLE IF EXISTS ESTACIONES_INTERMEDIAS;
DROP TABLE IF EXISTS RUTAS;
DROP TABLE IF EXISTS RECARGAS;
DROP TABLE IF EXISTS ESTACIONES;
DROP TABLE IF EXISTS PUNTOS_RECARGA;
DROP TABLE IF EXISTS TARIFAS;
DROP TABLE IF EXISTS TARJETAS;
DROP TABLE IF EXISTS LOCALIDADES;
DROP TABLE IF EXISTS USUARIOS;

CREATE TABLE USUARIOS (
    usuario_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    numero_celular VARCHAR(20),
    fecha_nacimiento DATE,
    direccion_residencia VARCHAR(255),
    numero_cedula VARCHAR(50),
    ciudad_nacimiento VARCHAR(100),
    departamento_nacimiento VARCHAR(100),
    fecha_registro DATE,
    genero CHAR(1),
    correo_electronico VARCHAR(100),
    contraseña VARCHAR(100),
    foto_perfil VARCHAR(500),
    estado VARCHAR(50),
    tipo varchar(50),
    fecha_actualizacion VARCHAR(50),
    acepta_terminos CHAR(1)
);

CREATE TABLE TARJETAS (
    tarjeta_id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES USUARIOS(usuario_id),
    fecha_adquisicion DATE,
    estado VARCHAR(50),
    fecha_actualizacion DATE,
    fecha_caducidad varchar(50),
    tipo varchar(50)
);
CREATE TABLE LOCALIDADES (
    localidad_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100)
);


CREATE TABLE PUNTOS_RECARGA (
    punto_recarga_id SERIAL PRIMARY KEY,
    direccion VARCHAR(255),
    latitud FLOAT,
    longitud FLOAT,
    localidad_id INTEGER REFERENCES LOCALIDADES(localidad_id)
);

CREATE TABLE TARIFAS (
    tarifa_id SERIAL PRIMARY KEY,
    valor FLOAT,
    fecha DATE
);

CREATE TABLE RECARGAS (
    recarga_id SERIAL PRIMARY KEY,
    fecha DATE,
    monto FLOAT,
    punto_recarga_id INTEGER REFERENCES PUNTOS_RECARGA(punto_recarga_id),
    tarjeta_id INTEGER REFERENCES TARJETAS(tarjeta_id)
);

CREATE TABLE ESTACIONES (
    estacion_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    direccion VARCHAR(255),
    localidad_id INTEGER REFERENCES LOCALIDADES(localidad_id),
    latitud FLOAT,
    longitud FLOAT
);

CREATE TABLE RUTAS (
    ruta_id SERIAL PRIMARY KEY,
    estacion_origen_id INTEGER REFERENCES ESTACIONES(estacion_id),
    estacion_destino_id INTEGER REFERENCES ESTACIONES(estacion_id)
);

CREATE TABLE ESTACIONES_INTERMEDIAS (
    estacion_id INTEGER,
    ruta_id INTEGER,
    PRIMARY KEY (estacion_id, ruta_id),
    FOREIGN KEY (estacion_id) REFERENCES ESTACIONES(estacion_id),
    FOREIGN KEY (ruta_id) REFERENCES RUTAS(ruta_id)
);

CREATE TABLE VIAJES (
    viaje_id SERIAL PRIMARY KEY,
    estacion_abordaje_id INTEGER REFERENCES ESTACIONES(estacion_id),
    fecha DATE,
    tarifa_id INTEGER REFERENCES TARIFAS(tarifa_id),
    tarjeta_id INTEGER REFERENCES TARJETAS(tarjeta_id)
);

CREATE TABLE TARJETA_ESTADO_AUDITORIA (
    id_auditoria SERIAL PRIMARY KEY,
    tarjeta_id INT NOT NULL,
    estado_anterior VARCHAR(50),
    estado_nuevo VARCHAR(50) NOT NULL,
    fecha_cambio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion VARCHAR(100),
    CONSTRAINT fk_tarjeta FOREIGN KEY (tarjeta_id) REFERENCES tarjetas(tarjeta_id)
);

CREATE TABLE PROMOCION (
    id_promocion SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    tipo VARCHAR(50)
);

CREATE TABLE DISPOSITIVO_VALIDACION (
    id_dispositivo SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255)
);

CREATE TABLE TARJETA_SALDO_HISTORIAL (
    id_historial SERIAL PRIMARY KEY,
    tarjeta_id INT NOT NULL,
    saldo DECIMAL(10,2) NOT NULL,
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    motivo VARCHAR(100), 
    referencia INT,
    CONSTRAINT fk_historial_tarjeta FOREIGN KEY (tarjeta_id) REFERENCES tarjetas(tarjeta_id)
);
