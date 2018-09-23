#!/usr/bin/env bash
echo "[postquassel]: a.sh"
echo "[postquassel]: enable logging for postgresql-10-main.log.."
/bin/bash -c "tail -n 1 -F /var/log/postgresql/postgresql-10-main.log" &
exec /etc/init.d/postgresql start
