# Deploy Node Exporter with Ansible

## Описание

Данный playbook автоматически устанавливает Node Exporter на целевую Linux VM.

## Что делает playbook

- скачивает архив Node Exporter с GitHub
- распаковывает его в `/opt/node_exporter`
- создаёт символическую ссылку `/usr/local/bin/node_exporter`
- создаёт systemd-юнит
- запускает и включает службу
- проверяет доступность метрик на `localhost:9100`
