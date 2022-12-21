#! /bin/sh
# Operations on sqlite db on android device (the "local" database on device)
DB_PATH="/storage/emulated/0/Android/data/com.samuelsolon.bandy_client/files/"
DB_NAME="kaleidalog.db"

case "$1" in
    "pull")
        adb pull $DB_PATH/$DB_NAME .
        ;;

    "ls")
        adb shell ls $DB_PATH
        ;;

    "rm")
        adb shell rm $DB_PATH/$DB_NAME
        adb shell rm $DB_PATH/$DB_NAME-journal
        ;;

    *)
        echo "Usage $0 pull | ls | rm"
        ;;
esac
