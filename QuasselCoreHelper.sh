echo "QuasselCoreHelper: initializing.."
while [ -z ${POSTGRES_READY+x} ]
do 
    echo "QuasselCoreHelper: ready/waiting.."
    sleep 5s    
done 

while :
do
    echo "QuasselCoreHelper: Connecting to database.."
    db_connect=$(psql -h localhost -U $POSTGRES_USER -lqt >/dev/null 2>&1)
    exitcode=$?
    if [ $exitcode -ne 0 ]; then
        echo "QuasselCoreHelper: Database connection failed!, retrying in 10 seconds.."
        sleep 10s
    else
        db_exists=$(psql -h localhost -U $POSTGRES_USER -lqt quassel >/dev/null 2>&1)
        exitcode=$?
        if [ $exitcode -ne 0 ]; then
            echo echo "QuasselCoreHelper: Database 'quassel' does not exist!, creating.."
            psql -h localhost -U admin -c "CREATE DATABASE quassel OWNER $POSTGRES_USER" >/dev/null 2>&1
            psql -h localhost -U admin -c "GRANT ALL PRIVILEGES ON DATABASE quassel TO $POSTGRES_USER" >/dev/null 2>&1
        else
            echo "QuasselCoreHelper: Database is up!, starting QuasselCore.."
            /usr/local/bin/quasselcore --configdir=/var/lib/postgresql/.config/quassel-irc.org/
            kill -INT $(head -1 /var/lib/postgresql/data/postmaster.pid)
            break
        fi
    fi
done

