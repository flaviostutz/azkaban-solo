# FROM openjdk:8-jdk-stretch AS BUILD
FROM flaviostutz/gradle-warmed:3.2.1 AS BUILD

ARG VERSION=3.72.1

WORKDIR /tmp
RUN wget https://github.com/azkaban/azkaban/archive/${VERSION}.tar.gz
RUN tar -zxf ${VERSION}.tar.gz

WORKDIR /tmp/azkaban-${VERSION}/azkaban-solo-server
RUN gradle build installDist -x test -info
RUN mkdir -p /opt/azkaban/
RUN tar -zxf build/distributions/azkaban-solo-server-0.1.0-SNAPSHOT.tar.gz -C /opt/azkaban/
RUN mv /opt/azkaban/azkaban-solo-server-0.1.0-SNAPSHOT /opt/azkaban/azkaban-solo-server
#    && tar -zxf ./azkaban-db/build/distributions/azkaban-db.tar.gz -C ${AZKABAN_HOME} \
#    && tar -zxf ./azkaban-exec-server/build/distributions/azkaban-exec-server.tar.gz -C ${AZKABAN_HOME} \
#    && tar -zxf ./azkaban-web-server/build/distributions/azkaban-web-server.tar.gz -C ${AZKABAN_HOME} \

RUN ls /opt/azkaban/ -al

FROM openjdk:13-alpine3.9
RUN apk update && apk add bash
COPY --from=BUILD /opt/azkaban /opt/azkaban
ADD /startup.sh /
EXPOSE 8081 8443
CMD [ "/startup.sh" ]
