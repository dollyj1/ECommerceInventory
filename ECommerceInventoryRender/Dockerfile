# Use official Tomcat 9 base image
FROM tomcat:9.0.82-jdk17

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file into the webapps directory
COPY ECommerceInventory-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose port (important for Render)
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
