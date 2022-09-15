-- Домашняя работа № 4. DDL скрипты.

-- 1. Создание ролей
    CREATE GROUP online_shop;

    CREATE ROLE online_shop_admin WITH 
        PASSWORD 'QRG33GGS22qwe'
        SUPERUSER
        CREATEDB
        CREATEROLE
        INHERIT
        LOGIN
        REPLICATION
        BYPASSRLS
        CONNECTION LIMIT -1;

    CREATE ROLE online_shop_manager WITH 
        LOGIN
        PASSWORD 'QqweRG33GGS22qwe'
        CONNECTION LIMIT -1;

    GRANT online_shop TO online_shop_admin;
    GRANT online_shop TO online_shop_manager;


-- 2. Создание базы данных
    CREATE DATABASE online_shop WITH 
        OWNER = online_shop
        ENCODING = 'UTF8'
        TABLESPACE = 'pg_default'
        CONNECTION LIMIT = -1;

-- 3. Создание схем
    CREATE SCHEMA IF NOT EXISTS catalog;
    CREATE SCHEMA IF NOT EXISTS orders;
    CREATE SCHEMA IF NOT EXISTS customers;

-- 4. Создание общих таблиц 
    CREATE TABLE public.language (
        language_id serial NOT NULL,
        name varchar(32) NOT NULL,
        code varchar(5) NOT NULL,
        locale varchar(255) NOT NULL,
        sort_order integer NOT NULL,
        status bool,
        PRIMARY KEY (language_id)
    );
    
    CREATE TABLE public.zone (
        zone_id serial NOT NULL,
        parent_id integer,
        sort_order integer NOT NULL,
        priority smallint,
        name varchar(128) NOT NULL,
        code varchar(5) NOT NULL,
        status bool,
        PRIMARY KEY (zone_id)
    );

-- 5. Создание таблиц для покупателя
    CREATE TABLE customers.customer_group (
        customer_group_id serial NOT NULL,
        sort_order integer NOT NULL,
        PRIMARY KEY (customer_group_id)
    );

    CREATE TABLE customers.customer_group_description (
        customer_group_id integer NOT NULL,
        language_id integer NOT NULL,
        name varchar(32) NOT NULL,
        description TEXT,
        PRIMARY KEY (customer_group_id, language_id),
        CONSTRAINT customer_group_description_cg_fk FOREIGN KEY (customer_group_id)
            REFERENCES customers.customer_group (customer_group_id) MATCH SIMPLE
            ON UPDATE CASCADE
            ON DELETE CASCADE,
        CONSTRAINT customer_group_description_l_fk FOREIGN KEY (language_id)
            REFERENCES public.language (language_id) MATCH SIMPLE
            ON UPDATE RESTRICT
            ON DELETE RESTRICT
    );

    CREATE TABLE customers.address (
        address_id serial NOT NULL,
        customer_id integer NOT NULL,
        company varchar(40) NULL,
        address varchar(128) NOT NULL,
        city varchar(128) NULL,
        postcode varchar(10) NULL,
        zone_id integer NOT NULL,
        PRIMARY KEY (address_id),
        CONSTRAINT address_c_fk FOREIGN KEY (customer_id)
            REFERENCES customers.customer (customer_id) MATCH SIMPLE
            ON UPDATE CASCADE
            ON DELETE CASCADE,
        CONSTRAINT address_z_fk FOREIGN KEY (zone_id)
            REFERENCES public.zone (zone_id) MATCH SIMPLE
            ON UPDATE CASCADE
            ON DELETE CASCADE
    );

    CREATE TABLE customers.customer (
        customer_id serial NOT NULL,
        customer_group_id integer NOT NULL,
        firstname varchar(32) NOT NULL,
        lastname varchar(32),
        email varchar(96) NOT NULL,
        telephone varchar(32) NOT NULL,
        password varchar(40) NOT NULL,
        salt varchar(9) NOT NULL,
        newsletter bool NOT NULL,
        address_id integer,
        status bool NOT NULL,
        date_added timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (customer_id),
        CONSTRAINT customer_cg_fk FOREIGN KEY (customer_group_id)
            REFERENCES customers.customer_group (customer_group_id) MATCH SIMPLE
            ON UPDATE CASCADE
            ON DELETE CASCADE,
        CONSTRAINT customer_ad_fk FOREIGN KEY (address_id)
            REFERENCES customers.address (address_id) MATCH SIMPLE
            ON UPDATE CASCADE
            ON DELETE SET NULL
    );

-- 6. Создание таблиц для товаров
    CREATE TABLE catalog.manufacturer (
        manufacturer_id serial NOT NULL,
        image varchar(255) NOT NULL,
        sort_order integer NOT NULL,
        status bool NOT NULL,
        date_added timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
        date_modified timestamp,
        PRIMARY KEY (manufacturer_id)
    );

    CREATE TABLE catalog.manufacturer_description (
        manufacturer_id integer NOT NULL,
        language_id integer NOT NULL,
        name varchar(32) NOT NULL,
        description TEXT,
        PRIMARY KEY (manufacturer_id, language_id),
        CONSTRAINT manufacturer_description_m_fk FOREIGN KEY (manufacturer_id)
            REFERENCES catalog.manufacturer (manufacturer_id) MATCH SIMPLE
            ON UPDATE CASCADE
            ON DELETE CASCADE,
        CONSTRAINT manufacturer_description_l_fk FOREIGN KEY (language_id)
            REFERENCES public.language (language_id) MATCH SIMPLE
            ON UPDATE RESTRICT
            ON DELETE RESTRICT
    );

    CREATE TABLE catalog.product (
        product_id serial NOT NULL,
        code varchar(64) NOT NULL,
        quantity integer NOT NULL,
        image varchar(255),
        manufacturer_id integer,
        price decimal(9,2) NOT NULL,
        date_available date NOT NULL,
        sort_order integer NOT NULL,
        status bool NOT NULL,
        date_added timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
        date_modified timestamp,
        PRIMARY KEY (product_id),
        CONSTRAINT product_m_fk FOREIGN KEY (manufacturer_id)
            REFERENCES catalog.manufacturer (manufacturer_id) MATCH SIMPLE
            ON UPDATE CASCADE
            ON DELETE RESTRICT
    );

-- 7. Создание таблиц для заказов
    CREATE TABLE orders.order (
        order_id serial NOT NULL,
        invoice_no varchar(64) NOT NULL,
        customer_id integer NOT NULL,
        address varchar(255),
        zone_id integer NOT NULL,
        total decimal(9,2) NOT NULL,
        shipping_method varchar(128),
        payment_method varchar(128),
        order_status varchar(64) NOT NULL,
        date_added timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
        date_modified timestamp,
        PRIMARY KEY (customer_id),
        CONSTRAINT order_c_fk FOREIGN KEY (customer_id)
            REFERENCES customers.customer (customer_id) MATCH SIMPLE
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
        CONSTRAINT address_z_fk FOREIGN KEY (zone_id)
            REFERENCES public.zone (zone_id) MATCH SIMPLE
            ON UPDATE CASCADE
            ON DELETE RESTRICT
    );