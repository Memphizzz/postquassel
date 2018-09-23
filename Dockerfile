FROM phusion/baseimage:0.11
#RUN echo VAR-VALUE > /etc/container_environment/VAR_NAME # HowTo pass env-var to my_init
#RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold" # HowTo dist-upgrade
#docker run phusion/baseimage:<VERSION> /sbin/my_init -- ls #TESTCOMMAND
#docker run YOUR_IMAGE /sbin/my_init --help # HELP

### DEV
RUN apt update && apt install -y wget nano curl htop postgresql-10 quassel-core libqt5sql5-psql
RUN apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN rm /var/lib/quassel/quasselCert.pem
RUN openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout /var/lib/quassel/quasselCert.pem -out /var/lib/quassel/quasselCert.pem -subj "/C=DE/ST=X/L=X/O=X/OU=X/CN=X"
RUN chown quasselcore:quassel /var/lib/quassel/ -R
RUN su -s /bin/bash -c "/etc/init.d/postgresql start && \
echo \"CREATE USER quassel WITH PASSWORD 'quassel'; CREATE DATABASE quassel OWNER quassel; GRANT ALL PRIVILEGES ON DATABASE quassel TO quassel;\" > /tmp/postquassel.sql && \
psql -f /tmp/postquassel.sql && /etc/init.d/postgresql stop" postgres


COPY postquassel.sh /etc/my_init.d/
COPY apostquassel.sh /etc/my_init.d/

EXPOSE 4242
CMD ["/sbin/my_init"]
