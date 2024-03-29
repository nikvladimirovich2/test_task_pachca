#!/bin/bash

docker build -t ruby_pachca:1.0 ./
docker-compose up -d && sleep 20
file=$(docker exec -i maria-master mysql -u root -e 'SHOW MASTER STATUS;' | grep master | awk '{ print $1 }')
pos=$(docker exec -i maria-master mysql -u root -e 'SHOW MASTER STATUS;' | grep master | awk '{ print $2 }')
host=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' maria-master)
docker exec -i maria-slave mysql -u root -e "CHANGE MASTER TO MASTER_HOST='$host', MASTER_USER='root', MASTER_LOG_FILE='$file', MASTER_LOG_POS=$pos;"
docker exec -i maria-slave mysql -u root -e "START SLAVE;"
docker exec -i maria-master mysql -u root app < ./structure.sql
sleep 5 && curl http://localhost:8090 && docker ps
echo -e "\nКонтейнеры запущены. Можно проверить в браузере, что сайт доступен и нажать enter" && read approve
docker stop maria-slave && docker ps && curl http://localhost:8090
echo -e "\nОстановлен 1 контейнер БД. Можно проверить в браузере, что сайт доступен и нажать enter" && read approve
docker start maria-slave && docker stop maria-master && docker ps
sleep 5 && curl http://localhost:8090
echo -e "\nОстановлен другой контейнер БД. Можно проверить в браузере, что сайт доступен и нажать enter" && read approve
docker ps
