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
!['Схема БД проекта'](001.png)
