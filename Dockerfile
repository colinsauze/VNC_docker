FROM ubuntu:focal
MAINTAINER cos@aber.ac.uk


COPY startup.sh /
COPY start_vnc.sh /

ENV TZ=Europe/London
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y pwgen tzdata git psmisc python3 python3-numpy net-tools && \
    apt-get install -y tigervnc-standalone-server jwm xterm wget nano expect nginx unzip lxterminal && \
    chmod 777 /*.sh && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && useradd -m -s /bin/bash vnc && \
    cd /opt && wget https://github.com/novnc/noVNC/archive/v1.0.0.tar.gz -O webvnc-v1.0.0.tar.gz && \
    tar xvfz webvnc-v1.0.0.tar.gz && chown -R vnc:vnc /opt/* && \
    ln -s /opt/noVNC-1.0.0/vnc.html /opt/noVNC-1.0.0/index.html && \
    mkdir -p /home/vnc/.config/lxterminal && \
    chown vnc:vnc /home/vnc/.config/lxterminal && \
    update-alternatives --set x-terminal-emulator /usr/bin/lxterminal && \
    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -keyout server.key -out server.cert && \
    chown vnc:vnc server.cert
    
COPY set_password.sh /opt
COPY webserver_config /etc/nginx/sites-enabled/default
COPY system.jwmrc /etc/jwm
COPY lxterminal.conf /home/vnc/.config/lxterminal

EXPOSE 80
ENTRYPOINT ["/bin/bash","/startup.sh"]
