# Приложение по БД

### Установка
1. Добавь и выполни следующий запрос для создания таблицы пользователей в своей БД.
```sql
CREATE TABLE IF NOT EXISTS Users
(
    ID              INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    UserName        CHAR(50) NOT NULL,
    UserEmail       CHAR(50) NOT NULL,
    UserPassword    CHAR(18) NOT NULL,
    UserRole	    CHAR(18) NOT NULL
);

# Пример для добавления пользователей в базу:
INSERT INTO Users VALUES(0, 'admin1', 'admin@admin', 'password', 'admin');
INSERT INTO Users VALUES(0, 'user1', 'user@user', 'password', 'user');
```
2. Отредактируй конфигурационный файл ```config.py``` в соответствии 
   со своими данными для подключения к БД.
```python
# DB config
db_host = 'localhost'
db_name = 'db'
db_cursor = 'DictCursor'

# DB credentials
username = 'root'
password = ''

# Application config
root_table = 'Client'  # Table
white_listed_tables = ['users']  # Hide tables from user group

```
3. Запусти ```app.py``` из корня проекта.