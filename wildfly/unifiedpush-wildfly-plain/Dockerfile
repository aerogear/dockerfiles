# Use latest aerogear/wildfly image as the base
FROM aerogear/wildfly:2.0.0
MAINTAINER Matthias Wessendorf <matzew@apache.org>


# Download Aerogear distribution
ENV UPSVER=2.0.1.Final
ENV UPSDIST=/opt/aerogear-unifiedpush-server-$UPSVER

RUN curl -L -o /opt/aerogear-unifiedpush-server-$UPSVER-dist.tar.gz https://github.com/aerogear/aerogear-unifiedpush-server/releases/download/$UPSVER/aerogear-unifiedpush-server-$UPSVER-dist.tar.gz
WORKDIR /opt
RUN tar zxf aerogear-unifiedpush-server-$UPSVER-dist.tar.gz

# install openssl needed for certificate
RUN yum install -y openssl && yum -q clean all

# Run everything below as aerogear user
USER jboss

# Switch to the working dir $JBOSS_HOME/standalone/deployments
WORKDIR /opt/jboss/wildfly/standalone/deployments

# copy war files
RUN cp $UPSDIST/servers/unifiedpush-server-wildfly.war $JBOSS_HOME/standalone/deployments


# copy and run startup script
# migration is done inside the startup script before launching the server
COPY entrypoint.sh /opt/
ENTRYPOINT ["/opt/entrypoint.sh"]
