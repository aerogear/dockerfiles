#!/bin/bash

set -e
# run migrator
echo "Starting Liquibase migration"
cd $UPSDIST/migrator/ups-migrator
./bin/ups-migrator update

# replace eventual private certificate
if [ -d /keys ];then
    export DOMAIN="aerogear.dev"
    export SERVER_PASSWORD=$(head -c 2000 /dev/urandom | tr -dc a-z0-9A-Z | head -c 256)
    echo "custom certificates directory found - replacing default self signed generated certificate"
    mv $JBOSS_HOME/standalone/configuration/certs/server.$DOMAIN.keystore $JBOSS_HOME/standalone/configuration/certs/selfsigned.keystore
    
    openssl pkcs12 -export -name server.$DOMAIN -in /keys/certificate.crt -inkey /keys/privatekey.key -out $JBOSS_HOME/standalone/configuration/certs/server.$DOMAIN.keystore -passout env:SERVER_PASSWORD
    sed -i "s/keystore-password=\".*\" a/keystore-password=\"$SERVER_PASSWORD\" a/g" $JBOSS_HOME/standalone/configuration/standalone.xml
else
    echo "no /keys directory found, will used default selfsigned certificate"
fi

# launch wildfly
exec /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 $@

