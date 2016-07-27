#!/bin/bash

set -e
# run migrator

# Drop in env-vars to liquibase.properties
echo "Liquibase properties - mixing-in environment variables..."
echo "url=jdbc:mysql://$MYSQL_HOST:$MYSQL_SERVICE_PORT/$MYSQL_DATABASE" >> $UPSDIST/migrator/ups-migrator/liquibase.properties
echo "username=$MYSQL_USER" >> $UPSDIST/migrator/ups-migrator/liquibase.properties
echo "password=$MYSQL_PASSWORD" >> $UPSDIST/migrator/ups-migrator/liquibase.properties
echo "changeLogFile=liquibase/master.xml" >> $UPSDIST/migrator/ups-migrator/liquibase.properties
echo "Done."

echo "Starting Liquibase migration"
cd $UPSDIST/migrator/ups-migrator
./bin/ups-migrator update

# launch wildfly
exec /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 $@
