#!/bin/bash

# install Ixd if necessary

if ! type "lxd" > /dev/null; then

  apt install lxd

fi

# Run Ixd init -auto if no Ixdbro exists

if [ ! -f /var/lib/lxd/lxd.db ]; then

  lxd init -auto

fi

# Launch a container running Ubuntu server named COMP2101-522 if necessary

if [ ! "$(lxc list | grep COMP2101-522)" ]; then

  lxc launch ubuntu: COMP2101-522

fi

# Associate the name COMP2101-522 with the container's IP address in /etc/hosts if necessary

if ! grep -q "COMP2101-522" /etc/hosts; then

  lxc exec COMP2101-522 -- /bin/bash -c "echo $(lxc list COMP2101-522 | grep eth0 | awk '{print $4}') COMP2101-522 >> /etc/hosts"

fi

# Install Apache2 in the container if necessary

if ! lxc exec COMP2101-522 -- /usr/bin/dpkg -s apache2 >/dev/null 2>&1; then

  lxc exec COMP2101-522 -- /usr/bin/apt update

  lxc exec COMP2101-522 -- /usr/bin/apt install -y apache2

fi

# Retrieve the default web page from the web service with curl and notify the user of success or failure

curl -s http://COMP2101-522 | grep -q "It works!"

if [ $? -eq 0 ]; then

  echo "It worked!"

else

  echo "It failed :("

fi
