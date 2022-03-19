FROM docker.io/alpine:3.15.1

ENV TZ=Europe/London

RUN apk update && apk add --no-cache --upgrade lighttpd=1.4.64-r0 ffmpeg=4.4.1-r2 bash=5.1.16-r0
RUN mkdir /var/www/localhost/cgi-bin
#VOLUME /var/www/localhost/cgi-bin
#VOLUME /var/www/localhost/htdocs
#VOLUME /etc/lighttpd
COPY start.sh /
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY mod_cgi.conf /etc/lighttpd/mod_cgi.conf
COPY test.sh /var/www/localhost/cgi-bin/test.sh
COPY sampleframe /var/www/localhost/cgi-bin/sampleframe
COPY samplestream /var/www/localhost/cgi-bin/samplestream
RUN chmod -R 777 /start.sh

CMD ["./start.sh"]
#CMD ["/bin/bash"]
