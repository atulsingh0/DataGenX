#!/bin/sh

USERID="$1"
PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 10)

# Run this script from root user

# Setup Local group
echo "Adding group ${USERID}"
groupadd ${USERID}   # linux will auto assign the next available group id
echo ""

# Setup local user
echo "Adding user ${USERID}"
useradd ${USERID} -m -d /home/${USERID} -g ${USERID} -s /bin/bash
echo "Setting up password" 
echo ${PASSWORD} | passwd --stdin ${USERID} -x 90 -n 0 -w 7 -i 0 # Min 0, Max 90, Warn 7 days
# Forcing to change password in next run
chage -d 0 ${USERID}                    # forcing user to change the password in next login
echo ""

echo "User $1 has been setup with Password ${PASSWORD}"
echo "User must change the password at first time."
echo ""
id ${USERID}
chage -l ${USERID}
echo ""
