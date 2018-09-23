#!/usr/bin/env bash
echo "[postquassel]: x.sh"

if [[ "$(/etc/init.d/postgresql status)" == *10*main*online* ]]; then
    echo "[postquassel]: PostgreSQL OK"
else
	echo "[postquassel]: PostreSQL Database is offline! FATAL ERROR."
	Exit -9
fi

if [[ $(pg_lsclusters) != *10*main*online* ]]; then
	echo "[postquassel]: Database is not available!"
	exit -99
fi

if [[ "$(/etc/init.d/quasselcore status)" == *is*running* ]]; then
    echo "[postquassel]: QuasselCore OK"
else
	echo "[postquassel]: QuasselCore is offline! FATAL ERROR."
	Exit -10
fi
