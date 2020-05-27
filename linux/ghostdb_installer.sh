#!/bin/bash

wget https://ghostdb.github.io/linux/latest/ghostdb
wget https://ghostdb.github.io/linux/ghostdb.service
wget https://ghostdb.github.io/linux/ghostdbConf.json

if [ grep -q "ghostdbservice" /etc/passwd ]; then 
    echo "ghostdbservice user already exists!";
else 
    useradd ghostdbservice -s /sbin/nologin -M && echo "ghostdbservice user created"; 
fi

if [ grep -q "ghostdbservice" /etc/group ]; then
    echo "ghostdbservice group already exists!";
else 
    groupadd ghostdbservice && echo "Ghostdb group created!";
fi

if [ -d "/etc/ghostdb" ]; then
    echo "ghostdb config directory exists!"
else
    mkdir /etc/ghostdb && echo "ghostdb config directory created";
    chown -R ghostdbservice:ghostdbservice /etc/ghostdb
fi

cp ghostdb /bin/
cp ghostdb.service /lib/systemd/system
cp ghostdbConf.json /etc/ghostdb
chmod 755 /bin/ghostdb
chmod 755 /lib/systemd/system/ghostdb.service
chmod 755 /etc/ghostdb/ghostdbConf.json
chown -R ghostdbservice:ghostdbservice /home/ghostdbservice
systemctl daemon-reload
echo "Successfully reloaded daemons..."
systemctl start ghostdb
echo "Successfully started ghostdb service..."
systemctl enable ghostdb
echo "Successfully enabled ghostdb service..."
echo "GhostDB successfully installed!"
