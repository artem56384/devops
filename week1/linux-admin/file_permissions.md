# Права доступа в Linux

## Категории

- User (владелец)
- Group (группа)
- Others (остальные)

## Типы прав

- r — чтение
- w — запись
- x — выполнение

## Просмотр прав

ls -l

## Изменение прав (chmod)

chmod используется для изменения прав доступа.

Примеры:

chmod 755 file

chmod 644 file

chmod u+x file

chmod g-w file

## Изменение владельца (chown)

chown user file

Изменить владельца и группу:

chown user:group file

## Изменение группы (chgrp)

chgrp group file
