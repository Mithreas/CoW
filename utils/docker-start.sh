# NB - you will need to Unixify the line endings of this file. 
# Test server setup instructions.
# Assumes the server home location is /nwn/server.
# Tested by:
# - installing Oracle VirtualBox
# - creating a new Debian VM with default settings.
# - configuring the VM to boot from debian-9.4.0-amd64-netinst (downloaded from Debian-cd)
# - configuring the VM network to map TCP port 22 on host to TCP port 22 on guest
# - configuring the VM network to map UDP port 5121 on host to UDP port 5121 on guest
# - installing a basic Debian install with no GUI, just SSH server and command line
# - creating /nwn/server and subdirectories modules, override, hak and tlk with relevant files
# - installing MariaDB (MySQL): apt-get -y install mariadb-server mariadb-client
# - configuring the database as follows
#   - mysql
#   - create user 'YOUR_DB_USER'@'localhost' identified by 'YOUR_DB_PASSWORD'; [same PW below]
#   - create database YOUR_DB;
#   - grant all privileges on YOUR_DB.* to 'YOUR_DB_USER'@'localhost'
#   - \q
#   - mysql YOUR_DB < schema_mysql.sql
# - installing ruby/rubygems: apt-get install ruby
# - installing the NWN library for ruby: gem install nwn-lib (may take a while)
# NOTE: need to get this working within the container!
# - installing Docker CE (https://docs.docker.com/install/linux/docker-ce/debian/)
# - running the script below to start the server. 
#
# - Other useful utilities
#   - apt-get install dos2unix (for converting dos line endings to unix)
#   - apt-get install php php-mbstring php-xml php-mysql(for running PHP enabled websites)
#
cd /nwn/server
sudo docker stop DockerNWNTest
sudo docker rm DockerNWNTest
sudo docker run --restart unless-stopped -dit \
    --net host -e NWN_PORT=5121 \
    --name DockerNWNTest \
    -v $(pwd):/nwn/home \
    -e NWN_MODULE='YOUR_MODULE_NAME' \
    -e NWN_PUBLICSERVER=1 \
    -e NWN_SERVERNAME='YOUR_SERVERNAME' \
    -e NWN_PLAYERPASSWORD='YOUR_PLAYER_PASS' \
    -e NWN_DMPASSWORD='YOUR_DM_PASS' \
    -e NWN_ELC=0 \
    -e NWN_ILR=0 \
    -e NWN_MAXLEVEL=40 \
    -e NWN_GAMETYPE=10 \
    -e NWN_PAUSEANDPLAY=0 \
    -e NWNX_ADMINISTRATION_SKIP=n \
    -e NWNX_BEHAVIOURTREE_SKIP=y \
    -e NWNX_CHAT_SKIP=n \
    -e NWNX_CREATURE_SKIP=n \
    -e NWNX_EVENTS_SKIP=n \
    -e NWNX_DATA_SKIP=n \
    -e NWNX_METRICS_INFLUXDB_SKIP=y \
    -e NWNX_OBJECT_SKIP=n \
    -e NWNX_PLAYER_SKIP=n \
    -e NWNX_RUBY_SKIP=y \
    -e NWNX_SERVERLOGREDIRECTOR_SKIP=y \
    -e NWNX_SQL_SKIP=n \
    -e NWNX_THREADWATCHDOG_SKIP=y \
    -e NWNX_TRACKING_SKIP=n \
    -e NWNX_SQL_TYPE=mysql \
    -e NWNX_SQL_HOST=127.0.0.1 \
    -e NWNX_SQL_USERNAME=YOUR_DB_USER \
    -e NWNX_SQL_PASSWORD='YOUR_DB_PASSWORD' \
    -e NWNX_SQL_DATABASE=YOUR_DB \
    -e NWNX_SQL_QUERY_METRICS=true \
    -e NWNX_CORE_LOG_LEVEL=7 \
    nwnxee/nwserver:8166
