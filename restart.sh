#!/bin/bash
sudo docker stop postgresql
sudo docker rm postgresql
./staticip.sh
