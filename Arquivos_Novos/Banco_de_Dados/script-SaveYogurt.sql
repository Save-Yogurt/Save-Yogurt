CREATE DATABASE SaveYogurt;
USE SaveYogurt;

CREATE TABLE empresa(
    id_empresa INT PRIMARY KEY AUTO_INCREMENT,
    cnpj CHAR(14) NOT NULL UNIQUE,
    razao_social VARCHAR(200) NOT NULL,
    dt_criacao DATE NOT NULL,
    token CHAR(16) NOT NULL UNIQUE
);

-- 1 = Dono | 0 = Funcionário
CREATE TABLE usuario(
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(200) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(200) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    dt_criacao DATE NOT NULL,
    cargo VARCHAR(45) NOT NULL,
    flag_identificador_responsavel TINYINT NOT NULL,
    fk_empresa INT NOT NULL,
    CONSTRAINT ch_cargo
        CHECK (cargo IN ('Estagiário','Junior','Pleno','Sênior','Gestor','Diretor')),
    CONSTRAINT ch_flag_responsavel
        CHECK (flag_identificador_responsavel IN (0,1)),
    CONSTRAINT fk_usuario_empresa
        FOREIGN KEY (fk_empresa)
        REFERENCES empresa(id_empresa)
);

CREATE TABLE sensor(
    id_sensor INT PRIMARY KEY AUTO_INCREMENT,
    codigo_sensor VARCHAR(45) NOT NULL UNIQUE,
    modelo VARCHAR(50) NOT NULL,
    status_sensor VARCHAR(30) NOT NULL,
    dt_instalacao DATE NOT NULL,
    dt_ultima_manutencao DATE,
    fk_empresa INT NOT NULL,
    CONSTRAINT ch_status_sensor
        CHECK(status_sensor IN ('Ativo','Manutenção','Inativo')),
    CONSTRAINT fk_sensor_empresa
        FOREIGN KEY (fk_empresa)
        REFERENCES empresa(id_empresa)
);

CREATE TABLE lote(
    id_lote INT PRIMARY KEY AUTO_INCREMENT,
    dt_fabricacao DATE NOT NULL,
    dt_validade DATE NOT NULL,
    qtd_caixas INT NOT NULL,
    codigo_identificador VARCHAR(45) NOT NULL UNIQUE,
    fk_empresa INT,
    CONSTRAINT cfk_empresa
		FOREIGN KEY (fk_empresa)
        REFERENCES empresa(id_empresa)
);

CREATE TABLE caixa(
    id_caixa INT PRIMARY KEY AUTO_INCREMENT,
    codigo_caixa VARCHAR(45) NOT NULL UNIQUE,
    status_caixa VARCHAR(45) NOT NULL,
    dt_cadastro DATETIME NOT NULL,
    temp_min DECIMAL(5,2) NOT NULL, 
    temp_max DECIMAL(5,2) NOT NULL,
    fk_sensor INT NOT NULL,
    fk_lote INT NOT NULL,
    CONSTRAINT ch_status_caixa
        CHECK(status_caixa IN ('Armazenada','Transporte','Entregue','Descartada')),
    CONSTRAINT fk_caixa_sensor
        FOREIGN KEY (fk_sensor)
        REFERENCES sensor(id_sensor),
    CONSTRAINT fk_caixa_lote
        FOREIGN KEY (fk_lote)
        REFERENCES lote(id_lote)
);

-- 1 = acima ou abaixo da temperatura ideal | 0 = dentro da temperatura ideal
CREATE TABLE registro(
    id_registro INT AUTO_INCREMENT,
    dt_registro DATETIME DEFAULT NOW() NOT NULL,
    temperatura DECIMAL(5,2) NOT NULL,
    fk_sensor INT NOT NULL,
    PRIMARY KEY (id_registro, fk_sensor),
    CONSTRAINT fk_registro_sensor
        FOREIGN KEY (fk_sensor)
        REFERENCES sensor(id_sensor)
);

INSERT INTO empresa 
(cnpj, razao_social, dt_criacao, token) 
VALUES
('11111111000101', 'Danone', '2026-04-10', 'DANONE2026041001'),
('22222222000102', 'YoPRO', '2026-04-10', 'YOPRO20260410002'),
('33333333000103', 'Danette', '2026-04-10', 'DANETTE202604003');

INSERT INTO usuario 
(nome, cpf, email, senha, dt_criacao, cargo, flag_identificador_responsavel, fk_empresa) 
VALUES
('Ana Souza', '12345678901', 'ana@danone.com', 'senha123', '2026-04-10', 'Diretor', 1, 1),
('Tomas Homan', '12345678902', 'tomas@danone.com', 'senha123', '2026-04-10', 'Pleno', 0, 1),
('Beatriz Rocha', '12345678903', 'beatriz@yopro.com', 'senha123', '2026-04-10', 'Gestor', 1, 2),
('Alvaro lima', '12345678904', 'alvaro@yopro.com', 'senha123', '2026-04-10', 'Junior', 0, 2),
('Mariana Galo', '12345678905', 'mariana@danette.com', 'senha123', '2026-04-10', 'Diretor', 1, 3),
('João Pedro', '12345678906', 'joao@danette.com', 'senha123', '2026-04-10', 'Estagiário', 0, 3);

INSERT INTO sensor
(codigo_sensor, modelo, status_sensor, dt_instalacao, dt_ultima_manutencao, fk_empresa)
VALUES
('SEN001', 'InfraRed X1', 'Ativo', '2026-04-10', '2026-04-15', 1),
('SEN002', 'InfraRed X2', 'Ativo', '2026-04-10', '2026-04-16', 1),
('SEN003', 'ThermoSafe A1', 'Ativo', '2026-04-10', '2026-04-15', 2),
('SEN004', 'ThermoSafe A2', 'Manutenção', '2026-04-10', '2026-04-18', 2),
('SEN005', 'CoolTrack Z1', 'Ativo', '2026-04-10', '2026-04-17', 3),
('SEN006', 'CoolTrack Z2', 'Inativo', '2026-04-10', '2026-04-19', 3);

INSERT INTO lote
(dt_fabricacao, dt_validade, qtd_caixas, codigo_identificador,fk_empresa)
VALUES
('2026-04-01', '2026-05-01', 120, 'LOTEDAN001',1),
('2026-04-05', '2026-05-05', 90, 'LOTEDAN002',1),
('2026-04-02', '2026-05-02', 150, 'LOTEYOP001',2),
('2026-04-06', '2026-05-06', 110, 'LOTEYOP002',2),
('2026-04-03', '2026-05-03', 130, 'LOTEDTT001',3),
('2026-04-07', '2026-05-07', 100, 'LOTEDTT002',3);

INSERT INTO caixa
(codigo_caixa, status_caixa, dt_cadastro, temp_min, temp_max, fk_sensor, fk_lote)
VALUES
('CX001', 'Armazenada', '2026-04-10 08:00:00', 2.00, 5.00, 1, 1),
('CX002', 'Transporte', '2026-04-10 09:00:00', 2.00, 5.00, 2, 2),
('CX003', 'Armazenada', '2026-04-10 08:30:00', 2.00, 5.00, 3, 3),
('CX004', 'Entregue', '2026-04-10 10:00:00', 2.00, 5.00, 4, 4),
('CX005', 'Armazenada', '2026-04-10 08:45:00', 2.00, 5.00, 5, 5),
('CX006', 'Descartada', '2026-04-10 11:00:00', 2.00, 5.00, 6, 6);

INSERT INTO registro
(dt_registro, temperatura, fk_sensor)
VALUES
('2026-04-10 08:10:00', 4.20, 1),
('2026-04-10 09:10:00', 5.60, 1),
('2026-04-10 10:10:00', 3.80, 2),
('2026-04-10 08:40:00', 2.50, 3),
('2026-04-10 09:40:00', 1.80, 3),
('2026-04-10 10:40:00', 4.70, 4),
('2026-04-10 08:50:00', 3.90, 5),
('2026-04-10 09:50:00', 5.30, 5),
('2026-04-10 10:50:00', 2.20, 6);

SELECT * FROM empresa;
SELECT * FROM usuario;
SELECT * FROM sensor;
SELECT * FROM lote;
SELECT * FROM caixa;
SELECT * FROM registro;
   
   
   -- select relacionando todas as tabelas
SELECT *
	FROM 
		empresa e
JOIN usuario AS u
	ON u.fk_empresa = e.id_empresa
JOIN sensor AS s
	ON s.fk_empresa = e.id_empresa
JOIN caixa AS c
	ON c.fk_sensor = s.id_sensor
JOIN lote AS l
	ON c.fk_lote = l.id_lote
JOIN registro AS r
	ON r.fk_sensor = s.id_sensor;
    
-- Histórico de temperatura por caixa
SELECT
    e.razao_social AS empresa,
    l.codigo_identificador AS lote,
    c.codigo_caixa,
    s.codigo_sensor,
    r.dt_registro,
    r.temperatura,
    CASE
        WHEN r.temperatura >=2 AND r.temperatura <= 5 THEN 'Ideal'
        WHEN r.temperatura <2 AND r.temperatura >=0 OR
        r.temperatura >5 AND r.temperatura <=10 THEN 'Alerta'
        WHEN r.temperatura >10 OR r.temperatura <0 THEN 'Critico'
	END AS 'Situação'
    FROM  registro r
JOIN sensor s
    ON r.fk_sensor = s.id_sensor
JOIN caixa c
    ON c.fk_sensor = s.id_sensor
JOIN lote l
    ON c.fk_lote = l.id_lote
JOIN empresa e
    ON s.fk_empresa = e.id_empresa
ORDER BY r.dt_registro;

-- Temperatura e situação por sensor 
SELECT
    e.razao_social AS empresa,
    l.codigo_identificador AS lote,
    c.codigo_caixa,
    s.codigo_sensor,
    r.dt_registro,
    r.temperatura,
    CASE
        WHEN r.temperatura >=2 AND r.temperatura <= 5 THEN 'ideal'
        WHEN r.temperatura <2 AND r.temperatura >=0 OR
        r.temperatura >5 AND r.temperatura <=10 THEN 'Alerta'
        WHEN r.temperatura >10 OR r.temperatura <0 THEN 'Critico'
	END AS 'Situação',
    CASE 
		WHEN r.temperatura >=2 AND r.temperatura <= 5 THEN 'Dentro do ideal'
        WHEN r.temperatura < 2 THEN 'Abaixo do ideal'
        WHEN r.temperatura > 5 THEN 'Acima do ideal'
	END AS 'Parâmetro'
    FROM  registro r
JOIN sensor s
    ON r.fk_sensor = s.id_sensor
JOIN caixa c
    ON c.fk_sensor = s.id_sensor
JOIN lote l
    ON c.fk_lote = l.id_lote
JOIN empresa e
    ON s.fk_empresa = e.id_empresa
ORDER BY r.dt_registro;


-- Sensores e seus Status
SELECT
    e.razao_social AS empresa,
    s.codigo_sensor,
    s.modelo,
    s.status_sensor,
    s.dt_instalacao,
    s.dt_ultima_manutencao
FROM sensor s
JOIN empresa e
    ON s.fk_empresa = e.id_empresa
ORDER BY e.razao_social, s.codigo_sensor;


-- Usuários por empresa
SELECT
    e.razao_social AS Empresa,
    u.nome AS Usuario,
    u.email AS Email,
    u.cargo AS Cargo,
    CASE
        WHEN u.flag_identificador_responsavel = 1 THEN 'Responsável'
        ELSE 'Funcionário'
    END AS Tipo_Usuario
FROM usuario u
JOIN empresa e
    ON u.fk_empresa = e.id_empresa
ORDER BY e.razao_social, u.nome;


-- Caixas em transporte
SELECT
    e.razao_social AS Empresa,
    l.codigo_identificador AS Lote,
    c.codigo_caixa AS Caixa,
    c.status_caixa AS Status_Caixa,
    c.dt_cadastro AS Data_Cadastro,
    s.codigo_sensor AS Sensor
FROM caixa c
JOIN lote l
    ON c.fk_lote = l.id_lote
JOIN sensor s
    ON c.fk_sensor = s.id_sensor
JOIN empresa e
    ON s.fk_empresa = e.id_empresa
WHERE c.status_caixa = 'Transporte'
ORDER BY c.dt_cadastro DESC;


-- Sensores em manutenção
SELECT
    e.razao_social AS Empresa,
    s.codigo_sensor AS Sensor,
    s.modelo AS Modelo,
    s.status_sensor AS Status,
    s.dt_ultima_manutencao AS Ultima_Manutencao
FROM sensor s
JOIN empresa e
    ON s.fk_empresa = e.id_empresa
WHERE s.status_sensor = 'Manutenção'
ORDER BY e.razao_social, s.codigo_sensor;