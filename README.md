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
