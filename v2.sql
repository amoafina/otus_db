CREATE database online_shop;
USE online_shop;

CREATE TABLE `address` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`customer_id` INT(11) NOT NULL,
	`company` VARCHAR(40) NOT NULL,
	`address` VARCHAR(128) NOT NULL,
	`city` VARCHAR(128) NOT NULL,
	`postcode` VARCHAR(10) NOT NULL,
	`zone_id` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`)
);
CREATE TABLE `customer` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`customer_group_id` INT(11) NOT NULL,
	`language_id` TINYINT(3) NOT NULL,
	`firstname` VARCHAR(32) NOT NULL,
	`lastname` VARCHAR(32) NOT NULL,
	`email` VARCHAR(96) NOT NULL,
	`custom_field` JSON NULL,
	`telephone` VARCHAR(32) NOT NULL,
	`password` VARCHAR(40) NOT NULL,
	`salt` VARCHAR(9) NOT NULL,
	`newsletter` TINYINT(1) NOT NULL DEFAULT '0',
	`address_id` INT(11) NOT NULL DEFAULT '0',
	`status` TINYINT(1) NOT NULL,
	`date_added` DATETIME NOT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE `customer_group` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`sort_order` TINYINT(3) NOT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE `customer_group_description` (
	`customer_group_id` INT(11) NOT NULL,
	`language_id` TINYINT(3) NOT NULL,
	`name` VARCHAR(32) NOT NULL,
	`description` TEXT NOT NULL,
	PRIMARY KEY (`customer_group_id`, `language_id`)
);
CREATE TABLE `attribute` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`attribute_group_id` INT(11) NOT NULL,
	`sort_order` TINYINT(3) NOT NULL,
	`attribute_key` VARCHAR(64) NULL DEFAULT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE `attribute_description` (
	`attribute_id` INT(11) NOT NULL,
	`language_id` TINYINT(3) NOT NULL,
	`name` VARCHAR(64) NOT NULL,
	PRIMARY KEY (`attribute_id`, `language_id`)
);
CREATE TABLE `attribute_group` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`sort_order` TINYINT(3) NOT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE `attribute_group_description` (
	`attribute_group_id` INT(11) NOT NULL,
	`language_id` TINYINT(3) NOT NULL,
	`name` VARCHAR(64) NOT NULL,
	PRIMARY KEY (`attribute_group_id`, `language_id`)
);
CREATE TABLE `category` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`image` VARCHAR(255) NULL DEFAULT NULL,
	`parent_id` INT(11) NOT NULL DEFAULT '0',
	`sort_order` INT(11) NOT NULL DEFAULT '0',
	`status` TINYINT(1) NOT NULL,
	`date_added` DATETIME NOT NULL,
	`date_modified` DATETIME NOT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE `category_description` (
	`category_id` INT(11) NOT NULL,
	`language_id` TINYINT(3) NOT NULL,
	`name` VARCHAR(128) NOT NULL,
	`description` TEXT NOT NULL,
	PRIMARY KEY (`category_id`, `language_id`)
);
CREATE TABLE `manufacturer` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`image` VARCHAR(255) NULL DEFAULT NULL,
	`sort_order` INT(11) NOT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE `manufacturer_description` (
	`manufacturer_id` INT(11) NOT NULL,
	`language_id` TINYINT(3) NOT NULL,
	`name` VARCHAR(128) NOT NULL,
	PRIMARY KEY (`manufacturer_id`, `language_id`)
);
CREATE TABLE `option` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`type` VARCHAR(32) NOT NULL,
	`sort_order` TINYINT(3) NOT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE `option_description` (
	`option_id` INT(11) NOT NULL,
	`language_id` TINYINT(3) NOT NULL,
	`name` VARCHAR(128) NOT NULL,
	PRIMARY KEY (`option_id`, `language_id`)
);
CREATE TABLE `option_value` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`option_id` INT(11) NOT NULL,
	`image` VARCHAR(255) NOT NULL,
	`value` VARCHAR(255) NULL DEFAULT NULL,
	`sort_order` TINYINT(3) NOT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE `option_value_description` (
	`option_value_id` INT(11) NOT NULL,
	`language_id` TINYINT(3) NOT NULL,
	`option_id` INT(11) NOT NULL,
	`name` VARCHAR(128) NOT NULL,
	PRIMARY KEY (`option_value_id`, `language_id`)
);
CREATE TABLE `order_status` (
	`id` TINYINT(3) NOT NULL AUTO_INCREMENT,
	`language_id` TINYINT(3) NOT NULL,
	`name` VARCHAR(32) NOT NULL,
	`sort_order` TINYINT(3) NOT NULL,
	PRIMARY KEY (`id`, `language_id`)
);
CREATE TABLE `cart` (
	`id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`customer_id` INT(11) NOT NULL,
	`product_id` INT(11) NOT NULL,
	`option` JSON NOT NULL,
	`quantity` INT(5) NOT NULL,
	`date_added` DATETIME NOT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE `order` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`invoice_no` VARCHAR(16) NOT NULL DEFAULT '0',
	`customer_id` INT(11) NOT NULL DEFAULT '0',
	`company` VARCHAR(128) NOT NULL,
	`address` VARCHAR(128) NOT NULL,
	`city` VARCHAR(128) NOT NULL,
	`zone_id` INT(11) NOT NULL,
	`payment_method` VARCHAR(128) NOT NULL,
	`shipping_method` VARCHAR(128) NOT NULL,
	`comment` TEXT NOT NULL,
	`total` DECIMAL(15,4) NOT NULL DEFAULT '0.0000',
	`order_status_id` TINYINT(3) NOT NULL DEFAULT '0',
	`date_added` DATETIME NOT NULL,
	`date_modified` DATETIME NOT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE `order_history` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`order_id` INT(11) NOT NULL,
	`order_status_id` TINYINT(3) NOT NULL,
	`comment` TEXT NOT NULL,
	`date_added` DATETIME NOT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE `order_option` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`order_id` INT(11) NOT NULL,
	`order_product_id` INT(11) NOT NULL,
	`product_option_id` INT(11) NOT NULL,
	`product_option_value_id` INT(11) NOT NULL DEFAULT '0',
	`name` VARCHAR(128) NOT NULL,
	`value` VARCHAR(255) NOT NULL,
	`type` VARCHAR(32) NOT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE `order_product` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`order_id` INT(11) NOT NULL,
	`product_id` INT(11) NOT NULL,
	`name` VARCHAR(255) NOT NULL,
	`model` VARCHAR(64) NOT NULL,
	`quantity` INT(4) NOT NULL,
	`price` DECIMAL(15,4) NOT NULL DEFAULT '0.0000',
	`total` DECIMAL(15,4) NOT NULL DEFAULT '0.0000',
	PRIMARY KEY (`id`)
);
CREATE TABLE `order_total` (
	`id` INT(10) NOT NULL AUTO_INCREMENT,
	`order_id` INT(11) NOT NULL,
	`code` VARCHAR(32) NOT NULL,
	`title` VARCHAR(255) NOT NULL,
	`value` DECIMAL(15,4) NOT NULL DEFAULT '0.0000',
	`sort_order` INT(3) NOT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE `product` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`model` VARCHAR(64) NOT NULL,
	`quantity` INT(4) NOT NULL DEFAULT '0',
	`image` VARCHAR(255) NULL DEFAULT NULL,
	`manufacturer_id` INT(11) NOT NULL,
	`price` DECIMAL(15,4) NOT NULL DEFAULT '0.0000',
	`date_available` DATE NOT NULL DEFAULT '0000-00-00',
	`sort_order` INT(11) NOT NULL DEFAULT '0',
	`status` TINYINT(1) NOT NULL DEFAULT '0',
	`date_added` DATETIME NOT NULL,
	`date_modified` DATETIME NOT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE `product_attribute` (
	`product_id` INT(11) NOT NULL,
	`attribute_id` INT(11) NOT NULL,
	`language_id` TINYINT(3) NOT NULL,
	`text` TEXT NOT NULL,
	PRIMARY KEY (`product_id`, `attribute_id`, `language_id`)
);
CREATE TABLE `product_description` (
	`product_id` INT(11) NOT NULL,
	`language_id` TINYINT(3) NOT NULL,
	`name` VARCHAR(255) NOT NULL,
	`description` TEXT NOT NULL,
	PRIMARY KEY (`product_id`, `language_id`)
);
CREATE TABLE `product_discount` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`product_id` INT(11) NOT NULL,
	`customer_group_id` INT(11) NOT NULL,
	`quantity` INT(4) NOT NULL DEFAULT '0',
	`priority` INT(5) NOT NULL DEFAULT '1',
	`price` DECIMAL(15,4) NOT NULL DEFAULT '0.0000',
	`date_start` DATE NOT NULL DEFAULT '0000-00-00',
	`date_end` DATE NOT NULL DEFAULT '0000-00-00',
	PRIMARY KEY (`id`)
);
CREATE TABLE `product_image` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`product_id` INT(11) NOT NULL,
	`image` VARCHAR(255) NULL DEFAULT NULL,
	`sort_order` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`)
);
CREATE TABLE `product_option` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`product_id` INT(11) NOT NULL,
	`option_id` INT(11) NOT NULL,
	`value` VARCHAR(255) NOT NULL,
	`required` TINYINT(1) NOT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE `product_option_value` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`product_option_id` INT(11) NOT NULL,
	`product_id` INT(11) NOT NULL,
	`option_id` INT(11) NOT NULL,
	`option_value_id` INT(11) NOT NULL,
	`quantity` INT(4) NOT NULL,
	`price` DECIMAL(15,4) NOT NULL,
	`price_prefix` VARCHAR(1) NOT NULL,
	`is_default` TINYINT(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`)
);
CREATE TABLE `product_special` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`product_id` INT(11) NOT NULL,
	`customer_group_id` INT(11) NOT NULL,
	`priority` INT(5) NOT NULL DEFAULT '1',
	`price` DECIMAL(15,4) NOT NULL DEFAULT '0.0000',
	`date_start` DATE NOT NULL DEFAULT '0000-00-00',
	`date_end` DATE NOT NULL DEFAULT '0000-00-00',
	PRIMARY KEY (`id`)
);
CREATE TABLE `product_to_category` (
	`product_id` INT(11) NOT NULL,
	`category_id` INT(11) NOT NULL,
	PRIMARY KEY (`product_id`, `category_id`)
);
CREATE TABLE `language` (
	`id` TINYINT(3) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(32) NOT NULL,
	`code` VARCHAR(5) NOT NULL,
	`locale` VARCHAR(16) NOT NULL,
	`sort_order` TINYINT(3) NOT NULL DEFAULT '0',
	`status` TINYINT(1) NOT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE `zone` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`parent_id` INT(11) NULL DEFAULT NULL,
	`sort_order` INT(11) NOT NULL DEFAULT '0',
	`priority` TINYINT(1) NOT NULL DEFAULT '0',
	`name` VARCHAR(128) NOT NULL,
	`code` VARCHAR(32) NOT NULL,
	`status` TINYINT(1) NOT NULL DEFAULT '1',
	PRIMARY KEY (`id`)
);
CREATE TABLE `geo_zone` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(32) NOT NULL,
	`description` VARCHAR(255) NOT NULL,
	`date_modified` DATETIME NOT NULL,
	`date_added` DATETIME NOT NULL,
	PRIMARY KEY (`id`)
);
CREATE TABLE `zone_to_geo_zone` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`zone_id` INT(11) NOT NULL DEFAULT '0',
	`geo_zone_id` INT(11) NOT NULL,
	`date_added` DATETIME NOT NULL,
	`date_modified` DATETIME NOT NULL,
	PRIMARY KEY (`id`)
);
