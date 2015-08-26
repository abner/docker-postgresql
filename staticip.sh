# in case of conflict with local nginx:
# make sure in all *.confs (
#   also in default and example to avoid error like 
#     'nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)'
# )
# set for instance "listen 127.0.0.1:80" instead of "listen *:80"

# docker & network settings
DOCKER_IMAGE_NAME="abner/postgresql"                 # build of nginx-php - for example
DOCKER_CONTAINERS_NAME="postgresql"                     # our container's name
DOCKER_NETWORK_INTERFACE_NAME="eth0:1"                  # default we have eth0 (or p2p1), so interface will eth0:1 or p2p1:1
DOCKER_NETWORK_INTERFACE_IP="192.165.0.1"                  # network interface address
DOCKER_NETWORK_INTERFACE_PORT_MAP="5432:5432"
# try to find created this network interface
found_iface=$(ifconfig | grep "$DOCKER_NETWORK_INTERFACE_NAME")
if [ -z "$found_iface" ]; then
  # create & start some another network interface for docker container
  sudo ifconfig $DOCKER_NETWORK_INTERFACE_NAME $DOCKER_NETWORK_INTERFACE_IP netmask 255.255.255.0 up
else
  echo "$DOCKER_NETWORK_INTERFACE_NAME with ip $DOCKER_NETWORK_INTERFACE_IP alredy exists";
fi

# start conteiner if "docker some_image run" earlier
found_container=$(docker ps -a | grep "$DOCKER_CONTAINERS_NAME")
if [ ! -z "$found_container" ]; then
   sudo docker start "$DOCKER_CONTAINERS_NAME"
else
  # bind docker container to created network interface
   sudo docker run --name="$DOCKER_CONTAINERS_NAME" -d -v /opt/postgresql/data:/var/lib/postgresql -e 'DB_USER=root' -e 'DB_PASS=r3dfr0g'  -e 'DB_NAME=mydb' -e 'PSQL_TRUST_LOCALNET=true' -p $DOCKER_NETWORK_INTERFACE_IP:$DOCKER_NETWORK_INTERFACE_PORT_MAP/tcp $DOCKER_IMAGE_NAME
fi

# also you can manually remove created virtual network interface
# ifconfig $DOCKER_NETWORK_INTERFACE_NAME down
