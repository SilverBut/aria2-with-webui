FROM alpine:edge

MAINTAINER SilverBut

RUN apk update && \
	apk add --no-cache --update bash && \
	mkdir -p /conf && \
	mkdir -p /conf-copy && \
	mkdir -p /data && \
	apk add --no-cache --update aria2 && \
	apk add git && \
	git clone https://github.com/ziahamza/webui-aria2 /aria2-webui && \
    rm /aria2-webui/.git* -rf && \
    apk del git && \
	apk add --update darkhttpd

ADD files/start.sh /conf-copy/start.sh
ADD files/aria2.conf /conf-copy/aria2.conf
ADD files/on-complete.sh /conf-copy/on-complete.sh

RUN chmod +x /conf-copy/start.sh && \
    groupadd -g 972 app_aria2 && \
    useradd -r -u 972 -g app_aria2 app_aria2
USER app_aria2

WORKDIR /
VOLUME ["/data"]
VOLUME ["/conf"]
EXPOSE 6800
EXPOSE 8080

CMD ["/conf-copy/start.sh"]
