#!/usr/bin/env bash

if [[ $(pg_lsclusters) != *"online"* ]]; then
	echo "[postquassel]: Database is not available!"
	exit -1
fi

if
	db_exists=$(PGPASSWORD=quassel psql -h localhost -U quassel -lqt quassel)
	exitcode=$?
	if [ $exitcode -ne 0 ]; then
		echo echo "[postquassel]: Database 'quassel' does not exist!"
		exit 404
	else
		echo "[postquassel]: Database is up, starting QuasselCore.."
		exec /etc/init.d/quasselcore start
	fi
	break
fi
