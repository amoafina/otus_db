    

    -- Подсчет суммы заказов с типами оплаты "Онлайн" и "Не онлайн" по месяцам за 1 год
    SELECT 
        YEAR(o.date_added) AS year,
        MONTH(o.date_added) AS month,
        SUM(CASE WHEN o.payment_code = 'cod' THEN o.total END) AS cod_total,
        SUM(CASE WHEN o.payment_code <> 'cod' THEN o.total END) AS not_cod_total
    FROM `order` o
    WHERE 
        o.date_added >= '2021-01-01' 
        AND o.date_added <= '2021-12-31'    
    GROUP BY YEAR(o.date_added), MONTH(o.date_added) WITH ROLLUP;


    -- Подсчет суммы заказов с типами оплаты "Онлайн" и "Не онлайн" по месяцам с подсчетом итого
    SET sql_mode = '';
    SELECT 
        IF(GROUPING(YEAR(o.date_added)), 'Все года', YEAR(o.date_added)) AS year,
        IF(GROUPING(MONTH(o.date_added)), 'Все месяца', MONTH(o.date_added)) AS month,
        SUM(CASE WHEN o.payment_code = 'cod' THEN o.total END) AS cod_total,
        SUM(CASE WHEN o.payment_code <> 'cod' THEN o.total END) AS not_cod_total
    FROM `order` o
    GROUP BY YEAR(o.date_added), MONTH(o.date_added) WITH ROLLUP
    ORDER BY YEAR(o.date_added), MONTH(o.date_added);


    -- Максимальная и минимальная цена товара и кол-во товаров
    SELECT 
        MAX(p.price) AS max_price,
        MIN(p.price) AS min_price,
        COUNT(p.id) AS product_count
    FROM product p
    WHERE p.price > 0;


    -- Подсчет кол-ва товаров в каждой категории
    SELECT 
        IF(GROUPING(cd.name), 'Все товары', cd.name) AS category_name,
        COUNT(p2c.product_id) AS product_count
    FROM product_to_category p2c
    INNER JOIN category_description cd
        ON cd.category_id = p2c.category_id
    GROUP BY cd.name WITH ROLLUP;


    -- Товар с максимальной и минимальной ценой в каждой категории
    WITH temp_product AS (
        SELECT 
            cd.name AS category_name, 
            pd.name AS product_name, 
            p.price AS price
        FROM category_description cd
        INNER JOIN product_to_category p2c
            ON p2c.category_id = cd.category_id
        INNER JOIN product p
            ON p.id = p2c.product_id
        INNER JOIN product_description pd
            ON pd.product_id = p.id
            AND pd.language_id = 1
        WHERE cd.language_id = 1
            AND p.price > 0
    ),
    temp_max_price AS (
        SELECT tt.category_name, MAX(tt.price) AS price
        FROM temp_product tt
        GROUP BY tt.category_name
    ),
    temp_min_price AS (
        SELECT tt.category_name, MIN(tt.price) AS price
        FROM temp_product tt
        GROUP BY tt.category_name
    )
    SELECT 
        tt.category_name, tt.product_name, tt.price
    FROM temp_product tt
    LEFT JOIN temp_max_price tt2
        ON tt2.category_name = tt.category_name
        AND tt2.price = tt.price
    LEFT JOIN temp_min_price tt3
        ON tt3.category_name = tt.category_name
        AND tt3.price = tt.price
    WHERE 
        tt2.price IS NOT NULL
        OR tt3.price IS NOT NULL
    ORDER BY tt.category_name, tt.price;
