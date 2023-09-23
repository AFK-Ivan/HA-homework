#!/bin/bash

SRC_DIR="/home/user"
BKP_DIR="/tmp/backup"

rsync -avh --checksum --exclude '.*' "$SRC_DIR" "$BKP_DIR"

if [ $? -eq 0 ]; then
    logger "Backup of $SRC_DIR to $BKP_DIR has been completed with code 0"
else
    logger "There are an error during the backup of $SRC_DIR to $BKP_DIR"
fi