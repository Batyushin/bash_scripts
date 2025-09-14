#!/bin/bash

# Обновление списка пакетов и установка необходимых компонентов
echo "Обновление списка пакетов и установка необходимых компонентов..."
apt update && apt install -y nodejs git make g++ gcc build-essential

# Установка Node-RED
echo "Установка Node-RED..."
npm install -g --unsafe-perm node-red@3.1.11

# Установка палитр для Node-RED
echo "Установка палитры node-red-contrib-telegrambot..."
sudo npm install -g --unsafe-perm node-red-contrib-telegrambot

echo "Установка палитры node-red-contrib-spruthub..."
sudo npm install -g --unsafe-perm node-red-contrib-spruthub

echo "Установка палитры node-red-contrib-wirenboard..."
sudo npm install -g --unsafe-perm node-red-contrib-wirenboard

echo "Установка палитры thingzi-logic-timers..."
sudo npm install -g --unsafe-perm thingzi-logic-timers

# Создание и редактирование systemd сервиса для Node-RED
echo "Создание файла сервиса Node-RED..."
sudo tee /etc/systemd/system/nodered.service > /dev/null <<EOL
[Unit]
Description=Node-RED graphical event wiring tool
Wants=network.target

[Service]
Type=simple
User=root
Group=root
WorkingDirectory=/home

Nice=5
Environment="NODE_OPTIONS=--max_old_space_size=256"
ExecStart=/usr/bin/env node-red \$NODE_OPTIONS \$NODE_RED_OPTIONS
KillSignal=SIGINT
Restart=on-failure
SyslogIdentifier=Node-RED

[Install]
WantedBy=multi-user.target
EOL

# Включение и запуск сервиса Node-RED
echo "Включение и запуск сервиса Node-RED..."
sudo systemctl enable nodered && sudo systemctl start nodered

echo "Установка и настройка Node-RED завершена."
