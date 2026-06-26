#!/bin/bash

# Функция для установки Node.js и Node-RED
install_nodered() {
    echo "Установка Node.js и Node-RED..."
    bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)
    sudo systemctl enable nodered.service
}

# Функция для установки плагинов Node-RED
install_plugins() {
    echo "Установка плагинов Node-RED..."
    npm install -g node-red-contrib-binance
    npm install -g node-red-contrib-cb-arp
    npm install -g node-red-contrib-ftp
    npm install -g node-red-contrib-hikvision-ultimate
    npm install -g node-red-contrib-homebridge-automation
    npm install -g node-red-contrib-homekit-bridged
    npm install -g node-red-contrib-mikrotik
    npm install -g node-red-contrib-play-audio
    npm install -g node-red-contrib-spruthub
    npm install -g node-red-contrib-telegrambot
    npm install -g node-red-contrib-timed-counter
    npm install -g node-red-contrib-toggle
    npm install -g node-red-contrib-unifi
    npm install -g node-red-contrib-wirenboard
    npm install -g node-red-contrib-wled2
    npm install -g node-red-contrib-yandex-station-management
    npm install -g node-red-contrib-zigbee2mqtt
    npm install -g node-red-dashboard
    npm install -g node-red-node-ping
    npm install -g node-red-node-random
    npm install -g thingzi-logic-timers
}

# Запрос выбора пользователя
echo "Выберите, что установить:"
echo "1) Установить Node-RED"
echo "2) Установить плагины Node-RED"
echo "3) Установить все"
echo "0) Выход"
read -p "Ваш выбор: " choice

# Установка в зависимости от выбора
case $choice in
    1)
        install_nodered
        ;;
    2)
        install_plugins
        ;;
    3)
        install_nodered
        install_plugins
        ;;
    0)
        echo "Выход..."
        exit 0
        ;;
    *)
        echo "Неверный выбор. Пожалуйста, выберите снова."
        ;;
esac

# Перезапуск Node-RED (если он запущен)
if pgrep -x "node-red" > /dev/null; then
    echo "Перезапуск Node-RED..."
    pkill node-red
    node-red &
else
    echo "Node-RED не запущен, запустите его вручную."
fi

echo "Установка завершена!"
