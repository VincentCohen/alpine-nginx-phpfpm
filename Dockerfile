FROM alpine:latest

RUN apk update \
    && apk add --no-cache curl ca-certificates zip unzip git libpng-dev \
    && apk add --no-cache nginx php81-fpm php81-cli php81-dev \
    && RUN docker-php-ext-install mysql-client \
    && RUN docker-php-ext-install php8.1-gd \
       php8.1-curl \
       php8.1-mysql php8.1-mbstring \
       php8.1-xml php8.1-zip php8.1-bcmath php8.1-soap \
       php8.1-intl php8.1-readline \
       php8.1-ldap \
       php8.1-msgpack php8.1-igbinary php8.1-redis \
       php8.1-memcached php8.1-pcov php8.1-xdebug \
       php8.1-imagick \
    && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \

COPY ./nginx.conf /etc/nginx/conf.d

ENTRYPOINT ["./entrypoint.sh"]