FROM ubuntu:16.04

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

# Installs PHP 7.1
RUN apt-get install php7.1 php7.1-cli php7.1-fpm php7.1-mysql php7.1-xml php7.1-mcrypt php7.1-curl php7.1-dev php7.1-mbstring php7.1-redis php7.1-zip -y

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

# Setting up some mysql configurations
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections

# Installs MySQL
RUN apt-get install mysql-server -y

# Set up site
COPY default.site /etc/nginx/sites-available/default

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

VOLUME ["/var/www/laravel"]

WORKDIR /var/www/laravel

EXPOSE 80 443

ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/supervisord"]
