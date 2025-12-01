FROM trafex/php-nginx:latest

# Copiamos el código
COPY --chown=nginx . /var/www/html

# Copiamos la configuración de Nginx
COPY config/nginx.conf /etc/nginx/conf.d/default.conf

# Cambiamos a root para instalaciones y permisos
USER root

# 1. Instalamos extensiones PHP 8.3
RUN apk add --no-cache \
    php83-intl \
    php83-mysqli \
    php83-pdo_mysql \
    php83-mbstring \
    php83-xml \
    php83-ctype \
    php83-tokenizer \
    php83-session

# 2. CRÍTICO: Arreglamos los permisos para que el usuario nginx pueda escribir los PIDs y Sockets
# Esto soluciona el error "CRIT could not write pidfile" y "Permission denied"
RUN chown -R nginx:nginx /run /var/lib/nginx /var/log/nginx

# Volvemos al usuario nginx para ejecutar la app de forma segura
USER nginx

EXPOSE 8080