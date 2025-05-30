# Use official Tomcat with Java 17
FROM tomcat:9.0-jdk17

# Clean default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file to ROOT.war
COPY ./dist/MovieReview.war /usr/local/tomcat/webapps/ROOT.war

# Copy PostgreSQL JDBC driver
COPY ./lib/postgresql-42.6.0.jar /usr/local/tomcat/lib/

# Expose port
EXPOSE 8080
