FROM php:8.1-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    nginx \
    default-mysql-client

# Install php extensions
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
# ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync
RUN install-php-extensions mbstring pdo_mysql zip exif pcntl gd curl xml zip \
    bcmath soap readline ldap msgpack igbinary redis memcached pcov xdebug imagick

RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy config files
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY entrypoint.sh /entrypoint.sh

RUN echo "daemon off;" >> /etc/nginx/nginx.conf && chmod +x /entrypoint.sh

# Expose ports.
EXPOSE 80
EXPOSE 443

# Run
ENTRYPOINT ["/entrypoint.sh"]