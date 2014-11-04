# Use latest aerogear/wildfly image as the base
FROM aerogear/wildfly
MAINTAINER Bruno Oliveira <bruno@aerogear.org>

# Set the repository name
ENV REPO_NAME aerogear-unifiedpush-server

# Set MAVEN_OPTS to increase the amount of memory available for Maven
ENV MAVEN_OPTS -Xmx768m -XX:+UseConcMarkSweepGC -XX:MaxPermSize=128m -XX:+CMSPermGenSweepingEnabled

# Node environment variable
ENV NPM_MODULES_HOME /opt/jboss/node_modules/

# Java environment variable
ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk

# Set the Maven version
ENV MAVEN_VERSION 3.1.1

# Set M2_HOME directory
ENV M2_HOME /opt/jboss/tools/maven

# General system variable setup
ENV PATH $JAVA_HOME/bin:$M2_HOME/bin:$NPM_MODULES_HOME/.bin:$NODE_HOME/bin:$PATH

# Run everything below as root user
USER root

# Allows aerogear user to run npm as sudo
RUN echo "jboss ALL=NOPASSWD:/usr/bin/npm" >> /etc/sudoers

# Install the dependencies required for Node.js
RUN sudo yum install -q -y nodejs npm gcc make libpng libpng-devel git && yum -q clean all

# Run everything below as aerogear user
USER jboss

# Clean the cache
RUN npm cache clear

# Install Node.js modules globally
RUN sudo npm install -g grunt-cli bower@1.3.8 node-gyp

# Switch to the working dir /opt/jboss
WORKDIR /opt/jboss

# Create directory tools for Maven download
RUN mkdir tools && cd tools

# Create /opt/jboss/tools/maven, download and extract Maven
RUN mkdir -p $M2_HOME && cd $M2_HOME && curl http://mirror.nbtelecom.com.br/apache/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar zx --strip 1 -C $M2_HOME

# Clone UnifiedPush server from the official repository
RUN git clone https://github.com/jboss/$REPO_NAME.git

# Switch to the cloned repository and run Maven install
RUN cd $REPO_NAME && mvn clean install -DskipTests=true

# Switch to server directory from UnifiedPush
WORKDIR /opt/jboss/jboss-unifiedpush-server/servers

# Copy binary file for the auth-server with Keycloak to deployments folder
RUN cp auth-server/target/*.war $JBOSS_HOME/standalone/deployments

# Copy binary file for the UnifiedPush server to deployments folder
RUN cp ups-wildfly/target/*.war $JBOSS_HOME/standalone/deployments
