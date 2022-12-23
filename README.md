# Курсовой проект в рамках курса "Базы данных" на тему "Мессенджер".

## 1. Введение.
Задачей данного проекта, является создание отказоустойчивого кластера с использованием MySQL для реализации простого мессенджера.  
Какими функциями будет обладать мессенджер:  
+ Создание\Чтение диалогов с одним пользователем
+ Создание\Чтение диалогов с несколькими пользователями (чаты)
+ Создание сообщений
+ Добавление к сообщениям медиафайлов
+ Отслеживание статусов прочтения сообщений
+ Ответ на сообщения  

Мессенджер должен хранить сообщения в зашифрованном виде  

Для реализации данного проекта были выбраны:
+ Кластер InnoDB Master + 2 Replica
+ Backend на PHP для демонстрации
+ Описание API с использованием Swagger (OpenAPI) 

## 2. Схема БД

### 2.1. conversation - Диалоги

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| uid | VARCHAR(64) | PK, NOT NULL |
| title | VARCHAR(128) | NULL, Заголовок чата |
| encrypt_key | VARBINARY(16) | NOT NULL, Ключ шифрования сообщений |
| encrypt_vector | VARBINARY(16) | NOT NULL |
| date_added | TIMESTAMP | NOT NULL, CURRENT_TIMESTAMP, Дата добавления. UTC |


### 2.2. conversation_member - Таблица для хранения пользователей чата

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| conversation_uid | VARCHAR(64) | FK (conversation -> uid), NOT NULL, UID диалога |
| author_uid | VARCHAR(64) | FK (user -> uid), NOT NULL, UID Пользователя в чате |
| date_added | TIMESTAMP | NOT NULL, CURRENT_TIMESTAMP, Дата добавления. UTC |

Индексы  

Уникальный индекс `conversation_member_unq_idx` (`conversation_uid`,`author_uid`)   
Индекс `conversation_author_uid_fk` (`author_uid`)  
Индекс `conversation_uid_fk` (`conversation_uid`)



### 2.3. message - Таблица для хранения сообщений в диалоге

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| uid | VARCHAR(64) | PK, NOT NULL, UID сообщения |
| conversation_uid | VARCHAR(64) | FK (conversation -> uid), NOT NULL, UID диалога |
| author_uid | VARCHAR(64) | FK (user -> uid), NOT NULL, UID автора сообщения |
| body | TEXT | NOT NULL, Текст сообщения |
| parent_message_uid | VARCHAR(64) | FK (message -> uid) NULL, UID сообщения, в ответ на которое создано текущее |
| date_added | TIMESTAMP | NOT NULL, CURRENT_TIMESTAMP, Дата добавления. UTC |

Индексы  

Уникальный индекс `message_conversation_fk` (`conversation_uid`)  
Индекс `message_author_fk` (`author_uid`)    
Индекс `message_parent_fk` (`parent_message_uid`)  


### 2.4. message_attachment - Таблица для хранения прикрепленных медиа

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| message_uid | VARCHAR(64) | FK (message -> uid) NOT NULL, UID Сообщения, к которому прикреплен медиа файл |
| upload_uid | VARCHAR(64) | FK (upload -> uid), NOT NULL, ID медиа файла |

Индексы    

Уникальный индекс `attachment_unq_idx` (`message_uid`,`upload_id`)   
Индекс `attachment_message_uid_fk` (`message_uid`)  
Индекс `attachment_upload_uid_fk` (`upload_id`)    

### 2.5. message_status_journal - Таблица для хранения статусов сообщений

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| message_uid | VARCHAR(64) | FK (message -> uid), NOT NULL, UID Сообщения, к которому прикреплен медиа файл |
| author_uid | VARCHAR(64) | FK (user -> uid), NOT NULL, UID автора сообщения |
| status | TINYINT(1) | NOT NULL, Статус сообщения в чате (0 - отправлено, 1 - прочитано) |
| date_added | TIMESTAMP | NOT NULL, CURRENT_TIMESTAMP, Дата добавления. UTC |


Индексы    

Уникальный индекс `message_status_unq_idx` (`message_uid`,`author_uid`)   
Индекс `message_uid_fk1` (`message_uid`)  
Индекс `message_author_uid_fk1` (`author_uid`)   


### 2.6. user - Таблица для хранения пользователей

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| id  | INT(11)  | PK, NOT NULL  AUTO_INCREMENT |
| uid  | VARCHAR(64)  | NOT NULL  |
| firstname  | VARCHAR(32)  | NOT NULL  |
| lastname  | VARCHAR(32)  | NOT NULL  |
| email  | VARCHAR(96)  | NOT NULL  |
| telephone  | VARCHAR(32)  | NOT NULL  |
| password  | VARCHAR(40)  | NOT NULL  |
| salt  | VARCHAR(9)  | NOT NULL  |
| status  | TINYINT(1)  | NOT NULL  |
| token  | VARCHAR(64)  | NOT NULL  |
| date_added  | TIMESTAMP  | NOT NULL  |


Индексы    

Уникальный индекс `user_ext_id_unq_idx` (`uid`)  

### 2.7. upload - Таблица для хранения инфо о загрузках

| Наименование поля | Тип поля | Комментарии
| --- | --- | --- |
| uid  | VARCHAR(64)  | PK, NOT NULL  AUTO_INCREMENT |
| name  | VARCHAR(255)  | NOT NULL  |
| filename  | VARCHAR(255)  | NOT NULL  |
| date_added  | TIMESTAMP  | NOT NULL  |

### Схема БД проекта
!['Схема БД проекта'](img/001.png)


## 3. Создание кластера Percona XtraDB Cluster

### 3.1. Создание каталога /pxc/config, в нем файл custom.cnf со следующим содержимым
    [mysqld]
    ssl-ca = /cert/ca.pem
    ssl-cert = /cert/server-cert.pem
    ssl-key = /cert/server-key.pem

    [client]
    ssl-ca = /cert/ca.pem
    ssl-cert = /cert/client-cert.pem
    ssl-key = /cert/client-key.pem

    [sst]
    encrypt = 4
    ssl-ca = /cert/ca.pem
    ssl-cert = /cert/server-cert.pem
    ssl-key = /cert/server-key.pem

### 3.2. Создание каталога /pxc/cert с вышеуказанными сертификатами, сгенерированными через mysql_ssl_rsa_setup 

### 3.3. Создание сети
    docker network create pxc-network

### 3.4. Создание первой ноды
    docker run -d -e MYSQL_ROOT_PASSWORD=wqeD33gDSF# -e CLUSTER_NAME=pxc-cluster -e MYSQL_INITDB=1 -e MYSQL_BOOTSTRAP=1 --name=node1 --network=pxc-network -p 53306:3306 -v <PATH_TO_PROJECT>\pxc\data\node1:/var/lib/mysql/data -v <PATH_TO_PROJECT>\pxc\cert:/cert -v <PATH_TO_PROJECT>\pxc\config:/etc/percona-xtradb-cluster.conf.d -it elchinoo/pxc:latest

### 3.5. Создание второй ноды
    docker run -d -e MYSQL_ROOT_PASSWORD=wqeD33gDSF# -e MYSQL_EXTRA_OPTS="--wsrep-sst-donor=node1 --wsrep-node-name=node2" --name=node2 --network=pxc-network -p 53307:3306 -v <PATH_TO_PROJECT>\pxc\data\node2:/var/lib/mysql/data -v <PATH_TO_PROJECT>\pxc\cert:/cert -v <PATH_TO_PROJECT>\pxc\config:/etc/percona-xtradb-cluster.conf.d -it elchinoo/pxc:latest

### 3.6. Создание третьей ноды
    docker run -d -e MYSQL_ROOT_PASSWORD=wqeD33gDSF# -e MYSQL_EXTRA_OPTS="--wsrep-sst-donor=node1 --wsrep-node-name=node3" --name=node3 --network=pxc-network -p 53308:3306 -v <PATH_TO_PROJECT>\pxc\data\node3:/var/lib/mysql/data -v <PATH_TO_PROJECT>\pxc\cert:/cert -v <PATH_TO_PROJECT>\pxc\config:/etc/percona-xtradb-cluster.conf.d -it elchinoo/pxc:latest

### 3.7. Создание четвертой ноды
    docker run -d -e MYSQL_ROOT_PASSWORD=wqeD33gDSF# -e MYSQL_EXTRA_OPTS="--wsrep-sst-donor=node1 --wsrep-node-name=node4" --name=node4 --network=pxc-network -p 53309:3306 -v <PATH_TO_PROJECT>\pxc\data\node4:/var/lib/mysql/data -v <PATH_TO_PROJECT>\pxc\cert:/cert -v <PATH_TO_PROJECT>\pxc\config:/etc/percona-xtradb-cluster.conf.d -it elchinoo/pxc:latest

### 3.8. Создание пятой ноды
    docker run -d -e MYSQL_ROOT_PASSWORD=wqeD33gDSF# -e MYSQL_EXTRA_OPTS="--wsrep-sst-donor=node1 --wsrep-node-name=node5" --name=node5 --network=pxc-network -p 53310:3306 -v <PATH_TO_PROJECT>\pxc\data\node5:/var/lib/mysql/data -v <PATH_TO_PROJECT>\pxc\cert:/cert -v <PATH_TO_PROJECT>\pxc\config:/etc/percona-xtradb-cluster.conf.d -it elchinoo/pxc:latest

### 3.9. Загрузка дампа БД в первую ноду
    docker cp <PATH_TO_PROJECT>\dump.sql node1:/tmp/

    bin/sh# mysql -uroot -pwqeD33gDSF#

    mysql> create database messenger;
    mysql> source /tmp/dump.sql;

## 4. Создание прокси

### 4.1. Установка образа Proxysql

    docker run -d -e MYSQL_ROOT_PASSWORD=wqeD33gDSF# -e DISCOVERY_SERVICE=10.20.2.4:2379 -e CLUSTER_NAME=pxc-cluster -e MYSQL_PROXY_USER=proxyuser -e MYSQL_PROXY_PASSWORD=s3cret --name=proxynode --network=pxc-network proxysql/proxysql

### 4.2. Добавление нод в прокси и добавление пользователя

    bin/sh# mysql -u admin -padmin -h 127.0.0.1 -P 6032

    mysql> INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (0,'0.0.0.0',53306);
    mysql> INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (0,'0.0.0.0',53307);
    mysql> INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (0,'0.0.0.0',53308);
    mysql> INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (0,'0.0.0.0',53309);
    mysql> INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (0,'0.0.0.0',53310);

    mysql> LOAD MYSQL SERVERS TO RUNTIME;

    mysql> INSERT INTO mysql_users (username,password) VALUES ('sbuser','sbpass');

    mysql> LOAD MYSQL USERS TO RUNTIME;
    mysql> SAVE MYSQL USERS TO DISK;


### 4.3. Добавление пользователя прокси в нодах
   
    bin/sh# mysql -uroot -pwqeD33gDSF#

    mysql> CREATE USER 'sbuser'@'%' IDENTIFIED BY 'sbpass';
    mysql>  GRANT ALL ON *.* TO 'sbuser'@'%';

      
 ### 4.4. Создание пользователя для мониторинга
   
    mysql> CREATE USER `proxysql`@`%` IDENTIFIED WITH mysql_native_password by 'Test12!33';
    mysql> GRANT USAGE ON *.* TO "proxysql"@"%";

    mysql@proxysql> UPDATE global_variables SET variable_value='proxysql' WHERE variable_name='mysql-monitor_username';
    mysql@proxysql> UPDATE global_variables SET variable_value='Test12!33' WHERE variable_name='mysql-monitor_password';

    mysql@proxysql> LOAD MYSQL VARIABLES TO RUNTIME;
    mysql@proxysql> SAVE MYSQL VARIABLES TO DISK;

