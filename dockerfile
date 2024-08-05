FROM nginx:latest
LABEL maintainer="Moucharaf AMADOU"
COPY . /usr/share/nginx/html
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl
COPY nginx.conf /etc/nginx/conf.d/default.conf
CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'
