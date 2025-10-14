#!/bin/bash
# Purpose: accept URL and filename as input values, download file and convert it into raw file
#          save content of raw file to local file
# Pre-req: Ensure to install wget from apt package (sudo apt update  and sudo apt install wget -y)
# Usage: ./download_github_file.sh <GitHub URL> <local_filename>

#check if input arguments passed are less than 2 ($# is default counter which keeps cound of positional arguments)
if [ $# -lt 2 ]; then
  echo "Usage: $0 <GitHub URL> <local_filename>"
  exit 1
fi

GITHUB_URL="$1"
LOCAL_FILE="$2"

# Convert GitHub blob URL → raw.githubusercontent URL
# sed streameditor is used twice in this command
# first sed would replace "github.com" from echo output wiith raw.githubusercontent.com
# second sed would replace "/blob" with nothing, so the final RAW_URL value would be https://raw.githubusercontent.com/user/repo/main/file.txt
RAW_URL=$(echo "$GITHUB_URL" | sed 's#github.com#raw.githubusercontent.com#' | sed 's#blob/##')

echo "Downloading from: $RAW_URL"
echo "Saving to: $LOCAL_FILE"

# Download the raw file
# wget :use this to download file
# -q : use this to suppress the status of download process
# -o : this is the argument to be passed for output filename
wget -q -O "$LOCAL_FILE" "$RAW_URL"


#below is the standard exit pattern for nash scripts
# $? contains 0 or some number for previous line command
# 0 indicates success, any non-zero value considered as error
if [ $? -eq 0 ]; then
  echo "✅ File downloaded successfully!"
else
  echo "❌ Failed to download file."
fi


# read ERROR lines from downloaded local file
cat $LOCAL_FILE | grep ERROR