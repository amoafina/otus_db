# Домашняя работа № 7. DML скрипты. Агрегация и сортировка

## 1. Создание таблицы
    CREATE TABLE statistic(
        player_name VARCHAR(100) NOT NULL,
        player_id INT NOT NULL,
        year_game SMALLINT NOT NULL CHECK (year_game > 0),
        points DECIMAL(12,2) CHECK (points >= 0),
        PRIMARY KEY (player_name,year_game)
    );

## 2. Заполнение таблицы данными
    INSERT INTO
        statistic(player_name, player_id, year_game, points)
    VALUES
        ('Luke',1,2019,16),
        ('Luke',1,2020,19),
        ('Luke',1,2018,18),
        ('Mike',2,2019,14),
        ('Mike',2,2020,17),
        ('Mike',2,2018,14),
        ('Jack',3,2019,15),
        ('Jack',3,2020,18),
        ('Jack',3,2018,30),
        ('Jackie',4,2019,28),
        ('Jackie',4,2020,29),
        ('Jackie',4,2018,30),
        ('Jet',5,2019,25),
        ('Jet',5,2020,27),
        ('Jet',5,2018,20);

## 3. Запросы
### 3.1. Запрос суммы очков с группировкой и сортировкой по годам
    SELECT 
        s.year_game, 
        SUM(s.points) AS current_year_sum,
        temp_sum.previous_year_sum
    FROM public.statistic s
    LEFT JOIN (
        SELECT ts.year_game, SUM(ts.points) AS previous_year_sum
        FROM public.statistic ts
        GROUP BY ts.year_game
    ) temp_sum 
        ON temp_sum.year_game = s.year_game - 1
    GROUP BY s.year_game, temp_sum.previous_year_sum
    ORDER BY s.year_game;

### 3.2. CTE
    WITH temp_sum AS (
        SELECT 
            ts.year_game, 
            SUM(ts.points) AS previous_year_sum
        FROM public.statistic ts
        GROUP BY ts.year_game
    )
    SELECT 
        s.year_game, 
        SUM(s.points) AS current_year_sum,
        temp_sum.previous_year_sum
    FROM public.statistic s
    LEFT JOIN temp_sum 
        ON temp_sum.year_game = s.year_game - 1
    GROUP BY s.year_game, temp_sum.previous_year_sum
    ORDER BY s.year_game;

### 3.3. LAG()
    SELECT 
        s.year_game, 
        SUM(s.points) AS current_year_sum,
        LAG (SUM(s.points), 1) OVER () AS previous_year_sum
    FROM public.statistic s
    GROUP BY s.year_game;
