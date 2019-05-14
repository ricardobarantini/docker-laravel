# Docker Laravel

Docker image to run Laravel project.

## What is inside?

This image contains:

- PHP 7.1
- Nginx
- MySQL
- Redis
- Certbot

## Downloading image

`docker pull ricardobarantini/laravel`

## Starting container

`docker run -d -v /path/to/passport/laravel:/var/www/laravel -p 80:80 --name containerName ricardobarantini/laravel`

## Accessing the container

`docker exec -it containerName bash`