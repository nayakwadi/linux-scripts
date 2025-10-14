# create emtpy file
touch "somefilename.txt"

#create empty file with vi editor
vi "newfilename.txt"

#display content of file
cat "filename"

#display contents in revers
tac "filename"

#display first 10 lines
head -n 10 "filename"

#display last 10 lines
tail -n 10 "filename"

#open file with scrolling option
less "samplefile"
more "samplefile" #(only forward scrolling)

#create a file with simple text in it
echo "This is line 1 in a file" >> "samplefile"

#create new file or This appends a new line to the file
Echo "hello India" >> "samplefile"

#rewrite all conents of existing file. REWRITES ALL THE FILE CONTENT. BECARFUL WHILE USING
Echo "hello USA" > samplefile

#If file contains 2 lines as below, print Name and EmployeeId
echo "My Name is Sridhar
My EmployeeId is 441" >> employee3.txt

echo "Name of the employee is: $(grep Name employee.txt | awk -F" " '{print$4}' ; grep EmployeeId employee.txt | awk -F" " '{print$4}')"
# Name of the employee is: Sridhar
# 441


#date
date
#make directory
mkdir "FolderName"

#change directory
cd "/filepath"

#delete a directiry
rmdir "Foldername"

#copy filea to fileb
cp filea fileb

#rename file name
rm oldfilename newfilename


