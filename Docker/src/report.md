# Simple Docker (willetts)

## Part 1. Готовый докер

После запуска докера начинаем выполнять задание:  
- Сначала скачиваем официальный докер-образ nginx с помощью команды docker pull nginx  
<img src="../misc/images/report_img/docker_pull_nginx.png" alt="docker_pull_nginx" width="700"/><br>  
- Затем проверяем наличие докер-образа через docker images  
<img src="../misc/images/report_img/docker_images.png" alt="docker_images" width="600"/><br>  
- После этого запускаем докер-образ через docker run -d [image_id|repository]; в нашем случае docker run -d nginx
- Проверяем, что всё запустилось через docker ps  
<img src="../misc/images/report_img/docker_run_ps.png" alt="docker_run_ps" width="800"/><br>  
- Посмотрим информацию о контейнере через docker inspect [container_id|container_name]
    - Чтобы посмотреть размер воспользуемся командой добавим к команде спецификатор size (и перенаправим вывод в файл)  
    <img src="../misc/images/report_img/inspect_size.png" alt="inspect_size" width="600"/><br>  
    При наличии данного спецификатора в вывод команды добавятся строки “SizeRootFs” и “SizeRW”.  
    _SizeRootFs_ показывает общий вес всех файлов в контейнере, в байтах  
    _SizeRW_ – вес новых или изменённых по сравнению с оригинальным изображением (image) файлов, тоже в байтах  
    <img src="../misc/images/report_img/inspect_size_file.png" alt="inspect_size_file" width="600"/><br>  
    - Для нахождения замапленных портов и ip контейнера достаточно команды docker inspect    
    <img src="../misc/images/report_img/inspect_file.png" alt="inspect_file" width="700"/><br>  
    - Таким образом,  
    **Размер**: 187668955 байт (~187,6 Мб),  
    **Замапленный порт**: 80/tcp,  
    **Ip контейнера**: 172.17.0.2
- Остановим докер образ через docker stop [container_id|container_name]  
- Проверим, что он остановился  
<img src="../misc/images/report_img/docker_stop.png" alt="docker_stop" width="600"/><br>  
- Запустим докер с портами 80 и 443 в контейнере, замапленными на такие же порты на локальной машине, через команду run.  
  <img src="../misc/images/report_img/map_to_host_ports.png" alt="map_to_host_ports" width="600"/><br>  
  > Примечание: флаг -d позволяет контейнеру работать “на заднем фоне”, в противном случае его работа зависела бы от терминала
- Проверим, что в браузере по адресу localhost:80 доступна стартовая страница nginx  
  <img src="../misc/images/report_img/localhost_nginx.png" alt="localhost_nginx" width="500"/><br>  
- Перезапустим докер контейнер через docker restart [container_id|container_name]  
  <img src="../misc/images/report_img/docker_restart.png" alt="docker_restart" width="700"/><br>  

## Part 2. Операции с контейнером

- Прочитаем конфигурационный файл nginx.conf внутри докер контейнера через команду exec.    
<img src="../misc/images/report_img/nginx_conf1.png" alt="nginx_conf1" width="700"/><br>  
<img src="../misc/images/report_img/nginx_conf2.png" alt="nginx_conf2" width="600"/><br>  
- Создадим на локальной машине файл nginx.conf. По образу файла nginx.conf внутри контейнера  
<img src="../misc/images/report_img/our_nginx_conf.png" alt="our_nginx_conf" width="600"/><br>  
Но:  
    - Добавим кусок кода, который будет выдавать по дефолту стартовую страницу nginx и при обращении по /status статус сервера(stub_status)  
    - Закомментим “include /etc/nginx/conf.d/*.conf” – если этого не сделать, то nginx по дефолту будет считать приоритетным файлы из conf.d, то есть в нашем случае default.conf, а там есть указание только на стартовую страницу nginx.   
    <img src="../misc/images/report_img/default_conf.png" alt="default_conf" width="500"/><br>  
    Соответственно, чтобы иметь доступ и к стартовой странице, и к /status, то нам нужно либо добавить указание на то, что делать при /status в default.conf, либо указание на то, что делать при дефолтном localhost в ngix.conf. Я так понял. По зданию нужно сделать второе.  
- Скопируем созданный файл nginx.conf внутрь докер-образа через команду docker cp.  
<img src="../misc/images/report_img/nginx_conf_cp.png" alt="nginx_conf_cp" width="500"/><br>  
- Перезапустим nginx внутри докер-образа через команду exec. Для этого используем команду “nginx -s reload”, но лучше сначала использовать команду “nginx -t” (это что-то типа netplan try)  
<img src="../misc/images/report_img/nginx_reload.png" alt="nginx_reload" width="500"/><br>  
- Проверим, что по адресу localhost:80/status отдается страничка со статусом сервера nginx  
<img src="../misc/images/report_img/localhost_status.png" alt="localhost_status" width="500"/><br>  
- Экспортируем контейнер в файл container.tar через команду export.  
<img src="../misc/images/report_img/nginx_export.png" alt="nginx_export" width="500"/><br>  
- Остановим контейнер.  
<img src="../misc/images/report_img/docker_stop1.png" alt="docker_stop1" width="500"/><br>  
- Удалим образ через docker rmi [image_id|repository], не удаляя перед этим контейнеры  
<img src="../misc/images/report_img/forced_removal.png" alt="forced_removal" width="500"/><br>  
- Удалим остановленный контейнер  
<img src="../misc/images/report_img/minus_container.png" alt="minus_container" width="500"/><br>  
- Импортируем контейнер обратно через команду import  
<img src="../misc/images/report_img/import_container.png" alt="import_container" width="500"/><br>  
- Запустим импортированный контейнер. Но он не запускается так просто  
<img src="../misc/images/report_img/fail_run.png" alt="fail_run" width="500"/><br>  
Причина в том, что команды import/export нужны для копирования файловой системы контейнера, а для переноса image чаще используют save/load. Соответственно, многие из настроек оригинального nginx, который мы пулили c docker_hub, не перенеслись в наш новый nginx, так как мы использовали команду export. Однако это можно исправить вручную. Для этого нужно:  
    - Запулить оригинальный nginx  
    - С помощью inspect посмотреть его настройки  
    - С помощью того же inspect посмотреть настройки нашего текущего “nginx”   
    - Сравнить; посмотреть чего не хватает нашему.  
    <img src="../misc/images/report_img/compare_nginx.png" alt="compare_nginx" width="800"/><br>  
     Из того, что мы можем исправить при импорте – это Cmd и Entrypoint (Env тоже, вроде, можно, но не обязательно)  
    - Импортировать с исправлениями и запустить контейнер  
    <img src="../misc/images/report_img/suc_import.png" alt="suc_import" width="700"/><br>  
    <img src="../misc/images/report_img/suc_run.png" alt="suc_run" width="700"/><br>  

## Part 3. Мини веб-сервер

- Напишем мини-сервер на C и FastCgi, который будет возвращать простейшую страничку с надписью Hello World!  
<img src="../misc/images/report_img/fcgi_server_c.png" alt="fcgi_server_c" width="600"/><br>  
    - Если это всё делается со школьного мака, то во-первых, земля пухом 🙏, а во-вторых, нужно установить через brew пакеты “fcgi” и “spawn-fcgi” и потому что это школьный мак, то нужно его мордой потыкать в то, куда fcgi установился, то есть прописать в корневом файле .zshrc путь до библиотеки fcgi; в противном случае он будет выдавать ошибку, мол, ему библиотека fcgi_stdio.h незнакома  
    <img src="../misc/images/report_img/zshrc.png" alt="zshrc" width="400"/><br>  
    - После всех этих манипуляций можно по примеру [отсюда](https://fastcgi-archives.github.io/fcgi2/doc/fastcgi-prog-guide/ch2c.htm) написать файл мини-сервера  
    - Затем нужно скомпилировать всё это с флагом -lfcgi в .fcgi файл   
<img src="../misc/images/report_img/compile_server.png" alt="compile_server" width="700"/><br>  
- Запустим мини-сервер через spawn-fcgi на порту 8080  
<img src="../misc/images/report_img/spawn_fcgi_server.png" alt="spawn_fcgi_server" width="600"/><br>  
- Напишем свой nginx.conf, который будет проксировать все запросы с 81 порта на 127.0.0.1:8080   
<img src="../misc/images/report_img/nginx_config_server.png" alt="nginx_config_server" width="700"/><br>  
Здесь главное понять, куда потом после создания этот конфиг пихать (и какой include там писать), потому что не всегда понятно, куда установился nginx.  
Для нахождения директории nginx можно посмотреть на вывод команды nginx -t, которая проверяет на правильность конфигурационный файл nginx.   
<img src="../misc/images/report_img/nginx_t.png" alt="nginx_t" width="700"/><br>  
То есть, в моём случае – это “/Users/willetts/.brew/etc/nginx/nginx.conf”, соответственно конфигурацию нужно с заменой переместить по этому адресу, а в include написать “/Users/willetts/.brew/etc/nginx/mime.types”.  
Ну и нужно не забыть, собственно, запустить nginx командой nginx
- Проверим, что в браузере по localhost:81 отдается написанная нами страничка.   
<img src="../misc/images/report_img/81_server.png" alt="81_server" width="500"/><br>  
- Положим файл nginx.conf по пути ./nginx/nginx.conf (с этим я без проблем справился хах)

## Part 4. Свой докер

 - Напишем свой докер-образ, который:
    1) собирает исходники мини сервера на FastCgi из Части 3;
    2) запускает его на 8080 порту;
    3) копирует внутрь образа написанный ./nginx/nginx.conf;
    4) запускает nginx.  
    <img src="../misc/images/report_img/Task4_Dockerfile.png" alt="Task4_Dockerfile" width="600"/><br>  

    Тут это осуществляется через докерфайл, который  
    1. собирает образ на основе nginx, 
    2. копирует туда наш код для поднятия сервера, конфигурацию nginx, и файл баш, в котором прописаны команды для непосредственного запуска сервера, 
    3. устанавливает в него разные зависимости, которые нам нужны,
    4. запускает - предварительно скопированный в контейнер - файл баш, который непосредственно поднимает сервер    
     <img src="../misc/images/report_img/Task4_bash.png" alt="Task4_bash" width="600"/><br>  
- Соберём написанный докер-образ через docker build при этом указав имя и тег.  
 <img src="../misc/images/report_img/Task4_docker_build.png" alt="Task4_docker_build" width="600"/><br>  
- Проверим через docker images, что все собралось корректно.     
<img src="../misc/images/report_img/Task4_docker_images.png" alt="Task4_docker_images" width="600"/><br>  
- Запустим собранный докер-образ с маппингом 81 порта на 80 на локальной машине и маппингом папки ./nginx внутрь контейнера по адресу, где лежат конфигурационные файлы nginx'а  
<img src="../misc/images/report_img/Task4_docker_run.png" alt="Task4_docker_run" width="700"/><br>  
- Проверим, что по localhost:80 доступна страничка написанного мини сервера.  
<img src="../misc/images/report_img/Task4_curl_localhost.png" alt="Task4_curl_localhost" width="500"/><br>  
- Допишем в ./nginx/nginx.conf проксирование странички /status, по которой надо отдавать статус сервера nginx.  
<img src="../misc/images/report_img/Task4_nginx_conf.png" alt="Task4_nginx_conf" width="500"/><br>  
- Перезапустим докер-образ и проверим страничку /status  
<img src="../misc/images/report_img/Task4_restart.png" alt="Task4_restart" width="600"/><br>  

## Part 5. Dockle

Просканируем образ из предыдущего задания через dockle [image_id|repository].  
<img src="../misc/images/report_img/dockle_mistakes.png" alt="dockle_mistakes" width="600"/><br>  
Исправим всё так, чтобы при проверке через dockle не было ошибок и предупреждений.
- Первая ошибка (CIS-DI-0010) возникает из-за каких-то проблем с environment переменными. Так как, перечисленных в выводе ошибки, переменных  нет ни в среде, в которой я выполняю проект, ни в контейнерах, созданных по данному образу – вероятно, что они каким-то образом хранятся в самом nginx, поэтому специально для dockle я немного переписал Dockerfile, чтобы он создавался не на основе nginx, а на основе ubuntu, а nginx бы туда просто подгружался как пакет.  
Также я его сделал немного красивее и избавился от второй фатальной ошибки  
<img src="../misc/images/report_img/upd_dockerfile.png" alt="upd_dockerfile" width="600"/><br>  
- Третья ошибка (CIS-DI-0001) жалуется на то, что в Dockerfile существует только root пользователь, однако при попытках создать нового пользователя и наделить его правами админа (то есть переделать Dockerfile примерно так)  
<img src="../misc/images/report_img/dockle_help.png" alt="dockle_help" width="600"/><br>  
Сервер перестаёт нормально работать (хотя образ и контейнеры нормально создаются и запускаются)  
<img src="../misc/images/report_img/dockle_output.png" alt="dockle_output" width="600"/><br>  
Поэтому было принято решение просто прописывать dockle со спецификатором -i CIS-DI-0001  
<img src="../misc/images/report_img/dockle_fin.png" alt="dockle_fin" width="600"/><br>  

## Part 6. Базовый Docker Compose

Напишем файл docker-compose.yml, с помощью которого:
1) Поднимим докер-контейнер из Части 5 (он должен работать в локальной сети, т.е. не нужно использовать инструкцию EXPOSE и мапить порты на локальную машину).
2) Поднимим докер-контейнер с nginx, который будет проксировать все запросы с 8080 порта на 81 порт первого контейнера.
Замапим 8080 порт второго контейнера на 80 порт локальной машины.
По сути здесь мы просто прописываем ещё один Докерфайл для сервера-прокси и с нашего оригинального сервера через этот сервер-прокси выводим "Hello, World!" Для этого нам понадобится:
- Dockerfile прокси с дополнительным bash файлом  
<img src="../misc/images/report_img/proxy_dockerfile.png" alt="proxy_dockerfile" width="600"/><br>  
<img src="../misc/images/report_img/proxy_bash.png" alt="proxy_bash" width="600"/><br>  
- Nginx конфигурация для сервера-прокси  
<img src="../misc/images/report_img/proxy_nginx.png" alt="proxy_nginx" width="600"/><br>  
- Наконец, docker-compose.yaml, который будет собирать это всё вместе с сервером из прошлого задания  
<img src="../misc/images/report_img/docker_compose.png" alt="docker_compose" width="400"/><br>  

Спасибо за внимание, удачи и успехов (если ты не Dockle)