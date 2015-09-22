# in case of conflict with local nginx:
# make sure in all *.confs (
#   also in default and example to avoid error like 
#     'nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)'
# )
# set for instance "listen 127.0.0.1:80" instead of "listen *:80"

# docker & network settings
DOCKER_IMAGE_NAME="abner/postgresql"                 # build of nginx-php - for example
DOCKER_CONTAINERS_NAME="postgresql"                     # our container's name

# start conteiner if "docker some_image run" earlier
found_container=$(docker ps -a | grep "$DOCKER_CONTAINERS_NAME")
if [ ! -z "$found_container" ]; then
   sudo docker start "$DOCKER_CONTAINERS_NAME"
else
  # bind docker container to created network interface
   sudo docker run --name="$DOCKER_CONTAINERS_NAME" -d -v /opt/postgresql/data:/var/lib/postgresql -e 'DB_USER=root' -e 'DB_PASS=r3dfr0g'  -e 'DB_NAME=mydb' -e 'PSQL_TRUST_LOCALNET=true' -p 127.0.0.1:55432:5432 -t $DOCKER_IMAGE_NAME
fi

# also you can manually remove created virtual network interface
# ifconfig $DOCKER_NETWORK_INTERFACE_NAME down
