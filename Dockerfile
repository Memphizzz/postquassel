FROM postgres:latest

RUN pg_createcluster 10 main
RUN apt update && \
apt install gcc g++ wget cmake ccache zlib1g-dev qtdeclarative5-dev qtscript5-dev libqt5sql5-psql -y
RUN cd /root/ && \
wget https://quassel-irc.org/pub/quassel-0.13-rc1.tar.bz2 && \
tar -xvf quassel*tar.bz2 && \
rm quassel-*.tar.bz2 && \
cd quassel-* && \
mkdir build && \
cd build && \
cmake .. -DWANT_QTCLIENT=OFF -DWANT_MONO=OFF && \
make -j$(nproc) && \
make install && \
rm /root/quassel-* -R
RUN mkdir -p /var/lib/postgresql/.config/quassel-irc.org/
RUN openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout /var/lib/postgresql/.config/quassel-irc.org/quasselCert.pem -out /var/lib/postgresql/.config/quassel-irc.org/quasselCert.pem -subj "/C=DE/ST=X/L=X/O=X/OU=X/CN=X"
RUN chown postgres:postgres /var/lib/postgresql/.config/quassel-irc.org/ -R
RUN apt remove --purge gcc g++ cmake ccache zlib1g-dev qtdeclarative5-dev qtscript5-dev -y
RUN apt install libqt5script5 libqt5network5 -y
RUN apt autoremove -y
RUN apt clean

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -sf /usr/local/bin/docker-entrypoint.sh / # backwards compat
COPY QuasselCoreHelper.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432
EXPOSE 4242
CMD ["postgres"]
