# Docker Laravel

Docker image to run Laravel project.

## What is inside?

This image contains:

- PHP 7.4
- Nginx
- MySQL
- Redis
- Certbot

## Downloading image

`docker pull ricardobarantini/laravel`

## Creates MySQL Volume

`docker volume create --name mysql_volume`

## Starting container

`docker run -d -v /path/to/project/laravel:/var/www/html -v mysql_volume:/var/lib/mysql -P --name container_name ricardobarantini/laravel`

## Accessing the container

`docker exec -it container_name bash`

## Generating the ssl certificate

Inside the container, run the command:

`certbot --nginx -d app.tld`

At the `-d app.tld` just change for the site domain name.

## Updating the Nginx

Inside the container, run:

`vim /etc/nginx/sites-enabled/default`

At the line 5, changes the `localhost` to the site domain name.

At the line 6, changes `root`  path if is necessary.

## Creating the database

`mysql -u root -p -e "create database name;"`

Credentials:

**Username0**: root

**Password:** root

## Updating the Docker image

`docker stop container_name`

`docker rm container_name`

`docker run -d -v /path/to/project/laravel:/var/www/html -v mysql_volume:/var/lib/mysql -P --name container_name ricardobarantini/laravel`
