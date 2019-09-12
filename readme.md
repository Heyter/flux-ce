![Flux](https://teslacdn.net/files/logo/flux_logo.png)

Flux is a WIP gamemode framework designed with performance and convenience in mind.

# Alpha release
Current version of Flux is currently in active development as an open alpha. This means that you can install it and it will run, but there will almost inevitably be bugs and issues, as well as a lot of missing features. If you are not a developer, it is probably better for you to wait until Flux is in beta.

# Important

**Flux is only guaranteed to work on dedicated servers (srcds). We do not support "listen" servers (launching from Garry's Mod client).**

# Installation
**Please read these instructions carefully. We cannot provide support if you disregard one or more steps in there instructions. Thank you!**

### Prerequisites
* SteamCMD
* Git
* Linux: Debian Stretch or newer recommended
* Windows: Windows 10 / Windown Server 2016+ recommended
* Windows: Microsoft Visual C++ 2015

### General installation

If you want to just get Flux up and running, clone the [dependencies repository](https://github.com/TeslaCloud/flux-dependencies). After that, simply clone repo inside of the `gamemodes` folder, as well as the [reborn schema](https://github.com/TeslaCloud/reborn) repo.

Here is approximately what you will need to do on a Linux system (you can probably do the same on Windows):
```sh
# Clone the dependencies repo into the "flux_server" folder
git clone https://github.com/TeslaCloud/flux-dependencies.git flux_server

# Then install the server files on top.
steamcmd +login anonymous +force_install_dir ./flux_server +app_update 4020 +quit

# Navigate to the gamemodes folder.
cd ./flux_server/garrysmod/gamemodes

# Clone the Flux repository as a gamemode. Make sure to clone into the "flux" folder.
git clone https://github.com/TeslaCloud/flux-ce.git flux

# Then clone the Reborn schema, or any other schema you'd like to use.
git clone https://github.com/TeslaCloud/reborn.git

# And you're all set!
```

### Creating a server startup script.

Example start.sh / start.bat you may end up with:

**Linux:**
```sh
./srcds_run +gamemode "reborn" +map "gm_construct" +maxplayers 64 -tickrate 30
```

**Windows:**
```bat
srcds.exe -game garrysmod +gamemode "reborn" +map "gm_construct" +maxplayers 64 -tickrate 30
```

### Database setup
Depending on your use case, you may want to setup a database. SQLite is the default option and requires no further setup. It is perfect if you simply want to take a look at Flux and how it works. If you want to run Flux in production, however, you should consider setting up a MySQL (MariaDB) or PostgreSQL database.

Follow the instructions in `/garrysmod/gamemodes/flux/config/database.yml` to learn more.

### Environment
By default, Flux comes with `production` environment pre-chosen. It is good if you don't want to write code. If you plan on writing plugins, schemas or modifying the framework, you should set your environment to `development`. **No other environments are supported yet!** If you wish to change your environment, copy the `gamemodes/flux/config/environment.lua` file as `environment.local.lua` and change `production` to `development` inside that file.

**What is the difference between production and development?**

In production, code runs a little bit faster, but it sacrifices error-tolerance and refreshability. It it perfect when you are running your server properly, because in that case you don't want to refresh the code anyway (since it causes a lot of lag).

In development, code runs slower, but is a lot more tolerant to errors. It uses safe mode on hooks and print lots of useful debug information, such as load order. Due to the speed sacrifice, it is only practical to run `development` when actually developing.

# Upgrading
During Alpha, the database may break between versions. This will be different in beta and beyond, but until then, if you are upgrading Flux you need to recreate the database manually every time.

To do that, simply follow the steps below:

1. Delete the `/garrysmod/gamemodes/**your_schema**/db/` folder.
2. Follow the database-specific instructions below:

### SQLite
1. Simply delete the `/garrysmod/sv.db` file.
2. Restart the server.

### MariaDB (MySQL)
1. Open the MySQL console (`mysql` command on Linux) or any other means of managing your database.
2. Drop the table specified in `/garrysmod/gamemodes/flux/config/database[.local].yml`. To do that from console, simply run `DROP DATABASE database_name_here;`, replace `database_name_here` with your database name.
3. Create a new database. To do that, run `CREATE DATABASE database_name_here;`, replace `database_name_here` with your database name.
4. Restart the server.

### PostgreSQL
1. Open `psql` or pgAdmin (`sudo -u postgres psql`).
2. Drop the table specified in `/garrysmod/gamemodes/flux/config/database[.local].yml`. To do that from `psql`, simply run `DROP DATABASE database_name_here;`, replace `database_name_here` with your database name.
3. Create a new database. To do that, run `CREATE DATABASE database_name_here;`, replace `database_name_here` with your database name.
4. Restart the server.

# Playing
If you wish to play the gamemode, you should install the content addon to prevent purple-black checkers where the materials should be. You can find it here: <https://steamcommunity.com/sharedfiles/filedetails/?id=1518849094>

# Other info
For more info or technical support, please visit our forums: http://f.teslacloud.net/
