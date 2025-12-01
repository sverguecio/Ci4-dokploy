# Usamos una imagen ligera que ya trae Nginx y PHP configurados
FROM trafex/php-nginx:3.0.0

# Copiamos el código de CodeIgniter al contenedor
COPY --chown=nginx . /var/www/html

# CodeIgniter 4 sirve desde la carpeta /public, así que ajustamos la raíz del documento
# Nota: La imagen base usa /var/www/html por defecto, modificaremos la config de nginx más abajo o en el archivo conf.
# Para esta imagen específica, es mejor sobrescribir la configuración de nginx.

COPY config/nginx.conf /etc/nginx/conf.d/default.conf

# Instalar extensiones de PHP necesarias para CI4 (intl es crítica)
USER root
RUN apk add --no-cache php82-intl php82-mysqli php82-pdo_mysql
USER nginx

# Exponer el puerto 8080 (el defecto de esta imagen base)
EXPOSE 8080