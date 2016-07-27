# Use latest rhmap/wildfly image as the base
FROM rhmap/wildfly
MAINTAINER Bruno Oliveira <bruno@aerogear.org>

RUN mkdir -p /opt/jboss/wildfly/standalone/data && \
    mkdir -p /opt/jboss/wildfly/standalone/tmp/vfs/temp && \
    mkdir -p /opt/jboss/wildfly/standalone/log && \
    chmod -R 777 /opt/jboss/wildfly/standalone

# Download Aerogear distribution
ENV UPSVER=1.1.4-SNAPSHOT
ENV UPSDIST=/opt/aerogear-unifiedpush-server-$UPSVER
ENV BUILD=37

### there is a bug, in the versioning. The TAG is correctly .Final, but the artifacts aren't...
RUN curl -L -o /opt/aerogear-unifiedpush-server-$UPSVER-dist.tar.gz https://s3-eu-west-1.amazonaws.com/fh-builds/aerogear-unifiedpush-server/$BUILD/aerogear-unifiedpush-server-$UPSVER-dist.tar.gz
WORKDIR /opt
RUN tar zxf aerogear-unifiedpush-server-$UPSVER-dist.tar.gz

# unzip migrator and copy liquibase.properties
WORKDIR $UPSDIST/migrator
RUN unzip ups-migrator-dist.zip

# Drop-in empty liquibase.properties, mixin env vars added at runtime (see entrypoint.sh)
RUN touch $UPSDIST/migrator/ups-migrator/liquibase.properties && \
    chmod -R 777 $UPSDIST/migrator/ups-migrator/liquibase.properties

# Run everything below as aerogear user
USER jboss

# Switch to the working dir $JBOSS_HOME/standalone/deployments
WORKDIR /opt/jboss/wildfly/standalone/deployments

# copy war files
RUN cp $UPSDIST/servers/unifiedpush-auth-server.war $JBOSS_HOME/standalone/deployments \
    && cp $UPSDIST/servers/unifiedpush-server-wildfly.war $JBOSS_HOME/standalone/deployments


# copy and run startup script
# migration is done inside the startup script before launching the server
COPY entrypoint.sh /opt/
ENTRYPOINT ["/opt/entrypoint.sh"]
