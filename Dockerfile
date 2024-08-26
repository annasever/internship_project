FROM gradle:7.2-jdk11 AS build

WORKDIR /app

COPY . .

RUN chmod +x scripts/pgsql_restore.sh

RUN gradle build -x test


FROM postgres:13-alpine AS db-setup

WORKDIR /db

COPY --from=build /app/backup/2024-08-19.dump /db/2024-08-19.dump
COPY --from=build /app/scripts/pgsql_restore.sh /db/pgsql_restore.sh

RUN chmod +x /db/pgsql_restore.sh && /db/pgsql_restore.sh 2024-08-19.dump


FROM gradle:7.2-jdk11 AS test

WORKDIR /app

COPY . .

COPY --from=db-setup /db/2024-08-19.dump /app/backup/2024-08-19.dump
COPY --from=db-setup /db/pgsql_restore.sh /app/scripts/pgsql_restore.sh

RUN chmod +x scripts/pgsql_restore.sh

RUN ./scripts/pgsql_restore.sh 2024-08-19.dump && gradle test

RUN gradle build


FROM tomcat:9.0.50-jdk11

RUN apt-get update && apt-get install -y postgresql-client

COPY --from=build /app/build/libs/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
