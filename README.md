# Домашняя работа № 15. Хранимые процедуры и триггеры.

## 1. Создание пользователей.

### client
    CREATE USER 'client'@'localhost' IDENTIFIED WITH mysql_native_password BY '***';
    ALTER USER 'client'@'localhost' REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;

### manager
    CREATE USER 'manager'@'localhost' IDENTIFIED WITH mysql_native_password BY '***';
    ALTER USER 'manager'@'localhost' REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;

## 2. Создание хранимых процедур.

### Отбор товаров для Клиента

### Отбор заказов для Менеджера

## 3. Раздача прав.
### client
    GRANT SELECT ON `test`.* TO 'client'@'localhost';
    GRANT EXECUTE ON `test`.* TO 'client'@'localhost';
### manager
    GRANT SELECT ON `test`.* TO 'manager'@'localhost';
    GRANT EXECUTE ON `test`.* TO 'manager'@'localhost';