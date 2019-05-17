FROM openjdk:8-jdk-stretch AS BUILD

ARG VERSION=3.72.1

WORKDIR /tmp

RUN wget https://github.com/azkaban/azkaban/archive/${VERSION}.tar.gz \
    && tar -zxf ${VERSION}.tar.gz \
    && cd azkaban-${VERSION} \
    && sed -i "s/^apply plugin: 'com.cinnober.gradle.semver-git'/\/\/ &/g" build.gradle

WORKDIR /tmp/azkaban-${VERSION}/azkaban-solo-server

RUN ../gradlew --version

RUN ../gradlew build installDist -x test

RUN mkdir -p /opt/azkaban/

RUN tar -zxf build/distributions/azkaban-solo-server.tar.gz -C /opt/azkaban/
#    && tar -zxf ./azkaban-db/build/distributions/azkaban-db.tar.gz -C ${AZKABAN_HOME} \
#    && tar -zxf ./azkaban-exec-server/build/distributions/azkaban-exec-server.tar.gz -C ${AZKABAN_HOME} \
#    && tar -zxf ./azkaban-web-server/build/distributions/azkaban-web-server.tar.gz -C ${AZKABAN_HOME} \


FROM openjdk:13-jdk-alpine3.9

RUN apk update && apk add bash

COPY --from=BUILD /opt/azkaban /opt/azkaban

ADD /startup.sh /

EXPOSE 8081 8443

CMD [ "/startup.sh" ]
