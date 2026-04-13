# Ansible Remote Host Setup

## Описание

Ansible настроена для управления второй виртуальной машиной по SSH.

## Inventory

Используется файл `inventory.ini` со следующим хостом:

`vm2 ansible_host=192.168.56.103 ansible_user=ansible`

## Проверка подключения

Для проверки использовалась команда:

```bash
ansible servers -i inventory.ini -m ping
