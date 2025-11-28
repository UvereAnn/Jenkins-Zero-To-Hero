# Stage 1: Build the application artifact
FROM maven:3.8.1-adoptopenjdk-11 AS build
WORKDIR /app

# FIX: Update the COPY paths to point to the correct subdirectory
# Copy the pom.xml file:
COPY java-maven-sonar-argocd-helm-k8s/spring-boot-app/pom.xml .

# Copy the source code (src directory):
COPY java-maven-sonar-argocd-helm-k8s/spring-boot-app/src ./src

# Build the JAR file
RUN mvn clean install -DskipTests
 
# Stage 2: Create the final, lightweight runtime image
FROM openjdk:11-jre-slim
WORKDIR /app
# Copy the built JAR from the build stage (assuming the artifact name is standard)
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
