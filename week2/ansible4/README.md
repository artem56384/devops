# Install Docker with Ansible

## Описание

Данный playbook автоматически устанавливает Docker на Debian, добавляет официальный GPG-ключ и репозиторий Docker, устанавливает необходимые пакеты, добавляет пользователя `dev` в группу `docker`, запускает службу Docker и выполняет тестовый запуск контейнера `hello-world`.

## Что делает playbook

- устанавливает зависимости
- добавляет GPG-ключ Docker
- добавляет официальный репозиторий Docker
- устанавливает `docker-ce`, `docker-ce-cli`, `containerd.io`
- создаёт группу `docker`
- добавляет пользователя `dev` в группу `docker`
- запускает и включает службу `docker`
- запускает тестовый контейнер `hello-world`

## Файлы

- `install_docker.yml` — плейбук установки Docker
- `inventory.ini` — inventory с целевой машиной

## Запуск

```bash
ansible-playbook -i inventory.ini install_docker.yml
