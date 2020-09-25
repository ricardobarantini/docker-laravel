FROM ubuntu:18.04

# Setting up a environment variables
ENV DEBIAN_FRONTEND noninteractive

# Updates the OS
RUN apt-get update -y

# Creates the project directory
RUN mkdir -p /var/www

# Installs Utils
RUN apt-get install build-essential unzip libaio1 curl git git-core nfs-common cifs-utils software-properties-common vim -y

# Installs Nginx
RUN apt-get install nginx -y

# RUN add-apt-repository ppa:ondrej/php -y
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php -y
RUN apt-get update -y

# Installs PHP 5.6
RUN apt-get install php5.6 php5.6-cli php5.6-fpm php5.6-mysql php5.6-xml php5.6-curl php5.6-dev php5.6-mbstring php5.6-redis php5.6-zip php5.6-gd php5.6-bcmath php5.6-pgsql php5.6-xdebug -y

# Installs PHP Magick
RUN apt-get update -y
RUN apt-get install php-imagick -y

# Installs Supervisord
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

# Sets the work directory
WORKDIR /var/www/html

# Copies the xdebug configuration file to the container
COPY xdebug.ini /etc/php/5.6/mods-available/xdebug.ini

# Exposes a few ports
EXPOSE 80 8080 443 3306

# Runs this command when the container it's initiate
ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/supervisord"]
