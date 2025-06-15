<link href="style.css" rel="stylesheet"></link>

# **Отчёт по проекту LinuxNetwork (willetts)**  

## **Part 1.** Инструмент ipcalc  

### 1.1. **Сети и маски**  

1. **Адрес сети 192.167.38.54/13**: 192.160.0.0/13 (11000000.10100000.00000000.00000000)  
Адрес сети = ip & netmask = 192.167.38.54 & 255.248.0.0 = 192.160.0.0 

2. **Перевод маски 255.255.255.0 в префиксную и двоичную запись**:  
Префиксная: /24  
Двоичная: 11111111.11111111.11111111.00000000  
/15 в обычную и двоичную:  
Обычная: 255.254.0.0  
Десятичная: 11111111.11111110.00000000.00000000  
11111111.11111111.11111111.11110000 в обычную и префиксную:  
Обычная: 255.255.255.240  
Префиксная: /28  

3. **Минимальный и максимальный хост в сети 12.167.38.4** при масках:  
/8:  
Min: 12.0.0.1 Max: 12.255.255.254   
11111111.11111111.00000000.00000000:  
Min: 12.167.0.1 Max: 12.167.255.254  
255.255.254.0:  
Min: 12.167.38.1 Max: 12.167.39.254  
 /4:  
Min: 0.0.0.1 Max: 15.255.255.254  
(Первые 4 бита – адрес сети, так что максимум в первом октете – 00001111 = 15)  

### 1.2. **localhost**  

Можно ли обратиться к приложению, работающему на localhost, со следующими IP:  
Ip localhost - 127.0.0.0/8 ==>  
194.34.23.100 - нет  
127.0.0.2  - да  
127.1.0.1  - да  
128.0.0.1  - нет  

### 1.3. **Диапазоны и сегменты сетей**  

*Какие из перечисленных IP можно использовать в качестве публичного, а какие только в качестве частных:*  
10.0.0.45, 134.43.0.2, 192.168.4.2, 172.20.250.4, 172.0.2.1, 192.172.0.1, 172.68.0.2, 172.16.255.255, 10.10.10.10, 192.169.168.1  
>Согласно RFC 1918, существует три диапазона ip адресов, которые зарезервированы для частных сетей:  
>10.0.0.0 - 10.255.255.255 — 10.0.0.0/8;  
>172.16.0.0 - 172.31.255.255 — 172.16.0.0/12  
>192.168.0.0 - 192.168.255.255 — 192.168.0.0/16  

==>  
**Частные**: 10.0.0.45, 192.168.4.2, 172.20.254.4, 172.16.255.255, 10.10.10.10  
**Публичные**: 134.43.0.2, 172.0.2.1, 192.172.0.1, 172.68.0.2, 192.169.168.1  

*Какие из перечисленных IP адресов шлюза возможны у сети 10.10.0.0/18:*  
10.0.0.1, 10.10.0.2, 10.10.10.10, 10.10.100.1, 10.10.1.255  
Min: 10.10.0.1 Max: 10.10.63.254 ==>  
**Возможны**:  
10.10.0.2  
10.10.10.10  
10.10.1.255  

## **Part 2.** Статическая маршрутизация между двумя машинами  

- С помощью команды ip a смотрим существующие сетевые интерфейсы:  
![BU_ipa](../misc/images/Report_img/BU_ipa.png#medium)
![EU_ipa](../misc/images/Report_img/EU_ipa.png#medium)  

- Опишем сетевой интерфейс, соответствующий внутренней сети, на обеих машинах и зададим следующие адреса и маски: **ws1 - 192.168.100.10/16**, **ws2 - 172.24.116.8/12**  
Для этого внесём изменения в файл 00-installer-config.yaml  
![BU_yaml](../misc/images/Report_img/BU_yaml.png#medium)
![EU_yaml](../misc/images/Report_img/EU_yaml.png#medium)  
- Затем используем netplan try, чтобы проверить, что всё ок (и потом еще netplan apply, чтобы ну точно всё принялось)  
![BU_netplan_apply](../misc/images/Report_img/BU_netplan_apply.png#medium)
![EU_netplan_apply](../misc/images/Report_img/EU_netplan_apply.png#medium)  
- На всякий случай проверим, точно ли нам удалось задать нужный адрес нужному сетевому интерфейсу через команду ip a  
![BU_ipa_newip](../misc/images/Report_img/BU_ipa_newip.png#medium)
![EU_ipa_newip](../misc/images/Report_img/EU_ipa_newip.png#medium)  

### 2.1. **Добавление статического маршрута вручную**  

>**Важное замечание**: Для этого и последующих пунктов нужно сначала изменить настройки самой VirtualBox.  
>Конкретно – заменить в Network NAT на Internal Network. Эти настройки, как я понял, отвечают за взаимодействие виртуальной машины с хостом, другими виртуальными машинами и сетью.  
>И дефолтная NAT (Network Address Translation) не позволяет взаимодействие типа vm1-vm2, так как все соединения проходят через хоста, то есть хост выступает чем-то вроде роутера для нашей виртуальный машиной.  
![VB_network](../misc/images/Report_img/VB_network.png#small)  
>Теперь можно и начать делать задание без необходимости десять часов биться головой об стол, пытаясь понять, почему ничего не работает 

- Добавим статический маршрут от одной машины до другой и обратно при помощи команды вида ip r add. Пропингуем соединение между машинами.  
![BU_Manual_static_route](../misc/images/Report_img/BU_Manual_static_route.png#medium)
![EU_Manual_static_route](../misc/images/Report_img/EU_Manual_static_route.png#medium)  

### 2.2. **Добавление статического маршрута с сохранением**  

- Перезапустим машины. Теперь добавим статический маршрут от одной машины до другой с помощью файла etc/netplan/00-installer-config.yaml.  
![BU_route_w_saving_yaml](../misc/images/Report_img/BU_route_w_saving_yaml.png#medium)
![EU_route_w_saving_yaml](../misc/images/Report_img/EU_route_w_saving_yaml.png#medium)  
- Пропингуем соединение между машинами.  
![BU_route_w_saving_ping](../misc/images/Report_img/BU_route_w_saving_ping.png#medium)
![EU_route_w_saving_ping](../misc/images/Report_img/EU_route_w_saving_ping.png#medium)  

## **Part 3.** Утилита iperf3  

### 3.1. **Скорость соединения**  

*Переведём по заданию*:  
8 Mbps в MB/s =  1  MB/s  
100 MB/s в Kbps = 800000 Kbps  
1 Gbps в Mbps = 1000 Mbps  

### 3.2. **Утилита iperf3**  

- Измерим скорость соединения с помощью iperf3:  
Сначала запустим сервер на одной виртуальный машине с помощью iperf3 -s  
Затем запустим на клиентской части (второй машине) iperf3 -c 192.168.100.10 -i 3 -t 15  
Таким образом, мы подключимся к серверу, который в нашем примере находится по адресу 192.168.100.10 и с помощью флага i установим интервал выдачи промежуточного результата в 3 секунды (по дефолту 1 сек) и общее время проведения теста – 15 секунд (по дефолту 10 сек)  
![BU_iperf3_reg](../misc/images/Report_img/BU_iperf3_reg.png#medium)
![EU_iperf3_reg](../misc/images/Report_img/EU_iperf3_reg.png#medium)  
- Теперь отправим данные от сервера к клиенту с помощью флага -R и проверим скорость  
![BU_iperf3_R](../misc/images/Report_img/BU_iperf3_R.png#medium)
![EU_iperf3_R](../misc/images/Report_img/EU_iperf3_R.png#medium)  
==> Средняя скорость соединения = 1.6 Gbps  

## **Part 4.** Сетевой экран  

### 4.1. **Утилита iptables**  

- Создадим и изменим файл /etc/firewall.sh по заданию  
![BU_nano_firewall](../misc/images/Report_img/BU_nano_firewall.png#medium)
![EU_nano_firewallsh](../misc/images/Report_img/EU_nano_firewallsh.png#medium)  
- Запускаем /etc/firewall.sh  
![BU_sh_firewall](../misc/images/Report_img/BU_sh_firewall.png#medium)
![EU_sh_firewall](../misc/images/Report_img/EU_sh_firewall.png#medium)  
Разница в стратегиях первого и второго файла в том, что при наличии двух правил по отношению к одному и тому же запросу применяется первое правило. Соответственно, в firewall.sh мы запрещали именно echo reply, то есть ответ на пинг. И действительно, при попытке пропинговать вторую машину из первой – всё проходит (так как на второй машине сначала ACCEPT, а потом DROP), а при попытке пропинговать первую из второй – все пакеты дропаются (так как там наоборот DROP, а затем ACCEPT)

### 4.2. **Утилита nmap** 

- Пропингуем обе машины и найдём ту, которая не пингуется  
![BU_ping_firewall](../misc/images/Report_img/BU_ping_firewall.png#medium)
![EU_ping_firewall](../misc/images/Report_img/EU_ping_firewall.png#f4)  
- Теперь с помощью утилиты nmap проверим, что хотя она не пингуется, хост машины запущен  
![EU_nmap](../misc/images/Report_img/EU_nmap.png#medium)  

## **Part 5.** Статическая маршрутизация сети

### 5.1. **Настройка адресов машин**  

Настроим конфигурации машин в etc/netplan/00-installer-config.yaml согласно сети на рисунке.  
![Network_example](../misc/images/Report_img/Network_example.png#small)  

>**Важное замечание:** здесь также сначала нужно немного изменить настройки самих виртуальных машин через VirtualBox.  
>Дело в том, что для роутеров - согласно схеме - нам нужно два сетевых интерфейса, но по дефолту у всех виртуальных машин только один интерфейс.  
>Соответственно, нам нужно зайти в настройки наших роутеров и в меню network добавить ещё один сетевой адаптер  
>![VB_adapter](../misc/images/Report_img/VB_adapter.png#small)  

- Так у нас, собственно, выглядят файлы .yaml для каждой виртуальный машины:    
![Ws11_yaml](../misc/images/Report_img/Ws11_yaml.png#small)
![Ws21_yaml](../misc/images/Report_img/Ws21_yaml.png#small)
![Ws22_yaml](../misc/images/Report_img/Ws22_yaml.png#small)  
![R1_yaml](../misc/images/Report_img/R1_yaml.png#small)
![R2_yaml](../misc/images/Report_img/R2_yaml.png#small)  

- Перезапустим сервис сети. Ошибок нет, так что командой ip -4 a проверим, что адреса машин заданы верно.  
![ip4a_ws11](../misc/images/Report_img/ip4a_ws11.png#small)  
![ip4a_ws21](../misc/images/Report_img/ip4a_ws21.png#small)  
![ip4a_ws22](../misc/images/Report_img/ip4a_ws22.png#small)  
![ip4a_r1](../misc/images/Report_img/ip4a_r1.png#small)  
![ip4a_r2](../misc/images/Report_img/ip4a_r2.png#small)  

- Пропингуем ws22 с ws21  
![ping_ws22_ws21](../misc/images/Report_img/ping_ws22_ws21.png#small)  
- Пропингуем r1 с ws11  
![ping_r1_ws11](../misc/images/Report_img/ping_r1_ws11.png#small)  

### 5.2. **Включение переадресации IP-адресов**  

- Для включения переадресации IP, выполним команду на роутерах:  
*sysctl -w net.ipv4.ip_forward=1*  
При таком подходе переадресация не будет работать после перезагрузки системы.  
![R1_temp_forwarding](../misc/images/Report_img/R1_temp_forwarding.png#medium)  
![R2_temp_forwarding](../misc/images/Report_img/R2_temp_forwarding.png#medium)

- Откроем файл /etc/sysctl.conf и добавим в него следующую строку:
*net.ipv4.ip_forward = 1*  
При использовании этого подхода, IP-переадресация включена на постоянной основе.  
![R1_perm_forwarding](../misc/images/Report_img/R1_perm_forwarding.png#medium)
![R2_perm_forwarding](../misc/images/Report_img/R2_perm_forwarding.png#medium)  

### 5.3. **Установка маршрута по-умолчанию**  

- Настроим маршрут по-умолчанию (шлюз) для рабочих станций.  
Для этого добавим default перед IP роутера в файле конфигураций. Я это сделал сразу, потому что делал всё по [этому](https://ubuntu.com/server/docs/configuring-networks) туториалу с сайта ubuntu, так что .yaml файлы не отличаются от п. 5.1:  
![Ws11_yaml](../misc/images/Report_img/Ws11_yaml.png#small)
![Ws21_yaml](../misc/images/Report_img/Ws21_yaml.png#small)
![Ws22_yaml](../misc/images/Report_img/Ws22_yaml.png#small)  

- Вызовем ip r и покажем, что добавился маршрут в таблицу маршрутизации  
![ipr_ws11](../misc/images/Report_img/ipr_ws11.png#medium)  
![ipr_ws11](../misc/images/Report_img/ipr_ws11.png#medium)  
![ipr_ws22](../misc/images/Report_img/ipr_ws22.png#medium)  

- Пропингем с ws11 роутер r2 и покажем на r2, что пинг доходит (с помощью команды *sudo tcpdump -tn -i eth0*)  
![ping_ws11_r2](../misc/images/Report_img/ping_ws11_r2.png#medium)
![tcpdump_ws11_r2](../misc/images/Report_img/tcpdump_ws11_r2.png#medium)  

### 5.4. **Добавление статических маршрутов**  

- Добавим в роутеры r1 и r2 статические маршруты в файле конфигураций.

>У меня тут снова всё аналогично п. 5.1 по той же причине, что и в прошлом пункте. Вообще, как я понял, от нас в п. 5.1 хотели, чтобы мы прописали всё через gateway4 или типа того,  
>но это, вроде как, считается устаревшим синтаксисом. Но хз, может я просто что-то недопонял. 

![R1_yaml](../misc/images/Report_img/R1_yaml.png#medium)
![R2_yaml](../misc/images/Report_img/R2_yaml.png#medium)  

- Вызовем ip r и покажим таблицы с маршрутами на обоих роутерах:  
![ipr_r1](../misc/images/Report_img/ipr_r1.png#medium)
![ipr_r2](../misc/images/Report_img/ipr_r2.png#medium)  

- Запустим команды на ws11:  
*ip r list 10.10.0.0/18* и *ip r list 0.0.0.0/0*  
![ipr_list_ws11](../misc/images/Report_img/ipr_list_ws11.png#medium)  

- Для адреса 10.10.0.0/18 был выбран маршрут, отличный от 0.0.0.0/0, так как мы сами в .yaml файле задали отдельный дефолтный маршрут.  
То есть, если мы удалим часть кода routes, то при вызове ip r у нас всё равно останется строчка, которая начинается с 10.10.0.0/18, так как по дефолту виртуальный интерфейс, находящийся в определённой сети для попадания в эту сеть ссылается на себя или типа того.  
Соответственно, когда мы просим выдать путь в 0.0.0.0/0, то нам выдаётся default, а если мы конкретно указываем путь, который есть в ip r отдельно (в нашем случае 10.10.0.0/18), то он нам и выдастся.

### 5.5. **Построение списка маршрутизаторов**  

- При помощи утилиты traceroute построим список маршрутизаторов на пути от ws11 до ws21 предварительно включив tcpdump на r1 (два раза чисто потому что):  
![traceroute_ws11_ws21](../misc/images/Report_img/traceroute_ws11_ws21.png#medium)  
- Результат tcpdump на r1 (частично):  
![tcpdump_r1](../misc/images/Report_img/tcpdump_r1.png#medium)  
Команда traceroute отправляет в сторону нужного нам ip **udp-пакет** с определённым **ttl**, то есть количеством хопов, которые пакет может совершить до своей, так сказать, смерти.  
Если он таки умер, то выдаётся сообщение **ICMP time exceeded in-transit** и посылается следующий пакет со временем жизни ttl+1.  
Если пакет дошёл до места назначения, то выдаётся сообщение **ICMP [ip] udp port 33440 unreachable** (так как покет изначально посылается на закрытый порт 33440). Это сообщение означает, что пакет таки дошёл до места назначения и пора заканчивать трассировку.

### 5.6. **Использование протокола ICMP при маршрутизации**  

- Запустим на r1 перехват сетевого трафика, проходящего через eth0 с помощью команды *sudo tcpdump -n -i eth0 icmp* и пропингуем с ws11 несуществующий IP (например, 10.30.0.111)  
Вот что мы тогда получим:  
![111_ping_ws11](../misc/images/Report_img/111_ping_ws11.png#medium)  
![tcpdump_icmp_r1](../misc/images/Report_img/tcpdump_icmp_r1.png#medium)  
Фильтр icmp позволяет нам “ловить” только icmp пакеты, то есть те пакеты, которые отправляет команда ping  

## Part 6. **Динамическая настройка IP с помощью DHCP**  

>**Важное замечание**: перед взаимодействием с dhcp нам нужно, собственно, установить его на r1 и r2 с помощью *sudo apt-get install isc-dhcp-server*, для чего нам нужно снова залазить в настройки сети в VirtualBox, чтобы 
>заменить их на NAT, потом изменить .yaml файл, потом установить dhcp-server, а потом проделать всё в обратном порядке))0)  
>И ещё в .yaml файле ws21 нужно поставить dhcp4: true, иначе dhcp не будет работать.  

- Для r2 настроем в файле /etc/dhcp/dhcpd.conf конфигурацию службы DHCP:  
  1. Укажем адрес маршрутизатора по-умолчанию, DNS-сервер и адрес внутренней сети и еще lease-time, потому что могу:  
![dhcpd_conf_r2](../misc/images/Report_img/dhcpd_conf_r2.png#medium)  
  2. В файле resolv.conf пропишем nameserver 8.8.8.8:  
![resolv_conf_r2](../misc/images/Report_img/resolv_conf_r2.png#medium)  

- Перезагрузим службу DHCP командой *systemctl restart isc-dhcp-server* и заодно командой *status* проверим, работает ли наш сервер:  
![dhcp_restart_r2](../misc/images/Report_img/dhcp_restart_r2.png#medium)  
(Если выдаёт ошибку, то можно проверить причину по номеру pid, с помощью команды *journalctl _PID=[pid]*)  
- Машину ws21 перезагрузим при помощи *reboot* и через *ip a* покажем, что она получила адрес:  
![dhcp_ip_ws21](../misc/images/Report_img/dhcp_ip_ws21.png#medium)  
- Пропингуем ws22 с ws21:  
![dhcp_ip_ping_ws22_ws21](../misc/images/Report_img/dhcp_ip_ping_ws22_ws21.png#medium)  

- Укажем MAC адрес у ws11.  
Для этого в etc/netplan/00-installer-config.yaml надо добавить строки: *macaddress: 10:10:10:10:10:BA*, *dhcp4: true*   
**Здесь важно отметить, что MAC адрес также нужно изменить в настройках сети ws11 в VirtualBox**  
![set_mac_yaml_ws11](../misc/images/Report_img/set_mac_yaml_ws11.png#medium)  
- Настроим r1 аналогично r2, но сделаем выдачу адресов с жесткой привязкой к MAC-адресу ws11:  
    - Для начала (ну, после установки dhcp сервера) настроим dhcpd.conf  
 ![dhcpd_conf_r1](../misc/images/Report_img/dhcpd_conf_r1.png#medium)  
    - Перезагрузим службу DHCP командой *systemctl restart isc-dhcp-server* и заодно командой *status* проверим, работает ли наш сервер:  
 ![dhcpd_restart_r1](../misc/images/Report_img/dhcpd_restart_r1.png#medium)  
    - Машину ws11 перезагрузим при помощи *reboot* и через *ip a* покажем, что она получила адрес, который мы зарезервировали на r1 (10.0.0.3):  
 ![dhcp_ip_ws11](../misc/images/Report_img/dhcp_ip_ws11.png#medium)  
    - Пропингуем ws11 с ws21  
 ![dhcp_ip_ping_ws11_ws21](../misc/images/Report_img/dhcp_ip_ping_ws11_ws21.png#medium)  

- Запросим с ws21 обновление ip адреса.  
![dhcp_ip_update_ws21](../misc/images/Report_img/dhcp_ip_update_ws21.png#medium)  

При выполнении данного задания были использованы несколько опций DHCP сервера:  
1. subnet 10.20.0.0 netmask 255.255.255.192 {} – задаёт то для какой сети мы настраиваем dhcp сервер  
2. range 10.20.0.2 10.20.0.50 – задаёт пул доступных для аренды ip адресов  
3. option domain-name-servers – задаёт адрес DNS сервера, их может быть несколько  
4. option routers – задаёт маршрутизатор по умолчанию  
5. default-lease-time – задаёт время (в сек), на которое ip адрес арендуется  
6. max-lease-time – задаёт максимальное время, на протяжении которого ip адрес арендуется (то есть, default lease можно продлевать пока не дойдёшь до max)  
7. host hosthost { hardware ethernet 10:10:10:10:10:BA; fixed-address 10.10.0.3; } – конструкция host позволяет нам резервировать ip адреса за определёнными mac адресами  

## **Part 7.** NAT

>Важное замечание: здесь как и перед выполнением п.6 нужно установить доп пакеты.  
>В данном случае – это apache2, но алгоритм такой же (yaml->virtualbox->install->yaml->virtualbox)

- В файле /etc/apache2/ports.conf на ws22 и r1 изменим строку Listen 80 на Listen 0.0.0.0:80, то есть сделаем сервер Apache2 общедоступным.  
![apache_ports_conf_ws22](../misc/images/Report_img/apache_ports_conf_ws22.png#medium)
![apache_ports_conf_r1](../misc/images/Report_img/apache_ports_conf_r1.png#medium)  

- Запустим веб-сервер Apache командой service apache2 start на ws22 и r1.  
![apache_start_ws22](../misc/images/Report_img/apache_start_ws22.png#medium)
![apache_start_r1](../misc/images/Report_img/apache_start_r1.png#medium)  

- Добавим в брандмауэр, созданный по аналогии с брандмауэром из Части 4, на r2 следующие правила:  
  1) Удаление правил в таблице filter - iptables -F;  
  2) Удаление правил в таблице "NAT" - iptables -F -t nat;  
  3) Отбрасывать все маршрутизируемые пакеты - iptables --policy FORWARD DROP.  
![initial_firewall_r2](../misc/images/Report_img/initial_firewall_r2.png#medium)   
Запустим файл также, как в Части 4 (sudo chmod +x /etc/firewall.sh; sudo sh /etc/firewall.sh)  

- Проверим соединение между ws22 и r1 командой ping.  
![firewall_ws22_r1_no_ping](../misc/images/Report_img/firewall_ws22_r1_no_ping.png#medium)   
Ничего не пингуется из-за нашего firewall.  

- Добавим в файл firewall ещё одно правило:  
  4) Разрешить маршрутизацию всех пакетов протокола ICMP.  
![upd_firewall_r2](../misc/images/Report_img/upd_firewall_r2.png#medium)  
Запустим файл.

- Проверим соединение между ws22 и r1 командой ping.  
![firewall_ws22_r1_yes_ping](../misc/images/Report_img/firewall_ws22_r1_yes_ping.png#medium)  

- Добавим в файл firewall ещё два правила:  
  5) Включить SNAT, а именно маскирование всех локальных ip из локальной сети, находящейся за r2 (по обозначениям из Части 5 - сеть 10.20.0.0).  
  6) Включить DNAT на 8080 порт машины r2 и добавить к веб-серверу Apache, запущенному на ws22, доступ извне сети.  
![snat_dnat](../misc/images/Report_img/snat_dnat.png#small)  
Для этого, во-первых, нужно разрешить маршрутизацию пакетов протокола TCP,  
так как telnet, c помощью которого мы будем проверять соединение, создан на основе tcp и потом включить stat и dnat.  
![final_firewall_r2](../misc/images/Report_img/final_firewall_r2.png#medium)  
![final_firewall_r2_extra](../misc/images/Report_img/final_firewall_r2_extra.png#medium)
**SNAT:**  
Ключ -t указывает на то, что мы работаем с таблицей преобразования сетевых адресов (nat), а не дефолтной filter  
Postrouting так как это snat, то есть преобразование происходит “на выходе”  
Затем указываем, что snat действует для для всех пакетов, попадающих под критерий -o eth0, т.е. использующих в качестве исходящего интерфейс eth0  
После – задан диапазон адресов, которые нужно изменять  
Финальный параметр --to-source используется для указания адреса присваиваемому пакету, теперь именно этот адрес будет указываться в качестве исходящего, то есть адрес eth0  
**DNAT:**  
Prerouting так как это dnat, то есть преобразование происходит “на входе”  
Ключ -d и 10.20.0.1 значит, что преобразовываться будут только пакеты, которые направляются снаружи и через порт 10.20.0.1,  
то есть тоже самое, что eth0 для snat, только eth1 и путём написания ip  
Ключ -p конкретизирует, сетевые адреса каких пакетов преобразовывать (без него iptables не хочет принимать —dport)  
Ключ —dport конкретизирует порт назначения (по заданию 8080)  
Наконец, —to-destination 10.20.0.20:80 позволяет открыть доступ к серверу Apache на ws22 извне  

- Запустим брандмауэр и проверим:
  - Cоединение по TCP для SNAT: для этого с ws22 подключиvcz к серверу Apache на r1 командой: telnet 10.10.0.1 80  
  ![nat_ws22_r1_telnet](../misc/images/Report_img/nat_ws22_r1_telnet.png#medium)   
  - Cоединение по TCP для DNAT: для этого с r1 подключимся к серверу Apache на ws22 командой: telnet 10.20.0.1 8080  
  ![nat_r1_ws22_telnet](../misc/images/Report_img/nat_r1_ws22_telnet.png#medium)   

## **Part 8.** Дополнительно. Знакомство с SSH Tunnels

- Запустим на r2 фаервол с правилами из Части 7

- Запустим веб-сервер Apache на ws22 только на localhost (то есть в файле /etc/apache2/ports.conf изменим строку Listen 80 на Listen localhost:80)  
![tunnels_localhost80](../misc/images/Report_img/tunnels_localhost80.png#medium)  

>Перед всем этим нужно установить ssh сервера на все машины, с которыми будем работать (я так понял)

- Воспользуемся Local TCP forwarding с ws21 до ws22, чтобы получить доступ к веб-серверу на ws22 с ws21. Для этого:
  - В файле конфигурации ssh сервера /etc/ssh/sshd_config раскомментим “Port 22”, “AllowTcpForwarding yes”  
  ![tunnels_sshd_configP1](../misc/images/Report_img/tunnels_sshd_configP1.png#medium)  
  ![tunnels_sshd_configP2](../misc/images/Report_img/tunnels_sshd_configP2.png#medium)  
  - Используем на ws21 команду ssh -L 9999:localhost:22 willettsws22@10.20.0.20  
  ![tunnels_ssh_ws21_ws22](../misc/images/Report_img/tunnels_ssh_ws21_ws22.png#medium)  
  Ssh - программа удалённого доступа  
  -L  – определяет заданный порт на локальной машине который будет перенаправлен к заданной машине и порт на удаленной машине.  
  Короче, выбираем порт (9999), потом localhost, так как по заданию и потом 22, так как – это наш порт, который мы раскомментили ранее  
  - Проверяем подключение с помощью telnet 127.0.0.1 9999 с ws21  
  ![tunnels_telnet_ws21_ws22](../misc/images/Report_img/tunnels_telnet_ws21_ws22.png#medium)  

- Воспользуемся Remote TCP forwarding c ws11 до ws22, чтобы получить доступ к веб-серверу на ws22 с ws11. Для этого:  
  - В файле конфигурации ws11 аналогично всё раскомменчиваем  
  - Используем на ws22 команду ssh -R 9999:localhost:22 willettsws11@10.10.0.2  
  ![tunnels_ssh_ws11_ws22](../misc/images/Report_img/tunnels_ssh_ws11_ws22.png#medium)  
  Тут тоже самое, но используем R, так как remote forwarding и в данном случае 9999 – порт на удаленной машине,  
  который будет перенаправлен к заданной машине и локальному порту.
  - Проверяем подключение с помощью telnet 127.0.0.1 9999 с ws21  
  ![tunnels_telnet_ws11_ws22](../misc/images/Report_img/tunnels_telnet_ws11_ws22.png#medium)  