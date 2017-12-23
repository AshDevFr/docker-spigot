FROM alpine:3.6
MAINTAINER AshDev <ashdevfr@gmail.com>

# Java Version and other ENV
ENV JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=112 \
    JAVA_VERSION_BUILD=15 \
    JAVA_PACKAGE=server-jre \
    JAVA_HOME=/opt/jdk \
    PATH=${PATH}:/opt/jdk/bin \
    LANG=C.UTF-8

# Install dependencies
RUN apk upgrade --update && \
    apk add --update wget curl ca-certificates openssl bash git && \
    update-ca-certificates

# Install Java8
RUN apk add openjdk8-jre

#default directory for SPIGOT-server
ENV SPIGOT_HOME /minecraft

RUN mkdir ${SPIGOT_HOME}

ADD ./minecraft/opts.txt /usr/local/etc/minecraft/opts.txt
ADD ./minecraft/white-list.txt /usr/local/etc/minecraft/white-list.txt
ADD ./minecraft/server.properties /usr/local/etc/minecraft/server.properties
ADD ./lib/scripts/spigot_init.sh /spigot_init.sh

RUN chmod +x /spigot_init.sh

EXPOSE 25565
EXPOSE 8123
VOLUME ["/minecraft"]

ENV UID=1000

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
  STRUCTURES=true \
  SPAWNPROTECTION=16

#ENV DYNMAP=true ESSENTIALS=false PERMISSIONSEX=false CLEARLAG=false

#set default command
CMD /spigot_init.sh
