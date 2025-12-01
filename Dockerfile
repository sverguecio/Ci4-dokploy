FROM trafex/php-nginx:latest

# Copiamos el código
COPY --chown=nginx . /var/www/html

# Copiamos la configuración de Nginx
COPY config/nginx.conf /etc/nginx/conf.d/default.conf

# Cambiamos a root para configuraciones del sistema
USER root

# 1. Instalar extensiones PHP 8.3
RUN apk add --no-cache \
    php83-intl \
    php83-mysqli \
    php83-pdo_mysql \
    php83-mbstring \
    php83-xml \
    php83-ctype \
    php83-tokenizer \
    php83-session

# 2. CONFIGURACIÓN CLAVE: Modificar PHP-FPM para usar TCP (Puerto 9000)
# Esto reemplaza la configuración de socket por la de red, arreglando el error 502
RUN sed -i 's|listen = /run/php-fpm.sock|listen = 127.0.0.1:9000|g' /etc/php83/php-fpm.d/www.conf

# Aseguramos que PHP corra como el usuario 'nginx' para evitar problemas de permisos
RUN sed -i 's|user = nobody|user = nginx|g' /etc/php83/php-fpm.d/www.conf && \
    sed -i 's|group = nobody|group = nginx|g' /etc/php83/php-fpm.d/www.conf

# Volvemos al usuario nginx
USER nginx

EXPOSE 8080