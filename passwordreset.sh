#!/usr/bin/expect -f

# Define the new password
set option "1"
set new_password "Admin@7808"
set timeout 20

# Start the password reset script
spawn /opt/coldfusion/cfusion/bin/passwordreset.sh

# Automate the inputs for password reset
expect "Enter 1 for changing Admin Password and 2 for changing Admin Component(jetty) password :"
send "$option\r"

expect "Enter new Admin Password :"
send "$new_password\r"

expect "Confirm new Password :"
send "$new_password\r"

expect "Enter new RDS Password :"
send "$new_password\r"

expect "Confirm new Password :"
send "$new_password\r"

# Finish
expect eof
