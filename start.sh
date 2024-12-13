#!/bin/bash

# Define the path for neo-security.xml
NEO_SECURITY_PATH="/opt/coldfusion/cfusion/lib/neo-security.xml"

# Dynamically generate neo-security.xml based on the template
echo "Generating neo-security.xml..."
envsubst < /opt/coldfusion/cfusion/lib/neo-security.xml.template > "${NEO_SECURITY_PATH}"
if [ $? -ne 0 ]; then
    echo "Failed to generate neo-security.xml"
    exit 1
fi

# Set appropriate permissions
chmod 644 "${NEO_SECURITY_PATH}"

# Start ColdFusion in the background
echo "Starting ColdFusion server..."
/opt/coldfusion/cfusion/bin/coldfusion start

# Wait for ColdFusion to fully start
echo "Waiting for ColdFusion to initialize..."
sleep 60

# Set up the datasource
echo "Setting up datasource..."
curl -X POST http://localhost:8500/WEB-INF/datasource.cfm
if [ $? -ne 0 ]; then
    echo "Datasource setup failed!"
    exit 1
fi

# Tail logs to keep the container running
tail -f /opt/coldfusion/cfusion/logs/coldfusion-out.log
