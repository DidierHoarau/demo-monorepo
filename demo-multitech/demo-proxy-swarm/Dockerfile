FROM nginx:1-alpine

RUN apk add nginx-mod-http-lua && \
    rm -fr /etc/nginx/conf.d/*
    
ADD https://github.com/knyar/nginx-lua-prometheus.git /opt/nginx-lua-prometheus/

COPY nginx.conf /etc/nginx/nginx.conf
COPY conf_vue.conf /etc/nginx/conf.d/
COPY metrics.conf /etc/nginx/conf.d/
