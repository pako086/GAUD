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