FROM ubuntu:14.04
MAINTAINER AshDev <ashdevfr@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

ADD ./lib/apt/sources.list /etc/apt/sources.list
RUN apt-get update -y; apt-get upgrade -y
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update -y; apt-get upgrade -y
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt-get install -y curl oracle-java8-installer oracle-java8-set-default supervisor pwgen
RUN apt-get update && apt-get install -y wget git && apt-get clean all

#default directory for SPIGOT-server
ENV SPIGOT_HOME /minecraft

ADD ./lib/minecraft/opts.txt /usr/local/etc/minecraft/opts.txt
ADD ./lib/minecraft/white-list.txt /usr/local/etc/minecraft/white-list.txt
ADD ./lib/minecraft/server.properties /usr/local/etc/minecraft/server.properties
ADD ./lib/eula.txt /$SPIGOT_HOME/eula.txt
ADD ./lib/minecraft/plugins/dynmap-2.2-alpha-1.jar /$SPIGOT_HOME/plugins/dynmap.jar
ADD ./lib/scripts/spigot_init.sh /spigot_init.sh

RUN chmod +x /spigot_init.sh

RUN useradd -s /bin/bash -d /minecraft -m minecraft

EXPOSE 25565
EXPOSE 8123
VOLUME ["/$SPIGOT_HOME"]

#set default command
CMD /spigot_init.sh
