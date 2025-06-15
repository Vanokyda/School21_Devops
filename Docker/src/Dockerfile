FROM ubuntu

WORKDIR /home/project

COPY ./server/fcgi_server.c .
COPY server_launch_aux.sh .

# EXPOSE 8080

RUN apt-get update && apt-get install -y \
    gcc \
    libfcgi-dev \
    spawn-fcgi \
    nginx \
 && rm -rf /var/lib/apt/lists/*

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

CMD ["sh", "server_launch_aux.sh"]