CREATE database online_shop;
USE online_shop;

CREATE TABLE `address` (
	`address_id` INT(11) NOT NULL AUTO_INCREMENT,
	`customer_id` INT(11) NOT NULL,
	`company` VARCHAR(40) NOT NULL,
	`address` VARCHAR(128) NOT NULL,
	`city` VARCHAR(128) NOT NULL,
	`postcode` VARCHAR(10) NOT NULL,
	`zone_id` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`address_id`)
);
CREATE TABLE `customer` (
	`customer_id` INT(11) NOT NULL AUTO_INCREMENT,
	`customer_group_id` INT(11) NOT NULL,
	`language_id` INT(11) NOT NULL,
	`firstname` VARCHAR(32) NOT NULL,
	`lastname` VARCHAR(32) NOT NULL,
	`email` VARCHAR(96) NOT NULL,
	`telephone` VARCHAR(32) NOT NULL,
	`password` VARCHAR(40) NOT NULL,
	`salt` VARCHAR(9) NOT NULL,
	`newsletter` TINYINT(1) NOT NULL DEFAULT '0',
	`address_id` INT(11) NOT NULL DEFAULT '0',
	`status` TINYINT(1) NOT NULL,
	`date_added` DATETIME NOT NULL,
	PRIMARY KEY (`customer_id`)
);
CREATE TABLE `customer_group` (
	`customer_group_id` INT(11) NOT NULL AUTO_INCREMENT,
	`sort_order` INT(3) NOT NULL,
	PRIMARY KEY (`customer_group_id`)
);
CREATE TABLE `customer_group_description` (
	`customer_group_id` INT(11) NOT NULL,
	`language_id` INT(11) NOT NULL,
	`name` VARCHAR(32) NOT NULL,
	`description` TEXT NOT NULL,
	PRIMARY KEY (`customer_group_id`, `language_id`)
);
CREATE TABLE `attribute` (
	`attribute_id` INT(11) NOT NULL AUTO_INCREMENT,
	`attribute_group_id` INT(11) NOT NULL,
	`sort_order` INT(3) NOT NULL,
	`attribute_key` VARCHAR(64) NULL DEFAULT NULL,
	PRIMARY KEY (`attribute_id`)
);
CREATE TABLE `attribute_description` (
	`attribute_id` INT(11) NOT NULL,
	`language_id` INT(11) NOT NULL,
	`name` VARCHAR(64) NOT NULL,
	PRIMARY KEY (`attribute_id`, `language_id`)
);
CREATE TABLE `attribute_group` (
	`attribute_group_id` INT(11) NOT NULL AUTO_INCREMENT,
	`sort_order` INT(3) NOT NULL,
	PRIMARY KEY (`attribute_group_id`)
);
CREATE TABLE `attribute_group_description` (
	`attribute_group_id` INT(11) NOT NULL,
	`language_id` INT(11) NOT NULL,
	`name` VARCHAR(64) NOT NULL,
	PRIMARY KEY (`attribute_group_id`, `language_id`)
);
CREATE TABLE `category` (
	`category_id` INT(11) NOT NULL AUTO_INCREMENT,
	`image` VARCHAR(255) NULL DEFAULT NULL,
	`parent_id` INT(11) NOT NULL DEFAULT '0',
	`sort_order` INT(3) NOT NULL DEFAULT '0',
	`status` TINYINT(1) NOT NULL,
	`date_added` DATETIME NOT NULL,
	`date_modified` DATETIME NOT NULL,
	PRIMARY KEY (`category_id`)
);
CREATE TABLE `category_description` (
	`category_id` INT(11) NOT NULL,
	`language_id` INT(11) NOT NULL,
	`name` VARCHAR(255) NOT NULL,
	`description` TEXT NOT NULL,
	PRIMARY KEY (`category_id`, `language_id`)
);
CREATE TABLE `manufacturer` (
	`manufacturer_id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(64) NOT NULL,
	`image` VARCHAR(255) NULL DEFAULT NULL,
	`sort_order` INT(3) NOT NULL,
	PRIMARY KEY (`manufacturer_id`)
);
CREATE TABLE `manufacturer_description` (
	`manufacturer_id` INT(11) NOT NULL,
	`language_id` INT(11) NOT NULL,
	`name` VARCHAR(64) NOT NULL,
	PRIMARY KEY (`manufacturer_id`, `language_id`)
);
CREATE TABLE `option` (
	`option_id` INT(11) NOT NULL AUTO_INCREMENT,
	`type` VARCHAR(32) NOT NULL,
	`sort_order` INT(3) NOT NULL,
	PRIMARY KEY (`option_id`)
);
CREATE TABLE `option_description` (
	`option_id` INT(11) NOT NULL,
	`language_id` INT(11) NOT NULL,
	`name` VARCHAR(128) NOT NULL,
	PRIMARY KEY (`option_id`, `language_id`)
);
CREATE TABLE `option_value` (
	`option_value_id` INT(11) NOT NULL AUTO_INCREMENT,
	`option_id` INT(11) NOT NULL,
	`image` VARCHAR(255) NOT NULL,
	`value` VARCHAR(255) NULL DEFAULT NULL,
	`sort_order` INT(3) NOT NULL,
	PRIMARY KEY (`option_value_id`)
);
CREATE TABLE `option_value_description` (
	`option_value_id` INT(11) NOT NULL,
	`language_id` INT(11) NOT NULL,
	`option_id` INT(11) NOT NULL,
	`name` VARCHAR(128) NOT NULL,
	PRIMARY KEY (`option_value_id`, `language_id`)
);
CREATE TABLE `order_status` (
	`order_status_id` INT(11) NOT NULL AUTO_INCREMENT,
	`language_id` INT(11) NOT NULL,
	`name` VARCHAR(32) NOT NULL,
	`sort_order` INT(11) NOT NULL,
	PRIMARY KEY (`order_status_id`, `language_id`)
);
CREATE TABLE `cart` (
	`cart_id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`customer_id` INT(11) NOT NULL,
	`product_id` INT(11) NOT NULL,
	`option` TEXT NOT NULL,
	`quantity` INT(5) NOT NULL,
	`date_added` DATETIME NOT NULL,
	PRIMARY KEY (`cart_id`)
);
CREATE TABLE `order` (
	`order_id` INT(11) NOT NULL AUTO_INCREMENT,
	`invoice_no` INT(11) NOT NULL DEFAULT '0',
	`customer_id` INT(11) NOT NULL DEFAULT '0',
	`company` VARCHAR(40) NOT NULL,
	`address` VARCHAR(128) NOT NULL,
	`city` VARCHAR(128) NOT NULL,
	`zone_id` INT(11) NOT NULL,
	`method` VARCHAR(128) NOT NULL, --TODO
	`comment` TEXT NOT NULL,
	`total` DECIMAL(15,4) NOT NULL DEFAULT '0.0000',
	`order_status_id` INT(11) NOT NULL DEFAULT '0',
	`date_added` DATETIME NOT NULL,
	`date_modified` DATETIME NOT NULL,
	PRIMARY KEY (`order_id`)
);
CREATE TABLE `order_history` (
	`order_history_id` INT(11) NOT NULL AUTO_INCREMENT,
	`order_id` INT(11) NOT NULL,
	`order_status_id` INT(11) NOT NULL,
	`comment` TEXT NOT NULL,
	`date_added` DATETIME NOT NULL,
	PRIMARY KEY (`order_history_id`)
);
CREATE TABLE `order_option` (
	`order_option_id` INT(11) NOT NULL AUTO_INCREMENT,
	`order_id` INT(11) NOT NULL,
	`order_product_id` INT(11) NOT NULL,
	`product_option_id` INT(11) NOT NULL,
	`product_option_value_id` INT(11) NOT NULL DEFAULT '0',
	`name` VARCHAR(255) NOT NULL,
	`value` TEXT NOT NULL,
	`type` VARCHAR(32) NOT NULL,
	PRIMARY KEY (`order_option_id`)
);
CREATE TABLE `order_product` (
	`order_product_id` INT(11) NOT NULL AUTO_INCREMENT,
	`order_id` INT(11) NOT NULL,
	`product_id` INT(11) NOT NULL,
	`name` VARCHAR(255) NOT NULL,
	`model` VARCHAR(64) NOT NULL,
	`quantity` INT(4) NOT NULL,
	`price` DECIMAL(15,4) NOT NULL DEFAULT '0.0000',
	`total` DECIMAL(15,4) NOT NULL DEFAULT '0.0000',
	PRIMARY KEY (`order_product_id`)
);
CREATE TABLE `order_total` (
	`order_total_id` INT(10) NOT NULL AUTO_INCREMENT,
	`order_id` INT(11) NOT NULL,
	`code` VARCHAR(32) NOT NULL,
	`title` VARCHAR(255) NOT NULL,
	`value` DECIMAL(15,4) NOT NULL DEFAULT '0.0000',
	`sort_order` INT(3) NOT NULL,
	PRIMARY KEY (`order_total_id`)
);
CREATE TABLE `product` (
	`product_id` INT(11) NOT NULL AUTO_INCREMENT,
	`model` VARCHAR(64) NOT NULL,
	`quantity` INT(4) NOT NULL DEFAULT '0',
	`stock_status_id` INT(11) NOT NULL,
	`image` VARCHAR(255) NULL DEFAULT NULL,
	`manufacturer_id` INT(11) NOT NULL,
	`price` DECIMAL(15,4) NOT NULL DEFAULT '0.0000',
	`date_available` DATE NOT NULL DEFAULT '0000-00-00',
	`sort_order` INT(11) NOT NULL DEFAULT '0',
	`status` TINYINT(1) NOT NULL DEFAULT '0',
	`date_added` DATETIME NOT NULL,
	`date_modified` DATETIME NOT NULL,
	PRIMARY KEY (`product_id`)
);
CREATE TABLE `product_attribute` (
	`product_id` INT(11) NOT NULL,
	`attribute_id` INT(11) NOT NULL,
	`language_id` INT(11) NOT NULL,
	`text` TEXT NOT NULL,
	PRIMARY KEY (`product_id`, `attribute_id`, `language_id`)
);
CREATE TABLE `product_description` (
	`product_id` INT(11) NOT NULL,
	`language_id` INT(11) NOT NULL,
	`name` VARCHAR(255) NOT NULL,
	`description` TEXT NOT NULL,
	PRIMARY KEY (`product_id`, `language_id`)
);
CREATE TABLE `product_discount` (
	`product_discount_id` INT(11) NOT NULL AUTO_INCREMENT,
	`product_id` INT(11) NOT NULL,
	`customer_group_id` INT(11) NOT NULL,
	`quantity` INT(4) NOT NULL DEFAULT '0',
	`priority` INT(5) NOT NULL DEFAULT '1',
	`price` DECIMAL(15,4) NOT NULL DEFAULT '0.0000',
	`date_start` DATE NOT NULL DEFAULT '0000-00-00',
	`date_end` DATE NOT NULL DEFAULT '0000-00-00',
	PRIMARY KEY (`product_discount_id`)
);
CREATE TABLE `product_image` (
	`product_image_id` INT(11) NOT NULL AUTO_INCREMENT,
	`product_id` INT(11) NOT NULL,
	`image` VARCHAR(255) NULL DEFAULT NULL,
	`sort_order` INT(3) NOT NULL DEFAULT '0',
	PRIMARY KEY (`product_image_id`)
);
CREATE TABLE `product_option` (
	`product_option_id` INT(11) NOT NULL AUTO_INCREMENT,
	`product_id` INT(11) NOT NULL,
	`option_id` INT(11) NOT NULL,
	`value` TEXT NOT NULL,
	`required` TINYINT(1) NOT NULL,
	PRIMARY KEY (`product_option_id`)
);
CREATE TABLE `product_option_value` (
	`product_option_value_id` INT(11) NOT NULL AUTO_INCREMENT,
	`product_option_id` INT(11) NOT NULL,
	`product_id` INT(11) NOT NULL,
	`option_id` INT(11) NOT NULL,
	`option_value_id` INT(11) NOT NULL,
	`quantity` INT(3) NOT NULL,
	`price` DECIMAL(15,4) NOT NULL,
	`price_prefix` VARCHAR(1) NOT NULL,
	`is_default` TINYINT(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`product_option_value_id`)
);
CREATE TABLE `product_special` (
	`product_special_id` INT(11) NOT NULL AUTO_INCREMENT,
	`product_id` INT(11) NOT NULL,
	`customer_group_id` INT(11) NOT NULL,
	`priority` INT(5) NOT NULL DEFAULT '1',
	`price` DECIMAL(15,4) NOT NULL DEFAULT '0.0000',
	`date_start` DATE NOT NULL DEFAULT '0000-00-00',
	`date_end` DATE NOT NULL DEFAULT '0000-00-00',
	PRIMARY KEY (`product_special_id`)
);
CREATE TABLE `product_to_category` (
	`product_id` INT(11) NOT NULL,
	`category_id` INT(11) NOT NULL,
	PRIMARY KEY (`product_id`, `category_id`)
);
CREATE TABLE `oc_language` (
	`language_id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(32) NOT NULL,
	`code` VARCHAR(5) NOT NULL,
	`locale` VARCHAR(255) NOT NULL,
	`sort_order` INT(3) NOT NULL DEFAULT '0',
	`status` TINYINT(1) NOT NULL,
	PRIMARY KEY (`language_id`)
);
CREATE TABLE `zone` (
	`zone_id` INT(11) NOT NULL AUTO_INCREMENT,
	`parent_id` INT(11) NULL DEFAULT NULL,
	`sort_order` INT(11) NOT NULL DEFAULT '0',
	`priority` TINYINT(1) NOT NULL DEFAULT '0',
	`name` VARCHAR(128) NOT NULL,
	`code` VARCHAR(32) NOT NULL,
	`status` TINYINT(1) NOT NULL DEFAULT '1',
	PRIMARY KEY (`zone_id`)
);
CREATE TABLE `geo_zone` (
	`geo_zone_id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(32) NOT NULL,
	`description` VARCHAR(255) NOT NULL,
	`date_modified` DATETIME NOT NULL,
	`date_added` DATETIME NOT NULL,
	PRIMARY KEY (`geo_zone_id`)
);
CREATE TABLE `zone_to_geo_zone` (
	`zone_to_geo_zone_id` INT(11) NOT NULL AUTO_INCREMENT,
	`zone_id` INT(11) NOT NULL DEFAULT '0',
	`geo_zone_id` INT(11) NOT NULL,
	`date_added` DATETIME NOT NULL,
	`date_modified` DATETIME NOT NULL,
	PRIMARY KEY (`zone_to_geo_zone_id`)
);
