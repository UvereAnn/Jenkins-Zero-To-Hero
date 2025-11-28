# Stage 1: Build the application artifact
FROM maven:3.8.1-adoptopenjdk-11 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
# This command compiles the code and creates the JAR file
RUN mvn clean install -DskipTests

# Stage 2: Create the final, lightweight runtime image
FROM openjdk:11-jre-slim
WORKDIR /app
# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
