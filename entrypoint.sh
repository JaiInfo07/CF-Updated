#!/bin/bash

# Start ColdFusion in the background
/opt/coldfusion/cfusion/bin/coldfusion start

# Wait for ColdFusion server to initialize
echo "Waiting for ColdFusion server to start..."
TIMEOUT=300
while ! curl -s http://localhost:8500/CFIDE/administrator/index.cfm > /dev/null; do
    TIMEOUT=$((TIMEOUT - 5))
    if [ $TIMEOUT -le 0 ]; then
        echo "ColdFusion did not start within the expected time."
        exit 1
    fi
    echo "Still waiting for ColdFusion..."
    sleep 5
done
echo "ColdFusion server is running."

# Execute the datasource setup script
echo "Setting up datasource..."
curl -X POST http://localhost:8500/datasource.cfm || {
    echo "Datasource setup failed!"
    exit 1
}

# Keep the container alive
tail -f /opt/coldfusion/cfusion/logs/coldfusion-out.log /opt/coldfusion/cfusion/logs/server.log
