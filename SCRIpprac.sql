-- ================================================================
--  Script MySQL — examen2_Guzman
--
--  Estrategia ORM: JOINED TABLE  (InheritanceType.JOINED)
--  Una tabla por clase → sin repetición de columnas → normalizado.
--
--  Mapeo clase → tabla:
--  ┌────────────────────────────────────────────────────────────┐
--  │  Clase Java        │  Tabla MySQL     │  Relación         │
--  ├────────────────────────────────────────────────────────────┤
--  │  Propietario       │  propietario     │  —                │
--  │  Inmueble          │  inmueble        │  —                │
--  │  Apartamento       │  apartamento     │  1:1 FK           │
--  │  Casa              │  casa            │  1:1 FK           │
--  └────────────────────────────────────────────────────────────┘
--
--  Relaciones:
--    inmueble.propietario_id → propietario.id   (@ManyToOne  * → 1)
--    apartamento.numero      → inmueble.numero  (@OneToOne   1 → 1)
--    casa.numero             → inmueble.numero  (@OneToOne   1 → 1)
-- ================================================================

CREATE DATABASE IF NOT EXISTS examen2_Guzman
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE examen2_Guzman;

-- ================================================================
-- TABLA 1 — propietario
-- ================================================================
CREATE TABLE IF NOT EXISTS propietario (
    id     INT          NOT NULL AUTO_INCREMENT COMMENT '@Id',
    nombre VARCHAR(100) NOT NULL               COMMENT '@Column',
    PRIMARY KEY (id)
) ENGINE = InnoDB
  COMMENT = '@Entity Propietario';

-- ================================================================
-- TABLA 2 — inmueble
-- ================================================================
CREATE TABLE IF NOT EXISTS inmueble (
    numero         INT         NOT NULL COMMENT '@Id',
    fecha_compra   DATE                 COMMENT '@Column',
    estado         VARCHAR(50)          COMMENT '@Column',
    propietario_id INT         NOT NULL COMMENT '@ManyToOne FK → propietario.id',

    PRIMARY KEY (numero),

    CONSTRAINT fk_inmueble_propietario
        FOREIGN KEY (propietario_id)
        REFERENCES propietario(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB
  COMMENT = '@Entity Inmueble — tabla base de la herencia JOINED';

-- ================================================================
-- TABLA 3 — apartamento
-- ================================================================
CREATE TABLE IF NOT EXISTS apartamento (
    numero       INT NOT NULL COMMENT '@PrimaryKeyJoinColumn → inmueble.numero',
    numero_piso  INT NOT NULL COMMENT '@Column propio Apartamento',

    PRIMARY KEY (numero),

    CONSTRAINT fk_apartamento_inmueble
        FOREIGN KEY (numero)
        REFERENCES inmueble(numero)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB
  COMMENT = '@Entity Apartamento — JOINED';

-- ================================================================
-- TABLA 4 — casa
-- ================================================================
CREATE TABLE IF NOT EXISTS casa (
    numero         INT NOT NULL COMMENT '@PrimaryKeyJoinColumn → inmueble.numero',
    cantidad_pisos INT NOT NULL COMMENT '@Column propio Casa',

    PRIMARY KEY (numero),

    CONSTRAINT fk_casa_inmueble
        FOREIGN KEY (numero)
        REFERENCES inmueble(numero)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB
  COMMENT = '@Entity Casa — JOINED';

-- ================================================================
-- DATOS DE PRUEBA
-- (Tomados de las capturas de pantalla)
-- ================================================================

-- propietario (7 registros)
INSERT INTO propietario (id, nombre) VALUES
    (1,  'Adriana Guzman'),
    (2,  'Derlys Romero'),
    (6,  'María García'),
    (10, 'sandra martinez'),
    (52, 'Carlos López'),
    (85, 'maria alvarado'),
    (98, 'Juan Pérez');

-- inmueble (8 registros)
INSERT INTO inmueble (numero, fecha_compra, estado, propietario_id) VALUES
    (1,    '2024-01-10', 'Disponible', 1),
    (2,    '2023-05-20', 'Vendido',    1),
    (3,    '2022-08-15', 'Arrendado',  2),
    (4,    '2021-11-30', 'Disponible', 2),
    (85,   '2026-04-15', 'ARRENDADO',  85),
    (789,  '2026-04-15', 'VENDIDO',    10),
    (9991, '2025-12-25', 'Nuevo',      1),
    (9992, '2025-12-25', 'Usado',      2);

-- apartamento (4 registros)
INSERT INTO apartamento (numero, numero_piso) VALUES
    (1,    5),
    (3,    2),
    (789,  3),
    (9991, 5);

-- casa (4 registros)
INSERT INTO casa (numero, cantidad_pisos) VALUES
    (2,    2),
    (4,    3),
    (85,   7),
    (9992, 2);
