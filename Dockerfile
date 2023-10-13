FROM nginx
COPY ./default.conf.template /etc/nginx/templates/
COPY ./index.html /usr/share/nginx/html