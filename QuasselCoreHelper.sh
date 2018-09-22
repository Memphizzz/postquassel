echo "QuasselCoreHelper: ready/waiting.."
sleep 10s
while :
do
    echo "QuasselCoreHelper: Connecting to database.."
    db_connect=$(psql -U admin -lqt >/dev/null 2>&1)    
    exitcode=$?
    if [ $exitcode -ne 0 ]; then
        echo "QuasselCoreHelper: Database connection failed!, retrying in 10 seconds.."
        sleep 10s
    else
        db_exists=$(psql -U admin -lqt quassel >/dev/null 2>&1)
        exitcode=$?
        if [ $exitcode -ne 0 ]; then
            echo echo "QuasselCoreHelper: Database 'quassel' does not exist!, creating.."
            psql -U admin -c "CREATE DATABASE quassel OWNER admin" >/dev/null 2>&1
            psql -U admin -c "GRANT ALL PRIVILEGES ON DATABASE quassel TO admin" >/dev/null 2>&1
        else
            echo "QuasselCoreHelper: Database is up!, starting QuasselCore.."
            /usr/local/bin/quasselcore --configdir=/var/lib/postgresql/.config/quassel-irc.org/
            kill -INT $(head -1 /var/lib/postgresql/data/postmaster.pid)
            break
        fi
    fi
done

