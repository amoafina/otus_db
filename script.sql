DELIMITER $$
CREATE DEFINER = 'client'@'localhost' PROCEDURE get_products(
	IN in_category_id int(11),
	IN in_manufacturer_id int(11),
    IN in_price_min decimal(15,4),
    IN in_price_max decimal(15,4),
    IN in_sort_field_name varchar(64),
    IN in_sort_direction varchar(4),
    IN in_limit tinyint(3),
    IN in_offset tinyint(3)
) 
BEGIN
    SELECT 
        p.id,
        p2c.category_id,
        p.manufacturer_id,
        pd.name,
        pd.description,
        p.quantity,
        p.image,
        p.price,
        p.date_available,
        p.sort_order,
        p.status,
        p.date_added
    FROM product p
    INNER JOIN product_to_category p2c
        ON p2c.product_id = p.id
    INNER JOIN product_description pd
        ON pd.product_id = p.id
        AND language_id = 1
    WHERE 
        (p2c.category_id = in_category_id OR in_category_id IS NULL)
        AND (p.manufacturer_id = in_manufacturer_id OR in_manufacturer_id IS NULL)
        AND (p.price >= in_price_min OR in_price_min IS NULL)
        AND (p.price <= in_price_max OR in_price_max IS NULL)
    ORDER BY
        CASE WHEN in_sort_direction = 'ASC' THEN
            CASE 
                WHEN in_sort_field_name = 'name' THEN pd.name
                WHEN in_sort_field_name = 'price' THEN p.price 
                ELSE p.sort_order
            END
        END ASC
        , CASE WHEN in_sort_direction = 'DESC' THEN
            CASE 
                WHEN in_sort_field_name = 'name' THEN pd.name
                WHEN in_sort_field_name = 'price' THEN p.price
                ELSE p.sort_order
            END
        END DESC
    LIMIT in_offset, in_limit;
END$$
DELIMITER ;


call get_products(null, null, 200, 300, 'name', 'DESC', 20, 0);



DROP PROCEDURE get_orders;
DELIMITER $$
CREATE DEFINER = 'manager'@'localhost' PROCEDURE get_orders(
	IN in_date_start datetime,
	IN in_date_end datetime,
    IN in_period_mode varchar(1) CHARSET utf8mb4,
    IN in_group_by_mode varchar(16) CHARSET utf8mb4,
    IN in_limit tinyint(3),
    IN in_offset tinyint(3)
) 
BEGIN
    WITH temp_order_product_q AS (
        SELECT op.order_id, SUM(op.quantity) AS quantity
        FROM `order_product` op
        GROUP BY  op.order_id
    )
    SELECT 
        CASE 
            WHEN in_period_mode = 'h' THEN HOUR(o.date_added)
            WHEN in_period_mode = 'd' THEN DAY(o.date_added)
            WHEN in_period_mode = 'w' THEN WEEK(o.date_added)
            WHEN in_period_mode = 'm' THEN MONTH(o.date_added)
            ELSE DATE(o.date_added)
        END AS date,
        COUNT(o.id) AS `orders`,
        SUM(op.quantity) AS products,
        SUM(o.total)  AS `total`
    FROM `order` o
    INNER JOIN temp_order_product_q op
        ON op.order_id = o.id
    LEFT JOIN product p
        ON p.id = op.product_id
    WHERE o.order_status_id > 0
        AND DATE(o.date_added) >= in_date_start
        AND DATE(o.date_added) <= in_date_end
    GROUP BY 
        CASE 
            WHEN in_period_mode = 'h' THEN HOUR(o.date_added)
            WHEN in_period_mode = 'd' THEN DAY(o.date_added)
            WHEN in_period_mode = 'w' THEN WEEK(o.date_added)
            WHEN in_period_mode = 'm' THEN MONTH(o.date_added)
            ELSE DATE(o.date_added)
        END
    ORDER BY date
    LIMIT in_offset, in_limit;
END$$
DELIMITER ;



call get_orders ('2021-03-01', '2021-05-31', null, null, 31, 0);






