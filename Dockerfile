# Stage 1: Build
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app

# Copy gradle files first for caching
COPY gradle/ gradle/
COPY gradlew build.gradle settings.gradle ./

# Copy source code
COPY src/ src/

# Build the application (skipping tests for speed in build stage)
RUN ./gradlew bootJar -x test --no-daemon

# Stage 2: Run
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Create a non-root user for security
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copy JAR from builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Environment variables handled at runtime
ENTRYPOINT ["java", "-jar", "app.jar"]
