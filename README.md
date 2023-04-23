# asazanoff_infra
asazanoff Infra repository

Для подключения одной строкой:
ssh -A someinternalhost@10.128.0.3 -J appuser@51.250.84.181
где someinternalhost -- пользователь конечной машины, 10.128.0.3 -- IP конечной машины
appuser -- пользователь на бастионхосте, 51.250.84.181 -- внешний IP бастионхоста

Для подключения одной строкой сделаем конфигфайл:
PS C:\Users\enzel> cat .\.ssh\config
Host myinternalhost
    User someinternalhost
    HostName 10.128.0.3
    ProxyJump appuser@51.250.84.181
PS C:\Users\enzel> ssh myinternalhost
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-146-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

Last login: Sun Apr 23 17:42:52 2023 from 10.128.0.25
someinternalhost@someinternalhost:~$

Пруф добавления домена: https://xn--e1adnf2fb.xn--p1ai/labt-letsen-proof.PNG

bastion_IP = 51.250.84.181
someinternalhost_IP = 10.128.0.3
