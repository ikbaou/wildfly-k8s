#!/bin/bash

set -e

# Create the target directory
mkdir -p ${TARGET_DIR}

# Fetch JARs using Maven dependency plugin
for artifact in "${ARTIFACTS[@]}"; do
  # Split the artifact into parts
  IFS=':' read -r groupId artifactId version extension <<< "${artifact}"

  # Replace '.' with '/' for the groupId to form the correct directory structure
  groupDir=$(echo ${groupId} | sed 's/\./\//g')

  # Define the full path to the artifact
  artifactPath="${HOME}/.m2/repository/${groupDir}/${artifactId}/${version}/${artifactId}-${version}.${extension}"

  # Run Maven dependency get
  mvn dependency:get \
    -Dartifact=${artifact} \
    -DremoteRepositories=${REPO_URL} \
    -Dusername=${NEXUS_USERNAME} \
    -Dpassword=${NEXUS_PASSWORD} \
    -Dmaven.resolver.transport=wagon \
    -Dmaven.wagon.http.ssl.insecure=true \
    -Dmaven.wagon.http.ssl.allowall=true

  # Copy the artifact to the target directory
  echo "Copying ${artifactPath} to ${TARGET_DIR}"
  cp "${artifactPath}" ${TARGET_DIR}
  addgroup --system jboss
  adduser --system --ingroup jboss jboss
  echo "changing ownership to jboss:jboss (1000:1000) for: ${TARGET_DIR}"
  chown -R 1000:1000 ${TARGET_DIR}
  echo "listing contents of: ${TARGET_DIR}"
  ls -la ${TARGET_DIR}
done
