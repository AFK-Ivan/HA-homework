#!/bin/bash

# Проверка доступности порта (например, 80)
nc -z -w5 158.160.52.77 80
if [[ $? -ne 0 ]]; then
    echo "Port is not available."
    exit 1
fi

# Проверка существования файла index.html
curl -s -o /dev/null -w "%{http_code}" http://158.160.52.77/index.html | grep -q "200"
if [[ $? -ne 0 ]]; then
    echo "index.html is not available."
    exit 2
fi

exit 0