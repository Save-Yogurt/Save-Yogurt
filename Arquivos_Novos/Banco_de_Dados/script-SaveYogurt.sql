CREATE DATABASE SaveYogurt;
USE SaveYogurt;

CREATE TABLE empresa(
    id_empresa INT PRIMARY KEY AUTO_INCREMENT,
    cnpj CHAR(14) NOT NULL UNIQUE,
    razao_social VARCHAR(200) NOT NULL,
    dt_criacao DATETIME NOT NULL DEFAULT NOW(),
    token CHAR(16) NOT NULL UNIQUE
);

CREATE TABLE usuario(
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(200) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(200) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    dt_criacao DATETIME NOT NULL DEFAULT NOW(),
    fk_empresa INT NOT NULL,
    CONSTRAINT fk_usuario_empresa 
        FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa)
);

CREATE TABLE sensor(
    id_sensor INT PRIMARY KEY AUTO_INCREMENT,
    codigo_sensor VARCHAR(45) NOT NULL UNIQUE,
    status_sensor VARCHAR(30) NOT NULL, 
    fk_empresa INT NOT NULL,
    CONSTRAINT ch_status_sensor 
        CHECK(status_sensor IN ('Disponível','Em Uso')),
    CONSTRAINT fk_sensor_empresa 
        FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa)
);

CREATE TABLE lote(
    id_lote INT PRIMARY KEY AUTO_INCREMENT,
    codigo_lote VARCHAR(45) NOT NULL UNIQUE,
    dt_fabricacao DATE NOT NULL,
    dt_validade DATE NOT NULL,
    fk_empresa INT,
    CONSTRAINT cfk_lote_empresa 
        FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa)
);

CREATE TABLE entrega (
    id_entrega INT PRIMARY KEY AUTO_INCREMENT,
    tipo_veiculo VARCHAR(45),
    veiculo_placa VARCHAR(10) NOT NULL,
    ultima_loc VARCHAR (55),
    destino VARCHAR(100) NOT NULL,
    dt_inicio DATETIME DEFAULT NOW()
);

CREATE TABLE carga(
    id_carga INT PRIMARY KEY AUTO_INCREMENT,
    produto VARCHAR(45),
    qtd_caixas int,
    codigo_Carga VARCHAR(45) NOT NULL UNIQUE,
    status_carga VARCHAR(45) NOT NULL,
    temp_min DECIMAL(5,2) NOT NULL, 
    temp_max DECIMAL(5,2) NOT NULL,
    fk_lote INT NOT NULL,
    fk_entrega INT, 
    CONSTRAINT fk_carga_lote FOREIGN KEY (fk_lote) REFERENCES lote(id_lote),
    CONSTRAINT fk_carga_entrega FOREIGN KEY (fk_entrega) REFERENCES entrega(id_entrega)
);

CREATE TABLE monitoramento_sensor(
    id_monitoramento INT PRIMARY KEY AUTO_INCREMENT,
    fk_sensor INT NOT NULL,
    fk_carga INT NOT NULL,
    dt_inicio DATETIME NOT NULL DEFAULT NOW(),
    dt_fim DATETIME NULL,
    CONSTRAINT fk_monit_sensor FOREIGN KEY (fk_sensor) REFERENCES sensor(id_sensor),
    CONSTRAINT fk_monit_carga FOREIGN KEY (fk_carga) REFERENCES carga(id_carga)
);

CREATE TABLE registro(
    id_registro INT PRIMARY KEY AUTO_INCREMENT,
    dt_registro DATETIME DEFAULT NOW() NOT NULL,
    temperatura DECIMAL(5,2) NOT NULL,
    fk_sensor INT NOT NULL,
    CONSTRAINT fk_registro_sensor 
        FOREIGN KEY (fk_sensor) REFERENCES sensor(id_sensor)
);
CREATE TABLE alerta (
    id_alerta INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(100), 
    dt_alerta DATETIME DEFAULT NOW(),
    fk_registro INT, 
    fk_carga INT,  
    CONSTRAINT fk_alerta_registro FOREIGN KEY (fk_registro) REFERENCES registro(id_registro),
    CONSTRAINT fk_alerta_carga FOREIGN KEY (fk_carga) REFERENCES carga(id_carga)
);