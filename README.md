# Docker Laravel

Docker image to run Laravel project.

## What is inside?

This image contains:

- PHP 7.4
- Nginx
- MySQL
- Redis
- Xdebug
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

## Configuring Xdebug

You will need to know your ip host (local machine).

Run the following command:

`hostname -I`

The first ip address is your ip host.

Access the container and run:

`vim /etc/php/7.4/mods-available/xdebug.ini`

At the line: `xdebug.remote_host=` put your ip host and save the file.

### PhpStorm

Open your project on PhpStorm.

Access the settings with **CTRL+ALT+S** and go to  **Languages & Frameworks > Servers**.

Press **Insert** or click at the `+` signal to add a new server.

Fill the **Name** with a descriptive name.

Fill the **Host**** with **localhost**

Check **Use path mappings**