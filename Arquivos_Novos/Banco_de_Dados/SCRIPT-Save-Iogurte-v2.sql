CREATE DATABASE saveYogurt;
USE saveYogurt;

CREATE TABLE Empresa (
	id_empresa INT PRIMARY KEY AUTO_INCREMENT,
	razao_social VARCHAR(150) NOT NULL,
    responsavel VARCHAR(100),
    cnpj VARCHAR(18) UNIQUE NOT NULL
);

CREATE TABLE Usuario (
	id_usuario INT PRIMARY KEY AUTO_INCREMENT,
	email VARCHAR(100) UNIQUE NOT NULL,
	senha VARCHAR(255) NOT NULL,
    tipo_acesso VARCHAR(20),
    cpf CHAR(11) UNIQUE,
    fkEmpresa INT,
	CONSTRAINT ctFkEmpresa1
	FOREIGN KEY (fkEmpresa)
	REFERENCES Empresa(id_empresa),
	CONSTRAINT c_tipo
    CHECK (tipo_acesso IN ('administrador', 'cliente', 'visitante'))
);

CREATE TABLE Sensor (
    id_sensor INT PRIMARY KEY AUTO_INCREMENT,
    numero_serie VARCHAR(50) UNIQUE NOT NULL,
    modelo VARCHAR(50),
    atividade VARCHAR(10),
    CONSTRAINT c_atividade
    CHECK (atividade IN ('ativo', 'inativo')),
    fkEmpresa INT,
	CONSTRAINT ctFkEmpresa2
	FOREIGN KEY (fkEmpresa)
	REFERENCES Empresa(id_empresa)
);

CREATE TABLE MedTemperatura (
	id_medTemp INT PRIMARY KEY AUTO_INCREMENT,
	temperatura DECIMAL(5,2) NOT NULL,
	data_medicao DATETIME DEFAULT CURRENT_TIMESTAMP,
    fkSensor INT,
	CONSTRAINT ctFkSensor1
	FOREIGN KEY (fkSensor)
	REFERENCES Sensor(id_sensor)
);

CREATE TABLE Lote (
	id_lote INT PRIMARY KEY AUTO_INCREMENT,
    data_saida DATETIME,
    data_chegada DATETIME,
    localizacao VARCHAR(150),
    descricao VARCHAR(200),
    fkSensor INT,
    CONSTRAINT ctFkSensorLote
    FOREIGN KEY (fkSensor)
    REFERENCES Sensor(id_sensor)
);

-- Mostrar para professora
-- index
CREATE INDEX idx_sensor_data 
ON MedTemperatura (fkSensor, data_medicao);


-- TABELA RESUMO
CREATE TABLE MedTemperaturaResumo (
	id INT PRIMARY KEY AUTO_INCREMENT,
    fkSensor INT,
    media_temp DECIMAL(5,2),
    data_hora DATETIME
);


-- INSERTS

INSERT INTO Empresa (razao_social, responsavel, cnpj) VALUES
('Laticinios Boa Vida', 'Carlos Silva', '12345678000101'),
('Transporte Gelado LTDA', 'Ana Souza', '12345678000102'),
('Yogurt Express', 'João Lima', '12345678000103'),
('Frios do Sul', 'Marcos Pereira', '12345678000104'),
('Leite Puro SA', 'Fernanda Alves', '12345678000105'),
('Logistica Fria', 'Ricardo Mendes', '12345678000106'),
('Distribuidora Lactea', 'Juliana Costa', '12345678000107');

INSERT INTO Usuario (email, senha, tipo_acesso, cpf, fkEmpresa) VALUES
('admin1@email.com', '123456', 'administrador', '11111111111', 1),
('cliente1@email.com', '123456', 'cliente', '22222222222', 2),
('visitante1@email.com', '123456', 'visitante', '33333333333', 3),
('admin2@email.com', '123456', 'administrador', '44444444444', 4),
('cliente2@email.com', '123456', 'cliente', '55555555555', 5),
('visitante2@email.com', '123456', 'visitante', '66666666666', 6),
('cliente3@email.com', '123456', 'cliente', '77777777777', 7);

INSERT INTO Sensor (numero_serie, modelo, atividade, fkEmpresa) VALUES
('SN001', 'T1000', 'ativo', 1),
('SN002', 'T2000', 'ativo', 2),
('SN003', 'T3000', 'inativo', 3),
('SN004', 'T4000', 'ativo', 4),
('SN005', 'T5000', 'ativo', 5),
('SN006', 'T6000', 'inativo', 6),
('SN007', 'T7000', 'ativo', 7);

INSERT INTO MedTemperatura (temperatura, data_medicao, fkSensor) VALUES
(2.5, '2026-03-20 10:00:00', 1),
(2.7, '2026-03-20 10:05:00', 1),
(2.6, '2026-03-20 10:10:00', 1),
(4.0, '2026-03-20 10:00:00', 2),
(4.2, '2026-03-20 10:05:00', 2),
(3.9, '2026-03-20 10:10:00', 2),
(6.5, '2026-03-20 10:00:00', 3),
(3.2, '2026-03-20 10:00:00', 4),
(1.8, '2026-03-20 10:00:00', 5),
(5.5, '2026-03-20 10:00:00', 6),
(2.9, '2026-03-20 10:00:00', 7);

INSERT INTO Lote (data_saida, data_chegada, localizacao, descricao, fkSensor) VALUES
('2026-03-20 08:00:00', '2026-03-20 12:00:00', 'São Paulo', 'Entregue', 1),
('2026-03-20 09:00:00', '2026-03-20 13:00:00', 'Campinas', 'Em transporte', 2),
('2026-03-20 10:00:00', '2026-03-20 14:00:00', 'Santos', 'Entregue', 3),
('2026-03-20 11:00:00', '2026-03-20 15:00:00', 'Sorocaba', 'Atrasado', 4),
('2026-03-20 12:00:00', '2026-03-20 16:00:00', 'Ribeirão Preto', 'Entregue', 5),
('2026-03-20 13:00:00', '2026-03-20 17:00:00', 'São José dos Campos', 'Em transporte', 6),
('2026-03-20 14:00:00', '2026-03-20 18:00:00', 'Osasco', 'Entregue', 7);


-- SELECT

SELECT * FROM Usuario;
SELECT * FROM Empresa;
SELECT * FROM Sensor;
SELECT * FROM MedTemperatura;

-- sensores por empresa
SELECT 
	e.razao_social,
    s.numero_serie,
    s.modelo,
    s.atividade
FROM Sensor s
JOIN Empresa e ON s.fkEmpresa = e.id_empresa;

-- lote e última temperatura (sem repetir dados)
-- (MAX -> pega o maior valor de uma coluna)
-- vai mostrar o dado mais recente
SELECT 
	l.id_lote,
    l.localizacao,
    s.numero_serie,
    m.temperatura,
    m.data_medicao
FROM Lote l
JOIN Sensor s ON l.fkSensor = s.id_sensor
JOIN MedTemperatura m ON m.fkSensor = s.id_sensor
WHERE m.data_medicao = (
	SELECT MAX(m2.data_medicao)
    FROM MedTemperatura m2
    WHERE m2.fkSensor = s.id_sensor
);

-- classificação de temperatura
SELECT 
	s.numero_serie,
    m.temperatura,
    m.data_medicao,
CASE 
	WHEN m.temperatura < 2 THEN 'Muito frio'
	WHEN m.temperatura BETWEEN 2 AND 6 THEN 'Ideal'
	ELSE 'Acima do ideal'
END AS status_temperatura
FROM MedTemperatura m
JOIN Sensor s ON m.fkSensor = s.id_sensor
ORDER BY m.data_medicao DESC;


-- Ver quais lotes tiveram problema de temperatura
SELECT 
	l.id_lote,
    l.localizacao,
    s.numero_serie,
    m.temperatura,
    m.data_medicao,
CASE 
	WHEN m.temperatura < 2 THEN 'Muito frio'
	WHEN m.temperatura > 6 THEN 'Acima do ideal'
END AS problema
FROM Lote l
JOIN Sensor s ON l.fkSensor = s.id_sensor
JOIN MedTemperatura m ON m.fkSensor = s.id_sensor
WHERE m.temperatura < 2 OR m.temperatura > 6
ORDER BY m.data_medicao DESC;
