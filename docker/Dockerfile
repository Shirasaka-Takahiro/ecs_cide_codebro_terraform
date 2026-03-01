FROM nginx:alpine
 
COPY ./nginx/quick-infra.net /etc/nginx/conf.d/
ADD ./nginx/nginx.conf /etc/nginx/
COPY ./nginx/index.html /var/www/html/
COPY ./nginx/healthchek.html /var/www/html/ 

EXPOSE 80