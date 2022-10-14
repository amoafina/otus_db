-- Домашняя работа № 6. Индексы

-- 1. Подготовительные работы
-- 1.1. Создание базы данных
    CREATE DATABASE online_shop WITH 
        OWNER = postgres
        ENCODING = 'UTF8'
        TABLESPACE = 'pg_default'
        CONNECTION LIMIT = -1;

-- 1.2. Создание схем
    CREATE SCHEMA IF NOT EXISTS catalog;

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

-- 3. Работа с индексами
-- 3.1. Задача №1 и №5. Обычный и составной индекс
   
   	EXPLAIN (ANALYZE) SELECT p.id, pd.name, pd.description, p.image, p.price 
   	FROM catalog.product p
   	INNER JOIN catalog.product_description pd
   		ON pd.product_id = p.id
   		AND pd.language_id = 1
	WHERE p.price >= 250
	;	
   	
   /*
	    Nested Loop  (cost=0.14..20.08 rows=1 width=1132) (actual time=0.029..0.030 rows=1 loops=1)
		  ->  Seq Scan on product_description pd  (cost=0.00..11.50 rows=1 width=602) (actual time=0.012..0.013 rows=3 loops=1)
		        Filter: (language_id = 1)
		        Rows Removed by Filter: 3
		  ->  Index Scan using product_pkey on product p  (cost=0.14..8.16 rows=1 width=534) (actual time=0.004..0.004 rows=0 loops=3)
		        Index Cond: (id = pd.product_id)
		        Filter: (price >= '250'::numeric)
		        Rows Removed by Filter: 1
		Planning Time: 0.180 ms
		Execution Time: 0.053 ms
    */
   
   -- Создание составного индекса для более быстрого поиска наименований и описаний для товаров определенного языка
   CREATE INDEX product_description_product_id_idx ON catalog.product_description (product_id, language_id);
      	
   /*
	    Nested Loop  (cost=0.14..9.66 rows=1 width=1132) (actual time=0.022..0.023 rows=1 loops=1)
		  ->  Seq Scan on product_description pd  (cost=0.00..1.07 rows=1 width=602) (actual time=0.008..0.009 rows=3 loops=1)
		        Filter: (language_id = 1)
		        Rows Removed by Filter: 3
		  ->  Index Scan using product_pkey on product p  (cost=0.14..8.16 rows=1 width=534) (actual time=0.003..0.003 rows=0 loops=3)
		        Index Cond: (id = pd.product_id)
		        Filter: (price >= '250'::numeric)
		        Rows Removed by Filter: 1
		Planning Time: 0.311 ms
		Execution Time: 0.049 ms
    */
   
   -- Создание индекса на стоимость товара для более быстрого отбора товаров по цене
   CREATE INDEX product_price_idx ON catalog.product(price);
   
  	/*
	    Nested Loop  (cost=0.00..2.12 rows=1 width=1132) (actual time=0.016..0.017 rows=1 loops=1)
		  Join Filter: (p.id = pd.product_id)
		  Rows Removed by Join Filter: 2
		  ->  Seq Scan on product p  (cost=0.00..1.04 rows=1 width=534) (actual time=0.009..0.010 rows=1 loops=1)
		        Filter: (price >= '250'::numeric)
		        Rows Removed by Filter: 2
		  ->  Seq Scan on product_description pd  (cost=0.00..1.07 rows=1 width=602) (actual time=0.003..0.004 rows=3 loops=1)
		        Filter: (language_id = 1)
		        Rows Removed by Filter: 2
		Planning Time: 0.372 ms
		Execution Time: 0.036 ms
  	*/
  
  
-- 3.2. Задача №2. Индекс для полнотекстового поиска

  	-- Ведем поиск на русском
  	EXPLAIN (ANALYZE) SELECT p.id, pd.name, pd.description, p.image, p.price 
   	FROM catalog.product p
   	INNER JOIN catalog.product_description pd
   		ON pd.product_id = p.id
   		AND pd.language_id = 1
  	WHERE to_tsvector(pd.description) @@ plainto_tsquery('ноги')
  	
  	/*
  	    Nested Loop  (cost=0.14..14.62 rows=1 width=1132) (actual time=0.035..0.043 rows=1 loops=1)
		  Join Filter: (p.id = pd.product_id)
		  Rows Removed by Join Filter: 1
		  ->  Index Scan using product_description_pkey on product_description pd  (cost=0.14..13.55 rows=1 width=602) (actual time=0.027..0.035 rows=1 loops=1)
		        Index Cond: (language_id = 1)
		        Filter: (to_tsvector((description)::text) @@ plainto_tsquery('ноги'::text))
		        Rows Removed by Filter: 2
		  ->  Seq Scan on product p  (cost=0.00..1.03 rows=3 width=534) (actual time=0.005..0.006 rows=2 loops=1)
		Planning Time: 0.180 ms
		Execution Time: 0.068 ms
	*/
  	
    -- Создание индекса для полнотекстового поиска на поле с описанием для русского языка
  	CREATE INDEX product_description_ft_search_gin_idx ON catalog.product_description 
	USING gin (to_tsvector('russian', "description"));

	/*
	    Nested Loop  (cost=0.00..5.16 rows=1 width=1132) (actual time=0.044..0.056 rows=1 loops=1)
		  Join Filter: (p.id = pd.product_id)
		  Rows Removed by Join Filter: 1
		  ->  Seq Scan on product_description pd  (cost=0.00..4.09 rows=1 width=602) (actual time=0.037..0.047 rows=1 loops=1)
		        Filter: ((language_id = 1) AND (to_tsvector((description)::text) @@ plainto_tsquery('ноги'::text)))
		        Rows Removed by Filter: 5
		  ->  Seq Scan on product p  (cost=0.00..1.03 rows=3 width=534) (actual time=0.005..0.005 rows=2 loops=1)
		Planning Time: 0.168 ms
		Execution Time: 0.069 ms
	 */


-- 3.3. Индекс на часть таблицы
	
	EXPLAIN (ANALYZE) SELECT * FROM orders.order WHERE order_status = 'Завершен'
  
	/*
	    Seq Scan on "order"  (cost=0.00..10.62 rows=1 width=1398) (actual time=0.050..0.052 rows=2 loops=1)
		  Filter: ((order_status)::text = 'Завершен'::text)
		  Rows Removed by Filter: 3
		Planning Time: 0.078 ms
		Execution Time: 0.065 ms
	*/
	
    -- Создание индекса на часть таблицы с заказами, статус которых - Завершен
	CREATE INDEX order_status_complete_idx on orders.order(order_status) where order_status = 'Завершен';
	
	/*
	    Seq Scan on "order"  (cost=0.00..1.06 rows=1 width=1398) (actual time=0.010..0.012 rows=2 loops=1)
		  Filter: ((order_status)::text = 'Завершен'::text)
		  Rows Removed by Filter: 3
		Planning Time: 0.236 ms
		Execution Time: 0.026 ms
	 */

