#!/bin/bash

#set -x
LOG_FILES_DIRECTORY="/"
REPORT_FILE="log_analysis_report.txt"
CRITICAL_LOGS_FOLDER="Critical_Logs"

echo -e "Analysing bug files" > "$REPORT_FILE"
echo -e "============================================" >> "$REPORT_FILE"

# LOG_FILES_COMMAND=$(find $LOG_FILES_DIRECTORY -name "*.log" -mtime -1)
LOG_FILES_COMMAND=$(find $LOG_FILES_DIRECTORY -name "*.log")

LIST_OF_FILES=$(echo "$LOG_FILES_COMMAND" | tr ' ' '\n')

for FILE_NAME in $LIST_OF_FILES; do
    echo -e "${FILE_NAME/$LOG_FILES_DIRECTORY/}"  >> "$REPORT_FILE"
done

echo -e "============================================" >> "$REPORT_FILE"
ERROR_TYPES=("ERROR" "FATAL" "CRITICAL" "SYSTEM")

for LOG_FILE in $LIST_OF_FILES; do
    FILE_NAME=$(echo  "${LOG_FILE/$LOG_FILES_DIRECTORY/}")
    echo -e "============= START OF INNER LOOP FOR FILE $FILE_NAME ==========="  >> "$REPORT_FILE"
    echo -e "\n"  >> "$REPORT_FILE"
    for ERROR_TYPE in ${ERROR_TYPES[@]}; do

        echo -e "\nsearching $ERROR_TYPE count in $FILE_NAME"  >> "$REPORT_FILE"
        ERROR_COUNT=$(grep -c "$ERROR_TYPE" $LOG_FILE)
        echo "Error Count is: $ERROR_COUNT" >> "$REPORT_FILE"

        if [ "$ERROR_COUNT" -gt 10 ]; then
            echo -e "\n ‼️ ⚠️   ACTION REQUIRED  ⚠️ ‼️  \n too many $ERROR_TYPE errors in file $LOG_FILE"
            echo -e "\n ‼️ ⚠️   SAVING LOG FILES TO CRITICAL FOLDER  ⚠️ ‼️  \n"
            cp $LOG_FILE $CRITICAL_LOGS_FOLDER
        fi

        echo -e "\nprinting $ERROR_TYPE lines in $FILE_NAME "  >> "$REPORT_FILE"
        grep "$ERROR_TYPE" $LOG_FILE  >> "$REPORT_FILE"


    done
    echo -e "============= END OF INNER LOOP FOR FILE $FILE_NAME ==========="  >> "$REPORT_FILE"
    echo -e "\n"  >> "$REPORT_FILE"
    echo -e "======================================================================="  >> "$REPORT_FILE"
done
echo -e "============= END OF COMMANDS IN ALL THE FILES ==========="
echo -e "LOG ANALYSIS COMPLETED.REPORT SAVED IN $REPORT_FILE"

