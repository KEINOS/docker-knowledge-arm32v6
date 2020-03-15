# Dockerfile for Knowledge

FROM keinos/alpine

ENV \
  TOMCAT_MAJOR=8 \
  TOMCAT_VERSION=8.5.9 \
  TOMCAT_HOME=/opt/tomcat \
  CATALINA_HOME=/opt/tomcat \
  CATALINA_OUT=/dev/null

# ==== JDK8/Tomcat8 ====
RUN \
  mkdir -p /opt && \
  apk add --no-cache \
    dumb-init \
    openjdk8-jre \
    curl  && \
  curl -jksSL -o /tmp/apache-tomcat.tar.gz http://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
  tar -C /opt -xvzf /tmp/apache-tomcat.tar.gz && \
  ln -s /opt/apache-tomcat-${TOMCAT_VERSION} ${TOMCAT_HOME} && \
  rm -rf ${TOMCAT_HOME}/webapps/* && \
  rm -rf /tmp/* /var/cache/apk/* && \
  ${TOMCAT_HOME}/bin/catalina.sh version

# ==== add Knowledge ====
ADD https://github.com/support-project/knowledge/releases/download/v1.13.1/knowledge.war \
      ${TOMCAT_HOME}/webapps/ROOT.war

VOLUME [ "/root/.knowledge" ]
EXPOSE 8080

CMD [ "dumb-init", "/opt/tomcat/bin/catalina.sh", "run" ]
