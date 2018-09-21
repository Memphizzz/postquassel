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
RUN apt remove --purge gcc g++ cmake ccache zlib1g-dev qtdeclarative5-dev qtscript5-dev -y
RUN apt autoremove -y
RUN apt clean

COPY docker-entrypoint.sh /usr/local/bin/
EXPOSE 5432
EXPOSE 4242
CMD ['postgres']
