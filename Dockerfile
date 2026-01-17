# Build stage
FROM gradle:8.5-jdk21 AS build
WORKDIR /app

# Copy gradle files first for better caching
COPY build.gradle settings.gradle ./
COPY gradle gradle

# Download dependencies (this layer will be cached)
RUN gradle dependencies --no-daemon || true

# Copy source code
COPY src src

# Build the application
RUN gradle build -x test --no-daemon

# Run stage
FROM openjdk:21-jdk-slim
WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Expose port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

