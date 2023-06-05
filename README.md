# asazanoff_infra
asazanoff Infra repository

## ДЗ 5
Для подключения одной строкой:

    ssh -A someinternalhost@10.128.0.3 -J appuser@51.250.84.181

где:
* someinternalhost — пользователь конечной машины,
* 10.128.0.3 — IP конечной машины
* appuser — пользователь на бастионхосте,
* 51.250.84.181 — внешний IP бастионхоста

Для подключения короткой командой сделаем конфигфайл:

    > cat .\.ssh\config
    Host myinternalhost
        User someinternalhost
        HostName 10.128.0.3
        ProxyJump appuser@51.250.84.181
    > ssh myinternalhost
    someinternalhost@someinternalhost:~$

[Пруф добавления домена](https://xn--e1adnf2fb.xn--p1ai/labt-letsen-proof.PNG).

bastion_IP = 51.250.84.181
someinternalhost_IP = 10.128.0.3


## ДЗ 6

Команда для старта с метадатой

    > yc compute instance create `
    >> --name reddit-app2 `
    >> --hostname reddit-app2 `
    >> --memory=4 `
    >> --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB `
    >> --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 `
    >> --metadata-from-file user-data=metadata.yaml


testapp_IP = 158.160.100.105
testapp_port = 9292

## ДЗ 7
Был подготовлен простой образ для Packer, в котором нужно будет руками скачать приложение и запустить его, а также был подготовлен более полный образ Packer, в котором приложение запускается при старте.

Для простого образа используются скрипты из папки packer/scripts.

Для полного образа используются скрипты из packer/files, и там же файл сервиса, который будет запускаться при старте машины.

В файле Пакера используются переменные, которые заполняются в packer/variables.json .

В config-scripts/create-reddit-vm.sh находится команда создания машины из полного образа Пакера.

## ДЗ 8
При простом копировании кода для создания второй ВМ возникает проблема масштабирования и внесения изменений. Приходится просматривать очень много строк, чтобы нигде не ошибиться.

Для автоматического увеличения количества машин и приаттачивания их к таргет группе используется count в машинах, изменен механизм адресации к IP адресу машины для провиженинга.

В lb.tf также был добавлен динамический блок, чтобы добавить все машины к целевой группе.

## ДЗ 9
Были сделаны tf-файлы для машин с приложением и базой данных. Затем из них были сделаны модули, которые вызываются из prod и stage папок при применении конфигурации ВМ.

Для сохранения файла состояния в объектном хранилище и блокировки изменений через DynamoDB совместимую БД создайте бакет, получите к нему статические ключи доступа и создайте YDB-базу в serverless-режиме. Запомните ее documentary endpoint и имя таблицы. Добавьте в backend.tf следующее:

    backend "s3" {
        endpoint                    = "storage.yandexcloud.net"
        bucket                      = "Имя бакета"
        region                      = "ru-central1"
        key                         = "Имя файла для стейта"
        access_key                  = "Ключ доступа"
        secret_key                  = "Секретный ключ"
        skip_region_validation      = true
        skip_credentials_validation = true
        dynamodb_endpoint           = "Document API эндпоинт"
        dynamodb_table              = "state-lock-table"
    }

Для запуска приложения разрешил в БД подключение не только с локальной машины через замену в конфиге 127.0.0.1 на 0.0.0.0, а также перезапустил сервис базы данных. Затем в файле сервиса puma добавил переменную для подключения к базе данных. Однако, мне показалось это не очень безопасным, что база данных доступна всему миру, так что я отключил в ней  NAT, чтобы подключение стало доступным только по внутреннему IP в подсети, а замену файла через provisioner организовал через бастионхост, который также создается при применении конфигурации инфраструктуры.

## ДЗ 10
При первом выполнении плейбука Ансибл проверил, что файлы в папке актуальны, и ничего не сделал. После удаления папки и повторного запуска плейбука Ансибл скачал файлы, так как сейчас их не существовало.

Задание со звездочкой не сделал. По крайней мере, пока.

## ДЗ 11
В работе посоздавал плейбуки, рассмотрел возможность разбивки плейбуков на несколько, тегировал для вызова только определенных задач, рассмотрел работу шаблонов файлов. Также посмотрел, как работает провижинер с типом "Ансибл" для Пакера. Рассмотрел вызов хендлеров и вариантов повышения привилегий. Помимо этого для того, чтобы облегчить себе работу, прикрутил динамический инвентори по лейблам. Увы, не придумал, как сделать соединение только с машиной с базой данных через бастион-хост, теперь с обеими машинами соединение идет через бастион-хост.

Как реализовал динамический инвентори:
1. Запихнул в `~/.ansible/plugins/inventory/yc_compute.py` предложенный контрибьютором скрипт.
2. Изменил в нем строчку 134 на `NAME = 'yc_compute'`.
3. Установил yandexcloud: `pip install yandexcloud`.
4. Подогнал под себя пример использования, мануал можно посмотреть в `yc_compute.py` или по команде `ansible-doc -t inventory yc_compute`.
