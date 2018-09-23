#!/usr/bin/env bash
echo "[postquassel]: .sh"

if [[ $(pg_lsclusters) != *10*main* ]]; then
	echo "[postquassel]: Main cluster is not available, initializing cluster and database.."
	pg_createcluster 10 main
	/etc/init.d/postgresql restart
	pg_lsclusters
	echo "CREATE USER quassel WITH PASSWORD 'quassel'; CREATE DATABASE quassel OWNER quassel; GRANT ALL PRIVILEGES ON DATABASE quassel TO quassel;" > /tmp/postquassel.sql
	su -s /bin/bash -c "psql -f /tmp/postquassel.sql" postgres
fi

db_exists=$(PGPASSWORD=quassel psql -h localhost -U quassel -lqt quassel)
exitcode=$?
if [ $exitcode -ne 0 ]; then
	echo "[postquassel]: ERROR"
	exit 100
else
	echo "[postquassel]: enable logging for quassel/core.log.."
	/bin/bash -c "tail -n 1 -F /var/log/quassel/core.log" &

	echo "[postquassel]: Database is ready, starting QuasselCore.."
	exec /etc/init.d/quasselcore start
fi
