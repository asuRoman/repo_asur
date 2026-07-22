#!/bin/bash

# Папка для бэкапов
BACKUP_DIR="/home/asur/backup_mysql"
mkdir -p "$BACKUP_DIR"
CONFIG="/home/asur/.my.cnf"

# Получаем список баз и исключаем название таблицы
databases=$(mysql --defaults-file="$CONFIG" -e "SHOW DATABASES;" | grep -Ev "Database")
echo "$databases"
for db in $databases; do
    echo "=== База: $db ==="

# Папка для текущей базы
  DB_DIR="$BACKUP_DIR/$db"
    mkdir -p "$DB_DIR"

# Список таблиц в базе
    tables=$(mysql --defaults-file="$CONFIG" -D $db -e "SHOW TABLES;" | tail -n +2)

    for table in $tables; do
        echo "  Дамп таблицы: $table"
        mysqldump --defaults-file="$CONFIG" \
            --single-transaction \
            --skip-lock-tables \
            $db $table > "$DB_DIR/$table".sql
    done

done

echo "Выполнено успешно и готовые бэкапы лежат в $BACKUP_DIR"