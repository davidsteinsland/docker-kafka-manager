FROM openjdk:8u181-jdk AS builder
#FROM adoptopenjdk/openjdk12:slim AS builder

ARG KAFKA_MANAGER_VERSION="2.0.0.2"

RUN apt-get update && apt-get install --yes curl
RUN curl -L  https://github.com/yahoo/kafka-manager/archive/${KAFKA_MANAGER_VERSION}.tar.gz | tar -C /tmp -xzf - \
	&& cd /tmp/kafka-manager-${KAFKA_MANAGER_VERSION} \
	&& ./sbt clean dist \
	&& unzip -d / ./target/universal/kafka-manager-${KAFKA_MANAGER_VERSION}.zip \
	&& mv /kafka-manager-${KAFKA_MANAGER_VERSION} /kafka-manager

FROM adoptopenjdk/openjdk12:slim AS main

COPY --from=builder /kafka-manager /kafka-manager

ENV ZK_HOSTS="localhost:2181"

WORKDIR /kafka-manager

EXPOSE 9000

ENTRYPOINT ["./bin/kafka-manager"]
