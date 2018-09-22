FROM postgres:10

RUN pg_createcluster 10 main
RUN apt update && apt install nano wget quassel-core libqt5sql5-psql -y
RUN rm /var/lib/quassel/quasselCert.pem
RUN openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout /var/lib/quassel/quasselCert.pem -out /var/lib/quassel/quasselCert.pem -subj "/C=DE/ST=X/L=X/O=X/OU=X/CN=X"
RUN echo 'false' > /var/lib/quassel/POSTGRES_READY && chmod ug+rw /var/lib/quassel/POSTGRES_READY
RUN chown quasselcore:postgres /var/lib/quassel/ -R
RUN adduser postgres quassel
RUN adduser quasselcore postgres

COPY docker-entrypoint-postgres10.sh /usr/local/bin/docker-entrypoint.sh
RUN ln -sf /usr/local/bin/docker-entrypoint.sh / # backwards compat
COPY QuasselCoreHelper.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432
EXPOSE 4242
CMD ["postgres"]