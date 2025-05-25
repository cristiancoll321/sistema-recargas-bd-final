# Sistema de Recargas y Viajes

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

## Estructura del proyecto


```
sistema-recargas-bd/
├── scripts/
│   ├── 00_tablas.sql          # Creación de tablas base
│   ├── 01_modificaciones.sql  # Modificaciones a tablas
│   ├── 02_nuevas_tablas.sql   # Nuevas entidades
│   ├── 03_consultas.sql       # Consultas de análisis
│   └── inserts
└── README.md
```

## Tablas Principales
```
Tablas Base
USUARIOS: Información de usuarios del sistema
TARJETAS: Tarjetas asociadas a usuarios
LOCALIDADES: Divisiones geográficas
PUNTOS_RECARGA: Lugares para recargar tarjetas
ESTACIONES: Puntos de abordaje
TARIFAS: Histórico de tarifas
RECARGAS: Registro de recargas
VIAJES: Registro de viajes
```
## Nuevas Tablas
```
promocion: Gestión de promociones
dispositivo_validacion: Dispositivos para validar viajes
tarjeta_estado_auditoria: Historial de estados de tarjetas
tarjeta_saldo_historial: Historial de saldos
```
## Consultas Principales
Auditoría de Estados

- Cambios de estado por mes
- Top 5 tarjetas con más cambios
- Análisis de Promociones

- Recargas con promociones aplicadas
- Montos totales por tipo de promoción
- Dispositivos de Validación

- Buscar si hay algun saldo específico
- Historial de saldo con información del usuario
- Tarjetas con su historial de saldo más reciente

## Instrucciones de Implementación
Crear Base de Datos
```
CREATE DATABASE sistema_recargas_viajes_grupo[X] 
TEMPLATE sistema_recargas_viajes;
Ejecutar Scripts
```
Ejecutar scripts en orden numérico
Verificar creación de tablas
Cargar datos de prueba
Configuración de Conexión
```
Host: 149.130.169.172
Port: 33333
User: admin
Pass: Pass!__2025!
```
## Mejoras Implementadas
- Auditoría de estados de tarjetas
- Sistema de promociones
- Registro de dispositivos de validación
- Historial detallado de saldos
## Consideraciones Técnicas
- PostgreSQL como motor de base de datos
- Uso de foreign keys para integridad referencial
- Índices para optimización de consultas
- Campos de auditoría para seguimiento de cambios
