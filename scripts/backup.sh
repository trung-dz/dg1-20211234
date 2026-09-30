#!/bin/bash

# Kiểm tra tham số truyền vào: nếu rỗng (-z) hoặc không phải thư mục (! -d) thì thoát với mã lỗi 1
if [ -z "$1" ] || [ ! -d "$1" ]; then
    echo "Lỗi: Tham số truyền vào không phải là một thư mục hợp lệ!"
    exit 1
fi

# Khai báo các biến
TARGET_DIR=$(realpath "$1")
DIR_NAME=$(basename "$TARGET_DIR")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$HOME/backup"
LOG_FILE="$HOME/dg1_20211234/logs/backup.log"

# Tạo thư mục sao lưu nếu chưa có
mkdir -p "$BACKUP_DIR"
ARCHIVE_PATH="${BACKUP_DIR}/${DIR_NAME}_${TIMESTAMP}.tar.gz"

# Thực hiện nén thư mục
tar -czf "$ARCHIVE_PATH" -C "$(dirname "$TARGET_DIR")" "$DIR_NAME" 2>/dev/null

# Kiểm tra trạng thái lệnh tar vừa chạy ($? = 0 là thành công)
if [ $? -eq 0 ]; then
    echo "$(date +'%Y-%m-%d %H:%M:%S') - Backup thanh cong: $ARCHIVE_PATH" >> "$LOG_FILE"
    echo "Sao lưu thành công tệp: $ARCHIVE_PATH"
    exit 0
else
    echo "$(date +'%Y-%m-%d %H:%M:%S') - Backup that bai: $TARGET_DIR" >> "$LOG_FILE"
    echo "Lỗi khi sao lưu!"
    exit 2
fi
