# Multi-stage build setup (https://docs.docker.com/develop/develop-images/multistage-build/)

# Stage 1 (to create a "build" image, ~140MB)
FROM openjdk:8-jdk-alpine3.7 AS builder
RUN java -version

COPY . /usr/src/rest-service/
WORKDIR /usr/src/rest-service/
RUN apk --no-cache add maven && mvn --version
RUN mvn clean -e package -Dmaven.test.skip=true

# Stage 2 (to create a downsized "container executable", ~87MB)
FROM openjdk:8-jre-alpine3.7
WORKDIR /root/
COPY --from=builder /usr/src/rest-service/target/rest-service-0.1.0.jar .

EXPOSE 8090
ENTRYPOINT ["java", "-jar", "./rest-service-0.1.0.jar"]
