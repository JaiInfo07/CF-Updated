# Base Image
FROM adobecoldfusion/coldfusion2021:latest

# Accept EULA and set environment variables
ENV acceptEULA=YES \
    adminPassword="Admin@123" \
    enableSecureProfile=NO

# Set working directory
WORKDIR /opt/coldfusion/cfusion/wwwroot

# Update apt and install utilities
RUN apt-get update && apt-get install -y expect unzip vim curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the build.zip file into the container
COPY build.zip /tmp/build.zip

# Extract the zip file and clean up
RUN unzip /tmp/build.zip -d /tmp/build && \
    cp -r /tmp/build/. /opt/coldfusion/cfusion/wwwroot && \
    rm -rf /tmp/build /tmp/build.zip

# Copy configuration files
COPY server.xml /opt/coldfusion/cfusion/runtime/conf/server.xml
# COPY neo-security.xml /opt/coldfusion/cfusion/lib/neo-security.xml

# Copy and configure the password reset script
COPY passwordreset.sh /opt/coldfusion/cfusion/bin/passwordreset.sh
RUN chmod +x /opt/coldfusion/cfusion/bin/passwordreset.sh

# Install necessary ColdFusion packages
RUN /opt/coldfusion/cfusion/bin/cfpm.sh install sqlserver
RUN /opt/coldfusion/cfusion/bin/cfpm.sh install debugger
RUN /opt/coldfusion/cfusion/bin/cfpm.sh install image
RUN /opt/coldfusion/cfusion/bin/cfpm.sh install mail

# Expose ColdFusion server port
EXPOSE 8500

# Copy and set entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# ENTRYPOINT Section
ENTRYPOINT ["/entrypoint.sh"]
