FROM tomcat:9.0-jdk8

# Remove default ROOT
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your full JSP project into ROOT
COPY ./ /usr/local/tomcat/webapps/ROOT/

# Expose port 8080 for Railway
EXPOSE 8080

CMD ["catalina.sh", "run"]
