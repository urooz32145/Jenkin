#!/bin/bash

install_mongo() {
    apt-get install -y gnupg curl
    curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
    apt update
    apt install -y mongodb-org
    mongod --version
    systemctl start mongod
    systemctl daemon-reload
    systemctl status mongod
    systemctl enable mongod
    systemctl restart mongod
}

remove_mongo() {
    service mongod stop
    apt purge -y "mongodb-org*"
    rm -rf /var/log/mongodb
    rm -rf /var/lib/mongodb
}

case $1 in
    intmg)
        install_mongo
        ;;
    rm)
        remove_mongo
        ;;
    *)
        echo "Usage: $0 {intmg|rm}"
        exit 1
        ;;
esac
