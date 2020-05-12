# supertuxkart-docker   <!-- omit in toc -->
A ready-to-use supertuxkart server compiled following the instructions in https://github.com/supertuxkart/stk-code/blob/master/NETWORKING.md using a [docker base image of Ubuntu 20.04](https://hub.docker.com/_/ubuntu).

- [What is SuperTuxKart?](#what-is-supertuxkart)
- [Usage](#usage)
- [Hosting a WAN server](#hosting-a-wan-server)
  - [WAN server with volatile configuration](#wan-server-with-volatile-configuration)
  - [WAN server with persisting configuration](#wan-server-with-persisting-configuration)
  - [Optional WAN server ports](#optional-wan-server-ports)
- [Hosting a local internet server](#hosting-a-local-internet-server)
  - [Local internet server with volatile configuration](#local-internet-server-with-volatile-configuration)
  - [Local internet server with persisting configuration](#local-internet-server-with-persisting-configuration)

## What is SuperTuxKart?

[SuperTuxKart (STK)](https://supertuxkart.net) is a free and open-source kart racing game, distributed under the terms of the GNU General Public License, version 3. It features mascots of various open-source projects. SuperTuxKart is cross-platform, running on Linux, macOS, Windows, and Android systems. Version 1.1 was officially released on January 5, 2022.

SuperTuxKart started as a fork of TuxKart, originally developed by Steve and Oliver Baker in 2000. When TuxKart's development ended around March 2004, a fork as SuperTuxKart was conducted by other developers in 2006. SuperTuxKart is under active development by the game's community.

![logo](https://supertuxkart.net/skins/SuperTuxKart/images/logo.png)

## Usage
You can pass arguments to supertuxkart just as usual. For instance, in order to check all the available options:

```sh
docker run --rm -it juanelas/supertuxkart --help
```

## Hosting a WAN server

You are required to have an STK online account first, go [here](https://online.supertuxkart.net/register.php) for registration.


### WAN server with volatile configuration

You can run your WAN server just passing the necessary arguments. For example, you can host a soccer server in expert mode with (substitute `your_login_name` and `your_password` with your actual registered login name and password):

```sh
docker run --rm -it juanelas/supertuxkart --login=your_login_name --password=your_password --wan-server=your_server_name --mode=3 --difficulty=2 --network-console
```

You can also pass a configuration file with all the options to the server, although you should mount it in the container. Assuming that your file is located in `$HOME/supertuxkart/server_config.xml`, the command would be, for instance:

```sh
docker run --rm -it -v $HOME/supertuxkart/server_config.xml:/tmp/server_config.xml juanelas/supertuxkart --login=your_registered_name --password=your_password --server-config=/tmp/server_config.xml
```

A reference `server_config.xml` configuration file for a WAN server would be:

```xml
<?xml version="1.0"?>
<server-config version="6" >

    <!-- Name of server, encode in XML if you want to use unicode characters. -->
    <server-name value="STK Server" />

    <!-- Port used in server, if you specify 0, it will use the server port specified in stk_config.xml. If you wish to use a random port, set random-server-port to '1' in user config. STK will automatically switch to a random port if the port you specify fails to be bound. -->
    <server-port value="0" />

    <!-- Game mode in server, 0 is normal race (grand prix), 1 is time trial (grand prix), 3 is normal race, 4 time trial, 6 is soccer, 7 is free-for-all and 8 is capture the flag. Notice: grand prix server doesn't allow for players to join and wait for ongoing game. -->
    <server-mode value="3" />

    <!-- Difficulty in server, 0 is beginner, 1 is intermediate, 2 is expert and 3 is supertux (the most difficult). -->
    <server-difficulty value="0" />

    <!-- Number of grand prix tracks per game (If grand prix enabled). -->
    <gp-track-count value="3" />

    <!-- Use goal target in soccer. -->
    <soccer-goal-target value="false" />

    <!-- Enable wan server, which requires you to have an stk-addons account with a saved session. Check init-user command for details. -->
    <wan-server value="true" />

    <!-- Enable network console, which can do for example kickban. -->
    <enable-console value="false" />

    <!-- Maximum number of players on the server, setting this to a value greater than 8 can cause performance degradation. -->
    <server-max-players value="8" />

    <!-- Password for private server, leave empty for a public server. -->
    <private-server-password value="" />

    <!-- Message of today shown in lobby, you can enter encoded XML words here or a file.txt and let STK load it. -->
    <motd value="" />

    <!-- If this value is set to false, the server will ignore chat messages from all players. -->
    <chat value="true" />

    <!-- If client sends more than chat-consecutive-interval / 2 chats within this value (read in seconds), it will be ignore, negative value to disable. -->
    <chat-consecutive-interval value="8" />

    <!-- Allow players to vote for which track to play. If this value is set to false, the server will randomly pick the next track to play. -->
    <track-voting value="true" />

    <!-- Timeout in seconds for selecting karts and (or) voting tracks in server, you may want to use a lower value if you have track-voting off. -->
    <voting-timeout value="30" />

    <!-- Timeout in seconds for validation of clients in wan, currently STK will use the stk-addons server to share AES key between the client and server. -->
    <validation-timeout value="20" />

    <!-- By default WAN server will always validate player and LAN will not, disable it to allow non-validated player in WAN. -->
    <validating-player value="true" />

    <!-- Disable it to turn off all stun related code in server, it allows for saving of server resources if your server is not behind a firewall. -->
    <firewalled-server value="true" />

    <!-- Enable to allow IPv6 connection if you have a public IPv6 address. STK currently uses dual-stack mode which requires server to have both IPv4 and IPv6 and listen to same port. If STK detects your server has no public IPv6 address or port differs between IPv4 and IPv6 then it will use IPv4 only socket. For system which doesn't support dual-stack socket (like OpenBSD) you may fail to be connected by IPv4 clients. -->
    <ipv6-connection value="true" />

    <!-- No server owner in lobby which can control the starting of game or kick any players. -->
    <owner-less value="false" />

    <!-- Time to wait before entering kart selection screen if satisfied min-start-game-players below for owner less or ranked server. -->
    <start-game-counter value="60" />

    <!-- Clients below this value will be rejected from joining this server. It's determined by number of official karts in client / number of official karts in server -->
    <official-karts-threshold value="1" />

    <!-- Clients below this value will be rejected from joining this server. It's determined by number of official tracks in client / number of official tracks in server, setting this value too high will prevent android players from joining this server, because STK android apk has some official tracks removed. -->
    <official-tracks-threshold value="0.7" />

    <!-- Only auto start kart selection when number of connected player is larger than or equals this value, for owner less or ranked server, after start-game-counter reaches 0. -->
    <min-start-game-players value="2" />

    <!-- Automatically end linear race game after 1st player finished for some time (currently his finished time * 0.25 + 15.0). -->
    <auto-end value="false" />

    <!-- Enable team choosing in lobby in team game (soccer and CTF). If owner-less is enabled and live-players is not enabled, than this option is always disabled. -->
    <team-choosing value="true" />

    <!-- If strict-players is on, no duplicated online id or split screen players are allowed, which can prevent someone using more than 1 network AI with this server. -->
    <strict-players value="false" />

    <!-- Server will submit ranking to stk-addons server for linear race games, you require permission for that. validating-player, auto-end, strict-player and owner-less will be turned on. -->
    <ranked value="false" />

    <!-- If true, the server owner can config the difficulty and game mode in the GUI of lobby. This option cannot be used with owner-less or grand prix server, and will be automatically turned on if the server was created using the in-game GUI. The changed difficulty and game mode will not be saved in this config file. -->
    <server-configurable value="false" />

    <!-- If true, players can live join or spectate the in-progress game. Currently live joining is only available if the current game mode used in server is FFA, CTF or soccer, also no addon karts will be available for players to choose, and official-karts-threshold will be made 1.0. -->
    <live-players value="false" />

    <!-- Time in seconds when a flag is dropped a by player in CTF returning to its own base. -->
    <flag-return-timeout value="20" />

    <!-- Time in seconds to deactivate a flag when it's captured or returned to own base by players. -->
    <flag-deactivated-time value="3" />

    <!-- Hit limit of free for all, zero to disable hit limit. -->
    <hit-limit value="20" />

    <!-- Time limit of free for all in seconds, zero to disable time limit. -->
    <time-limit-ffa value="360" />

    <!-- Capture limit of CTF, zero to disable capture limit. -->
    <capture-limit value="5" />

    <!-- Time limit of CTF in seconds, zero to disable time limit. -->
    <time-limit-ctf value="600" />

    <!-- Value used by server to automatically estimate each game time. For races, it decides the lap of each race in network game, if more than 0.0f, the number of lap of each track vote in linear race will be determined by max(1.0f, auto-game-time-ratio * default lap of that track). For soccer if more than 0.0f, for time limit game it will be auto-game-time-ratio * soccer-time-limit in UserConfig, for goal limit game it will be auto-game-time-ratio * numgoals in UserConfig, -1 to disable for all. -->
    <auto-game-time-ratio value="-1" />

    <!-- Maximum ping allowed for a player (in ms), it's recommended to use default value if live-players is on. -->
    <max-ping value="300" />

    <!-- Tolerance of jitter in network allowed (in ms), it's recommended to use default value if live-players is on. -->
    <jitter-tolerance value="100" />

    <!-- Kick players whose ping is above max-ping. -->
    <kick-high-ping-players value="false" />

    <!-- Allow players exceeding max-ping to have a playable game, if enabled kick-high-ping-players will be disabled, please also use a default value for max-ping and jitter-tolerance with it. -->
    <high-ping-workaround value="true" />

    <!-- Kick idle player which has no network activity to server for more than some seconds during game, unless he has finished the race. Negative value to disable, and this option will always be disabled for LAN server. -->
    <kick-idle-player-seconds value="60" />

    <!-- Set how many states the server will send per second, the higher this value, the more bandwidth requires, also each client will trigger more rewind, which clients with slow device may have problem playing this server, use the default value is recommended. -->
    <state-frequency value="10" />

    <!-- Use sql database for handling server stats and maintenance, STK needs to be compiled with sqlite3 supported. -->
    <sql-management value="false" />

    <!-- Database filename for sqlite to use, it can be shared for all servers created in this machine, and STK will create specific table for each server. You need to create the database yourself first, see NETWORKING.md for details -->
    <database-file value="stkservers.db" />

    <!-- Specified in millisecond for maximum time waiting in sqlite3_busy_handler. You may need a higher value if your database is shared by many servers or having a slow hard disk. -->
    <database-timeout value="1000" />

    <!-- IPv4 ban list table name, you need to create the table first, see NETWORKING.md for details, empty to disable. This table can be shared for all servers if you use the same name. STK can auto kick active peer from ban list (update per minute) whichallows live kicking peer by inserting record to database. -->
    <ip-ban-table value="ip_ban" />

    <!-- IPv6 ban list table name, you need to create the table first, see NETWORKING.md for details, empty to disable. This table can be shared for all servers if you use the same name. STK can auto kick active peer from ban list (update per minute) which allows live kicking peer by inserting record to database. -->
    <ipv6-ban-table value="ipv6_ban" />

    <!-- Online ID ban list table name, you need to create the table first, see NETWORKING.md for details, empty to disable. This table can be shared for all servers if you use the same name. STK can auto kick active peer from ban list (update per minute) which allows live kicking peer by inserting record to database. -->
    <online-id-ban-table value="online_id_ban" />

    <!-- Player reports table name, which will be written when a player reports player in the network user dialog, you need to create the table first, see NETWORKING.md for details, empty to disable. This table can be shared for all servers if you use the same name. -->
    <player-reports-table value="player_reports" />

    <!-- Days to keep player reports, older than that will be auto cleared, 0 to keep them forever. -->
    <player-reports-expired-days value="3" />

    <!-- IP geolocation table, you only need this table if you want to geolocate IP from non-stk-addons connection, as all validated players connecting from stk-addons will provide the location info, you need to create the table first, see NETWORKING.md for details, empty to disable. This table can be shared for all servers if you use the same name. -->
    <ip-geolocation-table value="ip_mapping" />

    <!-- IPv6 geolocation table, you only need this table if you want to geolocate IP from non-stk-addons connection, as all validated players connecting from stk-addons will provide the location info, you need to create the table first, see NETWORKING.md for details, empty to disable. This table can be shared for all servers if you use the same name. -->
    <ipv6-geolocation-table value="ipv6_mapping" />

    <!-- If true this server will auto add / remove AI connected with network-ai=x, which will kick N - 1 bot(s) where N is the number of human players. Only use this for non-GP racing server. -->
    <ai-handling value="false" />

</server-config>
```


### WAN server with persisting configuration

Among other advantages, a persisting configuration enables: 1) storing your credentials (your token) so that you don't need to write them every time you invoke the supertuxkart server; and 2) make use of the integrated SQLite database management.

In order for the configuration to persist, you need to create a volume or a bind mount for the supertuxkart config directory in the container's `/root/.config/supertuxkart`. It is probably easier to bind a directory in your host machine for the config.

In the following we are assuming that you bind directory `supertuxkart/config` in your user's home.

First run the following to log in STK.

```sh
docker run --rm -it -v $HOME/supertuxkart/config:/root/.config/supertuxkart juanelas/supertuxkart --init-user --login=your_registered_name --password=your_password
```

If login succeeded, you should see these lines among the logged ones:

```sh
[info   ] Main: Logged in from command-line.
[info   ] Main: Done saving user, leaving
```

Now just edit and tune `$HOME/supertuxkart/config/config-0.10/server_config.xml`. Check that `wan-server` is set to `true` and enable (if desired) the advanced management by setting `sql-management` to `true`. Now run again with:

```sh
docker run --rm -it -v $HOME/supertuxkart/config:/root/.config/supertuxkart juanelas/supertuxkart
```

You can also create different configuration files in `$HOME/supertuxkart/config/config-0.10/` and switch to other one passing the `--server-config=file` option. For example, if you create a file `$HOME/supertuxkart/config/config-0.10/wan_server.xml`, you could use that file with:

```sh
docker run --rm -it -v $HOME/supertuxkart/config:/root/.config/supertuxkart juanelas/supertuxkart --server-config=/root/.config/supertuxkart/config-0.10/wan_server.xml
```

> Although the server config file could be anywhere, in practice SQL management will only work if it is placed in the standard config dir `/root/.config/supertuxkart/config-0.10/`, which holds the SQLite3 database.

### Optional WAN server ports

At the moment, STK has a list of STUN servers for NAT penetration which allows players or servers behind a firewall or router to be able to connect to each other. That is to say that no specific port needs to be exposed.

However, exposing udp port 2759 will allow your server to operate if the STUN servers do not work (or are disabled in your configuration). Moreover, exposing udp port 2757 enables server discovery of your WAN server from your LAN / localhost.

An example command exposing both above ports would be:

```sh
docker run --rm -it -v $HOME/supertuxkart/config:/root/.config/supertuxkart -p 2757:2757/udp -p 2759:2759/udp juanelas/supertuxkart --public-server
```

Remember also to allow access to both ports in your host firewall (if any) and to set up port forwarding in your router if you are behind a NAT.

## Hosting a local internet server

Everything is basically the same as for the WAN one, except that you don't need an STK online account. Moreover, now it is required that your server be discoverable and connectable by clients directly. As a result you must expose udp port 2757 (server discovery) and udp port 2759 (supertuxkart). Remember also to allow access in your host firewall (if any) to both ports and to set up port forwarding in your router if you are behind a NAT and want to allow access to clients outside your LAN.

### Local internet server with volatile configuration

You can run your local internet server just passing the necessary arguments. For example, you can host a soccer server in expert mode with:

```sh
docker run --rm -it -p 2757:2757/udp -p 2759:2759/udp juanelas/supertuxkart --lan-server=your_server_name --mode=3 --difficulty=2 --network-console
```

You can also pass a configuration file with all the options to the server, although you should mount it in the container. Assuming that your file is located in `$HOME/supertuxkart/server_config.xml`, the command would be, for instance:

```sh
docker run --rm -it -v $HOME/supertuxkart/server_config.xml:/tmp/server_config.xml juanelas/supertuxkart -p 2757:2757/udp -p 2759:2759/udp --server-config=/tmp/server_config.xml --lan-server=your_server_name
```

You can use, as a reference, the same `server_config.xml` configuration file for a WAN server. 

### Local internet server with persisting configuration

As with the WAN server, bind mount a directory and tweak your `server_config.xml`. In the following it is assumed that you bind directory `$HOME/supertuxkart/config` in your host machine.

Edit and tweak `$HOME/supertuxkart/config/config-0.10/server_config.xml`. 

> If the `config-0.10` does not exist since it is the first time you run the command, do not create it yourself. Just run the below command once and it will be created, then you can edit the file.

```sh
docker run --rm -it -v $HOME/supertuxkart/config:/root/.config/supertuxkart -p 2757:2757/udp -p 2759:2759/udp juanelas/supertuxkart --lan-server=your_server_name
```

If you want to be able to switch between different accounts, please read the instructions for the [WAN Server](#wan-server-wit-persisting-configuration).
