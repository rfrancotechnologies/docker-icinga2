FROM debian:jessie

MAINTAINER Raphael Bicker

ENV MYSQL_ICINGA_DB icinga2
ENV MYSQL_ICINGA_USER icinga2
ENV MYSQL_ICINGA_PASSWORD icinga2

ENV API_USER api
ENV API_PASSWORD api

ENV NODE_NAME icinga2

ENV DEBIAN_FRONTEND noninteractive     

RUN apt-get -q update \
  && apt-get -qqy upgrade \
  && apt-get install -y wget vim mysql-client ssmtp
  
RUN wget --quiet -O - https://packages.icinga.org/icinga.key | apt-key add -

RUN echo "deb http://packages.icinga.org/debian icinga-jessie main" >> /etc/apt/sources.list

RUN apt-get update -q \
  && apt-get install -y icinga2 icinga2-ido-mysql
  
RUN echo "const NodeName = \"${NODE_NAME}\"" >> /etc/icinga2/constants.conf
  
ADD content/ /

RUN chmod +x /run.sh

VOLUME ["/etc/icinga2", "/var/lib/icinga2", "/var/log/icinga2", "/etc/ssmtp"]

EXPOSE 5665

CMD ["/run.sh"]