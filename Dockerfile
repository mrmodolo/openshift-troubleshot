FROM ubuntu:focal

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
      DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      apt-utils rsync vim python3 golang nmap unzip \
      python3-pip ssh bind9-utils \
      iputils-ping git wget curl \
      fortune-mod fortunes fortunes-min cowsay \
      telnet tcptraceroute traceroute netcat openjdk-8-jdk \
      dnsutils iputils-tracepath iproute2 less ldap-utils krb5-user mtr-tiny && \
      rm -rf /var/lib/apt/lists/*

# RUN groupadd -g 10000 oc-user                                  

# RUN useradd --uid 10000 -g 10000 -G root -m -s /bin/bash -p ${SHADOW} op-user

ADD ./something.sh /usr/bin/something.sh

ADD ./etc/krb5.conf /etc/krb5.conf

ADD ./uid_entrypoint /usr/bin/uid_entrypoint

RUN chmod g=u /etc/passwd && chmod 775 /usr/bin/uid_entrypoint

RUN chmod +x /usr/bin/something.sh
RUN mkdir -p /opt/troubleshot/bin
RUN mkdir -p /opt/troubleshot/.terminfo/x

ADD ./kitty/xterm-kitty  /opt/troubleshot/.terminfo/x/xterm-kitty

RUN wget --quiet \
      -c 'https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-server-v3.11.0-0cbc58b-linux-64bit.tar.gz' \
      -O /opt/troubleshot/openshift.tgz

# O segredo para extrair o arquivo sem o caminho é --strip-components 1
RUN tar -xf /opt/troubleshot/openshift.tgz \
      --strip-components 1 \
      -C /opt/troubleshot/bin/ \
      openshift-origin-server-v3.11.0-0cbc58b-linux-64bit/oc 2>/dev/null

RUN tar -xf /opt/troubleshot/openshift.tgz \
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

RUN unlink /bin/sh && ln -s /usr/bin/bash /bin/sh

ENV HOME=/opt/troubleshot

ENV HISTFILE=/opt/troubleshot/.bash_history

WORKDIR /opt/troubleshot

ENTRYPOINT ["/usr/bin/uid_entrypoint"]

CMD [ "/usr/bin/bash", "/usr/bin/something.sh" ]
