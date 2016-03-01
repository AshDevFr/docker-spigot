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

RUN useradd -s /bin/bash -d /minecraft -m minecraft

ADD ./lib/minecraft/opts.txt /usr/local/etc/minecraft/opts.txt
ADD ./lib/minecraft/white-list.txt /usr/local/etc/minecraft/white-list.txt
ADD ./lib/minecraft/server.properties /usr/local/etc/minecraft/server.properties
ADD ./lib/scripts/spigot_init.sh /spigot_init.sh

RUN chmod +x /spigot_init.sh

EXPOSE 25565
EXPOSE 8123
VOLUME ["/minecraft"]

ENV UID=1000

ENV MOTD A Minecraft Server Powered by Spigot & Docker
ENV REV latest
ENV JVM_OPTS -Xmx1024M -Xms1024M
ENV LEVEL=world PVP=true VDIST=10 OPPERM=4 NETHER=true FLY=false MAXBHEIGHT=256 NPCS=true WLIST=false ANIMALS=true HC=false ONLINE=true RPACK='' DIFFICULTY=3 CMDBLOCK=false MAXPLAYERS=20 MONSTERS=true STRUCTURES=true SPAWNPROTECTION=16

#ENV DYNMAP=true ESSENTIALS=false PERMISSIONSEX=false CLEARLAG=false

#set default command
CMD /spigot_init.sh
