# Домашнее задание №1

Проект БД «Интернет-магазин»

В данной БД реализована простая схема организации каталога товаров, данных покупателей, заказов и регионов. Поддержка мультиязычности. Возможность назначать товарам скидки за кол-во, атрибуты, а также опции, влияющие на стоимость товара, таких как, например, Размер пиццы.

## Таблицы

### address - Хранилище сохраненных адресов покупателей
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| address_id | INT(11) |  |
| customer_id | INT(11) |  |
| company | VARCHAR(40) |  |
| address | VARCHAR(128) |  |
| city | VARCHAR(128) |  |
| postcode | VARCHAR(10) |  |
| zone_id | INT(11) |  |

### customer - Покупатели
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| customer_id | INT(11) |  |
| customer_group_id | INT(11) |  |
| language_id | INT(11) | Язык покупателя для отображения на сайте |
| firstname | VARCHAR(32) |  |
| lastname | VARCHAR(32) |  |
| email | VARCHAR(96) |  |
| telephone | VARCHAR(32) |  |
| password | VARCHAR(40) |  |
| salt | VARCHAR(9) |  |
| newsletter | TINYINT(1) | Подписан ли на новости |
| address_id | INT(11) | Основной адрес для доставки |
| status | TINYINT(1) |  |
| date_added | DATETIME |  |

### customer_group – группа покупателей
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| customer_group_id | INT(11) |  |
| sort_order | INT(3) |  |

### customer_group_description – текстовая информация для группы покупателей
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| customer_group_id | INT(11) |  |
| language_id | INT(11) |  |
| name | VARCHAR(32) |  |
| description | TEXT |  |

### attribute – атрибуты для товаров, например «Материал»
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| attribute_id | INT(11) |  |
| attribute_group_id | INT(11)  |  |
| sort_order | INT(3) |  |
| attribute_key | VARCHAR(64) | Уникальный ключ для упрощения обращения к нему в коде сайта |

### attribute_description – текстовая информация атрибутов товара
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| attribute_id | INT(11) |  |
| language_id | INT(11) |  |
| name | VARCHAR(64)  |  |

### attribute_group – группа атрибутов
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| attribute_group_id | INT(11) |  |
| sort_order | INT(3) |  |

### attribute_group_description – текстовая информация групп атрибутов
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| attribute_group_id | INT(11) |  |
| language_id | INT(11) |  |
| name | VARCHAR(64) |  |

### category – категории товаров
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| category_id | INT(11) |  |
| image | VARCHAR(255) |  |
| parent_id | INT(11) | Ссылка на category_id |
| sort_order | INT(3) |  |
| status | TINYINT(1) |  |
| date_added | DATETIME  |  |
| date_modified | DATETIME |  |

### category_description – текстовая информация категорий товаров
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| category_id | INT(11) |  |
| language_id | INT(11) |  |
| name | VARCHAR(255) |  |
| description | TEXT |  |

### manufacturer - производители
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| manufacturer_id | INT(11) |  |
| image | VARCHAR(255) |  |
| sort_order | INT(3) |  |
| status | TINYINT(1) |  |
| date_added | DATETIME  |  |
| date_modified | DATETIME |  |

### manufacturer_description – текстовая информация производителей
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| manufacturer_id | INT(11) |  |
| language_id | INT(11) |  |
| name | VARCHAR(255) |  |
| description | TEXT |  |

### option – опции товара, которые влияют на стоимость, например «Размер»
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| option_id | INT(11) |  |
| type | VARCHAR(32) | 1 – строковый, 2 – выбор из списка |
| sort_order | INT(3) |  |

### option_description – текстовое описание опции
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| option_id | INT(11) |  |
| language_id | INT(11) |  |
| name | VARCHAR(128) |  |

### option_value – значение опции, с типом «Выбор из списка»
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| option_value_id | INT(11) |  |
| option_id | INT(11) |  |
| image | VARCHAR(255) |  |
| value | VARCHAR(255) |  |
| sort_order | INT(3) |  |

### option_value_description - текстовое описание значений опций, с типом «Выбор из списка»
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| option_value_id | INT(11) |  |
| language_id | INT(11) |  |
| option_id | INT(11) |  |
| name | VARCHAR(128)  |  |

### order_status – список статусов заказа
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| order_status_id | INT(11) |  |
| language_id | INT(11) |  |
| name | VARCHAR(32) |  |
| sort_order | INT(11) |  |

### cart - корзина
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| cart_id | INT(11) |  |
| customer_id | INT(11) |  |
| product_id | INT(11) |  |
| option | TEXT | Json с выбранными опциями товара |
| quantity | INT(5) |  |
| date_added | DATETIME |  |

### order - заказы
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| order_id | INT(11) |  |
| invoice_no | INT(11) | Код заказа для клиентов/менеджеров |
| customer_id | INT(11) |  |
| company | VARCHAR(40) |  |
| address | VARCHAR(128) |  |
| city | VARCHAR(128) |  |
| zone_id | INT(11) |  |
| shipping_method | VARCHAR(128) | Код способа доставки |
| payment_method | VARCHAR(128) | Код способа оплаты |
| comment | TEXT |  |
| total | DECIMAL(15,4)  |  |
| order_status_id | INT(11) |  |
| date_added | DATETIME |  |
| date_modified | DATETIME |  |

### order_history – история изменения статусов заказа
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| order_history_id | INT(11) |  |
| order_id | INT(11) |  |
| order_status_id | INT(11) |  |
| comment | TEXT |  |
| date_added | DATETIME  |  |

### order_option – опции товара в заказе
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| order_option_id | INT(11) |  |
| order_id | INT(11) |  |
| order_product_id | INT(11) |  |
| product_option_id | INT(11) |  |
| product_option_value_id | INT(11) |  |
| name | VARCHAR(255) |  |
| value | TEXT |  |
| type | VARCHAR(32)  |  |

### order_product – товары в заказе
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| order_product_id | INT(11) |  |
| order_id | INT(11) |  |
| product_id | INT(11) |  |
| name | VARCHAR(255) |  |
| model | VARCHAR(64) |  |
| quantity | INT(4) |  |
| price | DECIMAL(15,4) |  |
| total | DECIMAL(15,4) |  |

### order_total – суммы, которые формируют итого заказа (например Старая цена, Скидка и т.п.)
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| order_total_id | INT(11) |  |
| order_id | INT(11) |  |
| code | VARCHAR(32) |  |
| title | VARCHAR(255) |  |
| value | DECIMAL(15,4)  |  |
| sort_order | INT(3) |  |

### product - товары
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| product_id | INT(11) |  |
| code | VARCHAR(64) |  |
| quantity | INT(4) |  |
| image | VARCHAR(255) |  |
| manufacturer_id | INT(11) |  |
| price | DECIMAL(15,4) |  |
| date_available | DATE |  |
| sort_order | INT(11) |  |
| status | TINYINT(1) |  |
| date_added | DATETIME |  |
| date_modified | DATETIME |  |

### product_attribute – атрибуты привязанные к товарам
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| product_id | INT(11) |  |
| attribute_id | INT(11) |  |
| language_id | INT(11) |  |
| text | TEXT |  |

### product_description – текстовая информация товаров
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| product_id | INT(11) |  |
| language_id | INT(11) |  |
| name | VARCHAR(255) |  |
| description | TEXT |  |

### product_discount – скидки для товаров, в зависимости от кол-ва
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| product_discount_id | INT(11) |  |
| product_id | INT(11) |  |
| customer_group_id | INT(11) |  |
| quantity | INT(4) | От какого кол-ва начинается скидка |
| priority | INT(5) |  |
| price | DECIMAL(15,4) |  |
| date_start | DATE |  |
| date_end | DATE |  |

### product_image – изображения товаров
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| product_image_id | INT(11) |  |
| product_id | INT(11) |  |
| image | VARCHAR(255) |  |
| sort_order | INT(3) |  |

### product_option – опции, привязанные к товару
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| product_option_id | INT(11) |  |
| product_id | INT(11) |  |
| option_id | INT(11) |  |
| value | TEXT |  |
| required | TINYINT(1) |  |

### product_option_value – значения опций, привязанные к товару
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| product_option_value_id | INT(11) |  |
| product_option_id | INT(11) |  |
| product_id | INT(11) |  |
| option_id | INT(11) |  |
| option_value_id | INT(11) |  |
| quantity | INT(3) |  |
| price | DECIMAL(15,4) | Величина, которая будет + или – к цене |
| price_prefix | VARCHAR(1) | + или – к цене |
| is_default | TINYINT(1) | Значение будет по умолчанию |

### product_special – скидка на товар
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| product_special_id | INT(11) |  |
| product_id | INT(11) |  |
| customer_group_id | INT(11) |  |
| priority | INT(5) |  |
| price | DECIMAL(15,4) |  |
| date_start | DATE |  |
| date_end | DATE |  |

### product_to_category – связи товаров с категориями
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| product_id | INT(11) |  |
| category_id | INT(11) |  |

### language - языки
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| language_id | INT(11) |  |
| name | VARCHAR(32) |  |
| code | VARCHAR(5) |  |
| locale | VARCHAR(255) |  |
| sort_order | INT(3) |  |
| status | TINYINT(1) |  |

### zone – регионы и города
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| zone_id | INT(11) |  |
| parent_id | INT(11) | Ссылка на zone_id |
| sort_order | INT(11) |  |
| priority | TINYINT(1) |  |
| name | VARCHAR(128) |  |
| code | VARCHAR(32) |  |
| status | TINYINT(1) |  |

### geo_zone – объединение регионов в зоны доставки
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| geo_zone_id | INT(11) |  |
| name | VARCHAR(32) |  |
| description | VARCHAR(255) |  |
| date_modified | DATETIME |  |
| date_added | DATETIME |  |

### zone_to_geo_zone – связи регионов с зонами доставки
| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| zone_to_geo_zone_id | INT(11) |  |
| zone_id | INT(11) |  |
| geo_zone_id | INT(11) |  |
| date_added | DATETIME |  |
| date_modified | DATETIME |  |

## Рекомендации к резервному копированию:

1. Раз в месяц
+ order_status
+ language
+ zone

2. Раз в неделю
+ attribute
+ attribute_description
+ attribute_group
+ attribute_group_description
+ option
+ option_description
+ option_value
+ option_value_description 
+ geo_zone
+ zone_to_geo_zone

3. Раз в сутки
+ category
+ category_description
+ manufacturer
+ manufacturer_description
+ product
+ product_attribute
+ product_description
+ product_discount
+ product_image
+ product_option
+ product_option_value
+ product_special
+ product_to_category
  
4. Четыре раза в сутки
+ сart
+ order
+ order_history
+ order_option
+ order_product
+ order_total
