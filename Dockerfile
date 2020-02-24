FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y

RUN mkdir -p /var/www

# Installs Utils
RUN apt-get install build-essential unzip libaio1 curl git git-core nfs-common cifs-utils software-properties-common vim -y

# Installs Nginx
RUN apt-get install nginx -y

#RUN add-apt-repository ppa:ondrej/php -y
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php -y
RUN apt-get update -y

# Installs PHP 7.2
RUN apt-get install php7.2 php7.2-cli php7.2-fpm php7.2-mysql php7.2-xml php7.2-curl php7.2-dev php7.2-mbstring php7.2-redis php7.2-zip php7.2-gd php7.2-bcmath php7.2-pgsql -y

# Install PHP Magick
RUN apt-get update -y
RUN apt-get install php-imagick -y

# Install Supervisord
RUN apt-get install supervisor -y
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
VOLUME ["/var/log/supervisor"]

# Installs Composer
RUN apt-get install composer -y

# Setting up some MySQL configurations
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections

# Installs MySQL
RUN apt-get install mysql-server -y

# Set up site
COPY default.site /etc/nginx/sites-available/default

# Changing some Nginx settings
RUN sed -i '/# server_tokens*/ a client_max_body_size\ 100M\;' /etc/nginx/nginx.conf

# Forces reload
RUN echo "sudo /etc/init.d/nginx start" | tee -a /etc/rc.local

# Installs Redis
RUN apt-get install redis-server -y

# Starts Redis
RUN service redis-server start

# Setting up Redis
RUN echo "maxmemory 256mb" >> /etc/redis/redis.conf
RUN echo "maxmemory-policy allkeys-lru" >> /etc/redis/redis.conf
RUN service redis-server restart

# Installs Let's Encrypt
RUN add-apt-repository ppa:certbot/certbot -y
RUN apt-get update -y
RUN apt-get install python-certbot-nginx -y

# Sets Volumes
VOLUME ["/var/www/html"]
VOLUME ["/var/lib/mysql"]

WORKDIR /var/www/html

EXPOSE 80 443 3306

ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/supervisord"]
