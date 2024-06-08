ARG IMAGE_NAME_WITH_TAG=nginx:1.26.1-alpine

FROM ${IMAGE_NAME_WITH_TAG}

COPY ./index.html /usr/share/nginx/html/index.html

# Start nginx
CMD [ "nginx", "-g", "daemon off;" ]