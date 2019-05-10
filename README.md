# Docker Passport

Docker image to run the EBT Passport

## Downloading image

`docker pull ebt/passport:1.0`

## Starting container

`docker run -d -v /path/to/passport/laravel:/var/www/laravel -p 80:80 --name passport ricardobarantini/passport:0.1`

## Accessing the container

`docker exec -it passport bash`