-- Создание БД.

CREATE database some_customers;
USE some_customers;

-- Создание схемы

-- Пользователи
CREATE TABLE `customer` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`title` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
	`first_name` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
	`last_name` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
	`correspondence_language_id` TINYINT(3) NULL,
	`birth_date` DATE NULL,
    `marital_status_id` TINYINT(1) NULL,
    `gender_id` TINYINT(2) NULL,
	`status` TINYINT(1) NOT NULL DEFAULT '1',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB CHARSET=utf8mb4 COLLATE utf8mb4_general_ci;

-- Семейный статус
CREATE TABLE `marital_status` (
	`id` TINYINT(1) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
	`sort_order` TINYINT(3) NOT NULL DEFAULT '0',
	`status` TINYINT(1) NOT NULL DEFAULT '1',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB CHARSET=utf8mb4 COLLATE utf8mb4_general_ci;

-- Пол. Для иностранцев будет оскорбительно, если не будет списка полов.
CREATE TABLE `gender` (
	`id` TINYINT(2) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
	`sort_order` TINYINT(3) NOT NULL DEFAULT '0',
	`status` TINYINT(1) NOT NULL DEFAULT '1',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB CHARSET=utf8mb4 COLLATE utf8mb4_general_ci;

-- Язык
CREATE TABLE `language` (
	`id` TINYINT(3) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
	`code` VARCHAR(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
	`sort_order` TINYINT(3) NOT NULL DEFAULT '0',
	`status` TINYINT(1) NOT NULL DEFAULT '1',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB CHARSET=utf8mb4 COLLATE utf8mb4_general_ci;

-- Страна
CREATE TABLE `country` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`sort_order` INT(11) NOT NULL DEFAULT '0',
	`name` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
	`code` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
	`status` TINYINT(1) NOT NULL DEFAULT '1',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB CHARSET=utf8mb4 COLLATE utf8mb4_general_ci;

-- Регион
CREATE TABLE `region` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`country_id` INT(11) NULL,
	`sort_order` INT(11) NOT NULL DEFAULT '0',
	`name` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
	`code` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
	`status` TINYINT(1) NOT NULL DEFAULT '1',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB CHARSET=utf8mb4 COLLATE utf8mb4_general_ci;

-- Город
CREATE TABLE `city` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`region_id` INT(11) NULL,
	`sort_order` INT(11) NOT NULL DEFAULT '0',
	`name` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
	`code` VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
	`status` TINYINT(1) NOT NULL DEFAULT '1',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB CHARSET=utf8mb4 COLLATE utf8mb4_general_ci;

-- Адреса пользователей
CREATE TABLE `address` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `customer_id` INT(11) NOT NULL,
    `country_id` INT(11) NULL,
    `region_id` INT(11) NULL,
    `city_id` INT(11) NULL,
    `postal_code` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
    `street` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
    `building_number` VARCHAR(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
    `status` TINYINT(1) NOT NULL DEFAULT '1',
    `is_default` TINYINT(1) NOT NULL DEFAULT '0',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB CHARSET=utf8mb4 COLLATE utf8mb4_general_ci;

-- Внешние ключи
ALTER TABLE `customer` ADD FOREIGN KEY (`correspondence_language_id`) REFERENCES `language`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `customer` ADD FOREIGN KEY (`marital_status_id`) REFERENCES `marital_status`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `customer` ADD FOREIGN KEY (`gender_id`) REFERENCES `gender`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `region` ADD FOREIGN KEY (`country_id`) REFERENCES `country`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `city` ADD FOREIGN KEY (`region_id`) REFERENCES `region`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `address` ADD FOREIGN KEY (`customer_id`) REFERENCES `customer`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `address` ADD FOREIGN KEY (`country_id`) REFERENCES `country`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `address` ADD FOREIGN KEY (`region_id`) REFERENCES `region`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `address` ADD FOREIGN KEY (`city_id`) REFERENCES `city`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;



-- Импорт данных

DROP TEMPORARY TABLE IF EXISTS tmp_import;
CREATE TEMPORARY TABLE tmp_import (
    id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NULL,
    first_name VARCHAR(255) NULL,
    last_name VARCHAR(255) NULL,
    correspondence_language VARCHAR(255) NULL,
    birth_date VARCHAR(255) NULL,
    gender VARCHAR(255) NULL,
    marital_status VARCHAR(255) NULL,
    country VARCHAR(255) NULL,
    postal_code VARCHAR(255) NULL,
    region VARCHAR(255) NULL,
    city VARCHAR(255) NULL,
    street VARCHAR(255) NULL,
    building_number VARCHAR(255) NULL
);

LOAD DATA INFILE '/userdata/php_upload/some_customers.csv'
INTO TABLE tmp_import
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(title,first_name,last_name,correspondence_language,birth_date,gender,marital_status,country,postal_code,region,city,street,building_number);



INSERT INTO gender (name) 
SELECT DISTINCT tt.gender FROM tmp_import tt
WHERE 
    tt.gender IS NOT NULL
    AND tt.gender <> ''
    AND tt.gender <> 'Unknown';


INSERT INTO language (name, code) 
SELECT DISTINCT tt.correspondence_language, tt.correspondence_language FROM tmp_import tt
WHERE 
    tt.correspondence_language IS NOT NULL
    AND tt.correspondence_language <> '';


INSERT INTO marital_status (name) 
SELECT DISTINCT marital_status FROM tmp_import tt
WHERE 
    tt.marital_status IS NOT NULL
    AND tt.marital_status <> '';


INSERT INTO country (name, code) 
SELECT DISTINCT tt.country, tt.country FROM tmp_import tt
WHERE 
    tt.country IS NOT NULL
    AND tt.country <> '';


INSERT INTO region (name, code, country_id) 
SELECT DISTINCT
    tt.region, 
    tt.region, 
    (SELECT c.id FROM country c WHERE c.code = tt.country)
FROM tmp_import tt
WHERE 
    tt.region IS NOT NULL
    AND tt.region <> '';


INSERT INTO city (name, code, region_id) 
SELECT DISTINCT
    tt.city, 
    tt.city, 
    MAX((SELECT r.id FROM region r WHERE r.code = tt.region))
FROM tmp_import tt
WHERE 
    tt.city IS NOT NULL
    AND tt.city <> ''
GROUP BY tt.city;

    
INSERT INTO customer (title, first_name, last_name, correspondence_language_id, birth_date, marital_status_id, gender_id) 
SELECT 
    tt.title,
    tt.first_name, 
    tt.last_name,
    (SELECT l.id FROM language l WHERE l.code = tt.correspondence_language),
    CASE WHEN tt.birth_date = '' THEN null ELSE tt.birth_date END,
    (SELECT ms.id FROM marital_status ms WHERE ms.name = tt.marital_status),
    (SELECT g.id FROM gender g WHERE g.name = tt.gender)
FROM tmp_import tt;



INSERT INTO address (customer_id, country_id, region_id, city_id, postal_code, street, building_number, is_default)
SELECT 
    c.id,
    (SELECT co.id FROM country co WHERE co.code = tt.country),
    (SELECT r.id FROM region r WHERE r.code = tt.region),
    (SELECT ci.id FROM city ci WHERE ci.code = tt.city),
    tt.postal_code,
    tt.street, 
    tt.building_number,
    0
FROM tmp_import tt
INNER JOIN customer c
    ON c.title = tt.title
    AND c.first_name = tt.first_name
    AND c.last_name = tt.last_name
    AND c.birth_date = tt.birth_date
;