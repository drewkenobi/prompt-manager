# Dockerfile para Prompts & Snippets Manager
# Imagen base: PHP 8.2 FPM con Alpine Linux

FROM php:8.2-fpm-alpine

# Información del mantenedor
LABEL maintainer="drewkenobi"

# Instalar dependencias del sistema
RUN apk add --no-cache \
    git \
    curl \
    libpng-dev \
    oniguruma-dev \
    libxml2-dev \
    zip \
    unzip \
    mysql-client \
    nodejs \
    npm

# Instalar extensiones de PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Instalar Redis extension
RUN apk add --no-cache pcre-dev $PHPIZE_DEPS \
    && pecl install redis \
    && docker-php-ext-enable redis

# Limpiar caché de apk
RUN rm -rf /var/cache/apk/*

# Obtener Composer desde imagen oficial
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crear usuario para Laravel
RUN addgroup -g 1000 www && \
    adduser -D -u 1000 -G www www

# Establecer directorio de trabajo
WORKDIR /var/www

# Copiar archivos existentes de la aplicación
COPY . /var/www

# Copiar permisos al usuario www
RUN chown -R www:www /var/www

# Cambiar al usuario www
USER www

# Exponer puerto 9000 para PHP-FPM
EXPOSE 9000

# Comando por defecto
CMD ["php-fpm"]
