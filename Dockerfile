# Use the official WildFly image
FROM quay.io/wildfly/wildfly:35.0.1.Final-jdk21

# Set environment variables if necessary (e.g., for admin user)
ENV WILDFLY_ADMIN_USER=admin
ENV WILDFLY_ADMIN_PASSWORD=admin123

# Copy the WAR file into the WildFly deployments directory
COPY ./build/libs/wildfly-k8s.war /opt/jboss/wildfly/standalone/deployments/

# Copy the run script
COPY ./docker/wildfly/start-wildfly.sh /opt/jboss/wildfly/bin/start-wildfly.sh

# Make the run script executable
USER root
RUN chmod +x /opt/jboss/wildfly/bin/start-wildfly.sh
USER jboss

# Run
ENTRYPOINT ["/opt/jboss/wildfly/bin/start-wildfly.sh"]
