# Use latest aerogear/wildfly image as the base
FROM aerogear/wildfly
MAINTAINER Bruno Oliveira <bruno@aerogear.org>

# Run everything below as aerogear user
USER aerogear

# Switch to the working dir $JBOSS_HOME/standalone/deployments
WORKDIR /opt/jboss/wildfly/standalone/deployments

# Download binary file for the UnifiedPush server
RUN curl -o ag-push.war https://repository.jboss.org/nexus/content/repositories/public-jboss/org/jboss/aerogear/unifiedpush/unifiedpush-server-wildfly/1.0.2/unifiedpush-server-wildfly-1.0.2.war

# Download binary file for the auth-server with Keycloak
RUN curl -o auth-server.war https://repository.jboss.org/nexus/content/repositories/public-jboss/org/jboss/aerogear/unifiedpush/unifiedpush-auth-server/1.0.2/unifiedpush-auth-server-1.0.2.war
