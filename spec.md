# Домашнее задание №2

Добавление в модель данных дополнительных индексов и ограничений

## Таблицы

### address - Хранилище сохраненных адресов покупателей
Будет поиск по id покупателя, а также возможен по id региона доставки, если у покупателя несколько адресов по стране/региону

+ Индекс на поле customer_id
+ Индекс на поле zone_id

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| address_id | INT(11) | PK, NOT NULL |
| customer_id | INT(11) | FK -> customer, NOT NULL |
| company | VARCHAR(40) |  |
| address | VARCHAR(128) | NOT NULL |
| city | VARCHAR(128) | NOT NULL |
| postcode | VARCHAR(10) |  |
| zone_id | INT(11) | FK -> zone, NOT NULL |

### customer - Покупатели
Возможен поиск по email, telephone, при авторизации пользователя. Также возможен поиск по полю newsletter, при составлении списка покупателей, кто подписан на новости, при отправке рассылки, по полю customer_group_id, при отборе покупателей определенной группы, и по полю date_added при отборе в отчетах о кол-ве зарегистрированных пользователей за определенную дату.

+ Индекс на поле email
+ Индекс на поле telephone
+ Индекс на поле customer_group_id (возможен)
+ Индекс на поле date_added (возможен)
  
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| customer_id | INT(11) | PK, NOT NULL |
| customer_group_id | INT(11) | FK -> customer_group, NOT NULL |
| language_id | INT(11) | FK -> language, NOT NULL |
| firstname | VARCHAR(32) | NOT NULL |
| lastname | VARCHAR(32) |  |
| email | VARCHAR(96) | NOT NULL, UNIQUE |
| telephone | VARCHAR(32) | NOT NULL, UNIQUE |
| password | VARCHAR(40) | NOT NULL |
| salt | VARCHAR(9) | NOT NULL |
| newsletter | TINYINT(1) | NOT NULL |
| address_id | INT(11) | FK -> address |
| status | TINYINT(1) | NOT NULL |
| date_added | DATETIME | NOT NULL |

### customer_group – группа покупателей
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| customer_group_id | INT(11) | PK, NOT NULL |
| sort_order | INT(3) | NOT NULL |

### customer_group_description – текстовая информация для группы покупателей
Необходимые поля находятся в PK, поэтому индексы не требуются
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| customer_group_id | INT(11) | PK, FK -> customer_group, NOT NULL |
| language_id | INT(11) | PK, FK -> language, NOT NULL |
| name | VARCHAR(32) | NOT NULL |
| description | TEXT |  |

### attribute – атрибуты для товаров, например «Материал»
Будет поиск по attribute_key из бэкенда, для быстрого доступа к свойству.

+ Индекс на поле attribute_key

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| attribute_id | INT(11) | PK |
| attribute_group_id | INT(11)  | FK -> attribute_group, NOT NULL, NOT NULL |
| sort_order | INT(3) |  |
| attribute_key | VARCHAR(64) | NOT NULL, UNIQUE |

### attribute_description – текстовая информация атрибутов товара
Необходимые поля находятся в PK, поэтому индексы не требуются
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| attribute_id | INT(11) | PK, FK -> attribute, NOT NULL |
| language_id | INT(11) | PK, FK -> language, NOT NULL |
| name | VARCHAR(64)  | NOT NULL |

### attribute_group – группа атрибутов
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| attribute_group_id | INT(11) | PK, NOT NULL |
| sort_order | INT(3) | NOT NULL |

### attribute_group_description – текстовая информация групп атрибутов
Необходимые поля находятся в PK, поэтому индексы не требуются
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| attribute_group_id | INT(11) | PK, FK -> attribute_group, NOT NULL |
| language_id | INT(11) | PK, FK -> language, NOT NULL |
| name | VARCHAR(64) | NOT NULL |

### category – категории товаров
Возможен поиск по parent_id, при отборе дочерних категорий

+ Индекс на поле parent_id (возможен)
 
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| category_id | INT(11) | PK, NOT NULL |
| image | VARCHAR(255) |  |
| parent_id | INT(11) |  |
| sort_order | INT(3) | NOT NULL |
| status | TINYINT(1) | NOT NULL |
| date_added | DATETIME  | NOT NULL |
| date_modified | DATETIME |  |

### category_description – текстовая информация категорий товаров
Возможен поиск по наименованию категории.

+ Индекс на поле name (возможен)
 
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| category_id | INT(11) | PK, FK -> category, NOT NULL |
| language_id | INT(11) | PK, FK -> language, NOT NULL |
| name | VARCHAR(255) | NOT NULL |
| description | TEXT |  |

### manufacturer - производители
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| manufacturer_id | INT(11) | PK, NOT NULL |
| image | VARCHAR(255) |  |
| sort_order | INT(3) | NOT NULL |
| status | TINYINT(1) | NOT NULL |
| date_added | DATETIME  | NOT NULL |
| date_modified | DATETIME |  |

### manufacturer_description – текстовая информация производителей
Возможен поиск по наименованию производителя.

+ Индекс на поле name (возможен)
 
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| manufacturer_id | INT(11) | PK, FK -> manufacturer, NOT NULL |
| language_id | INT(11) | PK, FK -> language, NOT NULL |
| name | VARCHAR(255) | NOT NULL |
| description | TEXT |  |

### option – опции товара, которые влияют на стоимость, например «Размер»
Возможен поиск по типу.

+ Индекс на поле type (возможен)
 
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| option_id | INT(11) | PK, NOT NULL |
| type | VARCHAR(32) | NOT NULL |
| sort_order | INT(3) | NOT NULL |

### option_description – текстовое описание опции
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| option_id | INT(11) | PK, FK -> option, NOT NULL |
| language_id | INT(11) | PK, FK -> language, NOT NULL |
| name | VARCHAR(128) | NOT NULL |

### option_value – значение опции, с типом «Выбор из списка»
Будет поиск по option_id

+ Индекс на поле option_id
+ Уникальный индекс на поля (option_id, value)

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| option_value_id | INT(11) | PK, NOT NULL |
| option_id | INT(11) | FK -> option, NOT NULL, UNIQUE() |
| image | VARCHAR(255) |  |
| value | VARCHAR(255) | NOT NULL, UNIQUE() |
| sort_order | INT(3) | NOT NULL |

### option_value_description - текстовое описание значений опций, с типом «Выбор из списка»
Необходимые поля находятся в PK, поэтому индексы не требуются
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| option_value_id | INT(11) | PK, FK -> option_value, NOT NULL |
| language_id | INT(11) | PK, FK -> language, NOT NULL |
| option_id | INT(11) | PK, FK -> option, NOT NULL  |
| name | VARCHAR(128)  | NOT NULL |

### order_status – список статусов заказа
Необходимые поля находятся в PK, поэтому индексы не требуются
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| order_status_id | INT(11) | PK, NOT NULL |
| language_id | INT(11) | PK, FK -> language, NOT NULL |
| name | VARCHAR(32) | NOT NULL |
| sort_order | INT(11) | NOT NULL |

### cart - корзина
Будет поиск по customer_id

+ Индекс на поле customer_id

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| cart_id | INT(11) | PK, NOT NULL |
| customer_id | INT(11) | FK -> customer, NOT NULL, UNIQUE |
| product_id | INT(11) | FK -> product, NOT NULL |
| option | TEXT |  |
| quantity | INT(5) | NOT NULL, CHECK (quantity > 0) |
| date_added | DATETIME | NOT NULL |

### order - заказы
Будет поиск по invoice_no, customer_id.
Возможен поиск в отчетах по городам, ID регионов, статусу и дате добавления.

+ Индекс на поле invoice_no
+ Индекс на поле customer_id
+ Индекс на поле zone_id (возможен)
+ Индекс на поле city (возможен)
+ Индекс на поле date_added (возможен)

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| order_id | INT(11) | PK, NOT NULL |
| invoice_no | INT(11) | NOT NULL, UNIQUE |
| customer_id | INT(11) | FK -> customer, NOT NULL |
| company | VARCHAR(40) |  |
| address | VARCHAR(128) |  |
| city | VARCHAR(128) | NOT NULL |
| zone_id | INT(11) | FK -> zone, NOT NULL |
| shipping_method | VARCHAR(128) |  |
| payment_method | VARCHAR(128) |  |
| comment | TEXT |  |
| total | DECIMAL(15,4)  | NOT NULL, CHECK (total > 0) |
| order_status_id | INT(11) | NOT NULL |
| date_added | DATETIME | NOT NULL |
| date_modified | DATETIME |  |

### order_history – история изменения статусов заказа
Будет поиск по order_id, возможен по date_added.

+ Индекс на поле order_id
+ Индекс на поле date_added (возможен)

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| order_history_id | INT(11) | PK, NOT NULL |
| order_id | INT(11) | FK -> order, NOT NULL |
| order_status_id | INT(11) | FK -> order_status, NOT NULL |
| comment | TEXT |  |
| date_added | DATETIME | NOT NULL |

### order_option – опции товара в заказе
Будет поиск по order_id, остальные поля можно не добавлять в индекс, так как в таблице уже есть необходимые данные, которые не потребуется джойнить в отчетах.

+ Индекс на поле order_id

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| order_option_id | INT(11) | PK, NOT NULL |
| order_id | INT(11) | FK -> order, NOT NULL |
| order_product_id | INT(11) | FK -> order_product, NOT NULL |
| product_option_id | INT(11) | FK -> product_option, NOT NULL |
| product_option_value_id | INT(11) | FK -> product_option_value |
| name | VARCHAR(255) | NOT NULL |
| value | TEXT |  |
| type | VARCHAR(32)  | NOT NULL |

### order_product – товары в заказе
Будет поиск по order_id, остальные поля можно не добавлять в индекс, так как в таблице уже есть необходимые данные, которые не потребуется джойнить в отчетах.

+ Индекс на поле order_id

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| order_product_id | INT(11) | PK, NOT NULL |
| order_id | INT(11) | FK -> order, NOT NULL |
| product_id | INT(11) | FK -> product, NOT NULL |
| name | VARCHAR(255) | NOT NULL |
| code | VARCHAR(64) | NOT NULL |
| quantity | INT(4) | NOT NULL, CHECK (quantity > 0) |
| price | DECIMAL(15,4) | NOT NULL, CHECK (price > 0) |
| total | DECIMAL(15,4) | NOT NULL, CHECK (total > 0) |

### order_total – суммы, которые формируют итого заказа (например Старая цена, Скидка и т.п.)
Будет поиск по order_id.

+ Индекс на поле order_id
  
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| order_total_id | INT(11) | PK, NOT NULL |
| order_id | INT(11) | FK -> order, NOT NULL |
| code | VARCHAR(32) | NOT NULL |
| title | VARCHAR(255) | NOT NULL |
| value | DECIMAL(15,4)  | NOT NULL |
| sort_order | INT(3) | NOT NULL |

### product - товары
Будет поиск по code.
Возможен поиск по date_available, manufacturer_id и date_added.

+ Индекс на поле code
+ Индекс на поле date_available (возможен)
+ Индекс на поле manufacturer_id (возможен)
+ Индекс на поле date_added (возможен)
  
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| product_id | INT(11) | PK, NOT NULL |
| code | VARCHAR(64) | NOT NULL, UNIQUE |
| quantity | INT(4) | NOT NULL, CHECK (quantity >= 0) |
| image | VARCHAR(255) |  |
| manufacturer_id | INT(11) | FK -> manufacturer |
| price | DECIMAL(15,4) | NOT NULL, CHECK (quantity > 0)  |
| date_available | DATE | NOT NULL |
| sort_order | INT(11) | NOT NULL |
| status | TINYINT(1) | NOT NULL |
| date_added | DATETIME | NOT NULL |
| date_modified | DATETIME |  |

### product_attribute – атрибуты привязанные к товарам
Необходимые поля находятся в PK, поэтому индексы не требуются
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| product_id | INT(11) | PK, FK -> product, NOT NULL |
| attribute_id | INT(11) | PK, FK -> attribute, NOT NULL |
| language_id | INT(11) | PK, FK -> language, NOT NULL |
| text | TEXT | NOT NULL |

### product_description – текстовая информация товаров
Будет поиск по name.
Другие поля находятся в PK, поэтому остальные индексы не требуются

+ Индекс на поле name
  
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| product_id | INT(11) | PK, FK -> product, NOT NULL |
| language_id | INT(11) | PK, FK -> language, NOT NULL |
| name | VARCHAR(255) | NOT NULL |
| description | TEXT |  |

### product_discount – скидки для товаров, в зависимости от кол-ва
Будет поиск по product_id и customer_group_id. А также по date_start и date_end

+ Индекс на поле product_id
+ Индекс на поле customer_group_id
+ Индекс на поле date_start
+ Индекс на поле date_end
+ Уникальный индекс на поля (customer_group_id, product_id, quantity, date_start)
  
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| product_discount_id | INT(11) | PK, NOT NULL |
| product_id | INT(11) | FK -> product, NOT NULL, UNIQUE() |
| customer_group_id | INT(11) | FK -> customer_group, NOT NULL, UNIQUE() |
| quantity | INT(4) | NOT NULL, CHECK (quantity > 0), UNIQUE() |
| priority | INT(5) | NOT NULL |
| price | DECIMAL(15,4) | NOT NULL, CHECK (price > 0) |
| date_start | DATE | NOT NULL, UNIQUE() |
| date_end | DATE | NOT NULL, CHECK (date_end > NOW()) |

### product_image – изображения товаров
Будет поиск по product_id.

+ Индекс на поле product_id
+ Уникальный индекс на поля (product_id, image)

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| product_image_id | INT(11) | PK, NOT NULL |
| product_id | INT(11) | FK -> product, NOT NULL, UNIQUE() |
| image | VARCHAR(255) | NOT NULL, UNIQUE() |
| sort_order | INT(3) | NOT NULL |

### product_option – опции, привязанные к товару
Будет поиск по product_id, option_id.

+ Индекс на поле product_id
+ Индекс на поле option_id
+ Уникальный индекс на поля (product_id, option_id)

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| product_option_id | INT(11) | PK, NOT NULL |
| product_id | INT(11) | FK -> product, NOT NULL, UNIQUE() |
| option_id | INT(11) | FK -> option, NOT NULL, UNIQUE() |
| value | TEXT | NOT NULL |
| required | TINYINT(1) | NOT NULL |

### product_option_value – значения опций, привязанные к товару
Будет поиск по product_id, product_option_id, option_id, option_value_id.

+ Индекс на поле product_id
+ Индекс на поле product_option_id
+ Индекс на поле option_id
+ Индекс на поле option_value
+ Уникальный индекс на поля (product_id, option_id, product_option_id, option_value_id)

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| product_option_value_id | INT(11) | PK, NOT NULL |
| product_option_id | INT(11) | FK -> product_option, NOT NULL, UNIQUE() |
| product_id | INT(11) | FK -> product, NOT NULL , UNIQUE()|
| option_id | INT(11) | FK -> option, NOT NULL, UNIQUE() |
| option_value_id | INT(11) | FK -> option_value, NOT NULL, UNIQUE() |
| quantity | INT(3) | NOT NULL, CHECK (quantity > 0) |
| price | DECIMAL(15,4) | NOT NULL, CHECK (price > 0) |
| price_prefix | VARCHAR(1) | NOT NULL |
| is_default | TINYINT(1) | NOT NULL |

### product_special – скидка на товар
Будет поиск по product_id, customer_group_id. А также по date_start и date_end

+ Индекс на поле product_id
+ Индекс на поле customer_group_id
+ Индекс на поле date_start
+ Индекс на поле date_end
+ Уникальный индекс на поля (customer_group_id, product_id, date_start)
  
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| product_special_id | INT(11) | PK, NOT NULL |
| product_id | INT(11) | FK -> product, NOT NULL, UNIQUE() |
| customer_group_id | INT(11) | FK -> customer_group, NOT NULL, UNIQUE() |
| priority | INT(5) | NOT NULL |
| price | DECIMAL(15,4) | NOT NULL, CHECK (price > 0) |
| date_start | DATE | NOT NULL, UNIQUE() |
| date_end | DATE | NOT NULL, CHECK (date_end > NOW()) |

### product_to_category – связи товаров с категориями
Все необходимые поля в PK. Поэтому доп. индексы не требуются.

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| product_id | INT(11) | PK, NOT NULL |
| category_id | INT(11) | PK, NOT NULL |

### language - языки
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| language_id | INT(11) | PK, NOT NULL |
| name | VARCHAR(32) | NOT NULL |
| code | VARCHAR(5) | NOT NULL, UNIQUE |
| locale | VARCHAR(255) | NOT NULL, UNIQUE |
| sort_order | INT(3) | NOT NULL |
| status | TINYINT(1) | NOT NULL |

### zone – регионы и города
Будет поиск по полю parent_id, name

+ Индекс на поле parent_id
+ Индекс на поле name
 
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| zone_id | INT(11) | PK, NOT NULL |
| parent_id | INT(11) |  |
| sort_order | INT(11) | NOT NULL |
| priority | TINYINT(1) |  |
| name | VARCHAR(128) | NOT NULL |
| code | VARCHAR(32) | NOT NULL, UNIQUE |
| status | TINYINT(1) | NOT NULL |

