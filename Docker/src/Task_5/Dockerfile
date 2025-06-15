FROM ubuntu

WORKDIR /home/project

COPY proxy_launch_aux.sh .

RUN apt-get update && apt-get install -y \
    gcc \
    libfcgi-dev \
    spawn-fcgi \
    nginx \
 && rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf

CMD ["sh", "proxy_launch_aux.sh"]