#!/bin/bash

echo "Обновление списка пакетов и установка базовых компонентов..."
apt update && apt install -y curl git make g++ gcc build-essential

# Установка актуальной версии Node.js (20.x LTS) через репозиторий NodeSource
echo "Настройка репозитория Node.js 20.x..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# Установка самого Node-RED глобально
echo "Установка актуальной версии Node-RED..."
npm install -g --unsafe-perm node-red

# Подготовка рабочей директории Node-RED
NODE_RED_DIR="/root/.node-red"
echo "Создание рабочей директории $NODE_RED_DIR..."
mkdir -p "$NODE_RED_DIR"
cd "$NODE_RED_DIR" || exit

# Инициализация package.json, если его нет (нужно для корректной установки локальных палитр)
if [ ! -f package.json ]; then
    npm init -y > /dev/null
fi

# Локальная установка палитр в рабочую директорию
echo "Установка палитр..."
npm install node-red-contrib-telegrambot
npm install node-red-contrib-spruthub
npm install node-red-contrib-wirenboard
npm install thingzi-logic-timers

# Создание и настройка systemd сервиса
echo "Создание файла сервиса Node-RED..."
tee /etc/systemd/system/nodered.service > /dev/null <<EOL
[Unit]
Description=Node-RED
After=network.target

[Service]
Type=simple
User=root
Group=root
WorkingDirectory=/root/.node-red
Environment="NODE_OPTIONS=--max_old_space_size=256"
ExecStart=/usr/bin/env node-red \$NODE_OPTIONS
KillSignal=SIGINT
Restart=on-failure
SyslogIdentifier=Node-RED

[Install]
WantedBy=multi-user.target
EOL

# Перезагрузка демона, включение и запуск сервиса
echo "Включение и запуск сервиса Node-RED..."
systemctl daemon-reload
systemctl enable nodered
systemctl restart nodered

echo "Установка и настройка завершена. Node-RED запущен!"
