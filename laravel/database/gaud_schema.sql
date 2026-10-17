SET NAMES utf8mb4;
CREATE DATABASE IF NOT EXISTS gaud CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE gaud;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS inscripciones;
DROP TABLE IF EXISTS asignatura_relaciones;
DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS asignaturas;
DROP TABLE IF EXISTS carreras;
DROP TABLE IF EXISTS universidades;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE universidades (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE carreras (
  id INT AUTO_INCREMENT PRIMARY KEY,
  universidad_id INT NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  periodo ENUM('trimestres','cuatrimestres','semestres') NOT NULL DEFAULT 'trimestres',
  UNIQUE KEY uq_uni_carrera (universidad_id, nombre),
  FOREIGN KEY (universidad_id) REFERENCES universidades(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE asignaturas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(20) NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  creditos INT NOT NULL,
  periodo TINYINT NOT NULL,
  tipo ENUM('obligatoria','optativa') NOT NULL DEFAULT 'obligatoria',
  carrera_id INT NOT NULL,
  UNIQUE KEY uq_carrera_codigo (carrera_id, codigo),
  FOREIGN KEY (carrera_id) REFERENCES carreras(id)
) ENGINE=InnoDB;

CREATE TABLE asignatura_relaciones (
  id INT AUTO_INCREMENT PRIMARY KEY,
  asignatura_id INT NOT NULL,
  relacionada_id INT NOT NULL,
  tipo ENUM('prerrequisito','correquisito') NOT NULL,
  UNIQUE KEY uq_relacion (asignatura_id, relacionada_id, tipo),
  KEY idx_relacionada (relacionada_id, tipo),
  CONSTRAINT chk_no_auto_referencia CHECK (asignatura_id <> relacionada_id),
  FOREIGN KEY (asignatura_id) REFERENCES asignaturas(id) ON DELETE CASCADE,
  FOREIGN KEY (relacionada_id) REFERENCES asignaturas(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  telefono VARCHAR(20) NULL,
  direccion VARCHAR(255) NULL,
  universidad_id INT NOT NULL,
  carrera_id INT NOT NULL,
  modalidad ENUM('presencial','virtual','mixta') NOT NULL,
  terminos_aceptado_en DATETIME NOT NULL,
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (universidad_id) REFERENCES universidades(id),
  FOREIGN KEY (carrera_id) REFERENCES carreras(id)
) ENGINE=InnoDB;

CREATE TABLE inscripciones (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  asignatura_id INT NOT NULL,
  periodo TINYINT NOT NULL,
  estado ENUM('en-curso','aprobada') NOT NULL,
  calificacion ENUM('A','B','C') NULL,
  actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_usuario_asignatura_periodo (usuario_id, asignatura_id, periodo),
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
  FOREIGN KEY (asignatura_id) REFERENCES asignaturas(id)
) ENGINE=InnoDB;
