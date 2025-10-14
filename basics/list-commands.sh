#Files & Folder commands

#list files in current folder
ls 

#list files including hidden files
ls -a 

#list files with details related to read,write,execute
ls -ltr 

#list folders and files recursively (Folders and files inside each folder)
ls -R

#list all files inside all folders with complete path
find .

#list only files (excluding Folders)
find . -type f

#list files with owners and size
ls -lR

#search a specific file type ending with .tf
find . -type f -name "*.tf"

#size on the disk commands
#show file sizes recursively
du -ah

#sort files by size(largest last)
find . -type f -exec du -h {} + | sort -h

#show top 10 largest files
du -ah . | sort -rh | head -n 10

#list top 20 files ending with format "\.terraform|\.tfstate|\.log"
du -ah . |grep -E "\.terraform|\.tfstate|\.log" | sort -rh |head -n 20