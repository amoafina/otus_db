-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Ноя 05 2022 г., 20:28
-- Версия сервера: 8.0.19
-- Версия PHP: 7.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `messager`
--

-- --------------------------------------------------------

--
-- Структура таблицы `conversation`
--

CREATE TABLE `conversation` (
  `uid` varchar(64) NOT NULL,
  `title` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Заголовок чата',
  `encrypt_key` varbinary(16) NOT NULL COMMENT 'Ключ шифрования сообщений',
  `encrypt_vector` varbinary(16) NOT NULL,
  `date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата добавления. UTC'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Модуль "Диалоги". Таблица для хранения диалогов.';

-- --------------------------------------------------------

--
-- Структура таблицы `conversation_member`
--

CREATE TABLE `conversation_member` (
  `conversation_uid` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'UID Чата (группы пользователей)',
  `author_uid` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'UID Пользователя в чате',
  `date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата добавления. UTC'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Модуль "Диалоги". Таблица для хранения пользователей чата.';

-- --------------------------------------------------------

--
-- Структура таблицы `message`
--

CREATE TABLE `message` (
  `uid` varchar(64) NOT NULL,
  `conversation_uid` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'UID Диалога',
  `author_uid` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'ID автора сообщения',
  `body` text NOT NULL COMMENT 'Текст сообщения',
  `parent_message_uid` varchar(64) DEFAULT NULL COMMENT 'UID сообщения, в ответ на которое создано текущее',
  `date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Модуль "Диалоги". Таблица для хранения сообщений в диалоге.';

-- --------------------------------------------------------

--
-- Структура таблицы `message_attachment`
--

CREATE TABLE `message_attachment` (
  `message_uid` varchar(64) NOT NULL COMMENT 'UID Сообщения, к которому прикреплен медиа файл',
  `upload_uid` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'ID медиа файла'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Модуль "Диалоги". Таблица для хранения прикрепленных медиа';

-- --------------------------------------------------------

--
-- Структура таблицы `message_status_journal`
--

CREATE TABLE `message_status_journal` (
  `message_uid` varchar(64) NOT NULL COMMENT 'UID Сообщения',
  `author_uid` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'UID Пользователя',
  `status` smallint NOT NULL COMMENT 'Статус сообщения в чате (0 - отправлено, 1 - прочитано)',
  `date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата добавления. UTC'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Модуль "Диалоги". Таблица для хранения статусов сообщений.';

-- --------------------------------------------------------

--
-- Структура таблицы `upload`
--

CREATE TABLE `upload` (
  `uid` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `name` varchar(255) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `date_added` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `user`
--

CREATE TABLE `user` (
  `id` int NOT NULL,
  `uid` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `firstname` varchar(32) NOT NULL,
  `lastname` varchar(32) NOT NULL,
  `email` varchar(96) NOT NULL,
  `telephone` varchar(32) NOT NULL,
  `password` varchar(40) NOT NULL,
  `salt` varchar(9) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `token` text NOT NULL,
  `date_added` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `user`
--

INSERT INTO `user` (`id`, `uid`, `firstname`, `lastname`, `email`, `telephone`, `password`, `salt`, `status`, `token`, `date_added`) VALUES
(38, NULL, 'Сергей', 'Тестов', 'sergey_k@wegetpage.ru', '+7 (111) 111-11-12', 'bb008212b6e647b11e4f7c7bd8bc23172f506bcc', 'c2q9K6LQ3', 1, '', '2020-12-20 13:45:19'),
(39, NULL, 'Kirill', '', 'kirill_fad@wegetpage.ru', '79996101000', '3a1a10bc03ece6f840a184288b9496bf4ff34d17', 'BfsFCYbt9', 1, '', '2022-07-05 23:12:21'),
(40, NULL, 'Вася', 'Трудов', 'info@exods.ru', '78961665809', '6b33805b481eb6cf7d58bcf1d50997b64aba0329', 'fbxQ2UNod', 1, '', '2022-07-06 21:07:54'),
(41, NULL, 'Тестовый контрагент от разработ2', 'test', 'exspamistkoz@outlook.com', '79045519118', '0d253afc2e24c0c3a9e9c8e08a786545830d6d18', 'bVyrUdsRB', 1, '', '2022-07-11 20:51:10'),
(42, NULL, 'test', 'test', 'test@test.ee', '71111111111', 'b23e4e1aee7018057679902fe72d5c41156e31c9', 'TWdIhGxGJ', 1, '', '2022-09-30 09:40:09'),
(43, NULL, 'Тест', 'Спб1', 'ilya.90.sp@outlook.com', '70000000001', '7b831a843b22572f505ad6766b7b769c8b3de1dc', 'ArbMO6xQz', 1, '', '2022-09-30 14:05:31');

--
-- Триггеры `user`
--
DELIMITER $$
CREATE TRIGGER `oc_user_generate_uid` BEFORE INSERT ON `user` FOR EACH ROW BEGIN
    IF new.uid IS NULL THEN
      SET new.uid = uuid();
    END IF;
  END
$$
DELIMITER ;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `conversation`
--
ALTER TABLE `conversation`
  ADD PRIMARY KEY (`uid`);

--
-- Индексы таблицы `conversation_member`
--
ALTER TABLE `conversation_member`
  ADD UNIQUE KEY `conversation_member_unq_idx` (`conversation_uid`,`author_uid`) USING BTREE,
  ADD KEY `conversation_author_uid_fk` (`author_uid`) USING BTREE,
  ADD KEY `conversation_uid_fk` (`conversation_uid`);

--
-- Индексы таблицы `message`
--
ALTER TABLE `message`
  ADD PRIMARY KEY (`uid`),
  ADD KEY `message_conversation_fk` (`conversation_uid`),
  ADD KEY `message_parent_fk` (`parent_message_uid`),
  ADD KEY `message_author_fk` (`author_uid`) USING BTREE;

--
-- Индексы таблицы `message_attachment`
--
ALTER TABLE `message_attachment`
  ADD UNIQUE KEY `attachment_unq_idx` (`message_uid`,`upload_uid`) USING BTREE,
  ADD KEY `attachment_upload_uid_fk` (`upload_uid`),
  ADD KEY `attachment_message_uid_fk` (`message_uid`);

--
-- Индексы таблицы `message_status_journal`
--
ALTER TABLE `message_status_journal`
  ADD UNIQUE KEY `message_status_unq_idx` (`message_uid`,`author_uid`),
  ADD KEY `message_author_uid_fk1` (`author_uid`),
  ADD KEY `message_uid_fk1` (`message_uid`) USING BTREE;

--
-- Индексы таблицы `upload`
--
ALTER TABLE `upload`
  ADD PRIMARY KEY (`uid`);

--
-- Индексы таблицы `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_ext_id_unq_idx` (`uid`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `user`
--
ALTER TABLE `user`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `conversation_member`
--
ALTER TABLE `conversation_member`
  ADD CONSTRAINT `author_fk` FOREIGN KEY (`author_uid`) REFERENCES `user` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `conversation_fk` FOREIGN KEY (`conversation_uid`) REFERENCES `conversation` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `message`
--
ALTER TABLE `message`
  ADD CONSTRAINT `author_message_fk` FOREIGN KEY (`author_uid`) REFERENCES `user` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `conversation_message_fk` FOREIGN KEY (`conversation_uid`) REFERENCES `conversation` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `parent_fk` FOREIGN KEY (`parent_message_uid`) REFERENCES `message` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `message_attachment`
--
ALTER TABLE `message_attachment`
  ADD CONSTRAINT `attachment_message_uid_fk` FOREIGN KEY (`message_uid`) REFERENCES `message` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `attachment_upload_uid_fk` FOREIGN KEY (`upload_uid`) REFERENCES `upload` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `message_status_journal`
--
ALTER TABLE `message_status_journal`
  ADD CONSTRAINT `message_author_uid_fk1` FOREIGN KEY (`author_uid`) REFERENCES `user` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `message_uid_status_fk` FOREIGN KEY (`message_uid`) REFERENCES `message` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
