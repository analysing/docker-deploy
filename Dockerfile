FROM php:7.4.33-fpm

LABEL maintainer="Gill"

# gd pdo_mysql redis
# composer
# sourceguardian https://stackoverflow.com/questions/64043106/how-to-install-php-extensionson-sourceguardian-on-wordpress-docker-image
# gmp zip
# mongodb swoole
# pcntl
RUN apt-get update && apt-get install -y \
 libfreetype6-dev \
 libjpeg62-turbo-dev \
 libpng-dev \
 libgmp-dev \
 libzip-dev \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install -j$(nproc) gd \
 && docker-php-ext-install pdo_mysql \
 && docker-php-ext-install gmp \
 && docker-php-ext-install zip \
 && pecl install mongodb-1.15.2 \
 && docker-php-ext-enable mongodb \
 && pecl install swoole-4.8.13 \
 && docker-php-ext-enable swoole \
 && pecl install redis-5.3.7 \
 && docker-php-ext-enable redis \
 && curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer \
 && mkdir -p /tmp/sourceguardian \
 && cd /tmp/sourceguardian \
 && curl -Os https://www.sourceguardian.com/loaders/download/loaders.linux-aarch64.tar.gz \
 && tar -xzf loaders.linux-aarch64.tar.gz \
 && cp ixed.7.4.lin "$(php -i | grep '^extension_dir =' | cut -d' ' -f3)/sourceguardian.so" \
 && echo "extension=sourceguardian.so" > /usr/local/etc/php/conf.d/15-sourceguardian.ini \
 && rm -rf /tmp/sourceguardian \
 && docker-php-ext-configure pcntl --enable-pcntl \
 && docker-php-ext-install pcntl

# RUN apt-get update
# # gd
# RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
#  && docker-php-ext-configure gd --with-freetype --with-jpeg \
#  && docker-php-ext-install -j$(nproc) gd

# # pdo_mysql
# RUN docker-php-ext-install pdo_mysql

# # gmp
# RUN apt-get install -y libgmp-dev \
#  && docker-php-ext-install gmp

# # zip
# RUN apt-get install -y libzip-dev \
#  && docker-php-ext-install zip

# # mongodb
# RUN pecl install mongodb-1.15.2 \
#  && docker-php-ext-enable mongodb

# # swoole
# RUN pecl install swoole-4.8.13 \
#  && docker-php-ext-enable swoole

# # redis
# RUN pecl install redis-5.3.7 \
#  && docker-php-ext-enable redis

# # composer
# RUN curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# # sourceguardian ixed.7.4.lin
# RUN mkdir -p /tmp/sourceguardian \
#  && cd /tmp/sourceguardian \
#  && curl -Os https://www.sourceguardian.com/loaders/download/loaders.linux-aarch64.tar.gz \
#  && tar -xzf loaders.linux-aarch64.tar.gz \
#  && cp ixed.7.4.lin "$(php -i | grep '^extension_dir =' | cut -d' ' -f3)/sourceguardian.so" \
#  && echo "extension=sourceguardian.so" > /usr/local/etc/php/conf.d/15-sourceguardian.ini \
#  && rm -rf /tmp/sourceguardian

# # pcntl
# RUN docker-php-ext-configure pcntl --enable-pcntl \
#  && docker-php-ext-install pcntl