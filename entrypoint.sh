#!/bin/bash
/usr/local/bin/supervisord
service nginx start
php-fpm