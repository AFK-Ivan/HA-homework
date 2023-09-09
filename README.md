# Домашнее задание к занятию 1 «Disaster recovery и Keepalived» - `Брыкин Иван`

### Задание 1

- Дана [схема](1/hsrp_advanced.pkt) для Cisco Packet Tracer, рассматриваемая в лекции.
- На данной схеме уже настроено отслеживание интерфейсов маршрутизаторов Gi0/1 (для нулевой группы)
- Необходимо аналогично настроить отслеживание состояния интерфейсов Gi0/0 (для первой группы).
- Для проверки корректности настройки, разорвите один из кабелей между одним из маршрутизаторов и Switch0 и запустите ping между PC0 и Server0.
- На проверку отправьте получившуюся схему в формате pkt и скриншот, где виден процесс настройки маршрутизатора.

------

### Решение

1. `Прикрепляю pkt файл + скриншот с выполненными командами`

![HW1 task 1](http://screenshot.alarislabs.com/ib2024/image_20230905181514_3f7bcb25.png) 

` Файл .pkt доступен в этом репозитории под названием "hsrp_advanced_done.pkt" `

---

### Задание 2

- Запустите две виртуальные машины Linux, установите и настройте сервис Keepalived как в лекции, используя пример конфигурационного [файла](1/keepalived-simple.conf).
- Настройте любой веб-сервер (например, nginx или simple python server) на двух виртуальных машинах
- Напишите Bash-скрипт, который будет проверять доступность порта данного веб-сервера и существование файла index.html в root-директории данного веб-сервера.
- Настройте Keepalived так, чтобы он запускал данный скрипт каждые 3 секунды и переносил виртуальный IP на другой сервер, если bash-скрипт завершался с кодом, отличным от нуля (то есть порт веб-сервера был недоступен или отсутствовал index.html). Используйте для этого секцию vrrp_script
- На проверку отправьте получившейся bash-скрипт и конфигурационный файл keepalived, а также скриншот с демонстрацией переезда плавающего ip на другой сервер в случае недоступности порта или файла index.html

---

### Решение

` Недоступный порт или недоступность index.html сымитировал обычным выключением NGINX. Активной нодой становится сервер, где nginx включен: `
1. На скриншоте видно, что при использования public virtual IP, переходит на хост где Nginx включен. Keepalived переходит в FAULT STATE на хосте, где Nginx ***выключен***.
![Скриншот](http://screenshot.alarislabs.com/ib2024/image_20230909190108_6b2330d4.png)

2. Если Nginx на активном сервере выключить, а на standby включить, то происходит переключение:
 ![Скриншот](http://screenshot.alarislabs.com/ib2024/image_20230909190614_7650a3c8.png)

 Добавил в этот репозиторий файлы **keepalived.conf** и **check_webserver.sh**
