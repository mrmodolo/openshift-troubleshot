FROM alpine:latest

RUN apk --update add iproute2 rsync vim python3 go py3-pip bash sudo openssh bind-tools iputils git less busybox-extras

ADD ./something.sh /usr/bin/something.sh

RUN chmod +x /usr/bin/something.sh
RUN mkdir -p /opt/troubleshot/bin

RUN wget --quiet \
      -c 'https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-server-v3.11.0-0cbc58b-linux-64bit.tar.gz' \
      -O /opt/troubleshot/openshift.tgz

# O segredo para extrair o arquivo sem o aminho é --strip-components 1
RUN tar -xf openshift.tgz \
      --strip-components 1 \
      -C /opt/troubleshot/bin/ \
      openshift-origin-server-v3.11.0-0cbc58b-linux-64bit/oc 2>/dev/null

RUN tar -xf openshift.tgz \
      --strip-components 1 \
      -C /opt/troubleshot/bin/ \
      openshift-origin-server-v3.11.0-0cbc58b-linux-64bit/kubectl 2>/dev/null

RUN rm -f /opt/troubleshot/openshift.tgz

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
