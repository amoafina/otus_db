# Домашнее задание № 16. Резервное копирование и восстановление.

### Листинг bash
Скорее всего, не оптимально. В основном оставил для себя.

    docker run -d --name percona-server-mysql -e MYSQL_ROOT_PASSWORD=root percona/percona-server:8.0
    docker exec -it percona-server-mysql bash               
    cd tmp
    mkdir backups
    cd backups
    mkdir xtrabackup
    cd xtrabackup
    mkdir stream  
    exit

    docker cp D:\\Otus\\otus_db\\world_db.sql percona-server-mysql:/tmp/
    docker cp D:\\Otus\\otus_db\\backup_des.xbstream.gz.des3 percona-server-mysql:/tmp/backups/xtrabackup/stream/

    docker exec -it percona-server-mysql bash   
    cd  /tmp/backups/xtrabackup/stream/
    openssl des3 -salt -k "password" -d -in backup_des.xbstream.gz.des3 -out backup_des.xbstream.gz
    gzip -d backup_des.xbstream.gz 

    exit

    docker exec -it percona-server-mysql mysql -uroot -proot

    create database world;
    use world;
    source /tmp/world_db.sql;
    show tables;
    exit;

![Результат show tables](img/001.png)

    docker exec -it percona-server-mysql bash   
    cd  /tmp/backups/xtrabackup/stream/
    xbstream -x < backup_des.xbstream 
    xtrabackup --prepare --export --target-dir=var/lib/mysql/backup/

    docker exec -it percona-server-mysql mysql world < var/lib/mysql/backup

![Результат импорта](img/002.png)
