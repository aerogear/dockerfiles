# Use latest aerogear/wildfly image as the base
FROM aerogear/wildfly
MAINTAINER Bruno Oliveira <bruno@aerogear.org>

# Set the repository name
ENV REPO_NAME aerogear-unifiedpush-server

# Set MAVEN_OPTS to increase the amount of memory available for Maven
ENV MAVEN_OPTS -Xmx768m -XX:+UseConcMarkSweepGC -XX:MaxPermSize=128m -XX:+CMSClassUnloadingEnabled

# Node environment variable
ENV NPM_MODULES_HOME /opt/jboss/node_modules/

# Set the Maven version
ENV MAVEN_VERSION 3.3.9

# Set M2_HOME directory
ENV M2_HOME /opt/jboss/tools/maven

# General system variable setup
ENV PATH $JAVA_HOME/bin:$M2_HOME/bin:$NPM_MODULES_HOME/.bin:$NODE_HOME/bin:$PATH

# Run everything below as root user
USER root

# Allows aerogear user to run npm as sudo
RUN echo "jboss ALL=NOPASSWD:/usr/bin/npm" >> /etc/sudoers

# Install Node.js and git for CentOS7
RUN yum install -y git && \
    yum install -y \
    https://rpm.nodesource.com/pub_0.12/el/7/x86_64/nodejs-0.12.9-1nodesource.el7.centos.x86_64.rpm && \
    yum clean all -y

# Clean the cache
RUN npm cache clear

# Install Node.js modules globally
RUN npm install -g grunt-cli bower@1.3.8 node-gyp

# Run everything below as aerogear user
USER jboss

# Switch to the working dir /opt/jboss
WORKDIR /opt/jboss

# Create directory tools for Maven download
RUN mkdir tools && cd tools

# Create /opt/jboss/tools/maven, download and extract Maven
RUN mkdir -p $M2_HOME && cd $M2_HOME && curl http://mirror.nbtelecom.com.br/apache/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar zx --strip 1 -C $M2_HOME

# Clone UnifiedPush server from the official repository
RUN git clone https://github.com/aerogear/$REPO_NAME.git

# Switch to the cloned repository and run Maven install
RUN cd $REPO_NAME && mvn clean install -DskipTests=true

# Switch to server directory from UnifiedPush
WORKDIR /opt/jboss/aerogear-unifiedpush-server/servers

# Copy binary file for the auth-server with Keycloak to deployments folder
RUN cp auth-server/target/*.war $JBOSS_HOME/standalone/deployments

# Copy binary file for the UnifiedPush server to deployments folder
RUN cp ups-wildfly/target/*.war $JBOSS_HOME/standalone/deployments
