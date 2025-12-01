# Usamos la versión 'latest' que actualmente corre PHP 8.3 en Alpine
FROM trafex/php-nginx:latest

# Copiamos el código de CodeIgniter al contenedor
COPY --chown=nginx . /var/www/html

# Copiamos la configuración de Nginx
COPY config/nginx.conf /etc/nginx/conf.d/default.conf

# Cambiamos a root para instalar extensiones
USER root

# Instalamos las librerías necesarias para CodeIgniter 4 usando los paquetes de PHP 8.3
# Añadí mbstring, xml y ctype que también son requeridos o recomendados por CI4
RUN apk add --no-cache \
    php83-intl \
    php83-mysqli \
    php83-pdo_mysql \
    php83-mbstring \
    php83-xml \
    php83-ctype \
    php83-tokenizer \
    php83-session

# Volvemos al usuario nginx por seguridad
USER nginx

# Exponer el puerto 8080
EXPOSE 8080