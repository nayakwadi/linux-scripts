#list of processes currently running in brief mode
ps 

#list of processes in full mode
ps -ef

#list a process matching with pattern
ps -ef | grep "zsh"

#prints processId with name containing zsh
ps -ef |grep "zsh" | awk -F " " '{print$2}'

#Print all postgress related PID and other details 
ps -ef | grep "postgres" | awk -F" " '{print$2, $8, $9, $10}'