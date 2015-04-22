## Minecraft server SPIGIT on Ubuntu 14.04

This docker image provides a Minecraft Server with Spigot that will automatically download the latest stable version at startup.

To simply use the latest stable version, run

    docker run -d -p 25565:25565 $USER/docker-spigot:latest

where the standard server port, 25565, will be exposed on your host machine.

If you want to serve up multiple Minecraft servers or just use an alternate port,
change the host-side port mapping such as

    docker run -p 25566:25565 ...

will serve your Minecraft server on your host's port 25566 since the `-p` syntax is
`host-port`:`container-port`.

Speaking of multiple servers, it's handy to give your containers explicit names using `--name`, such as

    docker run -d -p 25565:25565 --name mc $USER/docker-spigot:latest

With that you can easily view the logs, stop, or re-start the container:

    docker logs -f mc
        ( Ctrl-C to exit logs action )

    docker stop mc

    docker start mc

## Interacting with the server

In order to attach and interact with the Minecraft server, add `-it` when starting the container, such as

    docker run -d -it -p 25565:25565 --name mc $USER/docker-spigot:latest

With that you can attach and interact at any time using

    docker attach mc

and then Control-p Control-q to **detach**.

For remote access, configure your Docker daemon to use a `tcp` socket (such as `-H tcp://0.0.0.0:2375`)
and attach from another machine:

    docker -H $HOST:2375 attach mc

Unless you're on a home/private LAN, you should [enable TLS access](https://docs.docker.com/articles/https/).

## EULA Support

Mojang now requires accepting the [Minecraft EULA](https://account.mojang.com/documents/minecraft_eula). To accept add

        -e EULA=TRUE

such as

        docker run -d -it -e EULA=TRUE -p 25565:25565 $USER/docker-spigot:latest

## Attaching data directory to host filesystem

In order to readily access the Minecraft data, use the `-v` argument
to map a directory on your host machine to the container's `/minecraft` directory, such as:

    docker run -d -v /path/on/host:/minecraft ...

When attached in this way you can stop the server, edit the configuration under your attached `/path/on/host`
and start the server again with `docker start CONTAINERID` to pick up the new configuration.


## Running with Plugins

In order to add mods, you will need to attach the container's `/minecraft` directory
(see "Attaching data directory to host filesystem”).
Then, you can add mods to the `/path/on/host/mods` folder you chose. From the example above,
the `/path/on/host` folder contents look like:

```
/path/on/host
├── plugins
│   └── ... INSTALL PLUGINS HERE ...
├── ops.json
├── server.properties
├── whitelist.json
└── ...
```

If you add mods while the container is running, you'll need to restart it to pick those
up:

    docker stop $ID
    docker start $ID

## Server configuration

### Op/Administrator Players

To add more "op" (aka adminstrator) users to your Minecraft server, pass the Minecraft usernames separated by commas via the `OPS` environment variable, such as

	docker run -d -e OPS=user1,user2 ...

### Server icon

A server icon can be configured using the `ICON` variable. The image will be automatically
downloaded, scaled, and converted from any other image format:

    docker run -d -e ICON=http://..../some/image.png ...

### Level Seed

If you want to create the Minecraft level with a specific seed, use `SEED`, such as

    docker run -d -e SEED=1785852800490497919 ...

### Game Mode

By default, Minecraft servers are configured to run in Survival mode. You can
change the mode using `MODE` where you can either provide the [standard
numerical values](http://minecraft.gamepedia.com/Game_mode#Game_modes) or the
shortcut values:

* creative
* survival

For example:

    docker run -d -e MODE=creative ...

### Message of the Day

The message of the day, shown below each server entry in the UI, can be changed with the `MOTD` environment variable, such as

docker run -d -e 'MOTD=My Server' ...

If you leave it off, the last used or default message will be used. _The example shows how to specify a server
message of the day that contains spaces by putting quotes around the whole thing._

### PVP Mode

By default servers are created with player-vs-player (PVP) mode enabled. You can disable this with the `PVP`
environment variable set to `false`, such as

    docker run -d -e PVP=false ...

### World Save Name

You can either switch between world saves or run multiple containers with different saves by using the `LEVEL` option,
where the default is "world":

docker run -d -e LEVEL=bonus ...

**NOTE:** if running multiple containers be sure to either specify a different `-v` host directory for each
`LEVEL` in use or don't use `-v` and the container's filesystem will keep things encapsulated.

## JVM Configuration

### Memory Limit

The Java memory limit can be adjusted using the `JVM_OPTS` environment variable, where the default is
the setting shown in the example (max and min at 1024 MB):

    docker run -e 'JVM_OPTS=-Xmx1024M -Xms1024M' ...