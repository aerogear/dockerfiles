# Use latest jboss/wildfly image as the base
FROM jboss/wildfly:10.0.0.Final
MAINTAINER Bruno Oliveira <bruno@abstractj.org>

# Run everything below as root user
USER root

# Clean the metadata
RUN yum install -y unzip wget && yum -q clean all

## MYSQL
ENV mysql_module_dir=$JBOSS_HOME/modules/com/mysql/jdbc/main/
RUN mkdir -p ${mysql_module_dir}
RUN wget -O mysql-connector-java-5.1.18.jar http://search.maven.org/remotecontent\?filepath\=mysql/mysql-connector-java/5.1.18/mysql-connector-java-5.1.18.jar
RUN mv mysql-connector-java-5.1.18.jar ${mysql_module_dir}
COPY configuration/xml/mysql-module.xml ${mysql_module_dir}/module.xml

# Rename the original configuration file
RUN mv $JBOSS_HOME/standalone/configuration/standalone.xml $JBOSS_HOME/standalone/configuration/standalone.xml.orig

# WildFly configuration file ready for HTTPS
ADD configuration/xml/standalone-full-sample.xml $JBOSS_HOME/standalone/configuration/standalone.xml

# Add the certificate.sh script into $JBOSS_HOME/standalone/configuration/certs
ADD configuration/certs/ $JBOSS_HOME/standalone/configuration/certs

# Switch to $JBOSS_HOME/configuration/certs
WORKDIR /opt/jboss/wildfly/standalone/configuration/certs

# Execute the script to generate self signed certificates
RUN ./certificate.sh

# Switch to the working dir /opt/jboss/wildfly
WORKDIR /opt/jboss/wildfly

# Expose SSL default port
EXPOSE 8443
