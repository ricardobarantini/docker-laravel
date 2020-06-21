# Changelog

A small changelog to keep tracking of the changes that I made over the past.

## 0.3.1 - 2020-06-20
### Added
- Changelog

## 0.3.0 - 2020-06-10
### Changed
- PHP from 7.2 to 7.4
- Exposes port 8080
- PHP version on supervisord.conf
- PHP version on default.site

## 0.2.1 - 2020-02-24
### Added
- php7.2-pgsql extension

## 0.2.0 - 2020-02-23
### Changed
- Ubuntu from 16.04 to 18.04
- PHP from 7.1 to 7.2
- Volume and the workdir from `/var/www/laravel` to `/var/www/html`
- PHP version on supervisord.conf
- PHP version on default.site
- Root path on default.site

### Removed
- php7.1-mcrypt extension

## 0.1.5 - 2019-05-22
### Changed
- Updates the client_max_body_size on nginx.conf

## 0.1.4 - 2019-05-21
### Added
- php7.1-gd extension
- Exposes the MySQL port 3306

## 0.1.3 - 2019-05-20
### Added
- Volume path for MySQL data

## 0.1.2 - 2019-05-17
### Added
- PHP Magick
- php7.1-zip extension

## 0.1.1 - 2019-05-14
### Added
- Redis
- Letś Encrypt Certbot

### Changed
- default.site file to work with https
- supervisord.conf to start the Redis server

## [0.1.0] - 2019-05-10
### Added
- Ubuntu 16.04
- PHP 7.1
- MySQL
- Composer
- Supervisor
- Nginx