FROM openjdk:8

ARG AZKABAN_HOME=/root/azkaban
ARG VERSION=3.72.1

# RUN mkdir /root/.gradle
# COPY script/init.gradle /root/.gradle/init.gradle
# COPY script/sources.list /etc/apt/sources.list
# COPY 3.70.1.tar.gz /3.70.1.tar.gz
# COPY 3.57.0.tar.gz /3.57.0.tar.gz

RUN apt-get update -yqq \
    && apt-get upgrade -yqq \
    && apt-get install -yqq --no-install-recommends openjfx \
    && mkdir ${AZKABAN_HOME} \
    && wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie;" http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip \
    && unzip jce_policy-8.zip \
    && cp -rf UnlimitedJCEPolicyJDK8/* /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/
    
RUN wget https://github.com/azkaban/azkaban/archive/${VERSION}.tar.gz \
    && tar -zxf ${VERSION}.tar.gz \
    && cd azkaban-${VERSION} \
    && sed -i "s/^apply plugin: 'com.cinnober.gradle.semver-git'/\/\/ &/g" build.gradle  \
    && ./gradlew build installDist -x test\
    && tar -zxf ./azkaban-solo-server/build/distributions/azkaban-solo-server.tar.gz -C ${AZKABAN_HOME} \
#    && tar -zxf ./azkaban-db/build/distributions/azkaban-db.tar.gz -C ${AZKABAN_HOME} \
#    && tar -zxf ./azkaban-exec-server/build/distributions/azkaban-exec-server.tar.gz -C ${AZKABAN_HOME} \
#    && tar -zxf ./azkaban-web-server/build/distributions/azkaban-web-server.tar.gz -C ${AZKABAN_HOME} \

RUN apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf azkaban-${VERSION} \
        jce_policy-8.zip \
        UnlimitedJCEPolicyJDK8 \
        3.70.1.tar.gz \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

COPY script/entrypoint.sh /entrypoint.sh

WORKDIR ${AZKABAN_HOME}

EXPOSE 8081 8443

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["solo"]
