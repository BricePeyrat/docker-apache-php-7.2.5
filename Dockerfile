FROM php:7.2.4-apache-stretch

MAINTAINER Brice Peyrat <bricepeyrat@gmail.com>

RUN apt-get update
RUN apt-get install -y vim

RUN a2enmod rewrite

# Install php extension
RUN docker-php-ext-install pdo pdo_mysql

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/local/bin

# Set valid php.ini
COPY php.ini /usr/local/etc/php/conf.d/

# Set correct owner
COPY run.sh /usr/local/bin/run.sh

# Add www-data to root group and viceversa
RUN usermod -u 1000 www-data

# Change ownership of www-data root directory
RUN chown -R www-data:www-data /var/www

# Override the image ENTRYPOINT to add some logic
COPY run.sh /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
ENTRYPOINT ["run"]

# Directory of the application
WORKDIR /var/www/project

CMD ["apache2-foreground"]
