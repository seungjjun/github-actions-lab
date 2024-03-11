FROM amazoncorretto:17 as builder
WORKDIR application
COPY build/libs/*.jar playground.jar
RUN java -Djarmode=layertools -jar playground.jar extract

FROM amazoncorretto:17
EXPOSE 5000
WORKDIR application
COPY --from=builder application/dependencies/ ./
COPY --from=builder application/spring-boot-loader/ ./
COPY --from=builder application/snapshot-dependencies/ ./
COPY --from=builder application/playground/ ./

ENTRYPOINT ["java","org.springframework.boot.loader.JarLauncher"]
