FROM ubuntu:focal
MAINTAINER cos@aber.ac.uk


COPY startup.sh /
COPY start_vnc.sh /

ENV TZ=Europe/London
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y pwgen tzdata git psmisc python3 python3-numpy net-tools && \
    apt-get install -y tigervnc-standalone-server jwm xterm wget nano expect nginx unzip lxterminal && \
    apt-get install -y libxss1 libasound2 libegl1 && \
    chmod 777 /*.sh && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && useradd -m -s /bin/bash vnc && \
    cd /opt && wget https://github.com/novnc/noVNC/archive/v1.0.0.tar.gz -O webvnc-v1.0.0.tar.gz && \
    tar xvfz webvnc-v1.0.0.tar.gz && chown -R vnc:vnc /opt/* && \
    ln -s /opt/noVNC-1.0.0/vnc.html /opt/noVNC-1.0.0/index.html && \
    mkdir -p /home/vnc/.config/lxterminal && \
    mkdir -p /home/vnc/.config/spyder-py3/config && \
    cd /home/vnc && \
    wget https://scw-aberystwyth.github.io/python-novice-gapminder/files/python-novice-gapminder-data.zip && \
    unzip python-novice-gapminder-data.zip && \
    chown -R vnc:vnc /home/vnc/ && \
    update-alternatives --set x-terminal-emulator /usr/bin/lxterminal && \
    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -keyout server.key -out server.cert && \
    chown vnc:vnc server.cert && \
    cd /opt && wget https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh -O Anaconda3-installer.sh && \
    bash ./Anaconda3-installer.sh -b -p /opt/anaconda

COPY set_password.sh /opt
COPY webserver_config /etc/nginx/sites-enabled/default
COPY system.jwmrc /etc/jwm
COPY lxterminal.conf /home/vnc/.config/lxterminal
COPY spyder.ini /home/vnc/.config/spyder-py3/config

EXPOSE 80
ENTRYPOINT ["/bin/bash","/startup.sh"]
