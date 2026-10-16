SET NAMES utf8mb4;
USE gaud;

INSERT INTO universidades (nombre)
VALUES ('Universidad Abierta Para Adultos')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);

SET @uni_id = (SELECT id FROM universidades WHERE nombre = 'Universidad Abierta Para Adultos');

INSERT INTO carreras (universidad_id, nombre, periodo)
VALUES (@uni_id, 'Ingeniería en Software', 'trimestres')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), periodo = VALUES(periodo);

SET @carrera_isw_id = (SELECT id FROM carreras WHERE universidad_id = @uni_id AND nombre = 'Ingeniería en Software');

INSERT INTO asignaturas (carrera_id, codigo, nombre, creditos, trimestre)
VALUES
(@carrera_isw_id, 'CBC-103', 'Orientación a la Educación a Distancia Virtual', 3, 1),
(@carrera_isw_id, 'CBC-105', 'Tecnología para el Aprendizaje Virtual', 3, 1),
(@carrera_isw_id, 'CBE-109', 'Comunicación Oral y Escrita', 4, 1),
(@carrera_isw_id, 'CBM-107', 'Razonamiento Lógico Matemático', 4, 1),
(@carrera_isw_id, 'FGI-103', 'Lógica Computacional', 4, 2),
(@carrera_isw_id, 'CBC-107', 'Ser Humano y Desarrollo Sostenible', 3, 2),
(@carrera_isw_id, 'FGI-102', 'Álgebra y Geometría para Ingenieros', 4, 2),
(@carrera_isw_id, 'ING-103', 'Inglés Comunicativo', 3, 2),
(@carrera_isw_id, 'CBE-110', 'Análisis y Producción de Textos', 4, 3),
(@carrera_isw_id, 'FGI-104', 'Programación I', 4, 3),
(@carrera_isw_id, 'FGM-102', 'Análisis Matemático I', 5, 3),
(@carrera_isw_id, 'FGM-205', 'Matemática Discreta', 3, 3),
(@carrera_isw_id, 'FGC-105', 'Metodología de la Investigación Científica', 4, 4),
(@carrera_isw_id, 'FGI-106', 'Sistema de Base de Datos', 4, 4),
(@carrera_isw_id, 'FGI-105', 'Programación II', 4, 4),
(@carrera_isw_id, 'FGM-103', 'Análisis Matemático II', 5, 4),
(@carrera_isw_id, 'FGC-203', 'Filosofía y Sociedad', 3, 5),
(@carrera_isw_id, 'ISW-305', 'Estructura de Datos y Algoritmos', 4, 5),
(@carrera_isw_id, 'ING-213', 'Inglés Técnico para Ingenieros', 3, 5),
(@carrera_isw_id, 'FGC-204', 'Investigación Aplicada', 4, 5),
(@carrera_isw_id, 'FGF-201', 'Física General', 4, 6),
(@carrera_isw_id, 'LAF-201', 'Práctica de Física General', 1, 6),
(@carrera_isw_id, 'ISW-204', 'Diseño de Interfaz de Usuario', 4, 6),
(@carrera_isw_id, 'ISW-201', 'Ingeniería de Software I', 4, 6),
(@carrera_isw_id, 'FGC-106', 'Historia Social Dominicana', 3, 7),
(@carrera_isw_id, 'ISW-202', 'Ingeniería de Software II', 4, 7),
(@carrera_isw_id, 'ISW-306', 'Desarrollo de Aplicaciones Web', 4, 7),
(@carrera_isw_id, 'OP1', 'Optativa 1', 3, 7),
(@carrera_isw_id, 'FGM-206', 'Álgebra Lineal', 4, 8),
(@carrera_isw_id, 'FGI-209', 'Electrónica Básica', 4, 8),
(@carrera_isw_id, 'ISW-203', 'Calidad de Software', 4, 8),
(@carrera_isw_id, 'OP2', 'Optativa 2', 3, 8),
(@carrera_isw_id, 'FGC-208', 'Educación Constitucional', 3, 9),
(@carrera_isw_id, 'FGM-314', 'Matemática Numérica', 4, 9),
(@carrera_isw_id, 'FGI-210', 'Arquitectura de Hardware', 4, 9),
(@carrera_isw_id, 'FGM-207', 'Estadística y Probabilidades', 4, 9),
(@carrera_isw_id, 'FGC-409', 'Ética Profesional', 3, 10),
(@carrera_isw_id, 'INF-304', 'Informática Gerencial', 4, 10),
(@carrera_isw_id, 'ISW-412', 'Minería de Datos', 4, 10),
(@carrera_isw_id, 'OP3', 'Optativa 3', 3, 10),
(@carrera_isw_id, 'FGI-312', 'Redes y Servicios Telemáticos', 4, 11),
(@carrera_isw_id, 'LAT-312', 'Labo. Redes y Servicios Telemáticos', 1, 11),
(@carrera_isw_id, 'ISW-309', 'Inteligencia Artificial', 4, 11),
(@carrera_isw_id, 'INF-305', 'Sistemas Distribuidos', 4, 11),
(@carrera_isw_id, 'COE-101', 'Contabilidad I', 4, 12),
(@carrera_isw_id, 'CID-115', 'Procesamiento del Lenguaje Natural', 4, 12),
(@carrera_isw_id, 'ISW-420', 'Ciberseguridad', 4, 12),
(@carrera_isw_id, 'LAS-313', 'Labo. de Ciberseguridad', 1, 12),
(@carrera_isw_id, 'INF-408', 'Investigación de Operaciones', 4, 13),
(@carrera_isw_id, 'ISW-425', 'Programación Multiplataforma Móvil', 4, 13),
(@carrera_isw_id, 'LAP-414', 'Labo. Programación Multiplataforma', 1, 13),
(@carrera_isw_id, 'ISW-304', 'Desarrollo de Proyectos con Software Libre', 4, 13),
(@carrera_isw_id, 'ISW-414', 'Fundamentos de Inteligencia de Negocios', 4, 14),
(@carrera_isw_id, 'ISW-413', 'Simulación Digital', 4, 14),
(@carrera_isw_id, 'ISW-415', 'Ingeniería Robótica para Software Virtuales I', 4, 14),
(@carrera_isw_id, 'LAR-415', 'Labo. Robótica para Software Virtuales I', 1, 14),
(@carrera_isw_id, 'PPS-400', 'Práctica Profesional (Pasantía)', 8, 14),
(@carrera_isw_id, 'INF-307', 'Gestión del Conocimiento y Toma de Decisiones', 4, 15),
(@carrera_isw_id, 'ISW-416', 'Ingeniería Robótica para Software Virtuales II', 4, 15),
(@carrera_isw_id, 'LAR-416', 'Labo. Robótica para Software Virtuales II', 1, 15),
(@carrera_isw_id, 'ISW-417', 'Seminario de Proyectos de Software', 4, 15),
(@carrera_isw_id, 'ISW-400', 'Curso Final de Grado', 6, 16)
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), creditos = VALUES(creditos), trimestre = VALUES(trimestre);

INSERT INTO usuarios (nombre, email, password_hash, telefono, direccion, universidad_id, carrera_id, modalidad, terminos_aceptado_en)
VALUES ('Estudiante Demo', 'estudiante@gaud.dev', '$2y$10$mfODqfAvynGk58DAFBWOgO5Idexrq2XGlp7BBX6EOqhnTo8hQULLu', '809-555-1234', 'Santo Domingo, RD', @uni_id, @carrera_isw_id, 'virtual', NOW())
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), password_hash = VALUES(password_hash), telefono = VALUES(telefono), direccion = VALUES(direccion), universidad_id = VALUES(universidad_id), carrera_id = VALUES(carrera_id), modalidad = VALUES(modalidad);

SET @usuario_id = (SELECT id FROM usuarios WHERE email = 'estudiante@gaud.dev');

INSERT INTO inscripciones (usuario_id, asignatura_id, estado, calificacion)
VALUES
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'CBC-103'), 'aprobada', 'A'),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'CBC-105'), 'aprobada', 'B'),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'CBE-109'), 'aprobada', 'A'),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'CBM-107'), 'aprobada', 'B'),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGI-103'), 'aprobada', 'A'),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'CBC-107'), 'aprobada', 'C'),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGI-102'), 'aprobada', 'A'),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'ING-103'), 'aprobada', 'B'),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'CBE-110'), 'en-curso', NULL),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGI-104'), 'en-curso', NULL),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGM-102'), 'en-curso', NULL),
(@usuario_id, (SELECT id FROM asignaturas WHERE carrera_id = @carrera_isw_id AND codigo = 'FGM-205'), 'en-curso', NULL)
ON DUPLICATE KEY UPDATE estado = VALUES(estado), calificacion = VALUES(calificacion);
