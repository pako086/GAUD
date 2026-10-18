-- GAUD database script
-- Combinado de: gaud_schema.sql + gaud_seed.sql + uapa_prerrequisitos_correquisitos.sql

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

SET NAMES utf8mb4;
USE gaud;

INSERT INTO universidades (nombre)
VALUES ('Universidad Abierta Para Adultos')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);

SET @uni_id = (SELECT id FROM universidades WHERE nombre = 'Universidad Abierta Para Adultos');

-- ============================================================================
-- 1. Ingeniería en Ciencia de Datos
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Ingeniería en Ciencia de Datos', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_icd_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Ingeniería en Ciencia de Datos');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_icd_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_icd_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_icd_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_icd_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 1, 'obligatoria'),
(@carrera_icd_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 2, 'obligatoria'),
(@carrera_icd_id, 'FGI-103', 'Lógica Computacional', 4, 2, 'obligatoria'),
(@carrera_icd_id, 'FGI-102', 'Algebra y Geometría para Ingenieros', 4, 2, 'obligatoria'),
(@carrera_icd_id, 'CBE-110', 'Análisis y Producción de Textos', 4, 3, 'obligatoria'),
(@carrera_icd_id, 'FGI-104', 'Programación I', 4, 3, 'obligatoria'),
(@carrera_icd_id, 'FGM-102', 'Análisis Matemático I', 5, 3, 'obligatoria'),
(@carrera_icd_id, 'FGI-105', 'Programación II', 4, 4, 'obligatoria'),
(@carrera_icd_id, 'FGI-106', 'Sistema de Base de Datos', 4, 4, 'obligatoria'),
(@carrera_icd_id, 'FGM-103', 'Análisis Matemático II', 5, 4, 'obligatoria'),
(@carrera_icd_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 5, 'obligatoria'),
(@carrera_icd_id, 'FGI-208', 'Análisis y Diseño de Sistema', 4, 5, 'obligatoria'),
(@carrera_icd_id, 'CID-101', 'Ciencia de Datos', 4, 5, 'obligatoria'),
(@carrera_icd_id, 'FGC-204', 'Investigación Aplicada', 4, 6, 'obligatoria'),
(@carrera_icd_id, 'FGF-201', 'Física General', 4, 6, 'obligatoria'),
(@carrera_icd_id, 'LAF-201', 'Práctica de Física General', 1, 6, 'obligatoria'),
(@carrera_icd_id, 'FGM-215', 'Estadistica Probabilistica e Inferencial', 4, 6, 'obligatoria'),
(@carrera_icd_id, 'FGC-203', 'Filosofía y Sociedad', 3, 7, 'obligatoria'),
(@carrera_icd_id, 'FGF-207', 'Física Mecánica', 4, 7, 'obligatoria'),
(@carrera_icd_id, 'LAF-207', 'Laboratorio de Física Mecánica', 1, 7, 'obligatoria'),
(@carrera_icd_id, 'OPT-101', 'Optativa 1', 3, 7, 'optativa'),
(@carrera_icd_id, 'CID-202', 'Datos Masivos', 4, 8, 'obligatoria'),
(@carrera_icd_id, 'CID-203', 'Modelos de Programación Para Ciencia de Datos', 4, 8, 'obligatoria'),
(@carrera_icd_id, 'OPT-102', 'Optativa 2', 3, 8, 'optativa'),
(@carrera_icd_id, 'FGC-208', 'Educación Constitucional', 3, 9, 'obligatoria'),
(@carrera_icd_id, 'FGM-205', 'Matemática Discreta', 3, 9, 'obligatoria'),
(@carrera_icd_id, 'ISW-305', 'Estructura de Datos y Algoritmos', 4, 9, 'obligatoria'),
(@carrera_icd_id, 'FGM-309', 'Probabilidad Aplicada y Simulación Estocástica', 3, 9, 'obligatoria'),
(@carrera_icd_id, 'FGC-409', 'Ética Profesional', 3, 10, 'obligatoria'),
(@carrera_icd_id, 'FGM-206', 'Álgebra Lineal', 4, 10, 'obligatoria'),
(@carrera_icd_id, 'CID-304', 'Métodos Matemáticos Computacionales', 4, 10, 'obligatoria'),
(@carrera_icd_id, 'INF-303', 'Seguridad Informática', 4, 11, 'obligatoria'),
(@carrera_icd_id, 'ISW-309', 'Inteligencia Artificial', 4, 11, 'obligatoria'),
(@carrera_icd_id, 'CID-305', 'Arquitectura de Grandes Volúmenes de Datos', 4, 11, 'obligatoria'),
(@carrera_icd_id, 'FGN-204', 'Contabilidad y Finanzas', 4, 12, 'obligatoria'),
(@carrera_icd_id, 'CID-306', 'Tratamiento de Datos', 4, 12, 'obligatoria'),
(@carrera_icd_id, 'CID-307', 'Reconocimiento de Patrones', 4, 12, 'obligatoria'),
(@carrera_icd_id, 'CID-408', 'Calidad y Pre-Procesamiento de Datos', 4, 13, 'obligatoria'),
(@carrera_icd_id, 'CID-409', 'Visualización de la Información', 4, 13, 'obligatoria'),
(@carrera_icd_id, 'CID-411', 'Inteligencia de Negocios', 4, 13, 'obligatoria'),
(@carrera_icd_id, 'OPT-103', 'Optativa 3', 3, 13, 'optativa'),
(@carrera_icd_id, 'CID-410', 'Aprendizaje de Máquinas', 4, 14, 'obligatoria'),
(@carrera_icd_id, 'INF-408', 'Investigación de Operaciones', 4, 14, 'obligatoria'),
(@carrera_icd_id, 'PPZ-400', 'Práctica Profesional (Pasantía)', 8, 14, 'obligatoria'),
(@carrera_icd_id, 'ISW-412', 'Minería de Datos', 4, 15, 'obligatoria'),
(@carrera_icd_id, 'CID-115', 'Procesamiento del Lenguaje Natural', 4, 15, 'obligatoria'),
(@carrera_icd_id, 'CID-413', 'Diseño y Gestión de Proyectos en Ciencia de Datos', 4, 15, 'obligatoria'),
(@carrera_icd_id, 'CID-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_icd_id, 'CID-414', 'Analítica FinTech', 3, 0, 'optativa'),
(@carrera_icd_id, 'CID-415', 'MLOps y Despliegue de IA', 3, 0, 'optativa'),
(@carrera_icd_id, 'CID-416', 'Bioinformática e IA Biomédica', 3, 0, 'optativa'),
(@carrera_icd_id, 'CID-417', 'Computación Cuántica para Datos', 3, 0, 'optativa'),
(@carrera_icd_id, 'FGN-309', 'Metodologías de Emprendimiento', 3, 0, 'optativa'),
(@carrera_icd_id, 'ADM-316', 'Formulación y Creación de Proyectos Emprendedores', 3, 0, 'optativa'),
(@carrera_icd_id, 'CON-334', 'Finanzas Básicas para Emprendedores', 3, 0, 'optativa'),
(@carrera_icd_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 0, 'optativa'),
(@carrera_icd_id, 'FGP-421', 'Coaching', 3, 0, 'optativa'),
(@carrera_icd_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 2. Ingeniería en Software
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Ingeniería en Software', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_isw_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Ingeniería en Software');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_isw_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_isw_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_isw_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_isw_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 1, 'obligatoria'),
(@carrera_isw_id, 'FGI-103', 'Lógica Computacional', 4, 2, 'obligatoria'),
(@carrera_isw_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 2, 'obligatoria'),
(@carrera_isw_id, 'FGI-102', 'Álgebra y Geometría para Ingenieros', 4, 2, 'obligatoria'),
(@carrera_isw_id, 'ING-103', 'Inglés Comunicativo', 3, 2, 'obligatoria'),
(@carrera_isw_id, 'CBE-110', 'Análisis y Producción de Textos', 4, 3, 'obligatoria'),
(@carrera_isw_id, 'FGI-104', 'Programación I', 4, 3, 'obligatoria'),
(@carrera_isw_id, 'FGM-102', 'Análisis Matemático I', 5, 3, 'obligatoria'),
(@carrera_isw_id, 'FGM-205', 'Matemática Discreta', 3, 3, 'obligatoria'),
(@carrera_isw_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 4, 'obligatoria'),
(@carrera_isw_id, 'FGI-106', 'Sistema de Base de Datos', 4, 4, 'obligatoria'),
(@carrera_isw_id, 'FGI-105', 'Programación II', 4, 4, 'obligatoria'),
(@carrera_isw_id, 'FGM-103', 'Análisis Matemático II', 5, 4, 'obligatoria'),
(@carrera_isw_id, 'FGC-203', 'Filosofía y Sociedad', 3, 5, 'obligatoria'),
(@carrera_isw_id, 'ISW-305', 'Estructura de Datos y Algoritmos', 4, 5, 'obligatoria'),
(@carrera_isw_id, 'ING-213', 'Inglés Técnico para Ingenieros', 3, 5, 'obligatoria'),
(@carrera_isw_id, 'FGC-204', 'Investigación Aplicada', 4, 5, 'obligatoria'),
(@carrera_isw_id, 'FGF-201', 'Física General', 4, 6, 'obligatoria'),
(@carrera_isw_id, 'LAF-201', 'Práctica de Física General', 1, 6, 'obligatoria'),
(@carrera_isw_id, 'ISW-204', 'Diseño de Interfaz de Usuario', 4, 6, 'obligatoria'),
(@carrera_isw_id, 'ISW-201', 'Ingeniería de Software I', 4, 6, 'obligatoria'),
(@carrera_isw_id, 'FGC-106', 'Historia Social Dominicana', 3, 7, 'obligatoria'),
(@carrera_isw_id, 'ISW-202', 'Ingeniería de Software II', 4, 7, 'obligatoria'),
(@carrera_isw_id, 'ISW-306', 'Desarrollo de Aplicaciones Web', 4, 7, 'obligatoria'),
(@carrera_isw_id, 'OPT-101', 'Optativa 1', 3, 7, 'optativa'),
(@carrera_isw_id, 'FGM-206', 'Álgebra Lineal', 4, 8, 'obligatoria'),
(@carrera_isw_id, 'FGI-209', 'Electrónica Básica', 4, 8, 'obligatoria'),
(@carrera_isw_id, 'ISW-203', 'Calidad de Software', 4, 8, 'obligatoria'),
(@carrera_isw_id, 'OPT-102', 'Optativa 2', 3, 8, 'optativa'),
(@carrera_isw_id, 'FGC-208', 'Educación Constitucional', 3, 9, 'obligatoria'),
(@carrera_isw_id, 'FGM-314', 'Matemática Numérica', 4, 9, 'obligatoria'),
(@carrera_isw_id, 'FGI-210', 'Arquitectura de Hardware', 4, 9, 'obligatoria'),
(@carrera_isw_id, 'FGM-207', 'Estadística y Probabilidades', 4, 9, 'obligatoria'),
(@carrera_isw_id, 'FGC-409', 'Ética Profesional', 3, 10, 'obligatoria'),
(@carrera_isw_id, 'INF-304', 'Informática Gerencial', 4, 10, 'obligatoria'),
(@carrera_isw_id, 'ISW-412', 'Minería de Datos', 4, 10, 'obligatoria'),
(@carrera_isw_id, 'OPT-103', 'Optativa 3', 3, 10, 'optativa'),
(@carrera_isw_id, 'FGI-312', 'Redes y Servicios Telemáticos', 4, 11, 'obligatoria'),
(@carrera_isw_id, 'LAT-312', 'Laboratorio de Redes y Servicios Telemáticos', 1, 11, 'obligatoria'),
(@carrera_isw_id, 'ISW-309', 'Inteligencia Artificial', 4, 11, 'obligatoria'),
(@carrera_isw_id, 'INF-305', 'Sistemas Distribuidos', 4, 11, 'obligatoria'),
(@carrera_isw_id, 'COE-101', 'Contabilidad I', 4, 12, 'obligatoria'),
(@carrera_isw_id, 'CID-115', 'Procesamiento del Lenguaje Natural', 4, 12, 'obligatoria'),
(@carrera_isw_id, 'ISW-420', 'Ciberseguridad', 4, 12, 'obligatoria'),
(@carrera_isw_id, 'LAS-313', 'Laboratorio de Ciberseguridad', 1, 12, 'obligatoria'),
(@carrera_isw_id, 'INF-408', 'Investigación de Operaciones', 4, 13, 'obligatoria'),
(@carrera_isw_id, 'ISW-425', 'Programación Multiplataforma para Dispositivos Móviles', 4, 13, 'obligatoria'),
(@carrera_isw_id, 'LAP-414', 'Laboratorio de Programación Multiplataforma para Dispositivos Móviles', 1, 13, 'obligatoria'),
(@carrera_isw_id, 'ISW-304', 'Desarrollo de Proyectos con Software Libre', 4, 13, 'obligatoria'),
(@carrera_isw_id, 'ISW-414', 'Fundamentos de Inteligencia de Negocios', 4, 14, 'obligatoria'),
(@carrera_isw_id, 'ISW-413', 'Simulación Digital', 4, 14, 'obligatoria'),
(@carrera_isw_id, 'ISW-415', 'Ingeniería Robótica para Software Virtuales I', 4, 14, 'obligatoria'),
(@carrera_isw_id, 'LAR-415', 'Laboratorio de Robótica para Software Virtuales I', 1, 14, 'obligatoria'),
(@carrera_isw_id, 'PPS-400', 'Práctica Profesional (Pasantía)', 8, 14, 'obligatoria'),
(@carrera_isw_id, 'INF-307', 'Gestión del Conocimiento y la Toma de Decisiones', 4, 15, 'obligatoria'),
(@carrera_isw_id, 'ISW-416', 'Ingeniería Robótica para Software Virtuales II', 4, 15, 'obligatoria'),
(@carrera_isw_id, 'LAR-416', 'Laboratorio de Robótica para Software Virtuales II', 1, 15, 'obligatoria'),
(@carrera_isw_id, 'ISW-417', 'Seminario de Proyectos de Software', 4, 15, 'obligatoria'),
(@carrera_isw_id, 'ISW-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_isw_id, 'ISW-431', 'Blockchain y Aplicaciones Descentralizadas', 3, 0, 'optativa'),
(@carrera_isw_id, 'ISW-432', 'Administración de Servidores y Servicios Telemáticos', 3, 0, 'optativa'),
(@carrera_isw_id, 'ISW-423', 'Scrum Master', 3, 0, 'optativa'),
(@carrera_isw_id, 'ISW-424', 'Computación Cuántica y Algoritmos Avanzados', 3, 0, 'optativa'),
(@carrera_isw_id, 'FGN-309', 'Metodologías de Emprendimiento', 3, 0, 'optativa'),
(@carrera_isw_id, 'ADM-316', 'Formulación y Creación de Proyectos Emprendedores', 3, 0, 'optativa'),
(@carrera_isw_id, 'CON-334', 'Finanzas Básicas para Emprendedores', 3, 0, 'optativa'),
(@carrera_isw_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 0, 'optativa'),
(@carrera_isw_id, 'FGP-421', 'Coaching', 3, 0, 'optativa'),
(@carrera_isw_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 3. Licenciatura en Educación Inicial
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Educación Inicial', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_edi_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Educación Inicial');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_edi_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_edi_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_edi_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_edi_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 2, 'obligatoria'),
(@carrera_edi_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 2, 'obligatoria'),
(@carrera_edi_id, 'FGE-101', 'Fundamentos Filosóficos e Históricos de la Educación', 4, 2, 'obligatoria'),
(@carrera_edi_id, 'FGP-101', 'Psicología del Desarrollo 1 (0-3 años)', 3, 3, 'obligatoria'),
(@carrera_edi_id, 'FGE-209', 'Didáctica General', 3, 3, 'obligatoria'),
(@carrera_edi_id, 'FGE-102', 'Fundamentos y Estructura del Currículo', 3, 3, 'obligatoria'),
(@carrera_edi_id, 'FGC-203', 'Filosofía y Sociedad', 3, 3, 'obligatoria'),
(@carrera_edi_id, 'FGP-207', 'Neurociencias y Aprendizaje', 3, 4, 'obligatoria'),
(@carrera_edi_id, 'FGE-203', 'Procesos de Enseñanza y Aprendizaje', 4, 4, 'obligatoria'),
(@carrera_edi_id, 'EDI-201', 'Currículo del Nivel Inicial', 3, 4, 'obligatoria'),
(@carrera_edi_id, 'FGP-210', 'Psicología del Aprendizaje', 3, 5, 'obligatoria'),
(@carrera_edi_id, 'EDI-203', 'Didáctica Especial del Nivel Inicial', 4, 5, 'obligatoria'),
(@carrera_edi_id, 'FGE-306', 'Gestión de Ambientes de Aprendizaje y el Aula', 3, 5, 'obligatoria'),
(@carrera_edi_id, 'PRA-201', 'Práctica Docente Nivel I', 2, 5, 'obligatoria'),
(@carrera_edi_id, 'CBE-110', 'Análisis y Producción de Textos', 4, 6, 'obligatoria'),
(@carrera_edi_id, 'EDI-306', 'Educación y Expresión Artística', 3, 6, 'obligatoria'),
(@carrera_edi_id, 'FGP-313', 'Estimulación del Desarrollo en la Primera Infancia', 3, 6, 'obligatoria'),
(@carrera_edi_id, 'FGC-106', 'Historia Social Dominicana', 3, 7, 'obligatoria'),
(@carrera_edi_id, 'FGP-102', 'Psicología del Desarrollo II (3-6 años)', 3, 7, 'obligatoria'),
(@carrera_edi_id, 'PRA-207', 'Práctica Docente Nivel II', 3, 7, 'obligatoria'),
(@carrera_edi_id, 'OPT-101', 'Optativa 1', 3, 7, 'optativa'),
(@carrera_edi_id, 'EDI-305', 'Evaluación de los Aprendizajes en el Nivel Inicial', 3, 8, 'obligatoria'),
(@carrera_edi_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 8, 'obligatoria'),
(@carrera_edi_id, 'PRA-203', 'Práctica Docente Nivel III', 3, 8, 'obligatoria'),
(@carrera_edi_id, 'EDI-307', 'Descubrimiento del Medio Social y Natural', 4, 9, 'obligatoria'),
(@carrera_edi_id, 'FGC-208', 'Educación Constitucional', 3, 9, 'obligatoria'),
(@carrera_edi_id, 'EDI-304', 'Recursos Didácticos y Tecnológicos en el Nivel Inicial', 3, 9, 'obligatoria'),
(@carrera_edi_id, 'EDI-309', 'Expresión Corporal y Desarrollo Psicomotor', 3, 10, 'obligatoria'),
(@carrera_edi_id, 'EDL-315', 'Literatura Infantil', 3, 10, 'obligatoria'),
(@carrera_edi_id, 'PSE-101', 'Psicología Educativa', 4, 10, 'obligatoria'),
(@carrera_edi_id, 'EDI-308', 'Educación y Expresión Musical', 2, 10, 'obligatoria'),
(@carrera_edi_id, 'EDI-412', 'Manualidades y Artes Plásticas', 3, 11, 'obligatoria'),
(@carrera_edi_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 11, 'obligatoria'),
(@carrera_edi_id, 'PRA-305', 'Práctica Docente Nivel IV', 4, 11, 'obligatoria'),
(@carrera_edi_id, 'EDI-411', 'Higiene, Seguridad y Salud Infantil', 3, 12, 'obligatoria'),
(@carrera_edi_id, 'FGP-211', 'Desarrollo del Lenguaje', 3, 12, 'obligatoria'),
(@carrera_edi_id, 'FGP-315', 'Atención a la Diversidad', 3, 12, 'obligatoria'),
(@carrera_edi_id, 'PRA-405', 'Práctica Docente Nivel V', 3, 12, 'obligatoria'),
(@carrera_edi_id, 'FGC-409', 'Ética Profesional', 3, 13, 'obligatoria'),
(@carrera_edi_id, 'EDI-413', 'Escuela, Familia y Comunidad', 2, 13, 'obligatoria'),
(@carrera_edi_id, 'FGP-314', 'Logopedia', 3, 13, 'obligatoria'),
(@carrera_edi_id, 'OPT-102', 'Optativa 2', 3, 13, 'optativa'),
(@carrera_edi_id, 'FGC-413', 'Investigación Acción', 3, 14, 'obligatoria'),
(@carrera_edi_id, 'EDI-202', 'Normativas Legales para la Atención a la Primera Infancia', 2, 14, 'obligatoria'),
(@carrera_edi_id, 'EDP-414', 'Procesos de Enseñanza y Aprendizaje de la Lectura y la Escritura en el Nivel Inicial', 3, 14, 'obligatoria'),
(@carrera_edi_id, 'OPT-103', 'Optativa 3', 3, 14, 'optativa'),
(@carrera_edi_id, 'EDI-310', 'Estrategias Lúdicas', 3, 15, 'obligatoria'),
(@carrera_edi_id, 'FGP-308', 'Necesidades Específicas de Apoyo Educativo', 3, 15, 'obligatoria'),
(@carrera_edi_id, 'PPI-400', 'Práctica Profesional (Pasantía)', 5, 15, 'obligatoria'),
(@carrera_edi_id, 'EDI-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_edi_id, 'FGE-309', 'Metodología de Enseñanza Steam', 3, 0, 'optativa'),
(@carrera_edi_id, 'FGE-302', 'Educación Socioemocional del Docente y el Estudiante', 3, 0, 'optativa'),
(@carrera_edi_id, 'FGE-401', 'Administración y Legislación del Sistema Educativo Dominicano', 3, 0, 'optativa'),
(@carrera_edi_id, 'FGE-211', 'Planificación Educativa', 3, 0, 'optativa'),
(@carrera_edi_id, 'FGL-408', 'Inglés Básico I', 3, 0, 'optativa'),
(@carrera_edi_id, 'FGL-409', 'Inglés Básico II', 3, 0, 'optativa'),
(@carrera_edi_id, 'FGI-107', 'Inteligencia Artificial', 3, 0, 'optativa'),
(@carrera_edi_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 0, 'optativa'),
(@carrera_edi_id, 'FGP-421', 'Coaching', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 4. Licenciatura en Administración de Empresas
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Administración de Empresas', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_adm_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Administración de Empresas');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_adm_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_adm_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_adm_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_adm_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 2, 'obligatoria'),
(@carrera_adm_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 2, 'obligatoria'),
(@carrera_adm_id, 'ADM-103', 'Fundamentos de Administración Empresarial', 4, 2, 'obligatoria'),
(@carrera_adm_id, 'FGC-203', 'Filosofía y Sociedad', 3, 2, 'obligatoria'),
(@carrera_adm_id, 'CBE-110', 'Análisis y Producción de Textos', 4, 3, 'obligatoria'),
(@carrera_adm_id, 'MER-105', 'Fundamentos de Marketing', 4, 3, 'obligatoria'),
(@carrera_adm_id, 'COE-101', 'Contabilidad I', 4, 3, 'obligatoria'),
(@carrera_adm_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 4, 'obligatoria'),
(@carrera_adm_id, 'COE-102', 'Contabilidad II', 4, 4, 'obligatoria'),
(@carrera_adm_id, 'FGN-209', 'Economía Empresarial', 4, 4, 'obligatoria'),
(@carrera_adm_id, 'FGC-204', 'Investigación Aplicada', 4, 5, 'obligatoria'),
(@carrera_adm_id, 'FGN-207', 'Análisis de Datos I', 4, 5, 'obligatoria'),
(@carrera_adm_id, 'ADM-205', 'Gestión de Procesos Organizacionales', 4, 5, 'obligatoria'),
(@carrera_adm_id, 'FGN-208', 'Análisis de Datos II', 4, 6, 'obligatoria'),
(@carrera_adm_id, 'ADM-203', 'Teoría y Estructura Organizacional', 3, 6, 'obligatoria'),
(@carrera_adm_id, 'FGN-311', 'Inteligencia Artificial Aplicada a los Negocios', 3, 6, 'obligatoria'),
(@carrera_adm_id, 'OPT-101', 'Optativa 1', 3, 6, 'optativa'),
(@carrera_adm_id, 'FGD-414', 'Legislación Laboral', 4, 7, 'obligatoria'),
(@carrera_adm_id, 'ADM-222', 'Big Data para la Toma de Decisiones', 4, 7, 'obligatoria'),
(@carrera_adm_id, 'FGN-203', 'Matemática Financiera', 4, 7, 'obligatoria'),
(@carrera_adm_id, 'FGC-208', 'Educación Constitucional', 3, 8, 'obligatoria'),
(@carrera_adm_id, 'FGN-307', 'Seminario de Actualización para Negocios', 3, 8, 'obligatoria'),
(@carrera_adm_id, 'COE-307', 'Contabilidad de Costo I', 4, 8, 'obligatoria'),
(@carrera_adm_id, 'ADM-204', 'Administración de Operaciones', 4, 8, 'obligatoria'),
(@carrera_adm_id, 'FGC-106', 'Historia Social Dominicana', 3, 9, 'obligatoria'),
(@carrera_adm_id, 'ADM-207', 'Sostenibilidad y Responsabilidad Corporativa', 3, 9, 'obligatoria'),
(@carrera_adm_id, 'FGD-312', 'Legislación Comercial', 3, 9, 'obligatoria'),
(@carrera_adm_id, 'OPT-102', 'Optativa 2', 3, 9, 'optativa'),
(@carrera_adm_id, 'ADM-307', 'Presupuesto Empresarial', 4, 10, 'obligatoria'),
(@carrera_adm_id, 'ADM-206', 'Gestión de Calidad', 3, 10, 'obligatoria'),
(@carrera_adm_id, 'ADM-310', 'Logística y Cadena de Valor', 3, 10, 'obligatoria'),
(@carrera_adm_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 10, 'obligatoria'),
(@carrera_adm_id, 'ADM-417', 'Administración de Servicios', 4, 11, 'obligatoria'),
(@carrera_adm_id, 'ADM-311', 'Administración Estratégica I', 4, 11, 'obligatoria'),
(@carrera_adm_id, 'COE-331', 'Gerencia Financiera', 4, 11, 'obligatoria'),
(@carrera_adm_id, 'ADM-332', 'Práctica de Administración', 4, 12, 'obligatoria'),
(@carrera_adm_id, 'ADM-315', 'Administración Estratégica II', 4, 12, 'obligatoria'),
(@carrera_adm_id, 'ADM-418', 'Control de Procesos Administrativos', 4, 12, 'obligatoria'),
(@carrera_adm_id, 'ADM-312', 'Comercio y Finanzas Internacionales', 3, 13, 'obligatoria'),
(@carrera_adm_id, 'ADM-316', 'Formulación y Creación de Proyectos Emprendedores', 3, 13, 'obligatoria'),
(@carrera_adm_id, 'PPA-400', 'Práctica Profesional (Pasantía)', 8, 13, 'obligatoria'),
(@carrera_adm_id, 'ADM-419', 'Creación y Gerencia de Pymes', 4, 14, 'obligatoria'),
(@carrera_adm_id, 'FGC-409', 'Ética Profesional', 3, 14, 'obligatoria'),
(@carrera_adm_id, 'MER-423', 'E-commerce', 3, 14, 'obligatoria'),
(@carrera_adm_id, 'OPT-103', 'Optativa 3', 3, 14, 'optativa'),
(@carrera_adm_id, 'ADM-421', 'Productividad Empresarial', 4, 15, 'obligatoria'),
(@carrera_adm_id, 'ADM-443', 'Innovación Empresarial', 4, 15, 'obligatoria'),
(@carrera_adm_id, 'ADM-420', 'Simulación de Negocios', 4, 15, 'obligatoria'),
(@carrera_adm_id, 'ADM-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_adm_id, 'PSO-402', 'Gestión del Cambio Organizacional', 3, 0, 'optativa'),
(@carrera_adm_id, 'COE-221', 'Mercado de Valores', 3, 0, 'optativa'),
(@carrera_adm_id, 'FGD-321', 'Derecho Corporativo', 3, 0, 'optativa'),
(@carrera_adm_id, 'MER-319', 'Enfoques Contemporáneos de Gestión', 3, 0, 'optativa'),
(@carrera_adm_id, 'FGN-309', 'Metodologías de Emprendimiento', 3, 0, 'optativa'),
(@carrera_adm_id, 'CON-334', 'Finanzas Básicas para Emprendedores', 3, 0, 'optativa'),
(@carrera_adm_id, 'FGP-421', 'Coaching', 3, 0, 'optativa'),
(@carrera_adm_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 5. Licenciatura en Administración de Empresas Turísticas
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Administración de Empresas Turísticas', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_tur_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Administración de Empresas Turísticas');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_tur_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_tur_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_tur_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_tur_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 2, 'obligatoria'),
(@carrera_tur_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 2, 'obligatoria'),
(@carrera_tur_id, 'TUR-101', 'Fundamentos Teóricos de Turismo', 4, 2, 'obligatoria'),
(@carrera_tur_id, 'CBE-110', 'Análisis y Producción de Textos', 4, 3, 'obligatoria'),
(@carrera_tur_id, 'ING-101', 'Inglés Elemental I y Laboratorio', 5, 3, 'obligatoria'),
(@carrera_tur_id, 'TUR-103', 'Gestión de Empresas Turísticas I', 4, 3, 'obligatoria'),
(@carrera_tur_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 4, 'obligatoria'),
(@carrera_tur_id, 'ING-102', 'Inglés Elemental II y Laboratorio', 5, 4, 'obligatoria'),
(@carrera_tur_id, 'TUR-104', 'Gestión de Empresas Turísticas II', 4, 4, 'obligatoria'),
(@carrera_tur_id, 'FGC-203', 'Filosofía y Sociedad', 3, 5, 'obligatoria'),
(@carrera_tur_id, 'FGT-302', 'Cultura, Folklore y Patrimonio Dominicano', 3, 5, 'obligatoria'),
(@carrera_tur_id, 'ING-203', 'Inglés Intermedio I y Laboratorio', 5, 5, 'obligatoria'),
(@carrera_tur_id, 'FGC-204', 'Investigación Aplicada', 4, 6, 'obligatoria'),
(@carrera_tur_id, 'TUR-204', 'Geografía Turística Dominicana', 4, 6, 'obligatoria'),
(@carrera_tur_id, 'ING-204', 'Inglés Intermedio II y Laboratorio', 5, 6, 'obligatoria'),
(@carrera_tur_id, 'FGC-106', 'Historia Social Dominicana', 3, 7, 'obligatoria'),
(@carrera_tur_id, 'FGL-401', 'Inglés Técnico para Turismo', 4, 7, 'obligatoria'),
(@carrera_tur_id, 'FGC-409', 'Ética Profesional', 3, 7, 'obligatoria'),
(@carrera_tur_id, 'OPT-101', 'Optativa 1', 3, 7, 'optativa'),
(@carrera_tur_id, 'TUR-210', 'Economía del Turismo', 4, 8, 'obligatoria'),
(@carrera_tur_id, 'FGN-308', 'Contabilidad General', 4, 8, 'obligatoria'),
(@carrera_tur_id, 'FGT-201', 'Etiqueta, Protocolo y Eventos', 4, 8, 'obligatoria'),
(@carrera_tur_id, 'FGC-208', 'Educación Constitucional', 3, 9, 'obligatoria'),
(@carrera_tur_id, 'TUR-311', 'Recreación y Animación Cultural', 4, 9, 'obligatoria'),
(@carrera_tur_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 9, 'obligatoria'),
(@carrera_tur_id, 'OPT-102', 'Optativa 2', 3, 9, 'optativa'),
(@carrera_tur_id, 'FGN-206', 'Tecnología Aplicada al Turismo', 3, 10, 'obligatoria'),
(@carrera_tur_id, 'TUR-203', 'Operación y Alojamiento', 4, 10, 'obligatoria'),
(@carrera_tur_id, 'TUR-314', 'Costos Hoteleros', 4, 10, 'obligatoria'),
(@carrera_tur_id, 'TUR-211', 'Sostenibilidad y Turismo Responsable', 4, 11, 'obligatoria'),
(@carrera_tur_id, 'FGD-415', 'Legislación Laboral y Turística', 4, 11, 'obligatoria'),
(@carrera_tur_id, 'TUR-423', 'Cultura y Patrimonio Internacional', 3, 11, 'obligatoria'),
(@carrera_tur_id, 'PPT-400', 'Pasantía General', 8, 11, 'obligatoria'),
(@carrera_tur_id, 'TUR-421', 'Diseños de Rutas', 3, 12, 'obligatoria'),
(@carrera_tur_id, 'TUR-320', 'Guia Turístico', 3, 12, 'obligatoria'),
(@carrera_tur_id, 'TUR-212', 'Gastronomía Dominicana I-Lab.', 4, 12, 'obligatoria'),
(@carrera_tur_id, 'OPT-103', 'Optativa 3', 3, 12, 'optativa'),
(@carrera_tur_id, 'TUR-313', 'Gestión de Calidad Turística', 4, 13, 'obligatoria'),
(@carrera_tur_id, 'TUR-321', 'Gastronomía Dominicana II-Lab.', 4, 13, 'obligatoria'),
(@carrera_tur_id, 'TUR-322', 'Marketing Turístico Digital', 4, 13, 'obligatoria'),
(@carrera_tur_id, 'TUR-420', 'Formulación de Proyectos Turísticos', 4, 14, 'obligatoria'),
(@carrera_tur_id, 'TUR-417', 'Servicios de Restaurantes y Bares', 4, 14, 'obligatoria'),
(@carrera_tur_id, 'TUR-426', 'Gestión y Logística de Viajes', 4, 14, 'obligatoria'),
(@carrera_tur_id, 'PPT-401', 'Práctica Profesional (Pasantía)', 8, 14, 'obligatoria'),
(@carrera_tur_id, 'TUR-425', 'Planificación y Desarrollo Turístico', 4, 15, 'obligatoria'),
(@carrera_tur_id, 'PSI-203', 'Gestión Humana', 4, 15, 'obligatoria'),
(@carrera_tur_id, 'TUR-424', 'Innovación y Emprendimiento en Turismo', 4, 15, 'obligatoria'),
(@carrera_tur_id, 'ADT-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_tur_id, 'ENF-232', 'Taller Primeros Auxilios', 3, 0, 'optativa'),
(@carrera_tur_id, 'FGT-303', 'Lenguaje de Señas', 3, 0, 'optativa'),
(@carrera_tur_id, 'FGT-304', 'Gestión de Museos y Espacios Culturales', 3, 0, 'optativa'),
(@carrera_tur_id, 'FGN-309', 'Metodologías de Emprendimiento', 3, 0, 'optativa'),
(@carrera_tur_id, 'ADM-316', 'Formulación y Creación de Proyectos Emprendedores', 3, 0, 'optativa'),
(@carrera_tur_id, 'CON-334', 'Finanzas Básicas para Emprendedores', 3, 0, 'optativa'),
(@carrera_tur_id, 'FGP-421', 'Coaching', 3, 0, 'optativa'),
(@carrera_tur_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 6. Licenciatura en Contabilidad Empresarial
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Contabilidad Empresarial', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_coe_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Contabilidad Empresarial');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_coe_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_coe_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_coe_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_coe_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 2, 'obligatoria'),
(@carrera_coe_id, 'ADM-103', 'Fundamentos de Administración Empresarial', 4, 2, 'obligatoria'),
(@carrera_coe_id, 'COE-101', 'Contabilidad I', 4, 2, 'obligatoria'),
(@carrera_coe_id, 'CBE-110', 'Análisis y Producción de Textos', 4, 3, 'obligatoria'),
(@carrera_coe_id, 'COE-102', 'Contabilidad II', 4, 3, 'obligatoria'),
(@carrera_coe_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 3, 'obligatoria'),
(@carrera_coe_id, 'FGD-312', 'Legislación Comercial', 3, 4, 'obligatoria'),
(@carrera_coe_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 4, 'obligatoria'),
(@carrera_coe_id, 'MER-105', 'Fundamentos de Marketing', 4, 4, 'obligatoria'),
(@carrera_coe_id, 'FGC-203', 'Filosofía y Sociedad', 3, 4, 'obligatoria'),
(@carrera_coe_id, 'COE-203', 'Contabilidad III', 4, 5, 'obligatoria'),
(@carrera_coe_id, 'FGN-207', 'Análisis de Datos I', 4, 5, 'obligatoria'),
(@carrera_coe_id, 'FGD-414', 'Legislación Laboral', 4, 5, 'obligatoria'),
(@carrera_coe_id, 'FGN-208', 'Análisis de Datos II', 4, 6, 'obligatoria'),
(@carrera_coe_id, 'FGN-209', 'Economía Empresarial', 4, 6, 'obligatoria'),
(@carrera_coe_id, 'COE-205', 'Contabilidad Superior', 4, 6, 'obligatoria'),
(@carrera_coe_id, 'FGN-203', 'Matemática Financiera', 4, 7, 'obligatoria'),
(@carrera_coe_id, 'COE-221', 'Mercado de Valores', 3, 7, 'obligatoria'),
(@carrera_coe_id, 'FGC-208', 'Educación Constitucional', 3, 7, 'obligatoria'),
(@carrera_coe_id, 'OPT-101', 'Optativa 1', 3, 7, 'optativa'),
(@carrera_coe_id, 'FGC-204', 'Investigación Aplicada', 4, 8, 'obligatoria'),
(@carrera_coe_id, 'COE-206', 'Sistema de Contabilidad', 4, 8, 'obligatoria'),
(@carrera_coe_id, 'COE-307', 'Contabilidad de Costos I', 4, 8, 'obligatoria'),
(@carrera_coe_id, 'ADM-307', 'Presupuesto Empresarial', 4, 9, 'obligatoria'),
(@carrera_coe_id, 'COE-313', 'Contabilidad Computarizada', 4, 9, 'obligatoria'),
(@carrera_coe_id, 'COE-309', 'Contabilidad de Costos II', 4, 9, 'obligatoria'),
(@carrera_coe_id, 'COE-311', 'Auditoría I', 4, 10, 'obligatoria'),
(@carrera_coe_id, 'COE-331', 'Gerencia Financiera', 4, 10, 'obligatoria'),
(@carrera_coe_id, 'COE-332', 'Gestión Fiscal I', 4, 10, 'obligatoria'),
(@carrera_coe_id, 'COE-308', 'Práctica de Contabilidad I', 4, 11, 'obligatoria'),
(@carrera_coe_id, 'COE-314', 'Auditoría II', 4, 11, 'obligatoria'),
(@carrera_coe_id, 'COE-333', 'Gestión Fiscal II', 4, 11, 'obligatoria'),
(@carrera_coe_id, 'ADM-316', 'Formulación y Creación de Proyectos Emprendedores', 3, 12, 'obligatoria'),
(@carrera_coe_id, 'COE-417', 'Práctica de Contabilidad II', 4, 12, 'obligatoria'),
(@carrera_coe_id, 'FGC-106', 'Historia Social Dominicana', 3, 12, 'obligatoria'),
(@carrera_coe_id, 'OPT-102', 'Optativa 2', 3, 12, 'optativa'),
(@carrera_coe_id, 'MER-423', 'E-commerce', 3, 13, 'obligatoria'),
(@carrera_coe_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 13, 'obligatoria'),
(@carrera_coe_id, 'PPN-400', 'Práctica Profesional (Pasantía)', 8, 13, 'obligatoria'),
(@carrera_coe_id, 'COE-418', 'Auditoría Fiscal y Financiera', 4, 14, 'obligatoria'),
(@carrera_coe_id, 'FGN-311', 'Inteligencia Artificial Aplicada a los Negocios', 3, 14, 'obligatoria'),
(@carrera_coe_id, 'ADM-207', 'Sostenibilidad y Responsabilidad Corporativa', 3, 14, 'obligatoria'),
(@carrera_coe_id, 'OPT-103', 'Optativa 3', 3, 14, 'optativa'),
(@carrera_coe_id, 'FGN-307', 'Seminario de Actualización para Negocios', 3, 15, 'obligatoria'),
(@carrera_coe_id, 'COE-447', 'Gestión Contable y Toma de Decisiones', 3, 15, 'obligatoria'),
(@carrera_coe_id, 'FGC-409', 'Ética Profesional', 3, 15, 'obligatoria'),
(@carrera_coe_id, 'COE-420', 'Finanzas Públicas y Gestión Fiscal', 4, 15, 'obligatoria'),
(@carrera_coe_id, 'CON-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_coe_id, 'MER-319', 'Enfoques Contemporáneos de Gestión', 3, 0, 'optativa'),
(@carrera_coe_id, 'ADM-312', 'Comercio y Finanzas Internacionales', 3, 0, 'optativa'),
(@carrera_coe_id, 'PSO-402', 'Gestión del Cambio Organizacional', 3, 0, 'optativa'),
(@carrera_coe_id, 'ADM-203', 'Teoría y Estructura Organizacional', 3, 0, 'optativa'),
(@carrera_coe_id, 'FGN-309', 'Metodologías de Emprendimiento', 3, 0, 'optativa'),
(@carrera_coe_id, 'CON-334', 'Finanzas Básicas para Emprendedores', 3, 0, 'optativa'),
(@carrera_coe_id, 'FGP-421', 'Coaching', 3, 0, 'optativa'),
(@carrera_coe_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 7. Licenciatura en Derecho
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Derecho', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_der_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Derecho');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_der_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_der_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_der_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_der_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 2, 'obligatoria'),
(@carrera_der_id, 'CBE-110', 'Análisis y Producción de Textos', 4, 2, 'obligatoria'),
(@carrera_der_id, 'DER-106', 'Introducción al Estudio del Derecho', 4, 2, 'obligatoria'),
(@carrera_der_id, 'FGD-101', 'Derecho Romano', 3, 3, 'obligatoria'),
(@carrera_der_id, 'FGD-102', 'Sociología Jurídica', 3, 3, 'obligatoria'),
(@carrera_der_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 3, 'obligatoria'),
(@carrera_der_id, 'FGC-106', 'Historia Social Dominicana', 3, 3, 'obligatoria'),
(@carrera_der_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 4, 'obligatoria'),
(@carrera_der_id, 'DER-102', 'Derecho de las Personas y la Familia', 4, 4, 'obligatoria'),
(@carrera_der_id, 'FGD-205', 'Lógica y Filosofia Jurídica', 3, 4, 'obligatoria'),
(@carrera_der_id, 'FGD-103', 'Historia del Derecho y de las Ideas Políticas', 3, 4, 'obligatoria'),
(@carrera_der_id, 'DER-206', 'Derecho Penal General', 4, 5, 'obligatoria'),
(@carrera_der_id, 'FGC-204', 'Investigación Aplicada', 4, 5, 'obligatoria'),
(@carrera_der_id, 'DER-217', 'Teoría de las Obligaciones', 4, 5, 'obligatoria'),
(@carrera_der_id, 'DER-218', 'Métodos Alternativos de Resolución de Conflictos', 3, 6, 'obligatoria'),
(@carrera_der_id, 'DER-219', 'Los Contratos y las Garantías', 4, 6, 'obligatoria'),
(@carrera_der_id, 'DER-204', 'Derecho Constitucional y sus Procedimientos', 4, 6, 'obligatoria'),
(@carrera_der_id, 'OPT-101', 'Optativa 1', 3, 6, 'optativa'),
(@carrera_der_id, 'DER-209', 'Derecho Administrativo y sus Procedimientos', 4, 7, 'obligatoria'),
(@carrera_der_id, 'DER-212', 'Derecho Comercial y Societario', 4, 7, 'obligatoria'),
(@carrera_der_id, 'DER-208', 'Derecho Penal Especial I', 4, 7, 'obligatoria'),
(@carrera_der_id, 'DER-211', 'Derecho Penal Especial II', 4, 8, 'obligatoria'),
(@carrera_der_id, 'FGD-306', 'Derecho Internacional Público', 3, 8, 'obligatoria'),
(@carrera_der_id, 'DER-227', 'Derecho de la Propiedad Intelectual', 4, 8, 'obligatoria'),
(@carrera_der_id, 'OPT-102', 'Optativa 2', 3, 8, 'optativa'),
(@carrera_der_id, 'DER-315', 'Derecho Procesal Penal I', 4, 9, 'obligatoria'),
(@carrera_der_id, 'DER-314', 'Derecho Procesal Civil I', 4, 9, 'obligatoria'),
(@carrera_der_id, 'FGD-308', 'Derecho Internacional Privado', 3, 9, 'obligatoria'),
(@carrera_der_id, 'DER-332', 'Argumentación y Técnicas de Redacción Jurídica', 3, 9, 'obligatoria'),
(@carrera_der_id, 'DER-319', 'Derecho Procesal Penal II', 4, 10, 'obligatoria'),
(@carrera_der_id, 'DER-343', 'Derecho Procesal Civil II', 4, 10, 'obligatoria'),
(@carrera_der_id, 'FGD-413', 'Deontología Jurídica', 3, 10, 'obligatoria'),
(@carrera_der_id, 'OPT-103', 'Optativa 3', 3, 10, 'optativa'),
(@carrera_der_id, 'DER-344', 'Derecho Procesal Civil III', 4, 11, 'obligatoria'),
(@carrera_der_id, 'FGD-309', 'Derecho Comparado', 3, 11, 'obligatoria'),
(@carrera_der_id, 'DER-339', 'Responsabilidad Civil', 4, 11, 'obligatoria'),
(@carrera_der_id, 'DER-340', 'Derecho Laboral y Seguridad Social', 3, 11, 'obligatoria'),
(@carrera_der_id, 'DER-320', 'Práctica Jurídica I (Derecho Privado)', 4, 12, 'obligatoria'),
(@carrera_der_id, 'DER-342', 'Sucesiones y Liberalidades', 4, 12, 'obligatoria'),
(@carrera_der_id, 'DER-428', 'Legislación de Tránsito', 4, 12, 'obligatoria'),
(@carrera_der_id, 'FGD-310', 'Criminología', 4, 13, 'obligatoria'),
(@carrera_der_id, 'DER-422', 'Práctica Jurídica II (Derecho Público)', 4, 13, 'obligatoria'),
(@carrera_der_id, 'DER-318', 'Derecho Notarial', 4, 13, 'obligatoria'),
(@carrera_der_id, 'DER-424', 'Derecho Inmobiliario', 4, 14, 'obligatoria'),
(@carrera_der_id, 'DER-426', 'Medicina Forense', 4, 14, 'obligatoria'),
(@carrera_der_id, 'PPD-400', 'Práctica Profesional (Pasantía)', 8, 14, 'obligatoria'),
(@carrera_der_id, 'DER-425', 'Penología y Derecho Penitenciario', 4, 15, 'obligatoria'),
(@carrera_der_id, 'FGD-451', 'Seminario de Actualización Jurídica', 3, 15, 'obligatoria'),
(@carrera_der_id, 'DER-430', 'Legislación Tributaria, Monetaria y Financiera', 3, 15, 'obligatoria'),
(@carrera_der_id, 'DER-429', 'Criminalística', 4, 15, 'obligatoria'),
(@carrera_der_id, 'DER-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_der_id, 'FGD-218', 'Derecho Urbanístico y Medio Ambiente', 3, 0, 'optativa'),
(@carrera_der_id, 'FGD-219', 'Derecho Consular y Migratorio', 3, 0, 'optativa'),
(@carrera_der_id, 'FGD-320', 'Informática Jurídica y Delitos de Alta Tecnología', 3, 0, 'optativa'),
(@carrera_der_id, 'DER-345', 'Gestión de Despachos Jurídicos', 3, 0, 'optativa'),
(@carrera_der_id, 'FGN-309', 'Metodologías de Emprendimiento', 3, 0, 'optativa'),
(@carrera_der_id, 'ADM-316', 'Formulación y Creación de Proyectos Emprendedores', 3, 0, 'optativa'),
(@carrera_der_id, 'CON-334', 'Finanzas Básicas para Emprendedores', 3, 0, 'optativa'),
(@carrera_der_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 0, 'optativa'),
(@carrera_der_id, 'FGP-421', 'Coaching', 3, 0, 'optativa'),
(@carrera_der_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 8. Licenciatura en Educación Artística
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Educación Artística', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_ear_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Educación Artística');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_ear_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_ear_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_ear_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_ear_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 2, 'obligatoria'),
(@carrera_ear_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 2, 'obligatoria'),
(@carrera_ear_id, 'EAR-101', 'Introducción a la Educación Artística', 4, 2, 'obligatoria'),
(@carrera_ear_id, 'CBE-110', 'Análisis y Producción de Textos', 4, 3, 'obligatoria'),
(@carrera_ear_id, 'PSG-105', 'Introducción a la Psicología', 3, 3, 'obligatoria'),
(@carrera_ear_id, 'EAR-102', 'Valoración Estética y Cultural', 4, 3, 'obligatoria'),
(@carrera_ear_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 4, 'obligatoria'),
(@carrera_ear_id, 'FGE-101', 'Fundamento Filosóficos e Históricos de la Educación', 4, 4, 'obligatoria'),
(@carrera_ear_id, 'FGP-207', 'Neurociencias y Aprendizaje', 3, 4, 'obligatoria'),
(@carrera_ear_id, 'FGC-203', 'Filosofía y Sociedad', 3, 5, 'obligatoria'),
(@carrera_ear_id, 'FGE-209', 'Didáctica General', 3, 5, 'obligatoria'),
(@carrera_ear_id, 'EAR-204', 'Composición y Teoría del Color', 3, 5, 'obligatoria'),
(@carrera_ear_id, 'FGP-103', 'Psicología del Desarrollo I (de 6 a 9 años)', 3, 5, 'obligatoria'),
(@carrera_ear_id, 'FGC-204', 'Investigación Aplicada', 4, 6, 'obligatoria'),
(@carrera_ear_id, 'FGE-102', 'Fundamento y Estructura del Currículo', 3, 6, 'obligatoria'),
(@carrera_ear_id, 'EAR-205', 'Taller de Dibujo', 4, 6, 'obligatoria'),
(@carrera_ear_id, 'FGC-106', 'Historia Social Dominicana', 3, 7, 'obligatoria'),
(@carrera_ear_id, 'EAR-206', 'Taller de Escultura y Modelado', 4, 7, 'obligatoria'),
(@carrera_ear_id, 'PRA-210', 'Práctica Docente I', 2, 7, 'obligatoria'),
(@carrera_ear_id, 'FGP-104', 'Psicología del Desarrollo II (9 a 12 años)', 3, 7, 'obligatoria'),
(@carrera_ear_id, 'EAR-207', 'Pintura y Expresión Creativa', 4, 8, 'obligatoria'),
(@carrera_ear_id, 'EAR-208', 'Apreciación y Expresión Musical', 3, 8, 'obligatoria'),
(@carrera_ear_id, 'PRA-211', 'Práctica Docente II', 3, 8, 'obligatoria'),
(@carrera_ear_id, 'OPT-101', 'Optativa 1', 3, 8, 'optativa'),
(@carrera_ear_id, 'FGE-206', 'Evaluación de los Aprendizajes', 3, 9, 'obligatoria'),
(@carrera_ear_id, 'FGE-203', 'Proceso de Enseñanza Aprendizaje', 4, 9, 'obligatoria'),
(@carrera_ear_id, 'EAR-314', 'Didáctica para la Enseñanza de la Educación Artística', 4, 9, 'obligatoria'),
(@carrera_ear_id, 'FGC-409', 'Ética Profesional', 3, 10, 'obligatoria'),
(@carrera_ear_id, 'EAR-310', 'Historia de la Arquitectura', 3, 10, 'obligatoria'),
(@carrera_ear_id, 'PRA-212', 'Práctica Docente III', 3, 10, 'obligatoria'),
(@carrera_ear_id, 'OPT-102', 'Optativa 2', 3, 10, 'optativa'),
(@carrera_ear_id, 'FGP-106', 'Psicología de Adolescentes (12 a 18 años)', 3, 11, 'obligatoria'),
(@carrera_ear_id, 'FGE-306', 'Gestión de Ambientes de Aprendizaje y el Aula', 3, 11, 'obligatoria'),
(@carrera_ear_id, 'EAR-311', 'Medios y Recursos Multimedia Aplicada a las Artes', 4, 11, 'obligatoria'),
(@carrera_ear_id, 'EAR-312', 'Taller de Artes Escénicas', 4, 12, 'obligatoria'),
(@carrera_ear_id, 'PRA-324', 'Práctica Docente IV', 4, 12, 'obligatoria'),
(@carrera_ear_id, 'EAR-313', 'Taller de Artesanía', 4, 12, 'obligatoria'),
(@carrera_ear_id, 'EAR-414', 'Panorama y Taller de Teatro', 4, 13, 'obligatoria'),
(@carrera_ear_id, 'EAR-415', 'Expresión Corporal', 3, 13, 'obligatoria'),
(@carrera_ear_id, 'FGC-208', 'Educación Constitucional', 3, 13, 'obligatoria'),
(@carrera_ear_id, 'OPT-103', 'Optativa 3', 3, 13, 'optativa'),
(@carrera_ear_id, 'FGP-210', 'Psicología del Aprendizaje', 3, 14, 'obligatoria'),
(@carrera_ear_id, 'EAR-309', 'Folklore Dominicano y Caribeño', 4, 14, 'obligatoria'),
(@carrera_ear_id, 'EAR-416', 'Fotografía y Medios Visuales', 3, 14, 'obligatoria'),
(@carrera_ear_id, 'PRA-416', 'Práctica Docente V', 3, 14, 'obligatoria'),
(@carrera_ear_id, 'EAR-417', 'Panorama y Taller de Cine', 4, 15, 'obligatoria'),
(@carrera_ear_id, 'EAR-418', 'Animación Socio-Cultural', 3, 15, 'obligatoria'),
(@carrera_ear_id, 'PEA-400', 'Práctica Profesional (Pasantía)', 5, 15, 'obligatoria'),
(@carrera_ear_id, 'EAR-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_ear_id, 'EAR-209', 'Panorama de la Cinematografía', 3, 0, 'optativa'),
(@carrera_ear_id, 'FGE-302', 'Educación Socioemocional del Docente y el Estudiante', 3, 0, 'optativa'),
(@carrera_ear_id, 'FGE-401', 'Administración y Legislación del Sistema Educativo Dominicano', 3, 0, 'optativa'),
(@carrera_ear_id, 'FGE-211', 'Planificación Educativa', 3, 0, 'optativa'),
(@carrera_ear_id, 'FGL-408', 'Inglés Básico I', 3, 0, 'optativa'),
(@carrera_ear_id, 'FGL-409', 'Inglés Básico II', 3, 0, 'optativa'),
(@carrera_ear_id, 'FGE-309', 'Metodología de Enseñanza Steam', 3, 0, 'optativa'),
(@carrera_ear_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 0, 'optativa'),
(@carrera_ear_id, 'FGP-421', 'Coaching', 3, 0, 'optativa'),
(@carrera_ear_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 9. Licenciatura en Educación Mención Lenguas Extranjeras (Francés)
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Educación Mención Lenguas Extranjeras (Francés)', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_fra_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Educación Mención Lenguas Extranjeras (Francés)');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_fra_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_fra_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_fra_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_fra_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 2, 'obligatoria'),
(@carrera_fra_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 2, 'obligatoria'),
(@carrera_fra_id, 'FGE-101', 'Fundamentos Filosóficos e Históricos de la Educación', 4, 2, 'obligatoria'),
(@carrera_fra_id, 'PSG-105', 'Introducción a la Psicología', 3, 3, 'obligatoria'),
(@carrera_fra_id, 'FGE-102', 'Fundamento y Estructura del Currículo', 3, 3, 'obligatoria'),
(@carrera_fra_id, 'FRA-203', 'Francés Intermedio I y Laboratorio', 5, 3, 'obligatoria'),
(@carrera_fra_id, 'FGP-210', 'Psicología del Aprendizaje', 3, 4, 'obligatoria'),
(@carrera_fra_id, 'FGP-207', 'Neurociencias y Aprendizaje', 3, 4, 'obligatoria'),
(@carrera_fra_id, 'FRA-304', 'Francés Intermedio II y Laboratorio', 5, 4, 'obligatoria'),
(@carrera_fra_id, 'FGE-209', 'Didáctica General', 3, 5, 'obligatoria'),
(@carrera_fra_id, 'FGP-106', 'Psicología del Adolescente (12-18 años)', 3, 5, 'obligatoria'),
(@carrera_fra_id, 'FRA-204', 'Francés Intermedio III y Laboratorio', 5, 5, 'obligatoria'),
(@carrera_fra_id, 'FGE-203', 'Procesos de Enseñanza y Aprendizaje', 4, 6, 'obligatoria'),
(@carrera_fra_id, 'EDL-213', 'Introducción a la Lingüística', 3, 6, 'obligatoria'),
(@carrera_fra_id, 'FRA-305', 'Francés Avanzado I y Laboratorio', 5, 6, 'obligatoria'),
(@carrera_fra_id, 'FGC-106', 'Historia Social Dominicana', 3, 7, 'obligatoria'),
(@carrera_fra_id, 'FRA-306', 'Francés Avanzado II y Laboratorio', 5, 7, 'obligatoria'),
(@carrera_fra_id, 'FGE-306', 'Gestión de Ambientes de Aprendizaje y el Aula', 3, 7, 'obligatoria'),
(@carrera_fra_id, 'ELF-208', 'Lingüística Aplicada a la Enseñanza del FLE', 3, 8, 'obligatoria'),
(@carrera_fra_id, 'FGC-204', 'Investigación Aplicada', 4, 8, 'obligatoria'),
(@carrera_fra_id, 'FRA-205', 'Francés Avanzado III y Laboratorio', 5, 8, 'obligatoria'),
(@carrera_fra_id, 'FGC-208', 'Educación Constitucional', 3, 9, 'obligatoria'),
(@carrera_fra_id, 'ELF-209', 'Teorías de la Enseñanza del FLE', 3, 9, 'obligatoria'),
(@carrera_fra_id, 'FRA-307', 'Conversación Francesa', 4, 9, 'obligatoria'),
(@carrera_fra_id, 'OPT-101', 'Optativa 1', 3, 9, 'optativa'),
(@carrera_fra_id, 'FRA-408', 'Gramática Francesa', 4, 10, 'obligatoria'),
(@carrera_fra_id, 'ELF-310', 'Didáctica Especial del Francés I', 3, 10, 'obligatoria'),
(@carrera_fra_id, 'PRA-316', 'Práctica Docente I', 2, 10, 'obligatoria'),
(@carrera_fra_id, 'OPT-102', 'Optativa 2', 3, 10, 'optativa'),
(@carrera_fra_id, 'FRA-308', 'Fonética y Fonología Francesa', 4, 11, 'obligatoria'),
(@carrera_fra_id, 'PRA-326', 'Práctica Docente II', 3, 11, 'obligatoria'),
(@carrera_fra_id, 'ELF-313', 'Didáctica Especial del Francés II', 3, 11, 'obligatoria'),
(@carrera_fra_id, 'OPT-103', 'Optativa 3', 3, 11, 'optativa'),
(@carrera_fra_id, 'PRA-327', 'Práctica Docente III', 3, 12, 'obligatoria'),
(@carrera_fra_id, 'FRA-309', 'Composición Francesa', 4, 12, 'obligatoria'),
(@carrera_fra_id, 'FGC-203', 'Filosofía y Sociedad', 3, 12, 'obligatoria'),
(@carrera_fra_id, 'ELF-314', 'Evaluación de los Aprendizajes en la Lengua Francesa', 4, 13, 'obligatoria'),
(@carrera_fra_id, 'PRA-418', 'Práctica Docente IV', 4, 13, 'obligatoria'),
(@carrera_fra_id, 'FRA-410', 'Cultura Francófona', 4, 13, 'obligatoria'),
(@carrera_fra_id, 'FRA-415', 'Introducción a la Literatura de los Países Francófonos', 3, 14, 'obligatoria'),
(@carrera_fra_id, 'FGP-308', 'Necesidades Específicas de Apoyo Educativo', 3, 14, 'obligatoria'),
(@carrera_fra_id, 'PRA-419', 'Práctica Docente V', 3, 14, 'obligatoria'),
(@carrera_fra_id, 'ELF-416', 'Interculturalidad en la Clase de FLE', 3, 14, 'obligatoria'),
(@carrera_fra_id, 'ELF-417', 'Seminario de Investigación en Francés', 4, 15, 'obligatoria'),
(@carrera_fra_id, 'FGC-409', 'Ética Profesional', 3, 15, 'obligatoria'),
(@carrera_fra_id, 'PPF-400', 'Práctica Profesional (Pasantía)', 5, 15, 'obligatoria'),
(@carrera_fra_id, 'ELF-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_fra_id, 'FGP-314', 'Logopedia', 3, 0, 'optativa'),
(@carrera_fra_id, 'FGE-401', 'Administración y Legislación del Sistema Educativo Dominicano', 3, 0, 'optativa'),
(@carrera_fra_id, 'EDL-326', 'Sociolingüística', 3, 0, 'optativa'),
(@carrera_fra_id, 'FGP-315', 'Atención a la Diversidad', 3, 0, 'optativa'),
(@carrera_fra_id, 'FGE-309', 'Metodología de Enseñanza STEAM', 3, 0, 'optativa'),
(@carrera_fra_id, 'FGE-211', 'Planificación Educativa', 3, 0, 'optativa'),
(@carrera_fra_id, 'FGE-302', 'Educación Socioemocional del Docente y el Estudiante', 3, 0, 'optativa'),
(@carrera_fra_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 0, 'optativa'),
(@carrera_fra_id, 'FGP-421', 'Coaching', 3, 0, 'optativa'),
(@carrera_fra_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 10. Licenciatura en Educación Mención Lenguas Extranjeras (Inglés)
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Educación Mención Lenguas Extranjeras (Inglés)', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_ing_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Educación Mención Lenguas Extranjeras (Inglés)');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_ing_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_ing_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_ing_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_ing_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 2, 'obligatoria'),
(@carrera_ing_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 2, 'obligatoria'),
(@carrera_ing_id, 'FGE-101', 'Fundamentos Filosóficos e Históricos de la Educación', 4, 2, 'obligatoria'),
(@carrera_ing_id, 'PSG-105', 'Introducción a la Psicología', 3, 3, 'obligatoria'),
(@carrera_ing_id, 'FGE-102', 'Fundamento y Estructura del Currículo', 3, 3, 'obligatoria'),
(@carrera_ing_id, 'ING-206', 'Inglés Avanzado I y Laboratorio', 5, 3, 'obligatoria'),
(@carrera_ing_id, 'FGP-210', 'Psicología del Aprendizaje', 3, 4, 'obligatoria'),
(@carrera_ing_id, 'FGP-207', 'Neurociencias y Aprendizaje', 3, 4, 'obligatoria'),
(@carrera_ing_id, 'ING-207', 'Inglés Avanzado II y Laboratorio', 5, 4, 'obligatoria'),
(@carrera_ing_id, 'FGC-203', 'Filosofía y Sociedad', 3, 5, 'obligatoria'),
(@carrera_ing_id, 'FGP-106', 'Psicología del Adolescente (12-18 años)', 3, 5, 'obligatoria'),
(@carrera_ing_id, 'ING-211', 'Inglés Avanzado III y Laboratorio', 5, 5, 'obligatoria'),
(@carrera_ing_id, 'FGE-209', 'Didáctica General', 3, 6, 'obligatoria'),
(@carrera_ing_id, 'EDL-213', 'Introducción a la Lingüística', 3, 6, 'obligatoria'),
(@carrera_ing_id, 'ING-311', 'Conversación Inglesa', 4, 6, 'obligatoria'),
(@carrera_ing_id, 'FGE-306', 'Gestión de Ambientes de Aprendizaje y el Aula', 3, 6, 'obligatoria'),
(@carrera_ing_id, 'FGC-106', 'Historia Social Dominicana', 3, 7, 'obligatoria'),
(@carrera_ing_id, 'EDL-326', 'Sociolingüística', 3, 7, 'obligatoria'),
(@carrera_ing_id, 'ING-314', 'Gramática Inglesa', 4, 7, 'obligatoria'),
(@carrera_ing_id, 'OPT-101', 'Optativa 1', 3, 7, 'optativa'),
(@carrera_ing_id, 'FGE-203', 'Procesos de Enseñanza y Aprendizaje', 4, 8, 'obligatoria'),
(@carrera_ing_id, 'ELI-217', 'Teorías de Enseñanza-Aprendizaje de Lengua Inglesa', 3, 8, 'obligatoria'),
(@carrera_ing_id, 'ING-327', 'Fonética y Fonología Inglesa', 4, 8, 'obligatoria'),
(@carrera_ing_id, 'ELI-318', 'Metodología de la Enseñanza del Inglés', 4, 9, 'obligatoria'),
(@carrera_ing_id, 'FGC-208', 'Educación Constitucional', 3, 9, 'obligatoria'),
(@carrera_ing_id, 'ING-208', 'Lingüística Aplicada a la Enseñanza del Inglés', 4, 9, 'obligatoria'),
(@carrera_ing_id, 'ELI-312', 'Didáctica Especial del Inglés I', 3, 10, 'obligatoria'),
(@carrera_ing_id, 'PRA-322', 'Práctica Docente I', 2, 10, 'obligatoria'),
(@carrera_ing_id, 'FGC-204', 'Investigación Aplicada', 4, 10, 'obligatoria'),
(@carrera_ing_id, 'OPT-102', 'Optativa 2', 3, 10, 'optativa'),
(@carrera_ing_id, 'ELI-313', 'Didáctica Especial del Inglés II', 3, 11, 'obligatoria'),
(@carrera_ing_id, 'PRA-323', 'Práctica Docente II', 3, 11, 'obligatoria'),
(@carrera_ing_id, 'ING-322', 'Composición Inglesa', 4, 11, 'obligatoria'),
(@carrera_ing_id, 'FGP-308', 'Necesidades Específicas de Apoyo Educativo', 3, 11, 'obligatoria'),
(@carrera_ing_id, 'FGE-213', 'Medios y Recursos para el Aprendizaje', 3, 12, 'obligatoria'),
(@carrera_ing_id, 'PRA-328', 'Práctica Docente III', 3, 12, 'obligatoria'),
(@carrera_ing_id, 'ELI-419', 'Historia de la Lengua Inglesa', 3, 12, 'obligatoria'),
(@carrera_ing_id, 'ELI-320', 'Evaluación de los Aprendizajes en la Lengua Inglesa', 4, 12, 'obligatoria'),
(@carrera_ing_id, 'ING-323', 'Introducción a la Literatura de los Países Anglófonos', 3, 13, 'obligatoria'),
(@carrera_ing_id, 'PRA-412', 'Práctica Docente IV', 4, 13, 'obligatoria'),
(@carrera_ing_id, 'FGE-408', 'Innovación Educativa', 3, 13, 'obligatoria'),
(@carrera_ing_id, 'OPT-103', 'Optativa 3', 3, 13, 'optativa'),
(@carrera_ing_id, 'ELI-421', 'Interculturalidad en la Clase de Inglés', 3, 14, 'obligatoria'),
(@carrera_ing_id, 'PRA-413', 'Práctica Docente V', 3, 14, 'obligatoria'),
(@carrera_ing_id, 'FGE-302', 'Educación Socioemocional del Docente y el Estudiante', 3, 14, 'obligatoria'),
(@carrera_ing_id, 'ING-428', 'Cultura Anglófona', 4, 14, 'obligatoria'),
(@carrera_ing_id, 'ING-433', 'Seminario de Investigación en Inglés', 4, 15, 'obligatoria'),
(@carrera_ing_id, 'FGC-409', 'Ética Profesional', 3, 15, 'obligatoria'),
(@carrera_ing_id, 'PPL-400', 'Práctica Profesional (Pasantía)', 5, 15, 'obligatoria'),
(@carrera_ing_id, 'ELI-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_ing_id, 'FGE-401', 'Administración y Legislación del Sistema Educativo Dominicano', 3, 0, 'optativa'),
(@carrera_ing_id, 'FGE-211', 'Planificación Educativa', 3, 0, 'optativa'),
(@carrera_ing_id, 'FGI-107', 'Inteligencia Artificial', 3, 0, 'optativa'),
(@carrera_ing_id, 'FGP-314', 'Logopedia', 3, 0, 'optativa'),
(@carrera_ing_id, 'FGP-211', 'Desarrollo del Lenguaje', 3, 0, 'optativa'),
(@carrera_ing_id, 'FGE-309', 'Metodología de Enseñanza STEAM', 3, 0, 'optativa'),
(@carrera_ing_id, 'FGP-315', 'Atención a la Diversidad', 3, 0, 'optativa'),
(@carrera_ing_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 0, 'optativa'),
(@carrera_ing_id, 'FGP-421', 'Coaching', 3, 0, 'optativa'),
(@carrera_ing_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 11. Licenciatura en Educación Primaria, Primer Ciclo
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Educación Primaria, Primer Ciclo', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_eppc_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Educación Primaria, Primer Ciclo');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_eppc_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_eppc_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_eppc_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_eppc_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 2, 'obligatoria'),
(@carrera_eppc_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 2, 'obligatoria'),
(@carrera_eppc_id, 'FGE-101', 'Fundamentos Filosóficos e Históricos de la Educación', 4, 2, 'obligatoria'),
(@carrera_eppc_id, 'FGE-102', 'Fundamentos y Estructura del Currículo', 3, 3, 'obligatoria'),
(@carrera_eppc_id, 'FGE-209', 'Didáctica General', 3, 3, 'obligatoria'),
(@carrera_eppc_id, 'FGP-103', 'Psicología del Desarrollo (6-9 años)', 3, 3, 'obligatoria'),
(@carrera_eppc_id, 'FGC-203', 'Filosofía y Sociedad', 3, 3, 'obligatoria'),
(@carrera_eppc_id, 'EDP-304', 'Alfabetización y Currículo', 3, 4, 'obligatoria'),
(@carrera_eppc_id, 'FGP-207', 'Neurociencias y Aprendizaje', 3, 4, 'obligatoria'),
(@carrera_eppc_id, 'FGE-203', 'Procesos de Enseñanza Aprendizaje', 4, 4, 'obligatoria'),
(@carrera_eppc_id, 'EDP-201', 'Procesos de Enseñanza y Aprendizajes de la Lectura y la Escritura', 3, 5, 'obligatoria'),
(@carrera_eppc_id, 'FGE-306', 'Gestión de Ambientes de Aprendizaje y en el Aula', 3, 5, 'obligatoria'),
(@carrera_eppc_id, 'PRA-208', 'Práctica Docente I', 2, 5, 'obligatoria'),
(@carrera_eppc_id, 'CBE-110', 'Análisis y Producción de Textos', 4, 5, 'obligatoria'),
(@carrera_eppc_id, 'EDP-303', 'Didáctica Especial de la Lectoescritura I', 3, 6, 'obligatoria'),
(@carrera_eppc_id, 'EDS-210', 'Introducción a las Ciencias Sociales Nivel Primario', 3, 6, 'obligatoria'),
(@carrera_eppc_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 6, 'obligatoria'),
(@carrera_eppc_id, 'EDP-202', 'Didáctica Especial de la Matemática I en el Nivel Primario', 3, 7, 'obligatoria'),
(@carrera_eppc_id, 'PRA-209', 'Práctica Docente II', 3, 7, 'obligatoria'),
(@carrera_eppc_id, 'FGC-106', 'Historia Social Dominicana', 3, 7, 'obligatoria'),
(@carrera_eppc_id, 'OPT-101', 'Optativa 1', 3, 7, 'optativa'),
(@carrera_eppc_id, 'FGE-205', 'Recursos Didácticos para el Aprendizaje', 3, 8, 'obligatoria'),
(@carrera_eppc_id, 'EDP-302', 'Evaluación de los Aprendizajes en el Nivel Primario', 3, 8, 'obligatoria'),
(@carrera_eppc_id, 'FGP-210', 'Psicología del Aprendizaje', 3, 8, 'obligatoria'),
(@carrera_eppc_id, 'PRA-214', 'Práctica Docente III', 3, 8, 'obligatoria'),
(@carrera_eppc_id, 'FGC-208', 'Educación Constitucional', 3, 9, 'obligatoria'),
(@carrera_eppc_id, 'PSE-101', 'Psicología Educativa', 4, 9, 'obligatoria'),
(@carrera_eppc_id, 'EDP-305', 'Didáctica Especial de la Lectoescritura II', 3, 9, 'obligatoria'),
(@carrera_eppc_id, 'EDP-310', 'Didáctica Especial de la Matemática Il en el Nivel Primario', 3, 10, 'obligatoria'),
(@carrera_eppc_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 10, 'obligatoria'),
(@carrera_eppc_id, 'LEN-126', 'Oralidad y Escritura', 3, 10, 'obligatoria'),
(@carrera_eppc_id, 'EDP-410', 'Introducción a las Ciencias Naturales', 3, 10, 'obligatoria'),
(@carrera_eppc_id, 'PRA-314', 'Práctica Docente IV', 4, 11, 'obligatoria'),
(@carrera_eppc_id, 'FGP-315', 'Atención a la Diversidad', 3, 11, 'obligatoria'),
(@carrera_eppc_id, 'EDP-311', 'Didáctica Especial de la Ciencias Sociales', 3, 11, 'obligatoria'),
(@carrera_eppc_id, 'EDP-411', 'Didáctica Especial de las Ciencias Naturales', 3, 12, 'obligatoria'),
(@carrera_eppc_id, 'PRA-315', 'Práctica Docente V', 3, 12, 'obligatoria'),
(@carrera_eppc_id, 'EDL-204', 'Gramática Textual', 3, 12, 'obligatoria'),
(@carrera_eppc_id, 'OPT-102', 'Optativa 2', 3, 12, 'optativa'),
(@carrera_eppc_id, 'FGP-211', 'Desarrollo del Lenguaje', 3, 13, 'obligatoria'),
(@carrera_eppc_id, 'EDP-308', 'Didáctica para la Enseñanza de la Formación Integral, Humana y Religiosa', 3, 13, 'obligatoria'),
(@carrera_eppc_id, 'FGP-308', 'Necesidades Específicas de Apoyo Educativo', 3, 13, 'obligatoria'),
(@carrera_eppc_id, 'OPT-103', 'Optativa 3', 3, 13, 'optativa'),
(@carrera_eppc_id, 'EDL-437', 'Procesos de Comprensión Lectora', 3, 14, 'obligatoria'),
(@carrera_eppc_id, 'EDP-309', 'Didáctica para la Enseñanza de la Educación Artística', 2, 14, 'obligatoria'),
(@carrera_eppc_id, 'EDL-315', 'Literatura Infantil', 3, 14, 'obligatoria'),
(@carrera_eppc_id, 'EDI-413', 'Escuela, Familia y Comunidad', 2, 14, 'obligatoria'),
(@carrera_eppc_id, 'FGC-409', 'Ética Profesional', 3, 15, 'obligatoria'),
(@carrera_eppc_id, 'FGC-413', 'Investigación Acción', 3, 15, 'obligatoria'),
(@carrera_eppc_id, 'PPP-400', 'Práctica Profesional (Pasantía)', 5, 15, 'obligatoria'),
(@carrera_eppc_id, 'EDP-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_eppc_id, 'FGP-314', 'Logopedia', 3, 0, 'optativa'),
(@carrera_eppc_id, 'FGE-302', 'Educación Socioemocional del Docente y el Estudiante', 3, 0, 'optativa'),
(@carrera_eppc_id, 'FGE-401', 'Administración y Legislación del Sistema Educativo Dominicano', 3, 0, 'optativa'),
(@carrera_eppc_id, 'FGE-211', 'Planificación Educativa', 3, 0, 'optativa'),
(@carrera_eppc_id, 'FGL-408', 'Inglés Básico I', 3, 0, 'optativa'),
(@carrera_eppc_id, 'FGL-409', 'Inglés Básico II', 3, 0, 'optativa'),
(@carrera_eppc_id, 'FGC-309', 'Metodología de Enseñanza Steam', 3, 0, 'optativa'),
(@carrera_eppc_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 0, 'optativa'),
(@carrera_eppc_id, 'FGP-421', 'Coaching', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 12. Licenciatura en Educación Secundaria: Lengua Española y Literatura
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Educación Secundaria: Lengua Española y Literatura', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_eslel_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Educación Secundaria: Lengua Española y Literatura');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_eslel_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_eslel_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_eslel_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_eslel_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 2, 'obligatoria'),
(@carrera_eslel_id, 'PSG-105', 'Introducción a la Psicología', 3, 2, 'obligatoria'),
(@carrera_eslel_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 2, 'obligatoria'),
(@carrera_eslel_id, 'EDL-314', 'Historia de la Lengua Española', 3, 2, 'obligatoria'),
(@carrera_eslel_id, 'FGC-106', 'Historia Social Dominicana', 3, 3, 'obligatoria'),
(@carrera_eslel_id, 'EDL-104', 'Comprensión y Producción Oral I', 3, 3, 'obligatoria'),
(@carrera_eslel_id, 'FGE-102', 'Fundamentos y Estructura del Currículo', 3, 3, 'obligatoria'),
(@carrera_eslel_id, 'FGE-306', 'Gestión de Ambientes de Aprendizaje y el Aula', 3, 3, 'obligatoria'),
(@carrera_eslel_id, 'FGP-207', 'Neurociencias y Aprendizaje', 3, 4, 'obligatoria'),
(@carrera_eslel_id, 'EDL-105', 'Introducción al Estudio de la Literatura', 3, 4, 'obligatoria'),
(@carrera_eslel_id, 'EDL-106', 'Comprensión y Producción Oral II', 3, 4, 'obligatoria'),
(@carrera_eslel_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 4, 'obligatoria'),
(@carrera_eslel_id, 'FGP-106', 'Psicología del Adolescente (12 a 18 años)', 3, 5, 'obligatoria'),
(@carrera_eslel_id, 'FGE-101', 'Fundamentos Filosóficos e Históricos de la Educación', 4, 5, 'obligatoria'),
(@carrera_eslel_id, 'FGE-203', 'Procesos de Enseñanza y Aprendizaje', 4, 5, 'obligatoria'),
(@carrera_eslel_id, 'EDL-210', 'Literatura Universal I', 3, 5, 'obligatoria'),
(@carrera_eslel_id, 'FGP-210', 'Psicología del Aprendizaje', 3, 6, 'obligatoria'),
(@carrera_eslel_id, 'EDL-211', 'Literatura Universal II', 3, 6, 'obligatoria'),
(@carrera_eslel_id, 'EDL-208', 'Comprensión y Producción de Textos I (Narrativos y Descriptivos)', 3, 6, 'obligatoria'),
(@carrera_eslel_id, 'FGC-204', 'Investigación Aplicada', 4, 6, 'obligatoria'),
(@carrera_eslel_id, 'EDL-214', 'Evaluación de los Aprendizajes en Lengua y Literatura', 3, 7, 'obligatoria'),
(@carrera_eslel_id, 'EDL-209', 'Comprensión y Producción de Textos II (Expositivos y Argumentativos)', 3, 7, 'obligatoria'),
(@carrera_eslel_id, 'EDL-317', 'Currículo de la Lengua y la Literatura en el Nivel Secundaria', 3, 7, 'obligatoria'),
(@carrera_eslel_id, 'FGC-203', 'Filosofía y Sociedad', 3, 7, 'obligatoria'),
(@carrera_eslel_id, 'PRA-217', 'Práctica Docente I', 2, 8, 'obligatoria'),
(@carrera_eslel_id, 'EDL-321', 'Enfoques de la Enseñanza de la Lengua', 3, 8, 'obligatoria'),
(@carrera_eslel_id, 'EDL-213', 'Introducción a la Lingüística', 3, 8, 'obligatoria'),
(@carrera_eslel_id, 'FGE-209', 'Didáctica General', 3, 8, 'obligatoria'),
(@carrera_eslel_id, 'FGC-208', 'Investigación Aplicada', 3, 8, 'obligatoria'),
(@carrera_eslel_id, 'EDL-212', 'Comprensión y Producción de Textos Prescriptivos', 3, 9, 'obligatoria'),
(@carrera_eslel_id, 'EDL-316', 'Fonética y Fonología', 3, 9, 'obligatoria'),
(@carrera_eslel_id, 'PRA-319', 'Práctica Docente II', 3, 9, 'obligatoria'),
(@carrera_eslel_id, 'OPT-101', 'Optativa 1', 3, 9, 'optativa'),
(@carrera_eslel_id, 'EDL-319', 'Literatura Española I', 3, 10, 'obligatoria'),
(@carrera_eslel_id, 'EDL-320', 'Morfología y Sintaxis I', 3, 10, 'obligatoria'),
(@carrera_eslel_id, 'EDL-325', 'Enfoques de la Enseñanza de la Literatura', 3, 10, 'obligatoria'),
(@carrera_eslel_id, 'PRA-320', 'Práctica Docente III', 3, 10, 'obligatoria'),
(@carrera_eslel_id, 'EDL-323', 'Literatura Española II', 3, 11, 'obligatoria'),
(@carrera_eslel_id, 'PRA-321', 'Práctica Docente IV', 4, 11, 'obligatoria'),
(@carrera_eslel_id, 'EDL-324', 'Morfología y Sintaxis II', 3, 11, 'obligatoria'),
(@carrera_eslel_id, 'OPT-102', 'Optativa 2', 3, 11, 'optativa'),
(@carrera_eslel_id, 'EDL-326', 'Sociolingüística', 3, 12, 'obligatoria'),
(@carrera_eslel_id, 'EDL-432', 'Lexicología y Semántica', 3, 12, 'obligatoria'),
(@carrera_eslel_id, 'EDL-328', 'Literatura Hispanoamericana I', 3, 12, 'obligatoria'),
(@carrera_eslel_id, 'FGE-213', 'Medios y Recursos para el Aprendizaje', 3, 12, 'obligatoria'),
(@carrera_eslel_id, 'PRA-411', 'Práctica Docente V', 3, 13, 'obligatoria'),
(@carrera_eslel_id, 'EDL-430', 'Literatura Hispanoamericana II', 3, 13, 'obligatoria'),
(@carrera_eslel_id, 'EDL-431', 'Didáctica Especial de la Literatura', 3, 13, 'obligatoria'),
(@carrera_eslel_id, 'OPT-103', 'Optativa 3', 3, 13, 'optativa'),
(@carrera_eslel_id, 'EDL-327', 'Análisis del Discurso', 3, 14, 'obligatoria'),
(@carrera_eslel_id, 'EDL-433', 'Literatura Dominicana I', 3, 14, 'obligatoria'),
(@carrera_eslel_id, 'EDL-434', 'Análisis de la Obra Literaria I', 3, 14, 'obligatoria'),
(@carrera_eslel_id, 'PLE-400', 'Práctica Profesional (Pasantía)', 5, 14, 'obligatoria'),
(@carrera_eslel_id, 'EDL-436', 'Literatura Dominicana II', 3, 15, 'obligatoria'),
(@carrera_eslel_id, 'EDL-435', 'Análisis de la Obra Literaria II', 3, 15, 'obligatoria'),
(@carrera_eslel_id, 'EDL-329', 'Redacción Académica y Profesional', 4, 15, 'obligatoria'),
(@carrera_eslel_id, 'FGC-409', 'Ética Profesional', 3, 15, 'obligatoria'),
(@carrera_eslel_id, 'EDL-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_eslel_id, 'FGP-308', 'Necesidades Específicas de Apoyo Educativo', 3, 0, 'optativa'),
(@carrera_eslel_id, 'FGE-302', 'Educación Socioemocional del Docente y el Estudiante', 3, 0, 'optativa'),
(@carrera_eslel_id, 'FGE-401', 'Administración y Legislación del Sistema Educativo Dominicano', 3, 0, 'optativa'),
(@carrera_eslel_id, 'FGE-211', 'Planificación Educativa', 3, 0, 'optativa'),
(@carrera_eslel_id, 'FGL-408', 'Inglés Básico I', 3, 0, 'optativa'),
(@carrera_eslel_id, 'FGL-409', 'Inglés Básico II', 3, 0, 'optativa'),
(@carrera_eslel_id, 'FGE-309', 'Metodología de Enseñanza STEAM', 3, 0, 'optativa'),
(@carrera_eslel_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 0, 'optativa'),
(@carrera_eslel_id, 'FGP-421', 'Coaching', 3, 0, 'optativa'),
(@carrera_eslel_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 13. Licenciatura en Educación Secundaria: Matemática y Física
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Educación Secundaria: Matemática y Física', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_esmf_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Educación Secundaria: Matemática y Física');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_esmf_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_esmf_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_esmf_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_esmf_id, 'ESM-101', 'Aritmética Superior', 3, 1, 'obligatoria'),
(@carrera_esmf_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 2, 'obligatoria'),
(@carrera_esmf_id, 'PSG-105', 'Introducción a la Psicología', 3, 2, 'obligatoria'),
(@carrera_esmf_id, 'ESM-102', 'Álgebra Superior', 4, 2, 'obligatoria'),
(@carrera_esmf_id, 'FGE-101', 'Fundamentos Filosóficos e Históricos de la Educación', 4, 2, 'obligatoria'),
(@carrera_esmf_id, 'FGC-106', 'Historia Social Dominicana', 3, 3, 'obligatoria'),
(@carrera_esmf_id, 'CBE-110', 'Análisis y Producción de Textos', 4, 3, 'obligatoria'),
(@carrera_esmf_id, 'ESM-103', 'Lógica y Teoría de Conjuntos', 3, 3, 'obligatoria'),
(@carrera_esmf_id, 'FGE-209', 'Didáctica General', 3, 3, 'obligatoria'),
(@carrera_esmf_id, 'FGP-207', 'Neurociencias y Aprendizaje', 3, 4, 'obligatoria'),
(@carrera_esmf_id, 'ESM-104', 'Geometría I', 3, 4, 'obligatoria'),
(@carrera_esmf_id, 'FGE-102', 'Fundamentos y Estructura del Currículo', 3, 4, 'obligatoria'),
(@carrera_esmf_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 4, 'obligatoria'),
(@carrera_esmf_id, 'FGP-106', 'Psicología del Adolescente (12 a 18 años)', 3, 5, 'obligatoria'),
(@carrera_esmf_id, 'FGC-203', 'Filosofía y Sociedad', 3, 5, 'obligatoria'),
(@carrera_esmf_id, 'FGE-203', 'Procesos de Enseñanza y Aprendizaje', 4, 5, 'obligatoria'),
(@carrera_esmf_id, 'ESM-205', 'Geometría II', 3, 5, 'obligatoria'),
(@carrera_esmf_id, 'FGE-306', 'Gestión de Ambientes de Aprendizaje y el Aula', 3, 6, 'obligatoria'),
(@carrera_esmf_id, 'FGP-210', 'Psicología del Aprendizaje', 3, 6, 'obligatoria'),
(@carrera_esmf_id, 'ESM-206', 'Matemática Financiera', 3, 6, 'obligatoria'),
(@carrera_esmf_id, 'ESM-207', 'Trigonometría I', 3, 6, 'obligatoria'),
(@carrera_esmf_id, 'OPT-101', 'Optativa 1', 3, 6, 'optativa'),
(@carrera_esmf_id, 'ESM-208', 'Trigonometría II', 3, 7, 'obligatoria'),
(@carrera_esmf_id, 'ESM-209', 'Cálculo y Analítica I', 5, 7, 'obligatoria'),
(@carrera_esmf_id, 'FGC-208', 'Educación Constitucional', 3, 7, 'obligatoria'),
(@carrera_esmf_id, 'PRA-215', 'Práctica Docente I', 2, 7, 'obligatoria'),
(@carrera_esmf_id, 'PRA-216', 'Práctica Docente II', 3, 8, 'obligatoria'),
(@carrera_esmf_id, 'FGM-207', 'Estadística y Probabilidad', 4, 8, 'obligatoria'),
(@carrera_esmf_id, 'ESM-210', 'Cálculo y Analítica II', 5, 8, 'obligatoria'),
(@carrera_esmf_id, 'ESM-211', 'Álgebra Abstracta', 3, 8, 'obligatoria'),
(@carrera_esmf_id, 'FGE-213', 'Medios y Recursos para el Aprendizaje', 3, 9, 'obligatoria'),
(@carrera_esmf_id, 'FGE-206', 'Evaluación de los Aprendizajes', 3, 9, 'obligatoria'),
(@carrera_esmf_id, 'ESM-315', 'Álgebra Lineal', 4, 9, 'obligatoria'),
(@carrera_esmf_id, 'ESM-313', 'Física General I', 3, 9, 'obligatoria'),
(@carrera_esmf_id, 'ESM-314', 'Laboratorio de Física General I', 1, 9, 'obligatoria'),
(@carrera_esmf_id, 'PRA-317', 'Práctica Docente III', 3, 10, 'obligatoria'),
(@carrera_esmf_id, 'ESM-316', 'Física General II', 3, 10, 'obligatoria'),
(@carrera_esmf_id, 'ESM-317', 'Laboratorio de Física General II', 1, 10, 'obligatoria'),
(@carrera_esmf_id, 'ESM-318', 'Cálculo Vectorial', 4, 10, 'obligatoria'),
(@carrera_esmf_id, 'FGC-204', 'Investigación Aplicada', 4, 10, 'obligatoria'),
(@carrera_esmf_id, 'ESM-319', 'Física General III', 3, 11, 'obligatoria'),
(@carrera_esmf_id, 'ESM-320', 'Laboratorio de Física General III', 1, 11, 'obligatoria'),
(@carrera_esmf_id, 'ESM-321', 'Didáctica Especial de la Matemática', 3, 11, 'obligatoria'),
(@carrera_esmf_id, 'FGC-409', 'Ética Profesional', 3, 11, 'obligatoria'),
(@carrera_esmf_id, 'ESM-322', 'Ecuaciones Diferenciales', 5, 11, 'obligatoria'),
(@carrera_esmf_id, 'ESM-323', 'Métodos Matemáticos de la Física', 4, 12, 'obligatoria'),
(@carrera_esmf_id, 'PRA-318', 'Práctica Docente IV', 4, 12, 'obligatoria'),
(@carrera_esmf_id, 'ESM-324', 'Termodinámica', 3, 12, 'obligatoria'),
(@carrera_esmf_id, 'ESM-325', 'Física Moderna', 3, 12, 'obligatoria'),
(@carrera_esmf_id, 'ESM-426', 'Didáctica Especializada de la Física', 3, 13, 'obligatoria'),
(@carrera_esmf_id, 'ESM-427', 'Diseño de Experimentos en Física', 3, 13, 'obligatoria'),
(@carrera_esmf_id, 'ESM-428', 'Geología', 3, 13, 'obligatoria'),
(@carrera_esmf_id, 'ESM-329', 'Electromagnetismo y Óptica', 5, 13, 'obligatoria'),
(@carrera_esmf_id, 'ESM-430', 'Astronomía', 3, 14, 'obligatoria'),
(@carrera_esmf_id, 'ESM-431', 'Laboratorio de Astronomía', 1, 14, 'obligatoria'),
(@carrera_esmf_id, 'ESM-432', 'Didáctica Especializada de las Ciencias de la Tierra y del Universo', 3, 14, 'obligatoria'),
(@carrera_esmf_id, 'PRA-410', 'Práctica Docente V', 3, 14, 'obligatoria'),
(@carrera_esmf_id, 'OPT-102', 'Optativa 2', 3, 14, 'optativa'),
(@carrera_esmf_id, 'ESM-433', 'Climatología y Cambio Climático', 3, 15, 'obligatoria'),
(@carrera_esmf_id, 'ESM-434', 'Geofísica', 3, 15, 'obligatoria'),
(@carrera_esmf_id, 'PPM-400', 'Práctica Docente VI (Pasantía)', 5, 15, 'obligatoria'),
(@carrera_esmf_id, 'OPT-103', 'Optativa 3', 3, 15, 'optativa'),
(@carrera_esmf_id, 'ESM-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_esmf_id, 'FGE-302', 'Educación Socioemocional del Docente y el Estudiante', 3, 0, 'optativa'),
(@carrera_esmf_id, 'FGE-401', 'Administración y Legislación del Sistema Educativo Dominicano', 3, 0, 'optativa'),
(@carrera_esmf_id, 'FGE-309', 'Metodología de Enseñanza Steam', 3, 0, 'optativa'),
(@carrera_esmf_id, 'FGE-211', 'Planificación Educativa', 3, 0, 'optativa'),
(@carrera_esmf_id, 'ESM-436', 'Física Estadística', 3, 0, 'optativa'),
(@carrera_esmf_id, 'ESM-438', 'Teoría General de la Relatividad', 3, 0, 'optativa'),
(@carrera_esmf_id, 'ESM-439', 'Historia, Filosofía y Epistemología de las Matemáticas', 3, 0, 'optativa'),
(@carrera_esmf_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 0, 'optativa'),
(@carrera_esmf_id, 'FGP-421', 'Coaching', 3, 0, 'optativa'),
(@carrera_esmf_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 14. Licenciatura en Enfermería
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Enfermería', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_enf_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Enfermería');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_enf_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_enf_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_enf_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_enf_id, 'CBE-111', 'Comunicación Humana', 3, 1, 'obligatoria'),
(@carrera_enf_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 2, 'obligatoria'),
(@carrera_enf_id, 'CBE-110', 'Análisis y Producción de Textos', 4, 2, 'obligatoria'),
(@carrera_enf_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 2, 'obligatoria'),
(@carrera_enf_id, 'CBN-117', 'Biología Humana', 2, 2, 'obligatoria'),
(@carrera_enf_id, 'LBI-117', 'Laboratorio de Biología Humana', 2, 2, 'obligatoria'),
(@carrera_enf_id, 'CBN-118', 'Química', 2, 3, 'obligatoria'),
(@carrera_enf_id, 'LQU-118', 'Laboratorio de Química', 2, 3, 'obligatoria'),
(@carrera_enf_id, 'CBN-119', 'Física', 2, 3, 'obligatoria'),
(@carrera_enf_id, 'LAF-119', 'Laboratorio de Física', 2, 3, 'obligatoria'),
(@carrera_enf_id, 'FGL-407', 'Inglés Básico', 3, 3, 'obligatoria'),
(@carrera_enf_id, 'OPT-101', 'Optativa 1', 3, 3, 'optativa'),
(@carrera_enf_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 4, 'obligatoria'),
(@carrera_enf_id, 'CBN-114', 'Bioquímica y su Laboratorio', 3, 4, 'obligatoria'),
(@carrera_enf_id, 'CBN-120', 'Anatomía Humana', 2, 4, 'obligatoria'),
(@carrera_enf_id, 'LAA-120', 'Laboratorio Anatomía Humana', 2, 4, 'obligatoria'),
(@carrera_enf_id, 'ENF-101', 'Introducción a la Enfermería', 3, 4, 'obligatoria'),
(@carrera_enf_id, 'CBN-218', 'Microbiología', 2, 5, 'obligatoria'),
(@carrera_enf_id, 'LMI-218', 'Laboratorio de Microbiología', 2, 5, 'obligatoria'),
(@carrera_enf_id, 'CBN-219', 'Fisiología Humana', 2, 5, 'obligatoria'),
(@carrera_enf_id, 'LFI-219', 'Laboratorio Fisiología Humana', 2, 5, 'obligatoria'),
(@carrera_enf_id, 'ENF-202', 'Farmacología y su Laboratorio', 4, 5, 'obligatoria'),
(@carrera_enf_id, 'ENF-227', 'Nutrición y Salud', 3, 5, 'obligatoria'),
(@carrera_enf_id, 'ENF-222', 'Procedimientos Básicos de Enfermería y Bioseguridad', 2, 6, 'obligatoria'),
(@carrera_enf_id, 'LPB-222', 'Laboratorio de Procedimientos Básicos de Enfermería y Bioseguridad', 3, 6, 'obligatoria'),
(@carrera_enf_id, 'ENF-212', 'Parasitología', 2, 6, 'obligatoria'),
(@carrera_enf_id, 'LAP-212', 'Laboratorio de Parasitología', 2, 6, 'obligatoria'),
(@carrera_enf_id, 'ENF-213', 'Semiología Clínica', 2, 6, 'obligatoria'),
(@carrera_enf_id, 'LSC-213', 'Laboratorio de Semiología Clínica', 2, 6, 'obligatoria'),
(@carrera_enf_id, 'PSG-105', 'Introducción a Psicología', 3, 6, 'obligatoria'),
(@carrera_enf_id, 'ENF-226', 'Cuidados de Enfermería al Adulto y Envejeciente I', 2, 7, 'obligatoria'),
(@carrera_enf_id, 'PEN-226', 'Práctica de Cuidados de Enfermería al Adulto Envejeciente I', 3, 7, 'obligatoria'),
(@carrera_enf_id, 'ENF-231', 'Enfermería Comunitaria I', 5, 7, 'obligatoria'),
(@carrera_enf_id, 'ENF-206', 'Fisiopatología General', 3, 7, 'obligatoria'),
(@carrera_enf_id, 'FGP-420', 'Psicología del Desarrollo Humano', 3, 7, 'obligatoria'),
(@carrera_enf_id, 'ENF-230', 'Cuidados de Enfermería al Adulto y Envejeciente II', 2, 8, 'obligatoria'),
(@carrera_enf_id, 'PEN-230', 'Práctica de Cuidados de Enfermería al Adulto y Envejeciente II', 3, 8, 'obligatoria'),
(@carrera_enf_id, 'ENF-333', 'Enfermería Comunitaria II', 5, 8, 'obligatoria'),
(@carrera_enf_id, 'FGL-410', 'Inglés Técnico en Enfermería', 3, 8, 'obligatoria'),
(@carrera_enf_id, 'OPT-102', 'Optativa 2', 3, 8, 'optativa'),
(@carrera_enf_id, 'FGC-208', 'Educación Constitucional', 3, 9, 'obligatoria'),
(@carrera_enf_id, 'ENF-332', 'Clínica en Salud Mental y Psiquiatría', 2, 9, 'obligatoria'),
(@carrera_enf_id, 'PES-332', 'Práctica en Salud Mental y Psiquiatría', 3, 9, 'obligatoria'),
(@carrera_enf_id, 'FGN-310', 'Bioestadística', 4, 9, 'obligatoria'),
(@carrera_enf_id, 'ENF-318', 'Ética, Bioética y Legislación en Enfermería', 3, 9, 'obligatoria'),
(@carrera_enf_id, 'ENF-334', 'Enfermería Quirúrgica', 2, 10, 'obligatoria'),
(@carrera_enf_id, 'PEQ-334', 'Práctica de Enfermería Quirúrgica', 3, 10, 'obligatoria'),
(@carrera_enf_id, 'ENF-319', 'Metodología de la Investigación Aplicada a la Salud', 3, 10, 'obligatoria'),
(@carrera_enf_id, 'ENF-309', 'Enfermería Geriátrica y Gerontológica', 2, 10, 'obligatoria'),
(@carrera_enf_id, 'PEG-309', 'Prácticas Enfermería Geriátrica y Gerontológica', 3, 10, 'obligatoria'),
(@carrera_enf_id, 'ENF-210', 'Epidemiología General', 3, 10, 'obligatoria'),
(@carrera_enf_id, 'ENF-336', 'Enfermería Ginecobstétrica y Perinatal', 3, 11, 'obligatoria'),
(@carrera_enf_id, 'PEG-336', 'Práctica Enfermería Ginecobstétrica y Perinatal', 3, 11, 'obligatoria'),
(@carrera_enf_id, 'ENF-310', 'Enfermería Comunitaria Materno Infantil', 3, 11, 'obligatoria'),
(@carrera_enf_id, 'ENF-311', 'Enfermería Avanzada: Emergencias y Desastres', 3, 11, 'obligatoria'),
(@carrera_enf_id, 'OPT-103', 'Optativa 3', 3, 11, 'optativa'),
(@carrera_enf_id, 'ENF-338', 'Enfermería Pediátrica', 3, 12, 'obligatoria'),
(@carrera_enf_id, 'PEP-338', 'Práctica en Enfermería Pediátrica', 3, 12, 'obligatoria'),
(@carrera_enf_id, 'ENF-339', 'Enfermería en Salud Escolar', 5, 12, 'obligatoria'),
(@carrera_enf_id, 'ENF-440', 'Administración en Servicios de Enfermería Comunitaria', 5, 12, 'obligatoria'),
(@carrera_enf_id, 'ENF-335', 'Enfermería en Salud Laboral', 4, 13, 'obligatoria'),
(@carrera_enf_id, 'ENF-443', 'Administración de Servicios de Enfermería Hospitalaria', 2, 13, 'obligatoria'),
(@carrera_enf_id, 'PAS-443', 'Práctica de Administración de Servicios de Enfermería Hospitalaria', 3, 13, 'obligatoria'),
(@carrera_enf_id, 'ENF-442', 'Cuidados de Enfermería a Pacientes Críticos', 2, 13, 'obligatoria'),
(@carrera_enf_id, 'PCP-442', 'Práctica de Cuidados de Enfermería a Pacientes Críticos', 3, 13, 'obligatoria'),
(@carrera_enf_id, 'ENF-429', 'Internado Rotatorio Comunitario', 4, 14, 'obligatoria'),
(@carrera_enf_id, 'ENF-430', 'Internado Rotatorio Hospitalario', 6, 15, 'obligatoria'),
(@carrera_enf_id, 'ENF-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_enf_id, 'FGP-315', 'Atención a la Diversidad', 3, 0, 'optativa'),
(@carrera_enf_id, 'ENF-432', 'Cuidados Paliativos', 3, 0, 'optativa'),
(@carrera_enf_id, 'ENF-444', 'Cuidados Intensivos', 3, 0, 'optativa'),
(@carrera_enf_id, 'ENF-445', 'Gerencia Hospitalaria', 3, 0, 'optativa'),
(@carrera_enf_id, 'FGN-309', 'Metodologías de Emprendimiento', 3, 0, 'optativa'),
(@carrera_enf_id, 'ADM-316', 'Formulación y Creación de Proyectos Emprendedores', 3, 0, 'optativa'),
(@carrera_enf_id, 'CON-334', 'Finanzas Básicas para Emprendedores', 3, 0, 'optativa'),
(@carrera_enf_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 0, 'optativa'),
(@carrera_enf_id, 'FGP-421', 'Coaching', 3, 0, 'optativa'),
(@carrera_enf_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 15. Licenciatura en Informática Gerencial
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Informática Gerencial', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_ifg_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Informática Gerencial');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_ifg_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_ifg_id, 'CBE-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_ifg_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_ifg_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 1, 'obligatoria'),
(@carrera_ifg_id, 'FGI-103', 'Lógica Computacional', 4, 2, 'obligatoria'),
(@carrera_ifg_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 2, 'obligatoria'),
(@carrera_ifg_id, 'FGI-102', 'Álgebra y Geometría para Ingenieros', 4, 2, 'obligatoria'),
(@carrera_ifg_id, 'FGC-203', 'Filosofía y Sociedad', 3, 2, 'obligatoria'),
(@carrera_ifg_id, 'CBE-110', 'Análisis y Producción de Textos', 4, 3, 'obligatoria'),
(@carrera_ifg_id, 'FGI-104', 'Programación I', 4, 3, 'obligatoria'),
(@carrera_ifg_id, 'ING-103', 'Inglés Comunicativo', 3, 3, 'obligatoria'),
(@carrera_ifg_id, 'FGC-208', 'Educación Constitucional', 3, 3, 'obligatoria'),
(@carrera_ifg_id, 'ADM-103', 'Fundamentos de Administración Empresarial', 4, 4, 'obligatoria'),
(@carrera_ifg_id, 'FGI-412', 'Ciencia, Tecnología y Sociedad', 3, 4, 'obligatoria'),
(@carrera_ifg_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 4, 'obligatoria'),
(@carrera_ifg_id, 'FGC-409', 'Ética Profesional', 3, 4, 'obligatoria'),
(@carrera_ifg_id, 'FGI-105', 'Programación II', 4, 5, 'obligatoria'),
(@carrera_ifg_id, 'FGI-106', 'Sistema de Base de Datos', 4, 5, 'obligatoria'),
(@carrera_ifg_id, 'ING-213', 'Inglés Técnico para Ingenieros', 3, 5, 'obligatoria'),
(@carrera_ifg_id, 'COE-101', 'Contabilidad I', 4, 5, 'obligatoria'),
(@carrera_ifg_id, 'FGC-204', 'Investigación Aplicada', 4, 6, 'obligatoria'),
(@carrera_ifg_id, 'FGI-208', 'Análisis y Diseño de Sistema', 4, 6, 'obligatoria'),
(@carrera_ifg_id, 'FGM-207', 'Estadística y Probabilidades', 4, 6, 'obligatoria'),
(@carrera_ifg_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 6, 'obligatoria'),
(@carrera_ifg_id, 'ISW-414', 'Fundamentos de Inteligencia de Negocios', 4, 7, 'obligatoria'),
(@carrera_ifg_id, 'INF-408', 'Investigación de Operaciones', 4, 7, 'obligatoria'),
(@carrera_ifg_id, 'ADM-311', 'Administración Estratégica I', 4, 7, 'obligatoria'),
(@carrera_ifg_id, 'OPT-101', 'Optativa 1', 3, 7, 'optativa'),
(@carrera_ifg_id, 'ISW-306', 'Sistema de Automatización de Oficinas', 4, 8, 'obligatoria'),
(@carrera_ifg_id, 'INF-304', 'Fundamentos de Economía', 4, 8, 'obligatoria'),
(@carrera_ifg_id, 'INF-204', 'Estructura de Datos y Algoritmos', 4, 8, 'obligatoria'),
(@carrera_ifg_id, 'OPT-102', 'Optativa 2', 3, 8, 'optativa'),
(@carrera_ifg_id, 'ISW-309', 'Inteligencia Artificial', 4, 9, 'obligatoria'),
(@carrera_ifg_id, 'INF-307', 'Gestión de Conocimiento y la Toma de Decisiones', 4, 9, 'obligatoria'),
(@carrera_ifg_id, 'MER-105', 'Fundamentos de Marketing', 4, 9, 'obligatoria'),
(@carrera_ifg_id, 'OPT-103', 'Optativa 3', 3, 9, 'optativa'),
(@carrera_ifg_id, 'CID-101', 'Ciencia de Datos', 4, 10, 'obligatoria'),
(@carrera_ifg_id, 'INF-308', 'Arquitectura Empresarial', 4, 10, 'obligatoria'),
(@carrera_ifg_id, 'MER-415', 'Marketing Digital', 3, 10, 'obligatoria'),
(@carrera_ifg_id, 'TRS-207', 'Pensamiento Crítico Tecnológico', 4, 10, 'obligatoria'),
(@carrera_ifg_id, 'CID-409', 'Visualización de la Información', 4, 11, 'obligatoria'),
(@carrera_ifg_id, 'ISW-420', 'Ciberseguridad', 4, 11, 'obligatoria'),
(@carrera_ifg_id, 'LAS-313', 'Laboratorio de Ciberseguridad', 1, 11, 'obligatoria'),
(@carrera_ifg_id, 'PSI-203', 'Gestión Humana', 4, 11, 'obligatoria'),
(@carrera_ifg_id, 'ISW-412', 'Minería de Datos', 4, 12, 'obligatoria'),
(@carrera_ifg_id, 'INF-409', 'Formación de Empresas de Base Tecnológica', 4, 12, 'obligatoria'),
(@carrera_ifg_id, 'PSI-202', 'Comportamiento Organizacional', 4, 12, 'obligatoria'),
(@carrera_ifg_id, 'ADM-207', 'Sostenibilidad y Responsabilidad Corporativa', 3, 12, 'obligatoria'),
(@carrera_ifg_id, 'INF-306', 'Administración de Sistema de Información', 4, 13, 'obligatoria'),
(@carrera_ifg_id, 'ISW-304', 'Desarrollo de Proyectos con Software Libre', 4, 13, 'obligatoria'),
(@carrera_ifg_id, 'ISW-413', 'Simulación Digital', 4, 13, 'obligatoria'),
(@carrera_ifg_id, 'FGP-421', 'Coaching', 3, 13, 'obligatoria'),
(@carrera_ifg_id, 'INF-412', 'Auditoría de Sistemas de Información', 3, 14, 'obligatoria'),
(@carrera_ifg_id, 'ADM-419', 'Creación y Gerencia de Pymes', 4, 14, 'obligatoria'),
(@carrera_ifg_id, 'PIN-400', 'Práctica Profesional (Pasantía)', 8, 14, 'obligatoria'),
(@carrera_ifg_id, 'TRS-208', 'Gestión de Incidentes', 4, 15, 'obligatoria'),
(@carrera_ifg_id, 'INF-413', 'Consultoría en Transformación Digital', 4, 15, 'obligatoria'),
(@carrera_ifg_id, 'INF-414', 'Seminario de Proyectos Gerenciales', 4, 15, 'obligatoria'),
(@carrera_ifg_id, 'INF-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_ifg_id, 'ISW-431', 'Blockchain y Aplicaciones Descentralizadas', 3, 0, 'optativa'),
(@carrera_ifg_id, 'ISW-432', 'Administración de Servidores y Servicios Telemáticos', 3, 0, 'optativa'),
(@carrera_ifg_id, 'INF-416', 'DevOps y Automatización de Procesos Empresariales', 3, 0, 'optativa'),
(@carrera_ifg_id, 'ISW-424', 'Computación Cuántica y Algoritmos Avanzados', 3, 0, 'optativa'),
(@carrera_ifg_id, 'FGN-309', 'Metodologías de Emprendimiento', 3, 0, 'optativa'),
(@carrera_ifg_id, 'ADM-316', 'Formulación y Creación de Proyectos Emprendedores', 3, 0, 'optativa'),
(@carrera_ifg_id, 'CON-334', 'Finanzas Básicas para Emprendedores', 3, 0, 'optativa'),
(@carrera_ifg_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 16. Licenciatura en Lenguas Modernas, Mención Turismo
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Lenguas Modernas, Mención Turismo', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_lmt_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Lenguas Modernas, Mención Turismo');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_lmt_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_lmt_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_lmt_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_lmt_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 2, 'obligatoria'),
(@carrera_lmt_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 2, 'obligatoria'),
(@carrera_lmt_id, 'ING-101', 'Inglés Elemental I y Laboratorio', 5, 2, 'obligatoria'),
(@carrera_lmt_id, 'FGC-106', 'Historia Social Dominicana', 3, 3, 'obligatoria'),
(@carrera_lmt_id, 'CBE-110', 'Análisis y producción de textos', 4, 3, 'obligatoria'),
(@carrera_lmt_id, 'ING-102', 'Inglés Elemental II y Laboratorio', 5, 3, 'obligatoria'),
(@carrera_lmt_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 4, 'obligatoria'),
(@carrera_lmt_id, 'TUR-101', 'Fundamentos Teóricos del Turismo', 4, 4, 'obligatoria'),
(@carrera_lmt_id, 'ING-203', 'Inglés Intermedio I y Laboratorio', 5, 4, 'obligatoria'),
(@carrera_lmt_id, 'FGC-203', 'Filosofía y Sociedad', 3, 5, 'obligatoria'),
(@carrera_lmt_id, 'FGT-302', 'Cultura, Folklore y Patrimonio Dominicano', 3, 5, 'obligatoria'),
(@carrera_lmt_id, 'ING-204', 'Inglés Intermedio II y Laboratorio', 5, 5, 'obligatoria'),
(@carrera_lmt_id, 'OPT-101', 'Optativa 1', 3, 5, 'optativa'),
(@carrera_lmt_id, 'FRA-201', 'Francés Elemental I y Laboratorio', 5, 6, 'obligatoria'),
(@carrera_lmt_id, 'TUR-204', 'Geografía Turística Dominicana', 4, 6, 'obligatoria'),
(@carrera_lmt_id, 'ING-206', 'Inglés Avanzado I y Laboratorio', 5, 6, 'obligatoria'),
(@carrera_lmt_id, 'FRA-202', 'Francés Elemental Il y Laboratorio', 5, 7, 'obligatoria'),
(@carrera_lmt_id, 'FGC-204', 'Investigación Aplicada', 4, 7, 'obligatoria'),
(@carrera_lmt_id, 'ING-207', 'Inglés Avanzado II y Laboratorio', 5, 7, 'obligatoria'),
(@carrera_lmt_id, 'FRA-203', 'Francés Intermedio I y Laboratorio', 5, 8, 'obligatoria'),
(@carrera_lmt_id, 'FGT-201', 'Etiqueta, Protocolo y Eventos', 4, 8, 'obligatoria'),
(@carrera_lmt_id, 'ING-311', 'Conversación Inglesa', 4, 8, 'obligatoria'),
(@carrera_lmt_id, 'FRA-304', 'Francés Intermedio II y Laboratorio', 5, 9, 'obligatoria'),
(@carrera_lmt_id, 'TUR-311', 'Recreación y Animación Cultural', 4, 9, 'obligatoria'),
(@carrera_lmt_id, 'ING-314', 'Gramática Inglesa', 4, 9, 'obligatoria'),
(@carrera_lmt_id, 'FRA-305', 'Francés Avanzado I y Laboratorio', 5, 10, 'obligatoria'),
(@carrera_lmt_id, 'FGC-409', 'Ética Profesional', 3, 10, 'obligatoria'),
(@carrera_lmt_id, 'LIT-301', 'Seminario de Idiomas', 3, 10, 'obligatoria'),
(@carrera_lmt_id, 'OPT-102', 'Optativa 2', 3, 10, 'optativa'),
(@carrera_lmt_id, 'FRA-306', 'Francés Avanzado II y Laboratorio', 5, 11, 'obligatoria'),
(@carrera_lmt_id, 'FGD-415', 'Legislación Laboral y Turística', 4, 11, 'obligatoria'),
(@carrera_lmt_id, 'ING-327', 'Fonética y Fonología Inglesa', 4, 11, 'obligatoria'),
(@carrera_lmt_id, 'FGL-401', 'Inglés Técnico para Turismo', 4, 12, 'obligatoria'),
(@carrera_lmt_id, 'TUR-421', 'Diseño de Rutas', 3, 12, 'obligatoria'),
(@carrera_lmt_id, 'FRA-307', 'Conversación Francesa', 4, 12, 'obligatoria'),
(@carrera_lmt_id, 'ING-428', 'Cultura Anglófona', 4, 13, 'obligatoria'),
(@carrera_lmt_id, 'LIT-402', 'Introducción a la Traducción e Interpretación', 3, 13, 'obligatoria'),
(@carrera_lmt_id, 'FRA-408', 'Gramática Francesa', 4, 13, 'obligatoria'),
(@carrera_lmt_id, 'OPT-103', 'Optativa 3', 3, 13, 'optativa'),
(@carrera_lmt_id, 'LIT-403', 'Traducción e interpretación especializadas español-inglés', 4, 14, 'obligatoria'),
(@carrera_lmt_id, 'FRA-308', 'Fonética y Fonología Francesa', 4, 14, 'obligatoria'),
(@carrera_lmt_id, 'FGC-208', 'Educación Constitucional', 3, 14, 'obligatoria'),
(@carrera_lmt_id, 'PLM-400', 'Práctica Profesional (Pasantía)', 8, 14, 'obligatoria'),
(@carrera_lmt_id, 'FGL-405', 'Francés Técnico para Turismo', 4, 15, 'obligatoria'),
(@carrera_lmt_id, 'FRA-410', 'Cultura Francófona', 4, 15, 'obligatoria'),
(@carrera_lmt_id, 'LIT-404', 'Traducción e interpretación especializadas español-francés', 4, 15, 'obligatoria'),
(@carrera_lmt_id, 'LIT-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_lmt_id, 'ITA-327', 'Italiano I', 3, 0, 'optativa'),
(@carrera_lmt_id, 'ITA-328', 'Italiano II', 3, 0, 'optativa'),
(@carrera_lmt_id, 'ITA-329', 'Italiano III', 3, 0, 'optativa'),
(@carrera_lmt_id, 'FGP-211', 'Desarrollo del Lenguaje', 3, 0, 'optativa'),
(@carrera_lmt_id, 'FGN-309', 'Metodologías de Emprendimiento', 3, 0, 'optativa'),
(@carrera_lmt_id, 'ADM-316', 'Formulación y Creación de Proyectos Emprendedores', 3, 0, 'optativa'),
(@carrera_lmt_id, 'CON-334', 'Finanzas Básicas para Emprendedores', 3, 0, 'optativa'),
(@carrera_lmt_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 0, 'optativa'),
(@carrera_lmt_id, 'FGP-421', 'Coaching', 3, 0, 'optativa'),
(@carrera_lmt_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 17. Licenciatura en Mercadeo
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Mercadeo', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_mer_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Mercadeo');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_mer_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_mer_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_mer_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_mer_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 2, 'obligatoria'),
(@carrera_mer_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 2, 'obligatoria'),
(@carrera_mer_id, 'MER-105', 'Fundamentos de Marketing', 4, 2, 'obligatoria'),
(@carrera_mer_id, 'CBE-110', 'Análisis y Producción de Textos', 4, 3, 'obligatoria'),
(@carrera_mer_id, 'MER-104', 'Marketing Avanzado', 4, 3, 'obligatoria'),
(@carrera_mer_id, 'ADM-103', 'Fundamentos de Administración Empresarial', 4, 3, 'obligatoria'),
(@carrera_mer_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 4, 'obligatoria'),
(@carrera_mer_id, 'FGC-203', 'Filosofía y Sociedad', 3, 4, 'obligatoria'),
(@carrera_mer_id, 'COE-101', 'Contabilidad I', 4, 4, 'obligatoria'),
(@carrera_mer_id, 'FGN-209', 'Economía Empresarial', 4, 5, 'obligatoria'),
(@carrera_mer_id, 'FGN-207', 'Análisis de Datos I', 4, 5, 'obligatoria'),
(@carrera_mer_id, 'MER-207', 'Marketing Relacional', 3, 5, 'obligatoria'),
(@carrera_mer_id, 'FGC-204', 'Investigación Aplicada', 4, 6, 'obligatoria'),
(@carrera_mer_id, 'COE-102', 'Contabilidad II', 4, 6, 'obligatoria'),
(@carrera_mer_id, 'ADM-207', 'Sostenibilidad y Responsabilidad Corporativa', 3, 6, 'obligatoria'),
(@carrera_mer_id, 'FGN-208', 'Análisis de Datos II', 4, 7, 'obligatoria'),
(@carrera_mer_id, 'MER-204', 'Investigación de Mercado I', 4, 7, 'obligatoria'),
(@carrera_mer_id, 'MER-209', 'Diseño Gráfico', 3, 7, 'obligatoria'),
(@carrera_mer_id, 'MER-205', 'Investigación de Mercado II', 4, 8, 'obligatoria'),
(@carrera_mer_id, 'MER-210', 'Negocios Internacionales', 3, 8, 'obligatoria'),
(@carrera_mer_id, 'FGN-203', 'Matemática Financiera', 4, 8, 'obligatoria'),
(@carrera_mer_id, 'FGC-208', 'Educación Constitucional', 3, 9, 'obligatoria'),
(@carrera_mer_id, 'MER-307', 'Marketing Estratégico', 4, 9, 'obligatoria'),
(@carrera_mer_id, 'MER-315', 'Neuroventas', 3, 9, 'obligatoria'),
(@carrera_mer_id, 'OPT-101', 'Optativa 1', 3, 9, 'optativa'),
(@carrera_mer_id, 'FGC-409', 'Ética Profesional', 3, 10, 'obligatoria'),
(@carrera_mer_id, 'ADM-307', 'Presupuesto Empresarial', 4, 10, 'obligatoria'),
(@carrera_mer_id, 'MER-316', 'Práctica de Marketing', 4, 10, 'obligatoria'),
(@carrera_mer_id, 'ADM-316', 'Formulación y Creación de Proyectos Emprendedores', 3, 11, 'obligatoria'),
(@carrera_mer_id, 'MER-317', 'Inteligencia de Negocios', 3, 11, 'obligatoria'),
(@carrera_mer_id, 'MER-415', 'Marketing Digital', 3, 11, 'obligatoria'),
(@carrera_mer_id, 'OPT-102', 'Optativa 2', 3, 11, 'optativa'),
(@carrera_mer_id, 'MER-318', 'Gerencia de Marca', 3, 12, 'obligatoria'),
(@carrera_mer_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 12, 'obligatoria'),
(@carrera_mer_id, 'PPM-300', 'Práctica Profesional (Pasantía)', 8, 12, 'obligatoria'),
(@carrera_mer_id, 'MER-206', 'Comportamiento del Consumidor', 3, 13, 'obligatoria'),
(@carrera_mer_id, 'FGN-307', 'Seminario de Actualización para Negocios', 3, 13, 'obligatoria'),
(@carrera_mer_id, 'MER-422', 'Marketing de Servicios', 3, 13, 'obligatoria'),
(@carrera_mer_id, 'MER-423', 'E-commerce', 3, 13, 'obligatoria'),
(@carrera_mer_id, 'MER-421', 'Simulación de Marketing', 4, 14, 'obligatoria'),
(@carrera_mer_id, 'MER-424', 'Gestión Comercial', 4, 14, 'obligatoria'),
(@carrera_mer_id, 'MER-425', 'Trade Marketing', 3, 14, 'obligatoria'),
(@carrera_mer_id, 'MER-426', 'Estrategias de Comunicación Marketing', 5, 15, 'obligatoria'),
(@carrera_mer_id, 'FGN-311', 'Inteligencia Artificial Aplicada a los Negocios', 3, 15, 'obligatoria'),
(@carrera_mer_id, 'OPT-103', 'Optativa 3', 3, 15, 'optativa'),
(@carrera_mer_id, 'MER-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_mer_id, 'MER-319', 'Enfoques Contemporáneos de Gestión', 3, 0, 'optativa'),
(@carrera_mer_id, 'MER-320', 'Marketing Político', 3, 0, 'optativa'),
(@carrera_mer_id, 'FGD-312', 'Legislación Comercial', 3, 0, 'optativa'),
(@carrera_mer_id, 'COE-221', 'Mercado de Valores', 3, 0, 'optativa'),
(@carrera_mer_id, 'FGN-309', 'Metodologías de Emprendimiento', 3, 0, 'optativa'),
(@carrera_mer_id, 'CON-334', 'Finanzas Básicas para Emprendedores', 3, 0, 'optativa'),
(@carrera_mer_id, 'FGP-421', 'Coaching', 3, 0, 'optativa'),
(@carrera_mer_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 18. Licenciatura en Periodismo Digital
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Periodismo Digital', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_pdi_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Periodismo Digital');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_pdi_id, 'CBC-102', 'Introducción a la Educación a Distancia', 3, 1, 'obligatoria'),
(@carrera_pdi_id, 'CBE-103', 'Español I', 4, 1, 'obligatoria'),
(@carrera_pdi_id, 'CBC-104', 'Infotecnología para el Aprendizaje', 3, 1, 'obligatoria'),
(@carrera_pdi_id, 'CBE-105', 'Español II', 4, 2, 'obligatoria'),
(@carrera_pdi_id, 'CBM-106', 'Matemática Básica', 4, 2, 'obligatoria'),
(@carrera_pdi_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 2, 'obligatoria'),
(@carrera_pdi_id, 'FGC-104', 'Filosofía General', 2, 2, 'obligatoria'),
(@carrera_pdi_id, 'FGM-101', 'Matemática Superior', 4, 3, 'obligatoria'),
(@carrera_pdi_id, 'PDI-101', 'Redacción Periodística I', 4, 3, 'obligatoria'),
(@carrera_pdi_id, 'INF-410', 'Tecnología de la Informática y Comunicación Aplicada al Periodismo.', 4, 3, 'obligatoria'),
(@carrera_pdi_id, 'FGC-102', 'Sociología', 3, 4, 'obligatoria'),
(@carrera_pdi_id, 'PDI-102', 'Redacción Periodística II', 4, 4, 'obligatoria'),
(@carrera_pdi_id, 'PDI-103', 'Medio Digitales en la Sociedad Actual', 4, 4, 'obligatoria'),
(@carrera_pdi_id, 'FGC-205', 'Metodología de la Investigación I', 4, 5, 'obligatoria'),
(@carrera_pdi_id, 'PDI-204', 'Introducción al Periodismo Digital', 4, 5, 'obligatoria'),
(@carrera_pdi_id, 'PDI-205', 'Psicosociología de la Comunicación', 4, 5, 'obligatoria'),
(@carrera_pdi_id, 'FGC-206', 'Metodología de la Investigación II', 4, 6, 'obligatoria'),
(@carrera_pdi_id, 'FGN-201', 'Fundamentos de Economía', 3, 6, 'obligatoria'),
(@carrera_pdi_id, 'FGI-412', 'Ciencia, Tecnología y Sociedad', 3, 6, 'obligatoria'),
(@carrera_pdi_id, 'FGC-411', 'Introducción a las Ciencias Políticas.', 3, 7, 'obligatoria'),
(@carrera_pdi_id, 'PDI-206', 'Medios de Comunicación Digitales I', 4, 7, 'obligatoria'),
(@carrera_pdi_id, 'PDI-207', 'La Entrevista Periodística', 4, 7, 'obligatoria'),
(@carrera_pdi_id, 'PDI-208', 'Comunicación Gráfica y Audiovisual en la Sociedad del Conocimiento', 4, 8, 'obligatoria'),
(@carrera_pdi_id, 'PDI-209', 'Medios de Comunicación Digitales II', 4, 8, 'obligatoria'),
(@carrera_pdi_id, 'DER-313', 'Derechos Intelectuales', 4, 8, 'obligatoria'),
(@carrera_pdi_id, 'PDI-310', 'Fotoperiodismo Digital', 4, 9, 'obligatoria'),
(@carrera_pdi_id, 'PDI-311', 'Guión para Radio y Televisión', 4, 9, 'obligatoria'),
(@carrera_pdi_id, 'PDI-312', 'Técnicas de Reportaje Periodístico', 4, 9, 'obligatoria'),
(@carrera_pdi_id, 'PDI-313', 'Crónica Periodística', 4, 10, 'obligatoria'),
(@carrera_pdi_id, 'PDI-314', 'Taller de Radio y Televisión', 4, 10, 'obligatoria'),
(@carrera_pdi_id, 'PDI-315', 'Periodismo de Investigación I', 4, 10, 'obligatoria'),
(@carrera_pdi_id, 'PDI-316', 'Periodismo de Investigación II', 4, 11, 'obligatoria'),
(@carrera_pdi_id, 'PDI-317', 'Publicidad y Propaganda', 4, 11, 'obligatoria'),
(@carrera_pdi_id, 'PDI-318', 'Taller de Prensa Escrita I', 4, 11, 'obligatoria'),
(@carrera_pdi_id, 'PDI-319', 'Taller de Prensa Escrita II', 4, 12, 'obligatoria'),
(@carrera_pdi_id, 'PDI-320', 'Relato Periodístico', 4, 12, 'obligatoria'),
(@carrera_pdi_id, 'INF-411', 'Internet 2.0 y Redes Sociales en la Sociedad del Conocimiento', 4, 12, 'obligatoria'),
(@carrera_pdi_id, 'PDI-421', 'Opinión Pública', 4, 13, 'obligatoria'),
(@carrera_pdi_id, 'PDI-422', 'Periodismo Ciudadano', 4, 13, 'obligatoria'),
(@carrera_pdi_id, 'PDI-423', 'Periodismo en la Sociedad Global', 4, 13, 'obligatoria'),
(@carrera_pdi_id, 'FGD-417', 'Régimen Legal de los Medios de Comunicación en R.D.', 4, 14, 'obligatoria'),
(@carrera_pdi_id, 'PDI-424', 'Oratoria y Medios de Comunicación', 4, 14, 'obligatoria'),
(@carrera_pdi_id, 'PDI-425', 'Producción Audiovisual en la Era Digital', 4, 14, 'obligatoria'),
(@carrera_pdi_id, 'PPD-400', 'Pasantía con 240 horas', 8, 14, 'obligatoria'),
(@carrera_pdi_id, 'PDI-426', 'Estilos Literarios', 4, 15, 'obligatoria'),
(@carrera_pdi_id, 'FGC-412', 'Ética Profesional del Periodista', 3, 15, 'obligatoria'),
(@carrera_pdi_id, 'PDI-427', 'Seminario de Actualización Periodística', 3, 15, 'obligatoria'),
(@carrera_pdi_id, 'CPD-500', 'Curso Final de Grado', 6, 16, 'obligatoria')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 19. Licenciatura en Psicología
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Psicología', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_psg_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Psicología');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_psg_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_psg_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_psg_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_psg_id, 'CBE-110', 'Análisis y Producción de Textos', 4, 2, 'obligatoria'),
(@carrera_psg_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 2, 'obligatoria'),
(@carrera_psg_id, 'PSG-105', 'Introducción a la Psicología', 3, 2, 'obligatoria'),
(@carrera_psg_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 3, 'obligatoria'),
(@carrera_psg_id, 'PSG-102', 'Historia de la Psicología', 4, 3, 'obligatoria'),
(@carrera_psg_id, 'PSG-103', 'Anatomía y Fisiología del Sistema Nervioso', 4, 3, 'obligatoria'),
(@carrera_psg_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 4, 'obligatoria'),
(@carrera_psg_id, 'PSG-104', 'Psicología Social y Comunitaria', 4, 4, 'obligatoria'),
(@carrera_psg_id, 'PSG-205', 'Neuropsicología', 3, 4, 'obligatoria'),
(@carrera_psg_id, 'PSE-101', 'Psicología Educativa', 4, 5, 'obligatoria'),
(@carrera_psg_id, 'PSE-201', 'Psicología del Desarrollo I', 4, 5, 'obligatoria'),
(@carrera_psg_id, 'PSG-206', 'Teoría de los Test y Fundamentos de Medición', 4, 5, 'obligatoria'),
(@carrera_psg_id, 'FGC-204', 'Investigación Aplicada', 4, 6, 'obligatoria'),
(@carrera_psg_id, 'PSE-202', 'Psicología del Desarrollo II', 4, 6, 'obligatoria'),
(@carrera_psg_id, 'PSG-208', 'Pruebas de Aptitudes e Intereses', 4, 6, 'obligatoria'),
(@carrera_psg_id, 'FGC-208', 'Educación Constitucional', 3, 7, 'obligatoria'),
(@carrera_psg_id, 'PSC-202', 'Psicopatología I', 4, 7, 'obligatoria'),
(@carrera_psg_id, 'PSG-207', 'Teorías de la Personalidad', 3, 7, 'obligatoria'),
(@carrera_psg_id, 'OPT-101', 'Optativa 1', 3, 7, 'optativa'),
(@carrera_psg_id, 'PSC-204', 'Psicología Clínica', 4, 8, 'obligatoria'),
(@carrera_psg_id, 'PSG-209', 'Procesos Cognitivos', 4, 8, 'obligatoria'),
(@carrera_psg_id, 'PSG-310', 'Análisis y Modificación de Conducta', 4, 8, 'obligatoria'),
(@carrera_psg_id, 'FGP-210', 'Psicología del Aprendizaje', 3, 9, 'obligatoria'),
(@carrera_psg_id, 'PSG-311', 'Técnica de Entrevista Psicológica', 4, 9, 'obligatoria'),
(@carrera_psg_id, 'PSI-201', 'Psicología Industrial y de las Organizaciones', 3, 9, 'obligatoria'),
(@carrera_psg_id, 'OPT-102', 'Optativa 2', 3, 9, 'optativa'),
(@carrera_psg_id, 'FGC-409', 'Ética Profesional', 3, 10, 'obligatoria'),
(@carrera_psg_id, 'PSG-312', 'Evaluación de la Inteligencia', 4, 10, 'obligatoria'),
(@carrera_psg_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 10, 'obligatoria'),
(@carrera_psg_id, 'OPT-103', 'Optativa 3', 3, 10, 'optativa'),
(@carrera_psg_id, 'PSG-314', 'Introducción a la Psicoterapia', 4, 11, 'obligatoria'),
(@carrera_psg_id, 'PSG-318', 'Evaluación de la Personalidad', 4, 11, 'obligatoria'),
(@carrera_psg_id, 'PSI-311', 'Pruebas para la Selección de Personal', 4, 11, 'obligatoria'),
(@carrera_psg_id, 'PSE-306', 'Trastornos del Aprendizaje', 4, 12, 'obligatoria'),
(@carrera_psg_id, 'PSI-203', 'Gestión Humana', 4, 12, 'obligatoria'),
(@carrera_psg_id, 'PSI-308', 'Reclutamiento y Selección de Personal', 4, 12, 'obligatoria'),
(@carrera_psg_id, 'PSC-304', 'Psicopatología II', 4, 13, 'obligatoria'),
(@carrera_psg_id, 'PSE-414', 'Práctica de Intervención Psicopedagógica I', 4, 13, 'obligatoria'),
(@carrera_psg_id, 'PSO-401', 'Práctica de Gestión Humana', 4, 13, 'obligatoria'),
(@carrera_psg_id, 'PSC-410', 'Práctica de Psicología Clínica I', 4, 14, 'obligatoria'),
(@carrera_psg_id, 'PSE-309', 'Terapia de Aprendizaje', 4, 14, 'obligatoria'),
(@carrera_psg_id, 'PSG-417', 'Terapia y Dinámica de Grupos', 4, 14, 'obligatoria'),
(@carrera_psg_id, 'PPG-400', 'Práctica Profesional (Pasantía)', 8, 14, 'obligatoria'),
(@carrera_psg_id, 'FGP-419', 'Seminario de Actualización en Psicología', 3, 15, 'obligatoria'),
(@carrera_psg_id, 'PSE-413', 'Estimulación Temprana', 4, 15, 'obligatoria'),
(@carrera_psg_id, 'PSG-315', 'Test Proyectivo de la Personalidad', 4, 15, 'obligatoria'),
(@carrera_psg_id, 'PSG-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_psg_id, 'PSG-317', 'Psicología Positiva', 3, 0, 'optativa'),
(@carrera_psg_id, 'PSO-402', 'Gestión del Cambio Organizacional', 3, 0, 'optativa'),
(@carrera_psg_id, 'PSG-210', 'Psicología Forense', 3, 0, 'optativa'),
(@carrera_psg_id, 'FGP-207', 'Neurociencias y Aprendizaje', 3, 0, 'optativa'),
(@carrera_psg_id, 'FGN-309', 'Metodologías de Emprendimiento', 3, 0, 'optativa'),
(@carrera_psg_id, 'ADM-316', 'Formulación y Creación de Proyectos Emprendedores', 3, 0, 'optativa'),
(@carrera_psg_id, 'CON-334', 'Finanzas Básicas para Emprendedores', 3, 0, 'optativa'),
(@carrera_psg_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 0, 'optativa'),
(@carrera_psg_id, 'FGP-421', 'Coaching', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 20. Licenciatura en Psicología Clínica
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Psicología Clínica', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_psc_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Psicología Clínica');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_psc_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_psc_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_psc_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_psc_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 2, 'obligatoria'),
(@carrera_psc_id, 'CBE-110', 'Análisis y Producción de Textos', 4, 2, 'obligatoria'),
(@carrera_psc_id, 'PSG-105', 'Introducción a la Psicología', 3, 2, 'obligatoria'),
(@carrera_psc_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 3, 'obligatoria'),
(@carrera_psc_id, 'PSG-103', 'Anatomía y Fisiología del Sistema Nervioso', 4, 3, 'obligatoria'),
(@carrera_psc_id, 'PSG-102', 'Historia de la Psicología', 4, 3, 'obligatoria'),
(@carrera_psc_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 4, 'obligatoria'),
(@carrera_psc_id, 'PSE-201', 'Psicología del Desarrollo I', 4, 4, 'obligatoria'),
(@carrera_psc_id, 'PSG-205', 'Neuropsicología', 3, 4, 'obligatoria'),
(@carrera_psc_id, 'PSG-311', 'Técnicas de Entrevista Psicológica', 4, 5, 'obligatoria'),
(@carrera_psc_id, 'PSG-104', 'Psicología Social y Comunitaria', 4, 5, 'obligatoria'),
(@carrera_psc_id, 'PSG-206', 'Teoría de los Test y Fundamentos de Medición', 4, 5, 'obligatoria'),
(@carrera_psc_id, 'FGC-204', 'Investigación Aplicada', 4, 6, 'obligatoria'),
(@carrera_psc_id, 'PSC-204', 'Psicología Clínica', 4, 6, 'obligatoria'),
(@carrera_psc_id, 'PSE-202', 'Psicología del Desarrollo II', 4, 6, 'obligatoria'),
(@carrera_psc_id, 'PSG-208', 'Pruebas de Aptitudes e Intereses', 4, 7, 'obligatoria'),
(@carrera_psc_id, 'FGC-409', 'Ética Profesional', 3, 7, 'obligatoria'),
(@carrera_psc_id, 'PSG-207', 'Teoría de la Personalidad', 3, 7, 'obligatoria'),
(@carrera_psc_id, 'OPT-101', 'Optativa 1', 3, 7, 'optativa'),
(@carrera_psc_id, 'PSC-202', 'Psicopatología I', 4, 8, 'obligatoria'),
(@carrera_psc_id, 'PSG-209', 'Procesos Cognitivos', 4, 8, 'obligatoria'),
(@carrera_psc_id, 'PSG-310', 'Análisis y Modificación de la Conducta', 4, 8, 'obligatoria'),
(@carrera_psc_id, 'PSG-314', 'Introducción a la Psicoterapia', 4, 9, 'obligatoria'),
(@carrera_psc_id, 'FGC-208', 'Educación Constitucional', 3, 9, 'obligatoria'),
(@carrera_psc_id, 'PSC-301', 'Psicodiagnóstico Clínico', 3, 9, 'obligatoria'),
(@carrera_psc_id, 'OPT-102', 'Optativa 2', 3, 9, 'optativa'),
(@carrera_psc_id, 'PSG-418', 'Terapia Cognitiva Conductual', 4, 10, 'obligatoria'),
(@carrera_psc_id, 'PSC-304', 'Psicopatología II', 4, 10, 'obligatoria'),
(@carrera_psc_id, 'PSG-312', 'Evaluación de la Inteligencia', 4, 10, 'obligatoria'),
(@carrera_psc_id, 'PSC-410', 'Práctica de Psicología Clínica I', 4, 11, 'obligatoria'),
(@carrera_psc_id, 'PSG-315', 'Test Proyectivo de la Personalidad', 4, 11, 'obligatoria'),
(@carrera_psc_id, 'OPT-103', 'Optativa 3', 3, 11, 'optativa'),
(@carrera_psc_id, 'PSG-318', 'Evaluación de la Personalidad', 4, 12, 'obligatoria'),
(@carrera_psc_id, 'PSC-411', 'Práctica de Psicología Clínica II', 4, 12, 'obligatoria'),
(@carrera_psc_id, 'PSE-410', 'Terapia de Juego', 4, 12, 'obligatoria'),
(@carrera_psc_id, 'PSG-417', 'Terapia y Dinámica de Grupos', 4, 13, 'obligatoria'),
(@carrera_psc_id, 'PSC-307', 'Terapia Psicoanalítica', 4, 13, 'obligatoria'),
(@carrera_psc_id, 'PSC-408', 'Terapia Sexual y de Parejas', 4, 13, 'obligatoria'),
(@carrera_psc_id, 'FGP-210', 'Psicología del Aprendizaje', 3, 14, 'obligatoria'),
(@carrera_psc_id, 'PSC-409', 'Psicofarmacología', 3, 14, 'obligatoria'),
(@carrera_psc_id, 'FGP-419', 'Seminario de Actualización en Psicología', 3, 14, 'obligatoria'),
(@carrera_psc_id, 'PPC-400', 'Práctica Profesional (Pasantía)', 8, 14, 'obligatoria'),
(@carrera_psc_id, 'PSG-420', 'Salud Mental y Comunitaria', 3, 15, 'obligatoria'),
(@carrera_psc_id, 'PSC-306', 'Terapia Familiar', 4, 15, 'obligatoria'),
(@carrera_psc_id, 'PSC-412', 'Manejo Clínico de Intervención de la Crisis', 4, 15, 'obligatoria'),
(@carrera_psc_id, 'PSC-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_psc_id, 'PSG-210', 'Psicología Forense', 3, 0, 'optativa'),
(@carrera_psc_id, 'PSG-317', 'Psicología Positiva', 3, 0, 'optativa'),
(@carrera_psc_id, 'FGP-207', 'Neurociencias y Aprendizaje', 3, 0, 'optativa'),
(@carrera_psc_id, 'PSC-207', 'Criminología Clínica', 3, 0, 'optativa'),
(@carrera_psc_id, 'FGN-309', 'Metodologías de Emprendimiento', 3, 0, 'optativa'),
(@carrera_psc_id, 'ADM-316', 'Formulación y Creación de Proyectos Emprendedores', 3, 0, 'optativa'),
(@carrera_psc_id, 'CON-334', 'Finanzas Básicas para Emprendedores', 3, 0, 'optativa'),
(@carrera_psc_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 0, 'optativa'),
(@carrera_psc_id, 'FGP-421', 'Coaching', 3, 0, 'optativa'),
(@carrera_psc_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 21. Licenciatura en Psicología Educativa
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Psicología Educativa', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_pse_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Psicología Educativa');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_pse_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_pse_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_pse_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1, 'obligatoria'),
(@carrera_pse_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 2, 'obligatoria'),
(@carrera_pse_id, 'CBE-110', 'Análisis y Producción de Textos', 4, 2, 'obligatoria'),
(@carrera_pse_id, 'PSG-105', 'Introducción a la Psicología', 3, 2, 'obligatoria'),
(@carrera_pse_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 3, 'obligatoria'),
(@carrera_pse_id, 'PSG-103', 'Anatomía y Fisiología del Sistema Nervioso', 4, 3, 'obligatoria'),
(@carrera_pse_id, 'PSG-102', 'Historia de la Psicología', 4, 3, 'obligatoria'),
(@carrera_pse_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 4, 'obligatoria'),
(@carrera_pse_id, 'PSG-206', 'Teoría de los Tests y Fundamentos de Medición', 4, 4, 'obligatoria'),
(@carrera_pse_id, 'PSE-101', 'Psicología Educativa', 4, 4, 'obligatoria'),
(@carrera_pse_id, 'PSE-201', 'Psicología del Desarrollo I', 4, 5, 'obligatoria'),
(@carrera_pse_id, 'FGE-101', 'Fundamento Filosófico e Histórico de la Educación', 4, 5, 'obligatoria'),
(@carrera_pse_id, 'PSG-104', 'Psicología Social y Comunitaria', 4, 5, 'obligatoria'),
(@carrera_pse_id, 'FGC-204', 'Investigación Aplicada', 4, 6, 'obligatoria'),
(@carrera_pse_id, 'PSG-207', 'Teorías de la Personalidad', 3, 6, 'obligatoria'),
(@carrera_pse_id, 'PSE-202', 'Psicología del Desarrollo II', 4, 6, 'obligatoria'),
(@carrera_pse_id, 'FGE-302', 'Educación Socioemocional del Docente y el Estudiante', 3, 6, 'obligatoria'),
(@carrera_pse_id, 'PSG-311', 'Técnicas de Entrevista Psicológica', 4, 7, 'obligatoria'),
(@carrera_pse_id, 'PSC-202', 'Psicopatología I', 4, 7, 'obligatoria'),
(@carrera_pse_id, 'PSE-204', 'Psicología del Lenguaje', 4, 7, 'obligatoria'),
(@carrera_pse_id, 'PSG-310', 'Análisis y Modificación de Conducta', 4, 8, 'obligatoria'),
(@carrera_pse_id, 'PSG-205', 'Neuropsicología', 3, 8, 'obligatoria'),
(@carrera_pse_id, 'PSG-314', 'Introducción a la Psicoterapia', 4, 8, 'obligatoria'),
(@carrera_pse_id, 'PSG-312', 'Evaluación de la Inteligencia', 4, 9, 'obligatoria'),
(@carrera_pse_id, 'FGP-210', 'Psicología del Aprendizaje', 3, 9, 'obligatoria'),
(@carrera_pse_id, 'PSG-209', 'Procesos Cognitivos', 4, 9, 'obligatoria'),
(@carrera_pse_id, 'PSE-410', 'Terapia de Juego', 4, 10, 'obligatoria'),
(@carrera_pse_id, 'PSE-414', 'Práctica de Intervención Psicopedagógica I', 4, 10, 'obligatoria'),
(@carrera_pse_id, 'PSE-306', 'Trastornos del Aprendizaje', 4, 10, 'obligatoria'),
(@carrera_pse_id, 'FGC-208', 'Educación Constitucional', 3, 11, 'obligatoria'),
(@carrera_pse_id, 'PSG-417', 'Terapia y Dinámica de Grupos', 4, 11, 'obligatoria'),
(@carrera_pse_id, 'FGC-409', 'Ética Profesional', 3, 11, 'obligatoria'),
(@carrera_pse_id, 'PSE-415', 'Práctica de Intervención Psicopedagógica II', 4, 12, 'obligatoria'),
(@carrera_pse_id, 'PSE-309', 'Terapia de Aprendizaje', 4, 12, 'obligatoria'),
(@carrera_pse_id, 'PSG-208', 'Pruebas de Aptitudes e Intereses', 4, 12, 'obligatoria'),
(@carrera_pse_id, 'PSE-308', 'Pruebas Psicopedagógicas', 4, 13, 'obligatoria'),
(@carrera_pse_id, 'PSE-301', 'Convivencia Pacífica en Contextos Educativos', 3, 13, 'obligatoria'),
(@carrera_pse_id, 'FGP-315', 'Atención a la Diversidad', 3, 13, 'obligatoria'),
(@carrera_pse_id, 'PSE-203', 'Trastornos Infanto-Juveniles', 4, 14, 'obligatoria'),
(@carrera_pse_id, 'PSE-413', 'Estimulación Temprana', 4, 14, 'obligatoria'),
(@carrera_pse_id, 'PSG-318', 'Evaluación de la Personalidad', 4, 14, 'obligatoria'),
(@carrera_pse_id, 'PPE-400', 'Práctica Profesional (Pasantía)', 8, 14, 'obligatoria'),
(@carrera_pse_id, 'PSE-402', 'Gestión de Programas y Proyectos Psicoeducativos', 4, 15, 'obligatoria'),
(@carrera_pse_id, 'FGP-419', 'Seminario de Actualización en Psicología', 3, 15, 'obligatoria'),
(@carrera_pse_id, 'PSE-412', 'Orientación Vocacional', 4, 15, 'obligatoria'),
(@carrera_pse_id, 'PSE-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_pse_id, 'FGL-411', 'Creole', 3, 0, 'optativa'),
(@carrera_pse_id, 'FGP-207', 'Neurociencias y Aprendizaje', 3, 0, 'optativa'),
(@carrera_pse_id, 'FGE-102', 'Fundamento y Estructura del Currículo', 3, 0, 'optativa'),
(@carrera_pse_id, 'FGP-308', 'Necesidades Específicas de Apoyo Educativo', 3, 0, 'optativa'),
(@carrera_pse_id, 'FGN-309', 'Metodologías de Emprendimiento', 3, 0, 'optativa'),
(@carrera_pse_id, 'ADM-316', 'Formulación y Creación de Proyectos Emprendedores', 3, 0, 'optativa'),
(@carrera_pse_id, 'CON-334', 'Finanzas Básicas para Emprendedores', 3, 0, 'optativa'),
(@carrera_pse_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 0, 'optativa'),
(@carrera_pse_id, 'FGP-421', 'Coaching', 3, 0, 'optativa'),
(@carrera_pse_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

-- ============================================================================
-- 22. Licenciatura en Psicología Industrial
-- ============================================================================
INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Licenciatura en Psicología Industrial', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_psi_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Psicología Industrial');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, periodo, tipo) VALUES
(@carrera_psi_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1, 'obligatoria'),
(@carrera_psi_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1, 'obligatoria'),
(@carrera_psi_id, 'CBE-109', 'Comunicación oral y escrita', 4, 1, 'obligatoria'),
(@carrera_psi_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 2, 'obligatoria'),
(@carrera_psi_id, 'CBE-110', 'Análisis y Producción de Textos', 4, 2, 'obligatoria'),
(@carrera_psi_id, 'PSG-105', 'Introducción a la Psicología', 3, 2, 'obligatoria'),
(@carrera_psi_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 3, 'obligatoria'),
(@carrera_psi_id, 'PSG-102', 'Historia de la Psicología', 4, 3, 'obligatoria'),
(@carrera_psi_id, 'PSG-103', 'Anatomía y Fisiología del Sistema Nervioso', 4, 3, 'obligatoria'),
(@carrera_psi_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 4, 'obligatoria'),
(@carrera_psi_id, 'PSG-104', 'Psicología Social Comunitaria', 4, 4, 'obligatoria'),
(@carrera_psi_id, 'PSG-205', 'Neuropsicología', 3, 4, 'obligatoria'),
(@carrera_psi_id, 'PSI-201', 'Psicología Industrial y de las Organizaciones', 3, 5, 'obligatoria'),
(@carrera_psi_id, 'PSG-206', 'Teoría de los Test y Fundamentos de Medición', 4, 5, 'obligatoria'),
(@carrera_psi_id, 'ADM-103', 'Fundamentos de Administración Empresarial', 4, 5, 'obligatoria'),
(@carrera_psi_id, 'FGC-204', 'Investigación Aplicada', 4, 6, 'obligatoria'),
(@carrera_psi_id, 'PSG-207', 'Teorías de la Personalidad', 3, 6, 'obligatoria'),
(@carrera_psi_id, 'PSI-202', 'Comportamiento Organizacional', 4, 6, 'obligatoria'),
(@carrera_psi_id, 'PSG-208', 'Pruebas de Aptitudes e Intereses', 4, 7, 'obligatoria'),
(@carrera_psi_id, 'FGC-208', 'Educación Constitucional', 3, 7, 'obligatoria'),
(@carrera_psi_id, 'ADM-203', 'Teoría y Estructura Organizacional', 3, 7, 'obligatoria'),
(@carrera_psi_id, 'PSG-209', 'Procesos Cognitivos', 4, 8, 'obligatoria'),
(@carrera_psi_id, 'PSG-310', 'Análisis y Modificación de la Conducta', 4, 8, 'obligatoria'),
(@carrera_psi_id, 'PSI-203', 'Gestión Humana', 4, 8, 'obligatoria'),
(@carrera_psi_id, 'PSG-419', 'Gestión de Conflictos y Mediación', 3, 9, 'obligatoria'),
(@carrera_psi_id, 'PSI-304', 'Gerencia Estratégica', 4, 9, 'obligatoria'),
(@carrera_psi_id, 'PSO-301', 'Análisis y Diseño de Puestos', 3, 9, 'obligatoria'),
(@carrera_psi_id, 'FGC-409', 'Ética Profesional', 3, 10, 'obligatoria'),
(@carrera_psi_id, 'PSI-311', 'Pruebas para la Selección de Personal', 4, 10, 'obligatoria'),
(@carrera_psi_id, 'PSO-303', 'Técnicas de Entrevista Organizacional', 3, 10, 'obligatoria'),
(@carrera_psi_id, 'PSG-306', 'Evaluación de la Personalidad', 4, 11, 'obligatoria'),
(@carrera_psi_id, 'PSO-304', 'Valuación y Clasificación de Puestos', 4, 11, 'obligatoria'),
(@carrera_psi_id, 'PSI-308', 'Reclutamiento y Selección de Personal', 4, 11, 'obligatoria'),
(@carrera_psi_id, 'PSO-306', 'Compensación y Beneficios', 4, 12, 'obligatoria'),
(@carrera_psi_id, 'PSI-309', 'Evaluación del Desempeño', 4, 12, 'obligatoria'),
(@carrera_psi_id, 'PSO-305', 'Capacitación y Desarrollo de Personal', 4, 12, 'obligatoria'),
(@carrera_psi_id, 'PSI-306', 'Administración de Sueldos y Salarios', 4, 13, 'obligatoria'),
(@carrera_psi_id, 'PSO-302', 'Seguridad y Salud Ocupacional', 4, 13, 'obligatoria'),
(@carrera_psi_id, 'PSO-401', 'Práctica de Gestión Humana', 4, 13, 'obligatoria'),
(@carrera_psi_id, 'PSI-414', 'Sistema de Seguridad Social', 4, 14, 'obligatoria'),
(@carrera_psi_id, 'FGP-419', 'Seminario de Actualización en Psicología', 3, 14, 'obligatoria'),
(@carrera_psi_id, 'PSO-402', 'Gestión del Cambio Organizacional', 3, 14, 'obligatoria'),
(@carrera_psi_id, 'PPO-400', 'Práctica Profesional (Pasantía)', 8, 14, 'obligatoria'),
(@carrera_psi_id, 'PSI-415', 'Proyecto de Consultoría', 4, 15, 'obligatoria'),
(@carrera_psi_id, 'FGP-421', 'Coaching', 3, 15, 'obligatoria'),
(@carrera_psi_id, 'FGD-414', 'Legislación Laboral', 4, 15, 'obligatoria'),
(@carrera_psi_id, 'PSO-400', 'Curso Final de Grado', 6, 16, 'obligatoria'),
(@carrera_psi_id, 'PSG-317', 'Psicología Positiva', 3, 0, 'optativa'),
(@carrera_psi_id, 'MER-206', 'Comportamiento del Consumidor', 3, 0, 'optativa'),
(@carrera_psi_id, 'ADM-206', 'Gestión de Calidad', 3, 0, 'optativa'),
(@carrera_psi_id, 'ADM-207', 'Sostenibilidad y Responsabilidad Social', 3, 0, 'optativa'),
(@carrera_psi_id, 'FGN-309', 'Metodologías de Emprendimiento', 3, 0, 'optativa'),
(@carrera_psi_id, 'ADM-316', 'Formulación y Creación de Proyectos Emprendedores', 3, 0, 'optativa'),
(@carrera_psi_id, 'CON-334', 'Finanzas Básicas para Emprendedores', 3, 0, 'optativa'),
(@carrera_psi_id, 'ADM-314', 'Liderazgo y Gestión de Equipos', 3, 0, 'optativa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), periodo = VALUES(periodo), tipo = VALUES(tipo);

INSERT INTO usuarios (nombre, email, password_hash, telefono, direccion, universidad_id, carrera_id, modalidad, terminos_aceptado_en)
VALUES ('Estudiante Demo', 'estudiante@gaud.dev', '$2y$10$mfODqfAvynGk58DAFBWOgO5Idexrq2XGlp7BBX6EOqhnTo8hQULLu', '809-555-1234', 'Santo Domingo, RD', @uni_id, @carrera_isw_id, 'virtual', NOW())
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), password_hash = VALUES(password_hash), telefono = VALUES(telefono), direccion = VALUES(direccion), universidad_id = VALUES(universidad_id), carrera_id = VALUES(carrera_id), modalidad = VALUES(modalidad);

SET @usuario_id = (SELECT id FROM usuarios WHERE email = 'estudiante@gaud.dev');

INSERT INTO inscripciones (usuario_id, asignatura_id, periodo, estado, calificacion)
VALUES
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'CBC-103'), 1, 'aprobada', 'A'),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'CBC-105'), 1, 'aprobada', 'B'),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'CBE-109'), 1, 'aprobada', 'A'),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'CBM-107'), 1, 'aprobada', 'B'),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGI-103'), 2, 'aprobada', 'A'),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'CBC-107'), 2, 'aprobada', 'C'),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGI-102'), 2, 'aprobada', 'A'),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ING-103'), 2, 'aprobada', 'B'),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'CBE-110'), 3, 'en-curso', NULL),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGI-104'), 3, 'en-curso', NULL),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGM-102'), 3, 'en-curso', NULL),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGM-205'), 3, 'en-curso', NULL)
ON DUPLICATE KEY UPDATE periodo = VALUES(periodo), estado = VALUES(estado), calificacion = VALUES(calificacion);


SET NAMES utf8mb4;
USE gaud;

SET @uni_id = (SELECT id FROM universidades WHERE nombre = 'Universidad Abierta Para Adultos');

DELETE FROM asignatura_relaciones;

-- ============================================================================
-- RELACIONES DE ASIGNATURAS (PRERREQUISITOS Y CORREQUISITOS) - LOTE 1 (COMPLETO)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. INGENIERÍA EN CIENCIA DE DATOS
-- ----------------------------------------------------------------------------
SET @carrera_cid_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Ingeniería en Ciencia de Datos');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'FGI-104'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'FGI-103'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'FGI-105'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'FGI-104'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'FGI-106'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'FGI-104'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'FGM-103'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'FGM-102'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'FGI-208'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'FGI-106'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'FGC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'FGF-207'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'FGF-201'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'CID-202'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'CID-101'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'ISW-305'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'FGI-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'CID-304'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'FGM-205'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'CID-305'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'ISW-305'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'CID-306'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'CID-305'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'CID-409'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'CID-307'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'CID-410'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'ISW-309'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'PPZ-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'CID-409'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'CID-413'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'CID-307'), 'prerrequisito'),
-- Correquisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'LAF-201'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'FGF-201'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'LAF-207'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_cid_id AND codigo = 'FGF-207'), 'correquisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 2. INGENIERÍA EN SOFTWARE
-- ----------------------------------------------------------------------------
SET @carrera_isw_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Ingeniería en Software');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGI-103'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'CBM-107'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGI-104'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGI-103'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGI-105'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGI-104'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGM-103'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGM-102'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ING-213'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ING-103'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGI-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-202'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-201'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-306'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGI-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGI-209'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGF-201'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGI-210'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGI-209'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-412'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGM-207'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-309'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-412'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'CID-115'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-309'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-420'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGI-312'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-304'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-306'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-415'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-304'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'PPS-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-304'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-416'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-415'), 'prerrequisito'),
-- Correquisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'LAF-201'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGF-201'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'LAT-312'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGI-312'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'LAS-313'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-420'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'LAP-414'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-425'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'LAR-415'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-415'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'LAR-416'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ISW-416'), 'correquisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 3. LICENCIATURA EN EDUCACIÓN INICIAL
-- ----------------------------------------------------------------------------
SET @carrera_edi_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Educación Inicial');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'EDI-201'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'FGE-102'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'EDI-203'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'FGE-209'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'FGP-313'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'FGP-101'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'FGP-102'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'FGP-101'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'PRA-207'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'PRA-201'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'EDI-305'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'EDI-203'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'PRA-203'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'PRA-207'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'EDI-309'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'EDI-306'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'PRA-305'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'PRA-203'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'PRA-405'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'PRA-305'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'FGC-413'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'EDI-202'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'EDI-201'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'EDP-414'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'FGE-203'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'PPI-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edi_id AND codigo = 'PRA-405'), 'prerrequisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 4. LICENCIATURA EN ADMINISTRACIÓN DE EMPRESAS
-- ----------------------------------------------------------------------------
SET @carrera_adm_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Administración de Empresas');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'COE-102'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'COE-101'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'FGC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'FGN-207'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'CBM-107'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'FGN-208'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'FGN-207'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'FGN-203'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'CBM-107'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'COE-307'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'COE-102'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'ADM-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'ADM-103'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'ADM-206'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'FGN-208'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'ADM-311'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'ADM-205'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'COE-331'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'COE-102'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'ADM-332'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'ADM-205'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'ADM-315'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'ADM-311'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'PPA-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'ADM-332'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'ADM-421'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_adm_id AND codigo = 'ADM-205'), 'prerrequisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 5. LICENCIATURA EN ADMINISTRACIÓN DE EMPRESAS TURÍSTICAS
-- ----------------------------------------------------------------------------
SET @carrera_tur_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Administración de Empresas Turísticas');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-103'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-101'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'ING-102'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'ING-101'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-104'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-103'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'ING-203'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'ING-102'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'FGC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'ING-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'ING-203'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'FGL-401'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'ING-204'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-311'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'FGT-302'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-203'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-104'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-314'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'FGN-308'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'PPT-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-203'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-421'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-204'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-320'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-211'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-313'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-203'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-321'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-212'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-426'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'FGN-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'PPT-401'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'PPT-400'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-425'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-420'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-424'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_tur_id AND codigo = 'TUR-420'), 'prerrequisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 6. LICENCIATURA EN CONTABILIDAD EMPRESARIAL
-- ----------------------------------------------------------------------------
SET @carrera_coe_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Contabilidad Empresarial');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-102'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-101'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-203'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-102'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'FGN-207'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'CBM-107'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'FGN-208'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'FGN-207'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-205'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-203'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'FGN-203'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'CBM-107'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'FGC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-206'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-203'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-307'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-203'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-309'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-307'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-311'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-205'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-331'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-205'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-332'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-205'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-308'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-203'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-314'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-311'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-333'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-332'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-417'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-308'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'PPN-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-417'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-418'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-314'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-420'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_coe_id AND codigo = 'COE-333'), 'prerrequisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 7. LICENCIATURA EN DERECHO
-- ----------------------------------------------------------------------------
SET @carrera_der_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Derecho');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-206'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-106'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'FGC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-219'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-217'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-209'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-204'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-208'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-211'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-208'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'FGD-306'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-204'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-315'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-211'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-314'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-106'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'FGD-308'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-204'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-319'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-315'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-343'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-314'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-344'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-343'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-339'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-219'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-320'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-343'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-342'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-314'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-422'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-319'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'PPD-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_der_id AND codigo = 'DER-422'), 'prerrequisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 8. LICENCIATURA EN EDUCACIÓN ARTÍSTICA
-- ----------------------------------------------------------------------------
SET @carrera_ear_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Educación Artística');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_ear_id AND codigo = 'FGC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_ear_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_ear_id AND codigo = 'FGP-104'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_ear_id AND codigo = 'FGP-103'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_ear_id AND codigo = 'PRA-211'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_ear_id AND codigo = 'PRA-210'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_ear_id AND codigo = 'FGE-206'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_ear_id AND codigo = 'FGE-209'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_ear_id AND codigo = 'PRA-212'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_ear_id AND codigo = 'PRA-211'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_ear_id AND codigo = 'PRA-324'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_ear_id AND codigo = 'PRA-212'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_ear_id AND codigo = 'PRA-416'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_ear_id AND codigo = 'PRA-324'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_ear_id AND codigo = 'PEA-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_ear_id AND codigo = 'PRA-416'), 'prerrequisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 9. LICENCIATURA EN EDUCACIÓN MENCIÓN LENGUAS EXTRANJERAS (FRANCÉS)
-- ----------------------------------------------------------------------------
SET @carrera_fra_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Educación Mención Lenguas Extranjeras (Francés)');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FGE-102'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FGE-101'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-304'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-203'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-304'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-305'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-204'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-306'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-305'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'ELF-208'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'EDL-213'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FGC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-205'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-306'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'ELF-209'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'ELF-208'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-307'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-205'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-408'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-307'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'ELF-310'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FGE-209'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-308'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-408'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'PRA-326'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'PRA-316'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'ELF-313'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'ELF-310'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'PRA-327'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'PRA-326'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-309'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-308'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'ELF-314'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'ELF-313'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'PRA-418'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'PRA-327'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-410'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-308'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'PRA-419'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'PRA-418'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'ELF-416'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'FRA-410'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'ELF-417'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'ELF-416'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'PPF-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_fra_id AND codigo = 'PRA-419'), 'prerrequisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 10. LICENCIATURA EN EDUCACIÓN MENCIÓN LENGUAS EXTRANJERAS (INGLÉS)
-- ----------------------------------------------------------------------------
SET @carrera_eng_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Educación Mención Lenguas Extranjeras (Inglés)');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'FGE-102'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'FGE-101'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'FGP-210'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'PSG-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ING-207'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ING-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ING-211'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ING-207'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ING-311'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ING-211'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'EDL-326'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'EDL-213'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ING-314'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ING-311'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ING-327'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ING-314'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ELI-318'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ELI-217'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ING-208'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'EDL-213'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ELI-312'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'FGE-209'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'FGC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ELI-313'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ELI-312'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'PRA-323'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'PRA-322'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ING-322'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ING-327'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'PRA-328'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'PRA-323'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ELI-320'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ELI-313'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'PRA-412'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'PRA-328'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ELI-421'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ELI-320'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'PRA-413'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'PRA-412'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ING-428'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ING-322'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ING-433'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'ING-322'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'PPL-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_eng_id AND codigo = 'PRA-413'), 'prerrequisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 11. LICENCIATURA EN EDUCACIÓN PRIMARIA, PRIMER CICLO
-- ----------------------------------------------------------------------------
SET @carrera_edp_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Educación Primaria, Primer Ciclo');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'EDP-304'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'FGE-102'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'EDP-201'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'FGE-203'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'PRA-208'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'FGE-102'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'EDP-303'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'EDP-201'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'PRA-209'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'PRA-208'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'PRA-214'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'PRA-209'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'EDP-305'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'EDP-303'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'EDP-310'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'EDP-202'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'PRA-314'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'PRA-214'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'EDP-311'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'EDS-210'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'EDP-411'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'EDP-410'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'PRA-315'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'PRA-314'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'EDL-437'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'EDL-204'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'PPP-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_edp_id AND codigo = 'PRA-315'), 'prerrequisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 12. LICENCIATURA EN EDUCACIÓN SECUNDARIA: LENGUA ESPAÑOLA Y LITERATURA
-- ----------------------------------------------------------------------------
SET @carrera_esl_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Educación Secundaria: Lengua Española y Literatura');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-106'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-104'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-211'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-210'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'FGC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-209'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-208'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-317'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'FGE-102'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-212'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-209'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'PRA-319'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'PRA-217'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-319'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-317'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'PRA-320'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'PRA-319'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-323'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-319'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'PRA-321'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'PRA-320'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-324'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-320'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'PRA-411'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'PRA-321'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-430'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-328'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-431'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-325'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-433'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-430'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'PLE-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'PRA-411'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-436'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-433'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-435'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esl_id AND codigo = 'EDL-434'), 'prerrequisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 13. LICENCIATURA EN EDUCACIÓN SECUNDARIA: MATEMÁTICA Y FÍSICA
-- ----------------------------------------------------------------------------
SET @carrera_esm_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Educación Secundaria: Matemática y Física');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-102'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-101'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-205'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-104'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-207'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-205'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-208'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-207'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'PRA-216'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'PRA-215'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-210'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-209'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'FGE-206'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'FGE-209'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'PRA-317'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'PRA-216'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-316'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-313'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'FGC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-319'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-316'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-323'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-319'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'PRA-318'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'PRA-317'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-324'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-319'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-325'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-319'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-427'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-320'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'PRA-410'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'PRA-318'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'PPM-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'PRA-410'), 'prerrequisito'),
-- Correquisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-314'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-313'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-317'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-316'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-320'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-319'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-431'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_esm_id AND codigo = 'ESM-430'), 'correquisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 14. LICENCIATURA EN ENFERMERÍA
-- ----------------------------------------------------------------------------
SET @carrera_enf_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Enfermería');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBN-119'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBM-107'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'LAF-119'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBN-119'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBN-114'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBN-118'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBN-120'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBN-117'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBN-218'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBN-117'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBN-219'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBN-120'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-202'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBN-114'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-222'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-101'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-213'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBN-219'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-226'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-222'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-231'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-222'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-206'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-213'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-230'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-226'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-333'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-231'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'FGL-410'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'FGL-407'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-332'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-230'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'FGN-310'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBM-107'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-334'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-230'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-319'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-309'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-230'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-210'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'FGN-310'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-336'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-334'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-310'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-333'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-338'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-336'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-440'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-333'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-335'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-333'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-443'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-336'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-442'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-338'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-430'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-429'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-430'), 'prerrequisito'),
-- Correquisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'LBI-117'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBN-117'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'LQU-118'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBN-118'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'LAA-120'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBN-120'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'LMI-218'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBN-218'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'LFI-219'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'CBN-219'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'LPB-222'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-222'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'LAP-212'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-212'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'LSC-213'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-213'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'PEN-226'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-226'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'PEN-230'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-230'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'PES-332'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-332'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'PEQ-334'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-334'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'PEG-309'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-309'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'PEG-336'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-336'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'PEP-338'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-338'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'PAS-443'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-443'), 'correquisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'PCP-442'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_enf_id AND codigo = 'ENF-442'), 'correquisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 15. LICENCIATURA EN INFORMÁTICA GERENCIAL
-- ----------------------------------------------------------------------------
SET @carrera_inf_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Informática Gerencial');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'FGI-103'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'CBM-107'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'CBE-110'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'CBE-109'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'FGI-104'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'FGI-103'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'FGI-105'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'FGI-104'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'ING-213'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'ING-103'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'FGC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'INF-408'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'FGM-207'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'ISW-306'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'FGI-208'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'INF-307'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'INF-304'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'MER-105'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'INF-204'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'CID-101'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'ISW-309'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'MER-415'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'MER-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'CID-409'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'CID-101'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'INF-409'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'INF-308'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'INF-306'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'INF-409'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'PIN-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'INF-306'), 'prerrequisito'),
-- Correquisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'LAS-313'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_inf_id AND codigo = 'ISW-420'), 'correquisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 16. LICENCIATURA EN LENGUAS MODERNAS, MENCIÓN TURISMO
-- ----------------------------------------------------------------------------
SET @carrera_llm_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Lenguas Modernas, Mención Turismo');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-102'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-101'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-203'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-102'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-203'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-206'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-204'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-202'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-201'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FGC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-207'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-203'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-202'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-311'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-207'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-304'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-203'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'TUR-311'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FGT-302'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-314'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-311'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-305'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-304'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-306'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-305'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-327'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-314'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FGL-401'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-327'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'TUR-421'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'TUR-204'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-307'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-306'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-428'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'ING-327'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-408'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-307'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'LIT-403'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'LIT-402'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-308'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-408'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'PLM-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'TUR-421'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FGL-405'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-308'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-410'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'FRA-308'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'LIT-404'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_llm_id AND codigo = 'LIT-402'), 'prerrequisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 17. LICENCIATURA EN MERCADEO
-- ----------------------------------------------------------------------------
SET @carrera_mer_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Mercadeo');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'MER-104'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'MER-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'FGN-207'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'CBM-107'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'FGC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'COE-102'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'COE-101'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'FGN-208'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'FGN-207'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'MER-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'FGC-204'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'MER-205'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'MER-204'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'FGN-203'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'CBM-107'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'MER-307'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'MER-205'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'MER-316'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'MER-205'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'PPM-300'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'MER-316'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'MER-426'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'MER-209'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'FGN-311'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_mer_id AND codigo = 'MER-210'), 'prerrequisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 18. LICENCIATURA EN PERIODISMO DIGITAL
-- ----------------------------------------------------------------------------
SET @carrera_pdi_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Periodismo Digital');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'CBE-105'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'CBE-103'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'FGM-101'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'CBM-106'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-101'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'CBE-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'INF-410'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'CBC-104'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-102'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-101'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-103'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-205'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'FGC-102'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'FGC-206'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'FGC-205'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'FGI-412'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'INF-410'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-206'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-103'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-207'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-205'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-208'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-209'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-310'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-208'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-311'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-209'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-312'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-207'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-313'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-312'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-314'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-311'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-315'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-209'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-316'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-315'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-317'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-311'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-318'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-314'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-319'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-318'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-320'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-313'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'INF-411'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'FGI-412'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-421'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-316'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-422'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-317'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-423'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-317'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-424'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-422'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-425'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-314'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-426'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-319'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'PDI-427'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pdi_id AND codigo = 'FGD-417'), 'prerrequisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 19. LICENCIATURA EN PSICOLOGÍA
-- ----------------------------------------------------------------------------
SET @carrera_psg_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Psicología');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSG-205'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSG-103'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'FGC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSE-202'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSE-201'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSG-208'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSG-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSG-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSG-209'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSG-205'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSI-201'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSG-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSG-312'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSG-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSG-318'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSG-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSI-311'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSG-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSI-308'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSI-311'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSC-304'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSC-202'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSO-401'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSI-308'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PPG-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSO-401'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSE-413'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSE-201'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSG-315'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psg_id AND codigo = 'PSG-206'), 'prerrequisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 20. LICENCIATURA EN PSICOLOGÍA CLÍNICA
-- ----------------------------------------------------------------------------
SET @carrera_psc_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Psicología Clínica');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-205'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-103'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'FGC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSE-202'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSE-201'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-208'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-209'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-205'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-314'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-418'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-205'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSC-304'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSC-202'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-312'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSC-410'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSC-204'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-315'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-318'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSC-411'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSC-410'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSE-410'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-314'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-417'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-314'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSC-307'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-314'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSC-408'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-314'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'FGP-210'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-209'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSC-409'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSC-304'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PPC-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSC-411'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-420'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSC-202'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSC-306'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-314'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSC-412'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psc_id AND codigo = 'PSG-418'), 'prerrequisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 21. LICENCIATURA EN PSICOLOGÍA EDUCATIVA
-- ----------------------------------------------------------------------------
SET @carrera_pse_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Psicología Educativa');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'FGC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSE-202'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSE-201'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSG-205'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSG-103'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSG-312'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSG-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSG-209'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSG-205'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSE-410'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSG-314'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSE-414'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'FGP-210'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSE-306'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSC-202'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSG-417'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSG-314'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSE-415'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSE-414'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSE-309'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSE-306'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSG-208'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSG-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSE-308'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSG-312'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSE-413'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSE-201'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSG-318'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSG-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PPE-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSE-415'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSE-402'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSE-415'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSE-412'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_pse_id AND codigo = 'PSG-208'), 'prerrequisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);


-- ----------------------------------------------------------------------------
-- 22. LICENCIATURA EN PSICOLOGÍA INDUSTRIAL
-- ----------------------------------------------------------------------------
SET @carrera_psi_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Licenciatura en Psicología Industrial');

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo) VALUES
-- Prerrequisitos
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSG-205'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSG-103'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSI-201'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSG-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'FGC-204'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'FGC-105'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSG-208'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSG-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSG-209'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSG-205'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSI-311'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSG-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSG-306'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSG-206'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSO-304'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSO-301'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSI-308'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSI-311'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSO-306'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSO-304'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSI-306'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSO-306'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSO-401'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSI-308'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSI-414'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSO-302'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PPO-400'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSO-401'), 'prerrequisito'),
((SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSI-415'), (SELECT id FROM asignaturas WHERE carrera_id = @carrera_psi_id AND codigo = 'PSO-402'), 'prerrequisito')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);

INSERT INTO asignatura_relaciones (asignatura_id, relacionada_id, tipo)
SELECT relacionada_id, asignatura_id, 'correquisito'
FROM (
  SELECT asignatura_id, relacionada_id
  FROM asignatura_relaciones
  WHERE tipo = 'correquisito'
) t
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);