# supertuxkart-docker
A ready-to-use supertuxkart server compiled following the instructions in https://github.com/supertuxkart/stk-code/blob/master/NETWORKING.md using a [docker base image of Ubuntu 20.04](https://hub.docker.com/_/ubuntu).

## Usage
You can pass arguments to supertuxkart just as usual. For instance, in order to check all the available options:

```sh
docker run --rm -it juanelas/supertuxkart --help
```

## Hosting a WAN server

You are required to have an STK online account first, go [here](https://online.supertuxkart.net/register.php) for registration.

### Persisting configuration
It is recommended you have a saved user in your computer. In order for the configuration to persist, you need to create a volume or a bind mount for the supertuxkart config directory in the container's `/root/.config/supertuxkart`. It is probably easier to bind a directory in your host machine for the config.

In the following we are assuming that you bind directory `supertuxkart/config` in your user's home:

```sh
docker run --rm -it -v $HOME/supertuxkart/config:/root/.config/supertuxkart juanelas/supertuxkart --init-user --login=your_registered_name --password=your_password
```

If login succeeded, you should see these lines among the logged ones:

```sh
[info   ] Main: Logged in from command-line.
[info   ] Main: Done saving user, leaving
```

Now just edit and tune `$HOME/supertuxkart/config/config-0.10/server_config.xml`, don't forget to set `wan-server` to `true` and run again with:

```sh
docker run --rm -it -v $HOME/supertuxkart/config:/root/.config/supertuxkart juanelas/supertuxkart
```

Exposing udp port 2759 is optional for a WAN server since, at the moment, STK has a list of STUN servers for NAT penetration which allows players or servers behind a firewall or router to be able to connect to each other. Exposing the port will allow your server to operate if the STUN servers do not work (or are disabled), though.

Exposing udp port 2757 is also optional and enables server discovery for connecting your WAN server in LAN / localhost.

The same command exposing both above ports wuold be:

```sh
docker run --rm -it -v $HOME/supertuxkart/config:/root/.config/supertuxkart -p 2757:2757/udp -p 2759:2759/udp juanelas/supertuxkart
```

Remember to also enable port forwarding in your router if you are behind a NAT.

### Non-persisting configuration

If you prefer not to create a volume or bind mount, you can still run your WAN server passing the necessary arguments. For example, you can host a soccer server in expert mode with:

```sh
docker run --rm -it juanelas/supertuxkart --login=your_registered_name --password=your_password --wan-server=your_server_name --network-console --mode=3 --difficulty=2
```

## Hosting a local internet server

Everything is basically the same as WAN one, except you don't need an STK online account. 

Now, it is required that the server and server discovery port is connectable by clients directly, so exposing the ports is not optional and you should also ensure that the forwarded ports in your host machine are available.

If the default setup is OK for you, just do:

```sh
docker run --rm -it -p 2757:2757/udp -p 2759:2759/udp juanelas/supertuxkart  --lan-server=your_server_name
```

Since you probably want to tweak the server configuration, as with the WAN server, bind mount a directory and tweak your `server_config.xml`. In the following it is assumed that you bind directory `$HOME/supertuxkart/config` in your host machine.

Edit and tune `$HOME/supertuxkart/config/config-0.10/server_config.xml`.

> If the `config-0.10` does not exist since it is the first time you run the command, do not create it yourself. Just run the below command once and it will be created, then you can edit the file.

Don't forget to set `wan-server` to `false` and run again with:

```sh
docker run --rm -it -v $HOME/supertuxkart/config:/root/.config/supertuxkart -p 2757:2757/udp -p 2759:2759/udp juanelas/supertuxkart
```
