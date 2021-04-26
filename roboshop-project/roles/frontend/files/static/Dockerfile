FROM      nginx
RUN       rm -rf /usr/share/nginx/html /etc/nginx/conf.d/default.conf
ADD       static /usr/share/nginx/html
ADD       docker.conf /etc/nginx/conf.d/default.conf

