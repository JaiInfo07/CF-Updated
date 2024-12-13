#!/bin/bash

# Reset the admin password using an `expect` script if not already done
if [ ! -f /opt/coldfusion/cfusion/password_initialized ]; then
    echo "Resetting ColdFusion admin password..."
    /opt/coldfusion/cfusion/bin/passwordreset.sh << EOF
Admin@123
Admin@123
EOF
    # Create a flag file to ensure this script doesn't re-run
    touch /opt/coldfusion/cfusion/password_initialized
    echo "Admin password reset completed."
fi

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
curl -X POST http://localhost:8500/WEB-INF/datasource.cfm || {
    echo "Datasource setup failed!"
    exit 1
}

# Keep the container alive and log ColdFusion output
tail -f /opt/coldfusion/cfusion/logs/coldfusion-out.log /opt/coldfusion/cfusion/logs/server.log
