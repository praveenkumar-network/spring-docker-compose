From openjdk:8
copy ./target/spring-docker-compose-0.0.1-SNAPSHOT.jar spring-docker-compose-0.0.1-SNAPSHOT.jar
CMD ["java","-jar","spring-docker-compose-0.0.1-SNAPSHOT.jar"]