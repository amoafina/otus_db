-- Домашняя работа № 5. DML скрипты.

-- 1. Подготовительные работы
-- 1.1. Создание базы данных
    CREATE DATABASE online_shop WITH 
        OWNER = postgres
        ENCODING = 'UTF8'
        TABLESPACE = 'pg_default'
        CONNECTION LIMIT = -1;

-- 1.2. Создание схем
    CREATE SCHEMA IF NOT EXISTS catalog;
    CREATE SCHEMA IF NOT EXISTS orders;

-- 1.3. Создание таблиц 
    CREATE TABLE public.language (
        id serial NOT NULL,
        name varchar(32) NOT NULL,
        code varchar(5) NOT NULL,
        locale varchar(255) NOT NULL,
        sort_order integer NOT NULL,
        status bool,
        PRIMARY KEY (id)
    );

    CREATE TABLE catalog.product (
        id serial NOT NULL,
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
        PRIMARY KEY (id)
    );

    CREATE TABLE catalog.product_description (
        product_id integer NOT NULL,
        language_id integer NOT NULL,
        name varchar(32) NOT NULL,
        description varchar(512),
        PRIMARY KEY (product_id, language_id)
    );

    CREATE TABLE catalog.manufacturer_description (
        manufacturer_id integer NOT NULL,
        language_id integer NOT NULL,
        name varchar(32) NOT NULL,
        description TEXT,
        PRIMARY KEY (manufacturer_id, language_id)
    );

    CREATE TABLE orders.order (
        id serial NOT NULL,
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
        PRIMARY KEY (customer_id)
    );

-- 2. Вставка тестовых данных
-- 2.1. Обычная вставка

    INSERT INTO public.language (id, name, code, locale, sort_order, status)
    VALUES 
        (1, 'Русский', 'ru', 'ru-RU', 10, true),
        (2, 'English', 'en', 'en-US', 20, true)
    ;

    INSERT INTO catalog.product (id, code, quantity, image, manufacturer_id, price, date_available, sort_order, status, date_added, date_modified)
    VALUES
        (1, 'product_1', 1000, null, null, 100, '2022-10-01', 10, true, '2022-10-01', '2022-10-01'),
        (2, 'product_2', 1000, null, 1, 200, '2022-10-01', 20, true, '2022-10-01', '2022-10-01'),
        (3, 'product_3', 1000, null, null, 300, '2022-10-01', 30, true, '2022-10-01', '2022-10-01')
    ;

    INSERT INTO catalog.product_description (product_id, language_id, name, description)
    VALUES
        (1, 1, 'Супер продукт №1', 'Стильный и модный'),
        (1, 2, 'Super product', 'test'),
        (2, 1, 'Суповой набор', 'Крылья, ноги и хвосты'),
        (2, 2, 'Soup', 'test2'),
        (3, 1, 'Крабовый салат', 'Краб почти настоящий'),
        (3, 2, 'Crab', 'test3')
    ;

    INSERT INTO catalog.manufacturer_description (manufacturer_id, language_id, name, description)
    VALUES
        (1, 1, 'Фанта', ''),
        (1, 2, 'Super Fanta', 'test')
    ;

    INSERT INTO orders.order (id, invoice_no, customer_id, address, zone_id, total, shipping_method, payment_method, order_status, date_added, date_modified)
    VALUES
        (1, '000001', 1, 'улица Пушкина, дом Колотушкина', 1, 100, 'Доставка', 'Онлайн', 'Завершен', '2022-10-02 15:43', '2022-10-02 15:43'),
        (2, '000002', 2, 'улица Колотушкина, дом Пушкина', 1, 300, 'Доставка', 'Онлайн', 'Завершен', '2022-10-02 15:43', '2022-10-02 15:43'),
        (3, '000003', 5, 'улица Ленина, дом 23', 1, 400, 'Доставка', 'Онлайн', 'На доставке', '2022-10-02 15:43', '2022-10-02 15:43'),
        (4, '000004', 123, 'переулок Космонавтов, дом 44', 1, 1000, 'Доставка', 'Онлайн', 'На доставке', '2022-10-02 15:43', '2022-10-02 15:43')
    ;

-- 2.1. Вставка с возвратом ID заказа
    
    INSERT INTO orders.order (id, invoice_no, customer_id, address, zone_id, total, shipping_method, payment_method, order_status, date_added, date_modified)
    VALUES
        (5, '000005', 33, 'улица Пушкина, дом Колотушкина', 1, 1100, 'Самовывоз', 'При получении', 'Новый', '2022-10-02 15:43', '2022-10-02 15:43')
    RETURNING id;

-- 3. Запросы DML

-- 3.1. Запрос по своей базе с регулярным выражением
-- Запрос отбирает все ID товаров, наименования которых удовлетворяют запросу. Используется, например в поиске товаров.
    
    SELECT pd.product_id
    FROM catalog.product_description pd
    WHERE pd.name LIKE '%Суп%'
   		AND language_id = 1;

-- 3.2. Запрос по своей базе с использованием LEFT JOIN и INNER JOIN.
-- Запрос отбирает все товары, вместе с описаниям и названием, в зависимости от выбранного пользователем языка.

    SELECT p.id, p.code, p.quantity, p.image, p.price, p.date_available, p.sort_order, pd.name, pd.description
    FROM catalog.product p
    INNER JOIN catalog.product_description pd
        ON pd.product_id = p.id
        AND pd.language_id = 1
    ;

-- Запрос отбирает все товары, вместе с описаниям и названием, в зависимости от выбранного пользователем языка, включая названия производителей, если они есть. Если нет, то выводит текст "Производитель не определен"

    SELECT p.id, p.code, p.quantity, p.image, p.price, p.date_available, p.sort_order, pd.name, pd.description, COALESCE(md.name, 'Производитель не определен')
    FROM catalog.product p
    INNER JOIN catalog.product_description pd
        ON pd.product_id = p.id
        AND pd.language_id = 1
    LEFT JOIN catalog.manufacturer_description md
        ON md.manufacturer_id = p.manufacturer_id
        AND md.language_id = 1
    ;

-- 3.3. Запрос на добавление данных с выводом информации о добавленных строках.
-- см. п. 2.

-- 3.4. Запрос с обновлением данных используя UPDATE FROM.
-- Запрос обновляет описание товаров, добавляет наименование производителя в название, если названия производителя нет, то вставляется просто "производителя товаров".

    UPDATE catalog.product_description
        SET description = 'Лучшее от производителя ' || COALESCE(tmd.manufacturer_name, 'товаров')
    FROM (
        SELECT p.id AS product_id, md.name AS manufacturer_name 
        FROM catalog.product p
        LEFT JOIN catalog.manufacturer_description md
            ON md.manufacturer_id = p.manufacturer_id
            AND md.language_id = 1
    ) tmd
    WHERE tmd.product_id = catalog.product_description.product_id
   		AND catalog.product_description.language_id = 1
    ;

-- 3.5. Запрос для удаления данных с оператором DELETE, используя join с другой таблицей с помощью using

-- Запрос отключает английиский язык.

    UPDATE public.language
    SET status = false
    WHERE id = 2;

-- Запрос удаляет все описания товаров с отключенным языком.

    DELETE FROM catalog.product_description 
    USING public.language
    WHERE catalog.product_description.language_id = public.language.id 
        AND public.language.status = false; 

-- 3.6. Пример использования утилиты COPY
-- Сохранение копии таблицы как бэкап
COPY (SELECT * FROM catalog.product) TO '/var/lib/postgresql/data/product_backup.copy';

-- Очистка таблицы товаров
DELETE FROM catalog.product;

-- Загрузка бэкапа таблицы
COPY catalog.product FROM '/var/lib/postgresql/data/product_backup.copy';

-- Проверка, все ли загрузилось
SELECT * FROM catalog.product;