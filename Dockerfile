FROM php:8.1-fpm

RUN apt-get update
RUN apt-get install -y curl ca-certificates zip unzip git libpng-dev
RUN apt-get install -y nginx default-mysql-client curl

RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN docker-php-ext-install gd

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY entrypoint.sh /entrypoint.sh

RUN echo "daemon off;" >> /etc/nginx/nginx.conf && chmod +x /entrypoint.sh

# Expose ports.
EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]