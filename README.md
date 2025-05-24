# sistema-recargas-bd-final

## Diagrama Entidad-Relación

```mermaid
erDiagram
    USUARIOS {
        int usuario_id PK
        varchar nombre
        varchar apellido
        varchar numero_celular
        date fecha_nacimiento
        varchar direccion_residencia
        varchar numero_cedula
        varchar correo_electronico
        varchar estado
        varchar tipo
    }

    TARJETAS {
        int tarjeta_id PK
        int usuario_id FK
        date fecha_adquisicion
        varchar estado
        date fecha_actualizacion
        varchar tipo
    }

    LOCALIDADES {
        int localidad_id PK
        varchar nombre
    }

    PUNTOS_RECARGA {
        int punto_recarga_id PK
        varchar direccion
        float latitud
        float longitud
        int localidad_id FK
    }

    TARIFAS {
        int tarifa_id PK
        float valor
        date fecha
    }

    RECARGAS {
        int recarga_id PK
        date fecha
        float monto
        int punto_recarga_id FK
        int tarjeta_id FK
        int id_promocion FK
    }

    ESTACIONES {
        int estacion_id PK
        varchar nombre
        varchar direccion
        int localidad_id FK
        float latitud
        float longitud
    }

    VIAJES {
        int viaje_id PK
        int estacion_abordaje_id FK
        date fecha
        int tarifa_id FK
        int tarjeta_id FK
        int id_dispositivo FK
    }

    tarjeta_estado_auditoria {
        int id_auditoria PK
        int id_tarjeta FK
        varchar estado_anterior
        varchar estado_nuevo
        timestamp fecha_cambio
        varchar usuario_modificacion
    }

    promocion {
        int id_promocion PK
        varchar nombre
        varchar descripcion
        varchar tipo
    }

    dispositivo_validacion {
        int id_dispositivo PK
        varchar tipo
        varchar descripcion
    }

    tarjeta_saldo_historial {
        int id_historial PK
        int id_tarjeta FK
        decimal saldo
        timestamp fecha
        varchar motivo
        int referencia
    }

    USUARIOS ||--o{ TARJETAS : "tiene"
    LOCALIDADES ||--o{ PUNTOS_RECARGA : "contiene"
    LOCALIDADES ||--o{ ESTACIONES : "contiene"
    TARJETAS ||--o{ RECARGAS : "recibe"
    PUNTOS_RECARGA ||--o{ RECARGAS : "realiza"
    ESTACIONES ||--o{ VIAJES : "abordaje"
    TARIFAS ||--o{ VIAJES : "aplica"
    TARJETAS ||--o{ VIAJES : "realiza"
    TARJETAS ||--o{ tarjeta_estado_auditoria : "registra"
    TARJETAS ||--o{ tarjeta_saldo_historial : "registra"
    promocion ||--o{ RECARGAS : "aplica"
    dispositivo_validacion ||--o{ VIAJES : "valida"
```

## Descripción

Este sistema gestiona recargas y viajes para un sistema de transporte público. Incluye gestión de usuarios, tarjetas, recargas, viajes y dispositivos de validación.

## Tablas Principales
- Usuarios
- Tarjetas
- Recargas
- Viajes
- Promociones
- Dispositivos de validación
