FROM nimmis/alpine-glibc

MAINTAINER Andrea Rigoni <>

RUN apk update && apk upgrade && \
    apk add bash curl && \
    cd /root && \
    curl  https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz | tar xfz - && \
    mv rslsync /usr/local/bin/btsync && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /btsync/.sync /var/run/btsync /data

EXPOSE 8888
EXPOSE 55555
ADD start-btsync /usr/bin/start-btsync
RUN chmod +x /usr/bin/start-btsync
VOLUME ["/data"]
ENTRYPOINT ["start-btsync"]

