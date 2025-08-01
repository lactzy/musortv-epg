FROM node:22-alpine
ARG GIT_REPO=https://github.com/lactzy/iptv-epg.git
ARG GIT_BRANCH=master
ARG WORKDIR=/iptv-epg
ENV CRON_SCHEDULE="0 2 * * *"
ENV GZIP=false
ENV MAX_CONNECTIONS=1
ENV DAYS=
RUN apk update \
    && apk upgrade --available \
    && apk add curl git tzdata bash \
    && npm install -g npm@latest \
    && npm install pm2 -g \
    && mkdir $(echo "${WORKDIR}") -p \
    && cd $WORKDIR \
    && git clone --depth 1 -b $(echo "${GIT_BRANCH} ${GIT_REPO}") . \
    && npm install \
    && mkdir /public
RUN apk del git curl \
  && rm -rf /var/cache/apk/*
COPY pm2.config.js $WORKDIR
WORKDIR $WORKDIR
EXPOSE 3000
CMD [ "pm2-runtime", "pm2.config.js" ]