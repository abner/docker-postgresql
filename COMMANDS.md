#!/bin/bash
# https://github.com/abner/docker-postgresql#quick-start

# algumas vezes durante o stop pode ser que o container não seja removido
sudo docker rm  postgresql

# inicializando o container postgresql
sudo docker run --name postgresql -d -v /opt/postgresql/data:/var/lib/postgresql -e 'DB_USER=root' -e 'DB_PASS=r3dfr0g'  -e 'DB_NAME=mydb' -e 'PSQL_TRUST_LOCALNET=true' abner/postgresql:latest 



#!/bin/bash

sudo docker exec -it postgresql sudo -u postgres psql
sudo docker stop postgresql
sudo docker restart postgresql
