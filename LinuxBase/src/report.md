<link href="style.css" rel="stylesheet"></link>

# **Отчёт по проекту Linux (willetts)**

## **Part 1.** Installation of the OS

Чтобы установить Ubuntu на виртуальную машину необходимо:
1. Скачать файл iso с необходимой версией Ubuntu (в нашем случае – 20.04)  
2. В VirtalBox выбрать "New"  
![Virtual_Box](../misc/images/img_for_report/Virtual_box.png#f5) 
3. В открывшемся меню выбираем название новой виртуальной машины, папку, в которую хотим её установить (в нашем случае нужно в _goinfre_, иначе мак взорвётся)  
и какой iso хотим использовать для установки  
![Virtual_Machine](../misc/images/img_for_report/Virtual_machine.png#f5) 
4. Настраиваем виртуальную машину  
![V_m_1](../misc/images/img_for_report/V_M_1.png#small) ![V_m_2](../misc/images/img_for_report/V_M_2.png#small) ![V_m_2](../misc/images/img_for_report/V_M_2.png#small)  
5. Финишируем  
![V_m_finish](../misc/images/img_for_report/V_m_finish.png#f5)  

* Теперь, запустив нашу виртуалку, можем проверить версию Ubuntu командой __*cat /etc/issue*__:  
![V_m_finish](../misc/images/img_for_report/Version.png#f4)  

## **Part 2.** Creating a user

Для создания нового пользователя можно использовать команду __*sudo adduser username*__. В нашем случае мы добавляем пользователя *mega_willetts*:  
![Add_user](../misc/images/img_for_report/Add_user.png#f4)  

* Проверим факт создания нового пользователя с помощью __*cat /etc/passwd*__  
![Cat_passwd](../misc/images/img_for_report/cat_passwd.png#f4)  

Чтобы теперь добавить пользователя в группу "adm" прописываем команду __*sudo usermod -aG adm mega_willetts*__  
![Mega_willetts_adm](../misc/images/img_for_report/Mega_willets_adm.png#f4)  
Флаг _a – append_ – добавить пользователя в группу  
Флаг _G - groups_ – собсна, списко групп  

Проверим факт добавления нового пользователя в группу "adm" с помощью команды __*cat /etc/group | less*__  
![Cat_etc_group_less](../misc/images/img_for_report/Cat_etc_group_less.png#f4)  
После пайпа тут идёт команда _less_, которая позволяет нам по сути листать вывод команды, если он полностью не помещается на экран  

## **Part 3.** Setting up the OS network

1. **Set the machine name as user-1**  
Сначала проверим, что hostname в данный момент – это _willetts_  
После этого изменим willets на user-1 с помощью __*sudo hostname user-1*__  
![sudo_hostname_user-1](../misc/images/img_for_report/Part_3/sudo_hostname_user-1.png#f4)  
Но это ещё не всё. Чтобы наши изменения стали перманентными нам также нужно заменить willetts на user-1 в файлах /etc/hostname и /etc/hosts  
![hostname_willetts](../misc/images/img_for_report/Part_3/hostname_willetts.png#medium)
![hostname_user-1](../misc/images/img_for_report/Part_3/hostname_user-1.png#medium)  
(__*sudo nano /etc/hostname*__)  
![hosts_willetts](../misc/images/img_for_report/Part_3/hosts_willetts.png#medium)
![hosts_user-1](../misc/images/img_for_report/Part_3/hosts_user-1.png#medium)  
(__*sudo nano /etc/hosts*__)  
2. **Set the time zone corresponding to your current location**  
Сначала используем __*timedatectl*__, чтобы узнать, какой часовой пояс сейчас установлен в системе  
![timedatectl](../misc/images/img_for_report/Part_3/timedatectl.png#f4)  
Затем проверяем, есть ли вообще Москва в списке доступных часовых поясов с помощью команды __*timedatectl list-timezones | grep -i moscow*__  
![list-timezones_moscow](../misc/images/img_for_report/Part_3/list-timezones_moscow.png#f4)  
Устанавливаем новый часовой пояс через __*sudo timedatectl set-timezone Europe/Moscow*__  
![set_timezone](../misc/images/img_for_report/Part_3/set_timezone.png#f4)  
3. **Output the names of the network interfaces using a console command**  
Для того, чтобы увидеть названия сетевых интерфейсов можно воспользоваться командой __*ip link*__  
![ip link](../misc/images/img_for_report/Part_3/ip_link.png#f4)  
Команда _ip_ показывает и позволяет управлять маршрутизацией, сетевыми интерфейсами и туннелями.  
_link_ указывает на то, что нас интересуют непосредственно сетевые интерфейсы.  
**lo (или loopback) интерфейс** - это интерфейс, который автоматически создаётся операционной системой. Он называется loopback, потому что, грубо говоря, зацикливает компьютер сам на себя.  
Как я понял, в целом сетевые интерфейсы – это способы, которыми компьютер получает доступ к различным сетям. Они могут быть проводными, то есть ether (как, например, номер 2 на скриншоте), беспроводными (например, wlan) и тд.  
Непосредственно loopback является “внутренним ip адресом”, который нужен для того, чтобы программы могли взаимодействовать между собой в пределах этого компьютера, используя сетевые протоколы. Например, с помощью него браузер может получить доступ к локальному web-серверу.  
4. **Use the console command to get the ip address of the device you are working on from the DHCP server**  
Ip адрес от dhcp сервера можно получить с помощью команды  __*sudo dhclient -v*__  
![dhclient_v](../misc/images/img_for_report/Part_3/dhclient_v.png#f4)  
_dhclient_ – команда, с помощью которой можно взаимодействовать с DHCP (Dynamic Host Configuration Protocol) — протоколом динамической настройки узла, который автоматически раздаёт ip адреса девайсам в сети. Он упрощает управление адресами, так как сисадмину не нужно руками присваивать каждому устройству адрес. Плюс, DHCP гарантирует, что адреса будут уникальными. Ну, я так понял. Флаг _v (verbose)_ активирует подробный вывод.  
5. **Define and display the external ip address of the gateway (ip) and the internal IP address of the gateway, aka default ip address (gw)**  
_Внешний Ip адрес шлюза_ - это адрес, который нужен для выхода в интернет, принадлежит провайдеру (соответственно, мы его поменять не можем) и часто объединяет сотни пользователей.  
Его можно узнать, например, с помощью команды __*curl ifconfig.me*__ (по мимо ifconfig есть ещё куча других сайтов, с помощью которых через терминал можно вывести ip)  
![curl_ifconfig.me](../misc/images/img_for_report/Part_3/curl_ifconfig.me.png#f4)  
_Внутренний IP-адрес шлюза, он же ip-адрес по умолчанию (gw)_ - это адрес нашего шлюза (например, wifi роутера), по которому устройства внутри локальной сети к нему обращаются.  
Его можно узнать, например, с помощью команды __*ip r | grep default*__  
![ip_r_default](../misc/images/img_for_report/Part_3/ip_r_default.png#f4)  
Я примерно так понял соотношение всех этих ip адресов:  
![ip_ip_gw](../misc/images/img_for_report/Part_3/ip_ip_gw.png#medium)  
6. **Set static (manually set, not received from DHCP server) ip, gw, dns settings (use public DNS servers, e.g. 1.1.1.1 or 8.8.8.8)**  
Для того, чтобы изменить внутренний ip-адрес шлюза (_gw_) нужно сначала, используя команду __*sudo ip r delete default*__, удалить дефолтный внутренний ip-адрес шлюза (в нашем случае 10.0.2.2).  
![ip_r_delete_default](../misc/images/img_for_report/Part_3/ip_r_delete_default.png#f4)   
Затем, с помощью __*sudo ip r add default via 10.0.2.3 dev enp0s3*__ установить новый дефолтный шлюз.  
![new_default](../misc/images/img_for_report/Part_3/new_default.png#f4)  
Однако, чтобы изменения сохранились после перезапуска виртуальной машины, необходимо закрепить их в _.yaml_ файле в _/etc/netplan_. В этом же файле мы установим _static ip_ и _dns_, также нужные по заданию. Однако сначала нужно понять, какие значения _ip_ и _dns_ мы можем указать.  
Для _ip_ нам нужно выяснить диапазон доступных адресов. Для этого нам нужно узнать, собственно, _ip_ и _netmask_. Воспользуемся командой __*ifconfig -a*__.  
![ifconfig_a](../misc/images/img_for_report/Part_3/ifconfig_a.png#f4)  
Здесь мы видим как _ip_ – который мы определили раньше другим методом, – так и _netmask_, так и значение _broadcast_, которое указывает на предел доступных ip.  
То есть в нашем случае граница доступных _ip_ адресов - _10.0.2.254_.  
Первое же значение можно узнать с помощью формулы, которую я нашёл [на этом сайте](https://www.baeldung.com/cs/get-ip-range-from-subnet-mask).  
**First IP = IP & MASK** = 10.0.2.15 & 255.255.255.0 = 10.0.2.0, а первый стабильный для использования ip = 10.0.2.1 =>  
=> Доступный нам диапазон = _10.0.2.1 - 10.0.2.254_. Я так понял, по крайней мере. Возьмем для примера ip =  _10.0.2.254/24_ (24, так как при вызове ip a, можно увидеть, что под netmask зарезервировано 24 бита).  
![ip_a](../misc/images/img_for_report/Part_3/ip_a.png#small)  
Теперь разберёмся с _DNS_. Как я понял, каждому цифровому ip адресу присваивается буквенное имя (домен) и _DNS_ (Domain Name System) – это система, которая преобразует это имя обратно в ip для доступа к тому или иному ip. Короче, это система, которая позволяет вводить в адресной строке браузера не _192.2.0…_, а просто домен сайта _aboba.com_. В данном примере воспользуемся, предложенным в задании, публичным DNS сервером Google 8.8.8.8  
Теперь, наконец, перейдём к папке netplan.  
![netplan](../misc/images/img_for_report/Part_3/netplan.png#f4)  
В папке netplan могут находится разные файлы. В нашем случае в ней лежит файл _00-installer-config.yaml_, в который нам необходимо внести изменения с помощью  
__*sudo nano 00-installer-config.yaml*__  
![yaml_before](../misc/images/img_for_report/Part_3/yaml_before.png#f4)  
Теперь файл выглядит таким образом: мы отключили dhcp, указали кастомный ip и gw и указали dns сервер  
![yaml_after](../misc/images/img_for_report/Part_3/yaml_after.png#f4)  
Осталось только подтвердить изменения с помощью __*sudo netplan try*__  
![accept_new_yaml](../misc/images/img_for_report/Part_3/accept_new_yaml.png#f4)  
7. **Reboot the virtual machine. Make sure that the static network settings (ip, gw, dns) correspond to those set in the previous point**  
Тут было кайфовое видео с перезагрузкой и проверкой, но Гитлаб не разрешил... Так что вот скриншот  
![Substitute](../misc/images/img_for_report/Part_3/Substitute.png#f4)
8. **Successfully ping 1.1.1.1 and ya.ru remote hosts and add a screenshot of the output command to the report. There should be "0% packet loss" phrase in command output.**  
![ping](../misc/images/img_for_report/Part_3/ping.png#f4)  

## **Part 4.**  OS Update  

Для обновления системных пакетов необходимо использовать две команды: __*sudo apt update*__ и __*sudo apt upgrade*__  
После установки обновления можно снова вывести __*sudo apt upgrade*__ и даже на всякий случай __*apt list --upgradeable*__, чтобы убедиться, что всё установилось  
![update_upgrade](../misc/images/img_for_report/update_upgrade.png#f4)  

## **Part 5.**  Using the sudo command  

 * Команда **sudo (substitute user and do)** позволяет пользователям запускать программы от имени других пользователей и – главное – суперпользователя _root_, без необходимости ввода пароля _root_.  
Если специально не указывать имя другого пользователя, то по дефолту команда выполняется от имени _root_ суперпользователя. _Sudo_ может запросить ваш пароль, а иногда вообще отказаться работать, заявив, что у вас нет прав её использовать в данном случае.  

Разрешение использовать команду sudo на ubuntu = добавить пользователя в группу “sudo”  
_(cat /etc/group)_  
![Sudo_willetts](../misc/images/img_for_report/Sudo_willetts.png#f4)  
Соответственно, выполняется это через команду __*sudo user mod -aG sudo mega_willetts*__  
![Sudo_mega_willetts](../misc/images/img_for_report/Sudo_mega_willetts.png#f4)  

 * Меняем hostname через mega_willetts, также как в п.3:
    * __*sudo hostname UbuntuLover*__  
    ![UbuntuLover](../misc/images/img_for_report/UbuntuLover.png#f4)  
    * __*sudo nano /etc/hostname*__ + __*sudo nano /etc/hosts*__  
    ![Nano_Ubuntu_Lover](../misc/images/img_for_report/Nano_Ubuntu_Lover.png#medium)
    ![Nano_Ubuntu_Lover2](../misc/images/img_for_report/Nano_Ubuntu_Lover2.png#medium)  
    * Перезагружаем и проверям, что всё ок  
    ![After_Reload](../misc/images/img_for_report/After_Reload.png#f4)  

## **Part 6.**  Installing and configuring the time service  

Запускаем __*timedatectl show*__, как просят в задании  
А там уже всё синхронизированно  
![Sync_Time](../misc/images/img_for_report/Sync_Time.png#f4)  

## **Part 7.**  Installing and using text editors  

 * Написать в файлах никнейм + сохранить:  
   1. Vim: Esq=>:wq   
   ![Vim_nickname](../misc/images/img_for_report/Vim_nickname.png#small)  
   2. Nano: Cntrl+x=>Y=>Enter _OR_ Cntrl+o=>Enter=>Cntrl+x  
   ![Nano_nickname](../misc/images/img_for_report/Nano_nickname.png#small)  
   3. McEdit: Fn+F2=>Fn+F10  
   ![Mc_nickname](../misc/images/img_for_report/Mc_nickname.png#small)  

 * Написать в файлах “21 School 21” + выйти без сохранения:
   1. Vim: Esq=>:q!  
   ![Vim_Nosave](../misc/images/img_for_report/Vim_Nosave.png#small)  
   2. Nano: Cntrl+x=>N  
   ![Nano_Nosave](../misc/images/img_for_report/Nano_Nosave.png#small)  
   3. McEdit: Fn+F10=>No  
   ![Mc_Nosave](../misc/images/img_for_report/Mc_Nosave.png#small)  

 * Осуществить поиск и замену слова
   1. Vim: _Поиск:_ /willetts; _Замена:_ :s/willetts/mega_willetts  
   ![Vim_search](../misc/images/img_for_report/Vim_search.png#small)
   ![Vim_replace](../misc/images/img_for_report/Vim_replace.png#small)  
   2. Nano: _Поиск:_ Cntrl+M=>willetts; _Замена:_ Cntrl+\=>willetts=>mega_willetts=>Y or A(all)  
   ![Nano_search](../misc/images/img_for_report/Nano_search.png#small)
   ![Nano_replace](../misc/images/img_for_report/Nano_replace.png#small)  
   3. McEdit: _Поиск и Замена:_ Fn+F4=>willets to mega_willetts    
   ![Mc_replace](../misc/images/img_for_report/Mc_replace.png#small)
   ![Mc_replace2](../misc/images/img_for_report/Mc_replace2.png#shmall)  

## **Part 8.** Installing and basic setup of the SSHD service  

**SSH** (от англ. secure shell ― безопасная оболочка) ― это защищенный сетевой протокол, который используется для передачи данных, удалённого управления серверами, передачи шифрованного трафика и тд. SSH-соединение состоит из 2-х компонентов: _SSH-сервер_ и _SSH-клиент_. Они обмениваются публичными и частными ключами для аутентификации. Бесплатный вариант клиента и сервера — OpenSSH. Его и установим [(доп инфа по ssh)](https://help.reg.ru/support/hosting/dostupy-i-podklyucheniye-panel-upravleniya-ftp-ssh/chto-takoye-ssh)  

1. **Установка SSHd**  
Для того, чтобы установить sshd на нашу виртуальную машину, воспользуемся двумя командами:  
__*sudo apt-get install ssh*__ и __*sudo apt install openssh-server*__  
2. **Добавим автостарт службы при загрузке системы**
Для этого запустим команду __*sudo systemctl enable ssh*__  
Проверим работу ssh  
![Запуск_ssh](../misc/images/img_for_report/Запуск_ssh.png#f4)  
Как мы видим – всё работает  
3. **Перенастроим службу SSHd на порт 2022**  
Для этого изменим конфигурационный файл сервера ssh:  
__*sudo nano /etc/ssh/sshd_config*__  
![Перенастройка_порта](../misc/images/img_for_report/Перенастройка_порта.png#f5)  
Затем перезапустим ssh сервер:  
__*sudo systemctl restart ssh*__  
Проверим порт:  
![Новый_порт](../misc/images/img_for_report/Новый_порт.png#f4)  
4. **Используя команду ps, покажем наличие процесса sshd.**  
Для этого используем __*ps -C sshd*__  
![ps](../misc/images/img_for_report/ps.png#f4)  
Сама команда _ps_ позволяет видеть список активных процессов,  
а флаг _C_ даёт возможность произвести поиск по активным процессам, используя _“command name”_ или _“cmd”_ нужного процесса, в нашем случае – sshd  
5. **Перезагружаем систему**  
6. **Используем _netstat -tan_**  
![netstat](../misc/images/img_for_report/netstat.png#f4)  
Команда netstat показывает статус сети, а если конкретнее –  содержимое различных структур данных, связанных с сетью, в различных форматах, в зависимости от указанных опций.  
В данном случае мы используем _три флага_:  
   1. **--tcp|-t** – показывает _tcp_ сокеты, а нам нужны именно они, так как ssh действует как раз через протокол tcp.  
   В целом, **Tcp** - один из основных протоколов передачи данных.  
   По этому протоколу перед непосредственной передачей необходимо сначала установить соединение между двумя устройствами, которое называется “трёхстороннее рукопожатие”.  
   Сначала одна сторона спрашивает другую, может ли она начать передавать сообщение _(syn)_, вторая – подтверждает, что может _(syn ack)_, а потом первая подтверждает, что готова передавать _(ack)_, после чего начинается непосредственно передача.  
   **Плюс**: точность. **Минус**: скорость.  
   Используется в передаче сообщений в мессенджерах, при совершении банковских операций и тд.  
   Также есть протокол **Udp**. При использовании данного протокола отправляющая сторона просто сразу начинает высылать информацию получающей стороне.  
   **Плюс**: скорость. **Минус**: некоторые данные теряются.  
   Используется в зумах, скайпах и тп, на стриминговых платформах. [(доп инфа по протоколам)](https://www.youtube.com/watch?v=yMSJKBQINAc)  
   ![Tcp_vs_Udp](../misc/images/img_for_report/Tcp_vs_Udp.png#small)  
   2. **—all|-a** – показывает все активные сокеты, то есть и те, которые пока только ждут соединения.  
   По дефолту netstat выдаёт только сокеты с установленным соединением.  
   3. **—numeric|-n** – показывает сетевые адреса как числа. netstat обычно показывает адреса как символы, то есть без флага n “127.0.0.53:53” отображалось бы как “localhost:domain”
    ![netstat_без_n](../misc/images/img_for_report/netstat_без_n.png#small)  
7. **Что означает вывод netstat?**  
_Proto_ – протокол передачи данных (Tcp, Udp, Raw, Unix)  
_Recv-Q_ – биты, которые находятся в очереди на получение. Если это число высокое, то нужно проверить работоспособность приложения, которое работает с данным портом.  
_Send-Q_ – биты, которые находятся в очереди на отправку. Высокое значение может быть связано с перегрузкой сети сервера.  
_Local Address_ – локальный адрес сервера и порт, который используется для конкретного соединения. **0.0.0.0** значит, что подключаться можно ко всем доступным адресам этого сервера, а не к какому-то конкретному  
_Foreign Address_ – адрес второй стороны соединения. В обычных соединения – это адрес с которого пришло соединение. В прослушиваемых портах (с LISTEN в State) — это диапазон адресов. Так __0.0.0.0:*__ — значит подключаться можно с любых адресов и с любых портов.  
_State_ – Состояние подключения. LISTEN значит, что сокет ожидает подключения.  

## **Part 9.** Installing and using the top, htop utilities  

Утилиты top и htop уже были установлены!  

* **_top:_**  
 ![Top](../misc/images/img_for_report/Top.png#f5)  
__Uptime:__ 1:41 (1 час 41 минута)  
__Number of authorised users:__ 1 user  
__Total system load:__ 0.00 (за минуту), 0.00 (за 5 мин), 0.00 (за 15 мин)  
__Total number of processes:__ 96  
__Cpu load:__ 
_0.0 us (user)_ – процент использования cpu пользовательскими процессами  
_0.0 sy (system)_ – процент использования cpu системными процессами  
_0.0 ni (nice)_ – процент использования cpu процессами с пометкой “nice”, то есть процессами повышенного приоритета  
_100.0 id (idle)_ – процент времени, когда cpu отдыхает  
_0.0 wa (IO-wait)_ – процент времени, когда cpu находится в ожидании завершения процессов ввода/вывода  
_0.0 hi_ – процент использования cpu обработчиками аппаратных прерываний  
_0.0 si_ – процент использования cpu обработчиками программных прерываний  
_0.0 st_ – процент времени, когда cpu не был доступен текущей виртуальной машине, то есть “украден”(stolen) гипервизором  
__Memory load:__   
_MiB Mem:_ 1971.6 total, 1190.4 free, 196.0 used. 585.2 buff/cashe  
Это физическая память, в данном случае, в мебибайтах (2^20 байт)  
_MiB Swap:_ 1479.0 total, 1479.0 free, 0.0 used. 1620.4 avail Mem  
Это виртуальная память  
**Pid of the process with the highest memory usage:** 1702  
![Top_Mem](../misc/images/img_for_report/Top_Mem.png#f5)  
**Pid of the process taking the most CPU time:** 1749  
![Top_Time](../misc/images/img_for_report/Top_Time.png#f5)  
* **_htop:_**  
_Sorted by PID:_  
![htop_by_pid](../misc/images/img_for_report/htop_by_pid.png#medium)  
_Sorted by PERCENT_CPU:_  
![htop_by_percent_cpu](../misc/images/img_for_report/htop_by_percent_cpu.png#medium)  
_Sorted by PERCENT_MEM:_  
![htop_by_percent_mem](../misc/images/img_for_report/htop_by_percent_mem.png#medium)  
_Sorted by TIME:_  
![htop_by_time](../misc/images/img_for_report/htop_by_time.png#medium)  
_Filtered for sshd process:_  
![htop_filter_sshd](../misc/images/img_for_report/htop_filter_sshd.png#medium)  
_With the syslog process found by searching:_  
![htop_syslog](../misc/images/img_for_report/htop_syslog.png#medium)  
_With hostname, clock and uptime output added:_  
![htop_host_clock_uptime](../misc/images/img_for_report/htop_host_clock_uptime.png#medium)  

## **Part 10.** Using the fdisk utility  

Вывод fdisk -l:  
![fdisk](../misc/images/img_for_report/fdisk.png#f4)  
**Name of the hard disk:** dev/sda  
**Capacity:** 10 Gib  
**Number of sectors:** 20971520  
**Swap size:** 1.4 Gib  

## **Part 11.** Using the df utility  

* __*df:*__  
Вывод __*df*__:  
![df](../misc/images/img_for_report/df.png#f4)  
**Partition size:** 8408452 Kib  
**Space used:** 4322656 Kib  
**Space free:** 3637080 Kib  
**Percentage used:** 55  
**Единица измерения:** Kibibyte🥹  
* __*df -Th:*__  
Вывод __*df -Th*__:  
![df_-Th](../misc/images/img_for_report/df_-Th.png#f4)  
**Partition size:** 8.1 Gib  
**Space used:** 4.2 Gib  
**Space free:** 3.5 Gib  
**Percentage used:** 55  
**Тип файловой системы:** ext4  

_Ext4_– это журналируемая файловая система, которая является стандартной файловой системой Ubuntu. Её главной особенностью является то, что она выделяет блоки памяти группами _(multiblock allocation)_, что позволяет:  
1. Значительно снизить нагрузку на процессор при поиске свободных блоков в файловой системе;  
2. Снизить уровень фрагментации файловой системы, так как файловая система хранит информацию не только о месторасположении свободных блоков, но и о количестве свободных блоков, расположенных друг за другом таким образом, что при выделении места система находит такой фрагмент, куда данные можно записать без фрагментации.
###### **Журналируемая файловая система** – это система, в которой перед фактическим осуществлением каких-либо изменений их список предварительно сохраняется в отдельной части файловой системы, называемой журналом. Как только изменения внесены в журнал –  они применяются к файлам или метаданным, а затем соответствующие записи из журнала удаляются. Записи журнала организованы в наборы связанных изменений файловой системы. При перезагрузке системы программа монтирования может гарантировать целостность журналируемой файловой системы простой проверкой журнала на наличие ожидаемых, но не произведённых ивзменений и последующей записью их в файловую систему; то есть при наличии журнала в большинстве случаев системе не нужно проводить проверку целостности файловой системы. Соответственно, шансы потери данных в связи с проблемами в файловой системе значительно снижаются.  
_Tmpfs и devtmpfs_ – это файловые системы, которые используются для временных файлов. Обе файловые системы хранят все свои файлы в виртуальной памяти и при перезапуске системы все эти файлы теряются.  
_Squashfs_ – это сжимающая файловая система, предоставляющая доступ к данным в режиме «только для чтения».  

## **Part 12.** Using the du utility  

* **Размер /home:** 144 Kibibytes  
![du_home](../misc/images/img_for_report/du_home.png#medium)  
Здесь мы используем флаг h, чтобы указать размер в человекочитаемом формате.  
  * Интересно, что у команды du ещё есть флаг _—apparent-size_, который показывает размер в “apparent size”, то есть показывает количество байтов, которые, по мнению _du_, находятся в файле. По дефолту же du показывает “disk usage”, то есть объем пространства, который нельзя использовать для чего-то другого, поскольку это место занимает данный файл. В большинстве случаев _apparent size_ меньше, чем _disk usage_, так как во втором учитывается полный размер последнего (частичного) блока файла, а в _apparent size_ учитываются только данные, находящиеся в этом последнем блоке, а не он полностью.  
 ![du_apparent_size](../misc/images/img_for_report/du_apparent_size.png#medium)  
* **Размер /var:** 859 Mebibytes  
![du_var](../misc/images/img_for_report/du_var.png#medium)  
Здесь мы используем также флаг _s_, чтобы _du_ выдал только размер _var_, без составляющих _/var_ (их очень много) + _sudo_, чтобы нам не выдавались сообщения об отсутствии у нас прав на доступ к тем или иным репозиториям.  
* **Размер /var/log:** 150M  
![du_var_log](../misc/images/img_for_report/du_var_log.png#medium)   
* Размер всего содержимого /var/log (с помощью команды __sudo du -h /var/log/* | less__):  
![du_var_log_asterisk1](../misc/images/img_for_report/du_var_log_asterisk1.png#medium)  
![du_var_log_asterisk2](../misc/images/img_for_report/du_var_log_asterisk2.png#small)  

## **Part 13.** Installing and using the ncdu utility  

Утилита ncdu уже была установлена!  

* **Размер /home:** 144 Kib (__*ncdu /home*__)  
![ncdu_home](../misc/images/img_for_report/ncdu_home.png#medium)  
* **Размер /var:** 853 Mib (__*ncdu /var*__)  
![ncdu_var](../misc/images/img_for_report/ncdu_var.png#medium)  
* **Размер /var/log:** 149.9 Mib (__*ncdu /var/log*__)   
![ncdu_var_log](../misc/images/img_for_report/ncdu_var_log.png#medium)  

## **Part 14.** Working with system logs  

1. **/var/log/dmesg**  
__*dmesg*__ – это команда, с помощью которой можно проследить за процессом инициализации ядра ОС. В _var/log/dmesg_ хранится информация идентичная выводу команды _dmesg_. Также есть log по адресу _/var/log/kern.log_, где также хранится информация о предыдущих инициализациях ядра ОС с датами.  
![dmesg_start](../misc/images/img_for_report/dmesg_start.png#medium)
![dmesg_end](../misc/images/img_for_report/dmesg_end.png#medium)  
2. **/var/log/syslog**  
Глобальный системный журнал, в который записываются различные сообщения от ядра, служб, сетевых интерфейсов и тд.  
![syslog_start](../misc/images/img_for_report/syslog_start.png#medium)
![syslog_end](../misc/images/img_for_report/syslog_end.png#medium)  
3. **/var/log/auth.log**  
![auth_start](../misc/images/img_for_report/auth_start.png#medium)
![auth_end](../misc/images/img_for_report/auth_end.png#medium)  

Для того, чтобы вывести список открытых сегодня (10 Апреля) сессий воспользуемся командой:  
__*cat /var/log/auth.log | grep -i ‘Apr 10’ | grep -i ‘session’ | less*__  
![Last_log](../misc/images/img_for_report/Last_log.png#medium)  
* **Время последней успешной авторизации:** 18:04:30  
* **Имя пользователя:** willetts  
* **Метод хода в систему:** LOGIN(uid=0) (uid=0 – это root, то есть, как я понял, технически сессии открывает root user)  

Перезапустим ssh с помощью __*sudo systemctl restart ssh*__  
Информация об этом записалась в _syslog_ и _auth.log_  
![ssh_restart_in_syslog](../misc/images/img_for_report/ssh_restart_in_syslog.png#medium)  
![ssh_restart_in_auth](../misc/images/img_for_report/ssh_restart_in_auth.png#medium)  

## **Part 15.** Using the CRON job scheduler  

**Cron** — это планировщик задач, используемый для выполнения задач (в фоновом режиме) в указанное время.
Запускается cron с помощью команды crontab, которая обладает рядом флагов:  
![Cron_flags](../misc/images/img_for_report/Cron_flags.png#medium)  
Каждая запись в crontab состоит из шести полей, указываемых в порядке: минуты часы дни месяцы день недели команда  
![Cron_param](../misc/images/img_for_report/Cron_param.png#medium)  
Примеры использования:  
![Cron_examples](../misc/images/img_for_report/Cron_examples.png#medium)  
Также можно использовать оператор “/” для установки шага, например **10/2 * * * * aboba** будет запускать каждые две минуты в диапазоне от 1 до 10 минут каждого часа команду aboba
 
**Соответственно, для выполнения задания:**
* Открыл файл планировщика Cron для текущего пользователя с помощью команды __*crontab -e*__  
* В списке выбрал дефолтныйный редактор Nano (не успел сделать скриншот, на второй раз автоматом открылось через nano)  
* Добавил строчку ***/2 * * * * uptime**, чтобы каждые 2 мин запускалась команда uptime  
![Crontab-e](../misc/images/img_for_report/Crontab-e.png#medium)  
* Список текущих задач можно посмотреть с помощью __*crontab -l*__  
![Crontab-l](../misc/images/img_for_report/Crontab-l.png#medium)  
* Факт выполнения _uptime_ можно посмотреть в syslog и auth.log:  
![Cron_syslog](../misc/images/img_for_report/Cron_syslog.png#medium)
![Cron_auth](../misc/images/img_for_report/Cron_auth.png#medium)  
* Теперь удаляем через __*crontab -r*__:  
![Crontab-r](../misc/images/img_for_report/Crontab-r.png#medium)  
* Проверям через __*crontab -l*__  
![no_cron](../misc/images/img_for_report/no_cron.png#medium)  
И там пусто, вот это да

Thank you for coming to my TED Talk  
![ABOBA](../misc/images/img_for_report/ABOBA.jpeg#ABOBA)  



