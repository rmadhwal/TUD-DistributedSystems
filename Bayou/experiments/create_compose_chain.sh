#!/bin/sh

BASE_IP="172.22.0."
N_SLAVES=$(($1+0))
I=2
t="  "

rm ../docker-compose.yml
touch ../docker-compose.yml
echo "version: '2'" >> ../docker-compose.yml
echo "services:" >> ../docker-compose.yml
echo "${t}bayou-master:" >> ../docker-compose.yml
echo "${t}${t}container_name: master" >> ../docker-compose.yml
echo "${t}${t}image: master:0.1" >> ../docker-compose.yml
echo "${t}${t}restart: on-failure" >> ../docker-compose.yml
echo "${t}${t}ports:" >> ../docker-compose.yml
echo "${t}${t}${t}- 9999" >> ../docker-compose.yml
echo "${t}${t}command: \"[]\"" >> ../docker-compose.yml
echo "${t}${t}networks:" >> ../docker-compose.yml
echo "${t}${t}${t}bayou:" >> ../docker-compose.yml
echo -e "${t}${t}${t}${t}ipv4_address: $BASE_IP$I\n" >> ../docker-compose.yml

for ((i=1; i <= $N_SLAVES; ++i))
do
SUBIP=$(($i + $I))
ID=$(($i))
echo "${t}bayou-server$ID:" >> ../docker-compose.yml
echo "${t}${t}container_name: slave$ID" >> ../docker-compose.yml
echo "${t}${t}image: slave:0.1" >> ../docker-compose.yml
echo "${t}${t}restart: on-failure" >> ../docker-compose.yml
echo "${t}${t}ports:" >> ../docker-compose.yml
echo "${t}${t}${t}- 9999" >> ../docker-compose.yml
echo "${t}${t}command: \"[$BASE_IP$(($SUBIP-1))]\"" >> ../docker-compose.yml
echo "${t}${t}networks:" >> ../docker-compose.yml
echo "${t}${t}${t}bayou:" >> ../docker-compose.yml
echo -e "${t}${t}${t}${t}ipv4_address: $BASE_IP$SUBIP\n" >> ../docker-compose.yml
done

echo "${t}bayou-client1:" >> ../docker-compose.yml
echo "${t}${t}container_name: client1" >> ../docker-compose.yml
echo "${t}${t}image: client:0.1" >> ../docker-compose.yml
echo "${t}${t}restart: unless-stopped" >> ../docker-compose.yml
echo "${t}${t}ports:" >> ../docker-compose.yml
echo "${t}${t}${t}- 9999" >> ../docker-compose.yml
echo "${t}${t}command:" >> ../docker-compose.yml
echo "${t}${t}${t}- \"$BASE_IP$SUBIP\"" >> ../docker-compose.yml
echo "${t}${t}${t}- \"ham\"" >> ../docker-compose.yml
echo "${t}${t}${t}- \"kaas\"" >> ../docker-compose.yml
echo "${t}${t}${t}- \"melk\"" >> ../docker-compose.yml
echo "${t}${t}${t}- \"m\"" >> ../docker-compose.yml
echo "${t}${t}networks:" >> ../docker-compose.yml
echo "${t}${t}${t}bayou:" >> ../docker-compose.yml
echo -e "${t}${t}${t}${t}ipv4_address: $BASE_IP$(($SUBIP+1))\n" >> ../docker-compose.yml

# Write yml to create network
echo "networks:" >> ../docker-compose.yml
echo "${t}bayou:" >> ../docker-compose.yml
echo "${t}${t}driver: bridge" >> ../docker-compose.yml
echo "${t}${t}ipam:" >> ../docker-compose.yml
echo "${t}${t}${t}config:" >> ../docker-compose.yml
echo "${t}${t}${t}${t}- subnet: 172.22.0.0/24" >> ../docker-compose.yml
echo "${t}${t}${t}${t}  gateway: 172.22.0.254" >> ../docker-compose.yml
