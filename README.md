# ДЗ № 10. Типы данных в MySQL 

## 1. Изменения типов данных

### Таблица language
    language_id INT(11) -> TINYINT(3) - Языков не будет больше 1000
    sort_order INT(3) -> TINYINT(3) - Для длины в 3 уместнее tynyint
### Таблица customer
    language_id INT(11) -> TINYINT(3) - Изменился тип данных в таблице language
    + custom_field JSON - Добавлено поле для сохранения дополнительных, необязательных данных о пользователе, с развитием магазина, например пол или рост.

### Таблица customer_group
    sort_order INT(3) -> TINYINT(3) - Для длины в 3 уместнее tynyint

### Таблица customer_group_description
    language_id INT(11) -> TINYINT(3) - Изменился тип данных в таблице language

### Таблица attribute
    sort_order INT(3) -> TINYINT(3) - Для длины в 3 уместнее tynyint

### Таблица attribute_description
    language_id INT(11) -> TINYINT(3) - Изменился тип данных в таблице language

### Таблица attribute_group
    sort_order INT(3) -> TINYINT(3) - Для длины в 3 уместнее tynyint

### Таблица attribute_group_description
    language_id INT(11) -> TINYINT(3) - Изменился тип данных в таблице language

### Таблица category
    sort_order INT(3) -> INT(11) - Категорий может быть много, поэтому и длина числа сортировки увеличена

### Таблица category_description
    language_id INT(11) -> TINYINT(3) - Изменился тип данных в таблице language

### Таблица manufacturer
    sort_order INT(3) -> INT(11) - Производителей может быть много, поэтому и длина числа сортировки увеличена

### Таблица manufacturer_description
    language_id INT(11) -> TINYINT(3) - Изменился тип данных в таблице language
    name VARCHAR(64) -> VARCHAR(128) - Наименование производителя может быть длиннее, чем 64 символа

### Таблица option
    sort_order INT(3) -> TINYINT(3) - Для длины в 3 уместнее tynyint

### Таблица option_description
    language_id INT(11) -> TINYINT(3) - Изменился тип данных в таблице language

### Таблица option_value
    sort_order INT(3) -> TINYINT(3) - Для длины в 3 уместнее tynyint

### Таблица option_value_description
    language_id INT(11) -> TINYINT(3) - Изменился тип данных в таблице language

### Таблица order_status
    order_status_id INT(11) -> TINYINT(3) - Статусов заказов не такое большое количество
    language_id INT(11) -> TINYINT(3) - Изменился тип данных в таблице language
    sort_order INT(11) -> TINYINT(3) - Для малого кол-ва статусов, не нужно длинное число для сортировки

### Таблица cart
    option TEXT -> JSON - Для хранения значений опций лучше использовать JSON

### Таблица order
    invoice_no INT(11) -> VARCHAR(16) - Код заказа может содержать буквы
    order_status_id INT(11) -> TINYINT(3) - Изменился тип данных связанной таблицы

### Таблица order_history
    order_status_id INT(11) -> TINYINT(3) - Изменился тип данных связанной таблицы

### Таблица product_attribute
    language_id INT(11) -> TINYINT(3) - Изменился тип данных в таблице language

### Таблица product_description
    language_id INT(11) -> TINYINT(3) - Изменился тип данных в таблице language

## 2. Примеры SQL c использованием JSON 

### Добавление данных о пользователе, с информацией о его росте

    UPDATE customer SET
        custom_field = '{"height": "185"}'
    WHERE id = 1;

### Поиск данных о пользователях выше 180

    SELECT 
        id,
        firstname,
        lastname,
        telephone,
        custom_field->>"$.height" AS height
    FROM customer WHERE custom_field->>"$.height" > 180;