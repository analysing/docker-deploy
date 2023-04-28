FROM php:7.4.33-fpm

LABEL maintainer="Gill"

# gd pdo_mysql redis
# composer
# sourceguardian https://stackoverflow.com/questions/64043106/how-to-install-php-extensionson-sourceguardian-on-wordpress-docker-image
RUN apt-get update && apt-get install -y \
 libfreetype6-dev \
 libjpeg62-turbo-dev \
 libpng-dev \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install -j$(nproc) gd \
 && docker-php-ext-install pdo_mysql \
 && pecl install redis-5.3.7 \
 && docker-php-ext-enable redis \
 && curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer \
 && mkdir -p /tmp/sourceguardian \
 && cd /tmp/sourceguardian \
 && curl -Os https://www.sourceguardian.com/loaders/download/loaders.linux-aarch64.tar.gz \
 && tar -xzf loaders.linux-aarch64.tar.gz \
 && cp ixed.7.4.lin "$(php -i | grep '^extension_dir =' | cut -d' ' -f3)/sourceguardian.so" \
 && echo "extension=sourceguardian.so" > /usr/local/etc/php/conf.d/15-sourceguardian.ini \
 && rm -rf /tmp/sourceguardian