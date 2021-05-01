FROM      nginx
RUN       rm -rf /usr/share/nginx/html /etc/nginx/nginx.conf
COPY      static /usr/share/nginx/html
COPY      server.conf /etc/nginx/conf.d/default.conf
COPY      nginx.conf /etc/nginx/nginx.conf
