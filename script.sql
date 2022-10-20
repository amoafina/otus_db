-- 1. Описать пример транзакции из своего проекта с изменением данных в нескольких таблицах. Реализовать в виде хранимой процедуры.

-- 1.1. Создание процедуры
    DROP PROCEDURE IF EXISTS online_shop.update_order_status;

    DELIMITER $$
    $$
    CREATE PROCEDURE online_shop.update_order_status(IN in_order_id integer, IN in_order_status_id integer, IN in_comment text)
    BEGIN
        START TRANSACTION;
        
        -- Обновление статуса в таблице заказов
        UPDATE `order`
            SET order_status_id = in_order_status_id
        WHERE
            id = in_order_id;
        
        -- Запись в историю изменений
        INSERT INTO order_history (order_id, order_status_id, comment, date_added)
        VALUES (in_order_id, in_order_status_id, in_comment, NOW());

        COMMIT;
    END$$
    DELIMITER ;

-- 1.2. Добавление данных в заказы
    INSERT INTO online_shop.`order`
    (invoice_no, customer_id, company, address, city, zone_id, payment_method, shipping_method, comment, total, order_status_id, date_added, date_modified)
    VALUES('1111', 1, 'test', 'Ул. Пушкина дом Колотушкина', 'Default city', 1, 'online', 'Доставка', '', 1000, 1, NOW(), NOW());

-- 1.3. Вызов процедуры
    CALL online_shop.update_order_status(1,2,'TEst!!')

-- 1.4. Проверка данных в заказах и в истории заказов
    SELECT * from `order`;
    SELECT * from `order_history`;


-- 2. Импорт данных

-- 2.1. Создание таблиц для импорта
    CREATE TABLE apparel ( col1 text, col2 text, col3 text, col4 text, col5 text, col6 text, col7 text, col8 text, col9 text, col10 text, col11 text, col12 text, col13 text, col14 text, col15 text, col16 text, col17 text, col18 text, col19 text, col20 text, col21 text, col22 text, col23 text, col24 text, col25 text, col26 text, col27 text, col28 text, col29 text, col30 text, col31 text, col32 text, col33 text, col34 text, col35 text, col36 text, col37 text, col38 text, col39 text, col40 text, col41 text, col42 text, col43 text, col44 text);
    CREATE TABLE bicycles ( col1 text, col2 text, col3 text, col4 text, col5 text, col6 text, col7 text, col8 text, col9 text, col10 text, col11 text, col12 text, col13 text, col14 text, col15 text, col16 text, col17 text, col18 text, col19 text, col20 text, col21 text, col22 text, col23 text, col24 text, col25 text, col26 text, col27 text, col28 text, col29 text, col30 text, col31 text, col32 text, col33 text, col34 text, col35 text, col36 text, col37 text, col38 text, col39 text, col40 text, col41 text, col42 text, col43 text, col44 text);
    CREATE TABLE fashion ( col1 text, col2 text, col3 text, col4 text, col5 text, col6 text, col7 text, col8 text, col9 text, col10 text, col11 text, col12 text, col13 text, col14 text, col15 text, col16 text, col17 text, col18 text, col19 text, col20 text, col21 text, col22 text, col23 text, col24 text, col25 text, col26 text, col27 text, col28 text, col29 text, col30 text, col31 text, col32 text, col33 text, col34 text, col35 text, col36 text, col37 text, col38 text, col39 text, col40 text, col41 text, col42 text, col43 text, col44 text);
    CREATE TABLE jewelry ( col1 text, col2 text, col3 text, col4 text, col5 text, col6 text, col7 text, col8 text, col9 text, col10 text, col11 text, col12 text, col13 text, col14 text, col15 text, col16 text, col17 text, col18 text, col19 text, col20 text, col21 text, col22 text, col23 text, col24 text, col25 text, col26 text, col27 text, col28 text, col29 text, col30 text, col31 text, col32 text, col33 text, col34 text, col35 text, col36 text, col37 text, col38 text, col39 text, col40 text, col41 text, col42 text, col43 text, col44 text);
    CREATE TABLE snowdevil ( col1 text, col2 text, col3 text, col4 text, col5 text, col6 text, col7 text, col8 text, col9 text, col10 text, col11 text, col12 text, col13 text, col14 text, col15 text, col16 text, col17 text, col18 text, col19 text, col20 text, col21 text, col22 text, col23 text, col24 text, col25 text, col26 text, col27 text, col28 text, col29 text, col30 text, col31 text, col32 text, col33 text, col34 text, col35 text, col36 text, col37 text, col38 text, col39 text, col40 text, col41 text, col42 text, col43 text, col44 text);

-- 2.2. Пример импорта через LOAD DATA
    LOAD DATA INFILE 'w:\userdata\php_upload\jewelry.csv'
    INTO TABLE jewelry
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

-- 2.3. Пример импорта через mysqlimport
    mysqlimport -u root --force --ignore-lines=1 --fields-terminated-by=',' --fields-enclosed-by='\"' --lines-terminated-by='\n' upload_test  w:\userdata\php_upload\jewelry.csv;

