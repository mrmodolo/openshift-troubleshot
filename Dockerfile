FROM alpine:latest

RUN apk --update add iproute2 rsync vim python3 go py3-pip bash sudo openssh bind-tools iputils git less busybox-extras

ADD ./something.sh /usr/bin/something.sh

RUN chmod +x /usr/bin/something.sh
RUN mkdir -p /opt/troubleshot/bin

COPY ./bin/* /opt/troubleshot/bin/ 
COPY ./skel/* /opt/troubleshot/ 

RUN touch /opt/troubleshot/.bash_history

RUN chgrp -R 0 /opt/troubleshot && \
    chmod -R g+rwX /opt/troubleshot

RUN  chmod +x /opt/troubleshot/bin/*

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/troubleshot/bin

ENV HOME=/opt/troubleshot

ENV HISTFILE=/opt/troubleshot/.bash_history

WORKDIR /opt/troubleshot

CMD [ "/bin/bash", "/usr/bin/something.sh" ]
