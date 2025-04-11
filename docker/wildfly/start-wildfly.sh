#!/bin/bash
exec /opt/jboss/wildfly/bin/standalone.sh -b=0.0.0.0 -bmanagement=0.0.0.0 -Djboss.server.default.config=standalone-full-ha.xml \
-Djboss.node.name=${WILDFLY_NODE} -Djboss.socket.binding.port-offset=${WILDFLY_PORT_BINDING} \
-Djava.net.preferIPv4Stack=true -Djgroups.bind_addr=$(cat /etc/hostname) \
-Djboss.messaging.cluster.password=${WILDFLY_CLUSTER_PW}
