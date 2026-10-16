SET NAMES utf8mb4;
CREATE DATABASE IF NOT EXISTS gaud CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE gaud;

DROP TABLE IF EXISTS inscripciones;
DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS asignaturas;
DROP TABLE IF EXISTS carreras;
DROP TABLE IF EXISTS universidades;

CREATE TABLE universidades (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE carreras (
  id INT AUTO_INCREMENT PRIMARY KEY,
  universidad_id INT NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  UNIQUE KEY uq_uni_carrera (universidad_id, nombre),
  FOREIGN KEY (universidad_id) REFERENCES universidades(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE asignaturas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(20) NOT NULL UNIQUE,
  nombre VARCHAR(150) NOT NULL,
  creditos INT NOT NULL,
  trimestre TINYINT NOT NULL,
  carrera_id INT NOT NULL,
  FOREIGN KEY (carrera_id) REFERENCES carreras(id)
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
  estado ENUM('en-curso','aprobada') NOT NULL,
   calificacion ENUM('A','B','C') NULL,
  actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_usuario_asignatura (usuario_id, asignatura_id),
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
  FOREIGN KEY (asignatura_id) REFERENCES asignaturas(id)
) ENGINE=InnoDB;

-- Universidades y carreras de prueba luego se llena con las universidades de RD y sus carreras
INSERT INTO universidades (nombre) VALUES
('Universidad Abierta Para Adultos');

INSERT INTO carreras (universidad_id, nombre) VALUES
(1, 'Ingeniería en Software');

-- Seed: 62 asignaturas (pensum Ingeniería en Software, UAPA)
INSERT INTO asignaturas (codigo, nombre, creditos, trimestre, carrera_id) VALUES
('CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 1),
('CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 1),
('CBE-109', 'Comunicación Oral y Escrita', 4, 1, 1),
('CBM-107', 'Razonamiento Lógico Matemático', 4, 1, 1),
('FGI-103', 'Lógica Computacional', 4, 2, 1),
('CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 2, 1),
('FGI-102', 'Álgebra y Geometría para Ingenieros', 4, 2, 1),
('ING-103', 'Inglés Comunicativo', 3, 2, 1),
('CBE-110', 'Análisis y Producción de Textos', 4, 3, 1),
('FGI-104', 'Programación I', 4, 3, 1),
('FGM-102', 'Análisis Matemático I', 5, 3, 1),
('FGM-205', 'Matemática Discreta', 3, 3, 1),
('FGC-105', 'Metodología de la Investigación Científica', 4, 4, 1),
('FGI-106', 'Sistema de Base de Datos', 4, 4, 1),
('FGI-105', 'Programación II', 4, 4, 1),
('FGM-103', 'Análisis Matemático II', 5, 4, 1),
('FGC-203', 'Filosofía y Sociedad', 3, 5, 1),
('ISW-305', 'Estructura de Datos y Algoritmos', 4, 5, 1),
('ING-213', 'Inglés Técnico para Ingenieros', 3, 5, 1),
('FGC-204', 'Investigación Aplicada', 4, 5, 1),
('FGF-201', 'Física General', 4, 6, 1),
('LAF-201', 'Práctica de Física General', 1, 6, 1),
('ISW-204', 'Diseño de Interfaz de Usuario', 4, 6, 1),
('ISW-201', 'Ingeniería de Software I', 4, 6, 1),
('FGC-106', 'Historia Social Dominicana', 3, 7, 1),
('ISW-202', 'Ingeniería de Software II', 4, 7, 1),
('ISW-306', 'Desarrollo de Aplicaciones Web', 4, 7, 1),
('OP1', 'Optativa 1', 3, 7, 1),
('FGM-206', 'Álgebra Lineal', 4, 8, 1),
('FGI-209', 'Electrónica Básica', 4, 8, 1),
('ISW-203', 'Calidad de Software', 4, 8, 1),
('OP2', 'Optativa 2', 3, 8, 1),
('FGC-208', 'Educación Constitucional', 3, 9, 1),
('FGM-314', 'Matemática Numérica', 4, 9, 1),
('FGI-210', 'Arquitectura de Hardware', 4, 9, 1),
('FGM-207', 'Estadística y Probabilidades', 4, 9, 1),
('FGC-409', 'Ética Profesional', 3, 10, 1),
('INF-304', 'Informática Gerencial', 4, 10, 1),
('ISW-412', 'Minería de Datos', 4, 10, 1),
('OP3', 'Optativa 3', 3, 10, 1),
('FGI-312', 'Redes y Servicios Telemáticos', 4, 11, 1),
('LAT-312', 'Labo. Redes y Servicios Telemáticos', 1, 11, 1),
('ISW-309', 'Inteligencia Artificial', 4, 11, 1),
('INF-305', 'Sistemas Distribuidos', 4, 11, 1),
('COE-101', 'Contabilidad I', 4, 12, 1),
('CID-115', 'Procesamiento del Lenguaje Natural', 4, 12, 1),
('ISW-420', 'Ciberseguridad', 4, 12, 1),
('LAS-313', 'Labo. de Ciberseguridad', 1, 12, 1),
('INF-408', 'Investigación de Operaciones', 4, 13, 1),
('ISW-425', 'Programación Multiplataforma Móvil', 4, 13, 1),
('LAP-414', 'Labo. Programación Multiplataforma', 1, 13, 1),
('ISW-304', 'Desarrollo de Proyectos con Software Libre', 4, 13, 1),
('ISW-414', 'Fundamentos de Inteligencia de Negocios', 4, 14, 1),
('ISW-413', 'Simulación Digital', 4, 14, 1),
('ISW-415', 'Ingeniería Robótica para Software Virtuales I', 4, 14, 1),
('LAR-415', 'Labo. Robótica para Software Virtuales I', 1, 14, 1),
('PPS-400', 'Práctica Profesional (Pasantía)', 8, 14, 1),
('INF-307', 'Gestión del Conocimiento y Toma de Decisiones', 4, 15, 1),
('ISW-416', 'Ingeniería Robótica para Software Virtuales II', 4, 15, 1),
('LAR-416', 'Labo. Robótica para Software Virtuales II', 1, 15, 1),
('ISW-417', 'Seminario de Proyectos de Software', 4, 15, 1),
('ISW-400', 'Curso Final de Grado', 6, 16, 1);

-- Usuario demo (para pruebas de login)
-- Email: estudiante@gaud.dev | Contraseña: Gaud2026!
INSERT INTO usuarios (nombre, email, password_hash, telefono, direccion, universidad_id, carrera_id, modalidad, terminos_aceptado_en) VALUES
('Estudiante Demo', 'estudiante@gaud.dev', '$2y$10$mfODqfAvynGk58DAFBWOgO5Idexrq2XGlp7BBX6EOqhnTo8hQULLu', '809-555-1234', 'Santo Domingo, RD', 1, 1, 'virtual', NOW());

-- Inscripciones de ejemplo: T1-T2 aprobadas, T3 en curso
INSERT INTO inscripciones (usuario_id, asignatura_id, estado, calificacion) VALUES
(1, 1, 'aprobada', 'A'),
(1, 2, 'aprobada', 'B'),
(1, 3, 'aprobada', 'A'),
(1, 4, 'aprobada', 'B'),
(1, 5, 'aprobada', 'A'),
(1, 6, 'aprobada', 'C'),
(1, 7, 'aprobada', 'A'),
(1, 8, 'aprobada', 'B'),
(1, 9, 'en-curso', NULL),
(1, 10, 'en-curso', NULL),
(1, 11, 'en-curso', NULL),
(1, 12, 'en-curso', NULL);
