FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y

RUN mkdir -p /var/www

# Installs Utils
RUN apt-get install build-essential unzip libaio1 curl git git-core nfs-common cifs-utils software-properties-common vim -y

# Installs Nginx
RUN apt-get install nginx -y

# RUN add-apt-repository ppa:ondrej/php -y
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php -y
RUN apt-get update -y

# Installs PHP 7.4
RUN apt-get install php7.4 php7.4-cli php7.4-fpm php7.4-mysql php7.4-xml php7.4-curl php7.4-dev php7.4-mbstring php7.4-redis php7.4-zip php7.4-gd php7.4-bcmath php7.4-pgsql php7.4-sqlite3 -y

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

# Install SQLite3
RUN apt-get install sqlite3 -y

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

# Installs Oracle drivers
COPY drivers/instantclient-basic-linux.x64-12.1.0.2.0.zip /root/instantclient-basic-linux.x64-12.1.0.2.0.zip 
COPY drivers/instantclient-sdk-linux.x64-12.1.0.2.0.zip /root/instantclient-sdk-linux.x64-12.1.0.2.0.zip 
RUN mkdir -p /opt/oracle/
RUN unzip /root/instantclient-basic-linux.x64-12.1.0.2.0.zip -d /opt/oracle
RUN unzip /root/instantclient-sdk-linux.x64-12.1.0.2.0.zip -d /opt/oracle
RUN mv /opt/oracle/instantclient_12_1 /opt/oracle/instantclient
RUN chown -R root:www-data /opt/oracle
RUN ln -s /opt/oracle/instantclient/libclntsh.so.12.1 /opt/oracle/instantclient/libclntsh.so
RUN ln -s /opt/oracle/instantclient/libocci.so.12.1 /opt/oracle/instantclient/libocci.so
RUN echo /opt/oracle/instantclient > /etc/ld.so.conf.d/oracle-instantclient.conf
RUN ldconfig
RUN echo 'instantclient,/opt/oracle/instantclient' | pecl install oci8
RUN echo "extension = oci8.so" >> /etc/php/7.4/fpm/php.ini
RUN echo "extension = oci8.so" >> /etc/php/7.4/cli/php.ini
RUN echo "LD_LIBRARY_PATH=\"/opt/oracle/instantclient\"" >> /etc/environment
RUN echo "ORACLE_HOME=\"/opt/oracle/instantclient\"" >> /etc/environment
RUN service php7.4-fpm restart

# Installs Let's Encrypt
RUN add-apt-repository ppa:certbot/certbot -y
RUN apt-get update -y
RUN apt-get install python-certbot-nginx -y

# Sets Volumes
VOLUME ["/var/www/html"]
VOLUME ["/var/lib/mysql"]

WORKDIR /var/www/html

EXPOSE 80 8080 443 3306

ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/supervisord"]
