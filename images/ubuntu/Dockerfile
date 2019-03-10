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

ENV APP_NAME=server
#default directory for SPIGOT-server
ENV SPIGOT_HOME /minecraft
ENV RUN_DIR /minecraft_run

RUN groupadd -g 1000 minecraft && \
  useradd -s /bin/bash -d /minecraft -m minecraft -g minecraft && \
  usermod -aG sudo minecraft

RUN echo "minecraft ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/minecraft

RUN mkdir $RUN_DIR
RUN chown minecraft:minecraft $RUN_DIR

ADD ./minecraft/ops.txt /usr/local/etc/minecraft/ops.txt
ADD ./minecraft/white-list.txt /usr/local/etc/minecraft/white-list.txt
ADD ./minecraft/server.properties /usr/local/etc/minecraft/server.properties
ADD ./lib/scripts/spigot_init.sh /spigot_init.sh
ADD ./lib/scripts/spigot_run.sh /spigot_run.sh
ADD ./lib/scripts/spigot_cmd.sh /spigot_cmd.sh

RUN chmod +x /spigot_init.sh
RUN chmod +x /spigot_run.sh
RUN chmod +x /spigot_cmd.sh

EXPOSE 25565
EXPOSE 8123
VOLUME ["/minecraft"]

ENV UID=1000
ENV GUID=1000

ENV MOTD A Minecraft Server Powered by Spigot & Docker
ENV REV latest
ENV JVM_OPTS -Xmx1024M -Xms1024M
ENV LEVEL=world \
  PVP=true \
  VDIST=10 \
  OPPERM=4 \
  NETHER=true \
  FLY=false \
  MAXBHEIGHT=256 \
  NPCS=true \
  WLIST=false \
  ANIMALS=true \
  HC=false \
  ONLINE=true \
  RPACK='' \
  DIFFICULTY=3 \
  CMDBLOCK=false \
  MAXPLAYERS=20 \
  MONSTERS=true \
  STRUCTURES=true SPAWNPROTECTION=16

#ENV DYNMAP=true ESSENTIALS=false ESSENTIALSPROTECT=false PERMISSIONSEX=false CLEARLAG=false

USER minecraft

#set default command
CMD trap 'exit' INT; /spigot_init.sh
