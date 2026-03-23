-- ----------------------------------------------------------------------
-- Construção do BD
-- ----------------------------------------------------------------------

-- Criação do Banco de dados
CREATE DATABASE saveYogurt;
USE saveYogurt;

-- Criação da tabela para armazenamento das medições de temperatura
CREATE TABLE medTemperatura (
	id_medTemp INT PRIMARY KEY AUTO_INCREMENT,
	temperatura DECIMAL(5,2) NOT NULL,
	dt_medicao DATETIME DEFAULT CURRENT_TIMESTAMP()
);

-- Criação da tabela para armazenamento dos usuarios/clientes
CREATE TABLE usuario (
	id_usuario INT PRIMARY KEY AUTO_INCREMENT,
	email VARCHAR(100) UNIQUE NOT NULL,
	senha VARCHAR(30) NOT NULL,
	telefone VARCHAR(20),
	empresa VARCHAR(50),
	dt_pedido DATETIME DEFAULT current_timestamp(),
	CNPJ CHAR(14) UNIQUE NOT NULL,
	representante VARCHAR(40)
);

-- Criação da tabela para armazenamento dos dados do lote/transportadora
CREATE TABLE transportadora (
	id_unidade_transportadora INT PRIMARY KEY AUTO_INCREMENT,
	empresa_responsavel VARCHAR(40) NOT NULL,
	modelo_caminhao VARCHAR(25),
	lote INT,
	local_saida VARCHAR(50) NOT NULL,
	destino VARCHAR(50) NOT NULL,
	dt_saida DATE,
	placa VARCHAR(7) NOT NULL
);

-- ----------------------------------------------------------------------
-- INSERT de dados nas tabelas
-- ----------------------------------------------------------------------

-- Inserindo na tabela usuario --
INSERT INTO usuario (email, senha, telefone, empresa, CNPJ) VALUES
('maicoantonio@gmail.com','senhaMaicom','(11)98567-2354','Iogurtantonio', '12345678000101'),
('melhoriogurte@yahoo.com','melhoriogurtedomundo','(11)90864-3123','Melhoriogurte', '98765432000102'),
('carlos.silva@hotmail.com','senhaSegura123','(11)97765-4321','CarlosSilva99', '11222333000103'),
('ana.paula@outlook.com','anaP_2026','(11)96543-8765','AnaPaulaTech', '44555666000104'),
('contato.loja@gmail.com','loja@123','(11)91234-5678','LojaOficial', '77888999000105');

-- Inserindo temperaturas --
INSERT INTO medTemperatura (temperatura, dt_medicao) VALUES
(12.5, '2026-03-01 08:30:00'),
(10.0, '2026-03-01 09:15:00'), 
(3.9,  '2026-03-02 10:45:00'), 
(5.3,  '2026-03-02 11:30:00'), 
(8.5,  '2026-03-03 13:00:00'), 
(2.4,  '2026-03-03 14:20:00'),
(7.5,  '2026-03-04 15:10:00'), 
(-1.2, '2026-03-04 16:40:00'), 
(0.5,  '2026-03-05 18:00:00'); 

-- Inserindo transportadoras --
INSERT INTO transportadora (empresa_responsavel, lote, local_saida, destino, dt_saida, placa) VALUES
('TransLogística Rápida', 1, 'São Paulo - SP', 'Rio de Janeiro - RJ', '2024-12-01', 'ABC1234'),
('Cargas de Minas', 2, 'Belo Horizonte - MG', 'Curitiba - PR', '2024-12-05', 'XYZ9876'),
('Expresso Nordeste', 3, 'Salvador - BA', 'Recife - PE', '2024-12-10', 'DEF5678'),
('Sul Transportes', 4, 'Porto Alegre - RS', 'Florianópolis - SC', '2024-12-15', 'JKL3456'),
('Centro-Oeste Cargas', 5, 'Brasília - DF', 'Goiânia - GO', '2024-12-20', 'MNO7890');

INSERT INTO usuario (email, senha, telefone, empresa, CNPJ) VALUES
("fernando@danone.com", "12345", "11999999999", "Danone", "1234567890000");

-- ----------------------------------------------------------------------
-- CONSULTA de dados
-- ----------------------------------------------------------------------

-- Exibe todos dados das tabelas --
SELECT * FROM usuario;
SELECT * FROM transportadora;
SELECT * FROM medTemperatura;

-- Filtra usuários que usam o gmail --
SELECT * FROM usuario WHERE email LIKE '%@gmail.com';

-- Exibição dos dados de contato do cliente --
SELECT 
    CONCAT(empresa, ' (CNPJ: ', CNPJ, ')') AS dados_empresa, 
    email, 
    CONCAT('Tel: ', telefone) AS contato 
FROM usuario;

-- Relatório de logística com padrão de data brasileiro --
SELECT 
    empresa_responsavel, 
    CONCAT(local_saida, ' ➔ ', destino) AS rota_viagem, 
    DATE_FORMAT(dt_saida, '%d/%m/%Y') AS data_partida, 
    placa 
FROM transportadora;

-- Relatório de temperaturas --
SELECT 
	id_medTemp AS id_medicao,
    temperatura,
    DATE_FORMAT(dt_medicao, '%d/%m/%Y %H:%i') AS data_hora,
    
-- Coluna de categoria (Classificada por cor)
CASE 
	WHEN temperatura < 2.0 THEN 'Alerta azul'
	WHEN temperatura >= 2.0 AND temperatura <= 6.0 THEN 'Temperatura ideal'
	WHEN temperatura > 6.0 AND temperatura < 10.0 THEN 'Alerta amarelo'
	WHEN temperatura >= 10.0 THEN 'Alerta vermelho'
END AS categoria_alerta,

-- Coluna do estado (Descrição da classificação)
CASE 
	WHEN temperatura < 2.0 THEN 'Estado crítico'
	WHEN temperatura >= 2.0 AND temperatura <= 6.0 THEN 'Temperatura ideal'
	WHEN temperatura > 6.0 AND temperatura < 10.0 THEN 'Estado intermediário'
	WHEN temperatura >= 10.0 THEN 'Estado crítico'
END AS estado_carga
   
FROM medTemperatura
ORDER BY dt_medicao DESC;