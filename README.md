# Домашняя работа № 11. DML: вставка, обновление, удаление, выборка данных.

## 1. Запрос с INNER JOIN. Подсчет количества товаров в категории.
    SELECT COUNT(p.id) AS total
    FROM product_to_category p2c
    INNER JOIN product p
        ON p.id = p2c.product_id
    WHERE p.status = '1' 
        AND p.date_available <= NOW() 
        AND p2c.category_id = 20;

## 2. Запрос с LEFT JOIN. Получить топ 5 самых продаваемых товаров.

    SELECT p.id, SUM(op.quantity) AS total 
    FROM product p 
    LEFT JOIN order_product op 
        ON op.product_id = p.id 
    LEFT JOIN `order` o 
        ON op.order_id = o.id
    WHERE 
        o.order_status_id = 7 
        AND p.status = 1
        AND p.date_available <= NOW() 
    GROUP BY p.id 
    ORDER BY total DESC LIMIT 5;

## 3. Запрос с WHERE.

### 3.1 Cравнение на равенство. 
###     Поиск активных товаров.
    
    SELECT p.* FROM product p WHERE p.status = 1;

### 3.2 Cравнение на неравенство.
###     Поиск любых активных заказов.

    SELECT o.* FROM `order` o WHERE o.order_status_id <> 0

### 3.3 Поиск в диапазоне.
###     Поиск товаров для нескольких схожих категорий.
    
    SELECT p.* 
    FROM product p
    INNER JOIN product_to_category p2c
        ON p.id = p2c.product_id
    WHERE p2c.category_id IN (1, 3, 5);

### 3.4 Cравнение на больше чем или равно.
###     Поиск товаров от стоимостью от 3000.

    SELECT p.* FROM product p WHERE price >= 3000;

### 3.5 Cравнение на LIKE.
###     Поиск товаров с наименованием содержащим слово "сок"

    SELECT p.id, pd.name, p.price, p.quantity 
    FROM product p 
    INNER JOIN product_description pd
        ON pd.product_id = p.id
        AND pd.language_id = 1
    WHERE pd.name LIKE '%сок%';
    