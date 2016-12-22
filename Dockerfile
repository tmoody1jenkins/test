FROM centos:latest
MAINTAINER tom
EXPOSE 8080
RUN yum install -y epel-release && \
    yum upgrade -y

## install java
RUN yum install -y java-1.8.0-openjdk.x86_64

## create tom cat group

RUN groupadd tomcat && \
    mkdir /opt/tomcat && \
    useradd -s /bin/bash -d /opt/tomcat -g tomcat -u 1000 tomcat

## install tomcat
ADD apache-tomcat.tar.gz /opt/tomcat
RUN mv /opt/tomcat/apache-tomcat/* /opt/tomcat/ && \
    rm -r /opt/tomcat/apache-tomcat/ && \
    chown -R 1000:1000 /opt/tomcat && \
    chmod -R g+w /opt/tomcat && \
    chmod +t /opt/tomcat

## add admin user to tomcat
ADD tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml
ENTRYPOINT su -c "/opt/tomcat/bin/catalina.sh run" tomcat
