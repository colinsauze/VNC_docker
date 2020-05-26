FROM ubuntu:focal
MAINTAINER cos@aber.ac.uk


COPY startup.sh /
COPY start_vnc.sh /

ENV TZ=Europe/London
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y pwgen tzdata git psmisc python3 python3-numpy net-tools && \
    apt-get install -y tightvncserver jwm xterm wget nano expect nginx && \
    chmod 777 /*.sh && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && useradd -m vnc && \
    cd /opt && wget https://github.com/novnc/noVNC/archive/v1.0.0.tar.gz -O webvnc-v1.0.0.tar.gz && \
    tar xvfz webvnc-v1.0.0.tar.gz && chown -R vnc:vnc /opt/* && \
    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -keyout server.key -out server.cert && \
    chown vnc:vnc server.cert
    
COPY set_password.sh /opt
COPY webserver_config /etc/nginx/sites-enabled/default

EXPOSE 80
ENTRYPOINT ["/bin/bash","/startup.sh"]
