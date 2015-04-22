#!/bin/bash
set -e
usermod --uid $UID minecraft

if [ ! -e /$SPIGOT_HOME/eula.txt ]; then
  if [ "$EULA" != "" ]; then
    echo "# Generated via Docker on $(date)" > /$SPIGOT_HOME/eula.txt
    echo "eula=$EULA" >> /$SPIGOT_HOME/eula.txt
  else
    echo "*****************************************************************"
    echo "*****************************************************************"
    echo "** To be able to run spigot you need to accept minecrafts EULA **"
    echo "** see https://account.mojang.com/documents/minecraft_eula     **"
    echo "** include -e EULA=true on the docker run command              **"
    echo "*****************************************************************"
    echo "*****************************************************************"
    exit
  fi
fi

#only build if jar file does not exist
if [ ! -f /$SPIGOT_HOME/spigot.jar ]; then 
  echo "Building spigot jar file, be patient"
  mkdir -p /$SPIGOT_HOME/build
  cd /$SPIGOT_HOME/build
  wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
  HOME=/$SPIGOT_HOME/build java -jar BuildTools.jar
  cp /$SPIGOT_HOME/build/Spigot/Spigot-Server/target/spigot-1.8*.jar /$SPIGOT_HOME/spigot.jar
fi

if [ ! -f /$SPIGOT_HOME/opts.txt ]
then
    cp /usr/local/etc/minecraft/opts.txt /$SPIGOT_HOME/
fi

if [ ! -f /$SPIGOT_HOME/white-list.txt ]
then
    cp /usr/local/etc/minecraft/white-list.txt /$SPIGOT_HOME/
fi

if [ ! -f /$SPIGOT_HOME/server.properties ]
then
  cp /usr/local/etc/minecraft/server.properties /$SPIGOT_HOME/
    
  if [ -n "$MOTD" ]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /$SPIGOT_HOME/server.properties
  fi

  if [ -n "$LEVEL" ]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /$SPIGOT_HOME/server.properties
  fi

  if [ -n "$SEED" ]; then
    sed -i "/level-seed\s*=/ c level-seed=$SEED" /$SPIGOT_HOME/server.properties
  fi

  if [ -n "$PVP" ]; then
    sed -i "/pvp\s*=/ c pvp=$PVP" /$SPIGOT_HOME/server.properties
  fi

  if [ -n "$MODE" ]; then
    case ${MODE,,?} in
      0|1|2|3)
        ;;
      s*)
        MODE=0
        ;;
      c*)
        MODE=1
        ;;
      *)
        echo "ERROR: Invalid game mode: $MODE"
        exit 1
        ;;
    esac

    sed -i "/gamemode\s*=/ c gamemode=$MODE" /$SPIGOT_HOME/server.properties
  fi
fi

if [ -n "$OPS" ]; then
  echo $OPS | awk -v RS=, '{print}' >> /$SPIGOT_HOME/ops.txt
fi

if [ -n "$ICON" -a ! -e /$SPIGOT_HOME/server-icon.png ]; then
  echo "Using server icon from $ICON..."
  # Not sure what it is yet...call it "img"
  wget -q -O /tmp/icon.img $ICON
  specs=$(identify /tmp/icon.img | awk '{print $2,$3}')
  if [ "$specs" = "PNG 64x64" ]; then
    mv /tmp/icon.img /$SPIGOT_HOME/server-icon.png
  else
    echo "Converting image to 64x64 PNG..."
    convert /tmp/icon.img -resize 64x64! /$SPIGOT_HOME/server-icon.png
  fi
fi

# chance owner to minecraft
chown -R minecraft.minecraft /$SPIGOT_HOME/

cd /$SPIGOT_HOME/

exec java $JVM_OPTS -jar spigot.jar

# fallback to root and run shell if spigot don't start/forced exit
bash