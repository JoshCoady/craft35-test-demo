########################################################################################################################
# BASE
# Includes the Craft server requirements: https://docs.craftcms.com/v3/requirements.html
########################################################################################################################
FROM php:fpm-alpine

# Image Magick
RUN set -ex; \
    apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS imagemagick-dev libtool; \
    export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS"; \
    pecl install imagick; \
    docker-php-ext-enable imagick; \
    apk add --no-cache --virtual .imagick-runtime-deps imagemagick; \
    apk del .phpize-deps

# Compression
RUN set -ex; \
    apk add --no-cache libzip; \
    apk add --no-cache --virtual .zip-deps libzip-dev; \
    docker-php-ext-install zip; \
    apk del .zip-deps

# Internationalization
RUN set -ex; \
    apk add --no-cache icu-dev; \
    docker-php-ext-configure intl; \
    docker-php-ext-install intl

# Database client
RUN docker-php-ext-install pdo pdo_mysql

# Install composer
RUN set -o pipefail; curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_MEMORY_LIMIT=-1

WORKDIR /var/app

# Install app dependencies with composer
COPY composer.* ./
RUN set -ex; \
    composer self-update; \
    composer install --no-interaction --prefer-dist --no-suggest

# Install app
COPY . .
RUN set -ex; \
# put PHP config in the proper dirs so it will be used
    mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini; \
    ln -s `pwd`/config/php.ini /usr/local/etc/php/conf.d/craft.ini
