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
#   - create user 'nwn'@'localhost' identified by 'C10udyP4$$w0rd'; [same PW below]
#   - create database nwn;
#   - grant all privileges on nwn.* to 'nwn'@'localhost'
#   - \q
#   - mysql nwn < schema_mysql.sql
# - installing ruby/rubygems: apt-get install ruby
# - installing the NWN library for ruby: gem install nwn-lib (may take a while)
# NOTE: need to get this working within the container!
# - installing Docker CE (https://docs.docker.com/install/linux/docker-ce/debian/)
# - running the script below to start the server. 
#
cd /nwn/server
sudo docker stop CoWTest
sudo docker rm CoWTest
sudo docker run --restart unless-stopped -dit \
    --net host -e NWN_PORT=5121 \
    --name CoWTest \
    -v $(pwd):/nwn/home \
    -e NWN_MODULE='City of Winds' \
    -e NWN_PUBLICSERVER=1 \
    -e NWN_SERVERNAME='City of Winds Test' \
    -e NWN_PLAYERPASSWORD='T3st925#' \
    -e NWN_DMPASSWORD='DMT3st925#' \
    -e NWN_ELC=0 \
    -e NWN_ILR=0 \
    -e NWN_MAXLEVEL=15 \
    -e NWN_GAMETYPE=10 \
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
    -e NWNX_SQL_USERNAME=nwn \
    -e NWNX_SQL_PASSWORD='C10udyP4$$w0rd' \
    -e NWNX_SQL_DATABASE=nwn \
    -e NWNX_SQL_QUERY_METRICS=true \
    -e NWNX_RUBY_PRELOAD_SCRIPT=/nwn/home/hak/ruby/extern.rb \
    -e NWNX_RUBY_EVALUATE_METRICS=true \
    -e NWNX_CORE_LOG_LEVEL=7 \
    nwnxee/nwserver:8166
