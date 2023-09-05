FROM node:14 as node-build
COPY ./src /application
WORKDIR /application
RUN apt-get update
RUN npm install \
    && npm run prod


FROM nginx:alpine

WORKDIR /application

COPY ./docker/nginx/prod/conf.d/default.conf /etc/nginx/conf.d/
ADD ./docker/nginx/prod/conf.d/nginx.conf /etc/nginx/

COPY ./src /application
COPY --from=node-build /application/public /application/public/

ENV TZ=Asia/Tokyo

EXPOSE 80
