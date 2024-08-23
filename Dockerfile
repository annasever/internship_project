FROM gradle:7.2.0-jdk11 as build

WORKDIR /app

COPY . .

RUN chmod +x scripts/pgsql_restore.sh

RUN gradle build -x test  

FROM postgres:13-alpine as db-setup

WORKDIR /db

COPY --from=build /app/backup/2024-08-19.dump /db/2024-08-19.dump
COPY --from=build /app/scripts/pgsql_restore.sh /db/pgsql_restore.sh

RUN chmod +x /db/pgsql_restore.sh && /db/pgsql_restore.sh 2024-08-19.dump

FROM tomcat:9.0.50-jdk11

COPY --from=build /app/build/libs/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]

