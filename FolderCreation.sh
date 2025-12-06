# !/bin/bash
# Folder Utility Creation Structured.

# base directory creation.

base_dir="$HOME/EmployeeData"
folderCount=0
echo "FOLDER CREATION SCRIPT INITIATED"
echo "--------------------------------"
if [ -d "$base_dir" ]; then

	printf "\n--The folder directory: $base_dir already exists.--"
else
	sudo mkdir "$base_dir"
	printf "\n--Base directory: $base_dir has been created!--"
	((folderCount+=1))
fi
# Create admin folders per department.

if [ $? -eq 0 ]; then
	sudo mkdir "$base_dir/HR"
	if [ $? -eq 0 ]; then
		((folderCount+=1))
		echo "HR Folder Created..."
	else
		echo "ERROR HR not created/already exists"
	fi
	sudo mkdir "$base_dir/IT"
	if [ $? -eq 0 ]; then
		((folderCount+=1))
		echo "IT Folder created..."
	else
		echo "ERROR: IT no created/already exists"
	fi
	sudo mkdir "$base_dir/Finance"
	if [ $? -eq 0 ]; then
		((folderCount+=1))
		echo "Finance Folder Created..."
	else
		echo "ERROR: Finance not created/already exists"
	fi
	sudo mkdir "$base_dir/Executive"
	if [$? -eq 0 ]; then
		((folderCount+=1))
		echo "Executive Folder Created..."
	else
		echo "ERROR: Executive not created/already exists"
	fi
	sudo mkdir "$base_dir/Administrative"
	if [ $? -eq 0 ]; then
		((folderCount+=1))
		echo "Administrative Folder Created..."
	else 
		echo "ERROR: Administrative not created/already exists"
	fi
	sudo mkdir "$base_dir/Call Centre"
	if [ $? -eq 0 ]; then
		((folderCount+=1))
		echo "Call Centre Folder Created..."
	else
		echo "ERROR: Call Centre not created/already exists"
	fi
else
	echo "Errors: Can't create home directory or sub directories."
fi
# Set Owner full permission.
if [ $? -eq 0 ]; then
	sudo chmod u+rwx "$base_dir/HR"
	sudo chmod u+rwx "$base_dir/IT"
	sudo chmod u+rwx "$base_dir/Finance"
	sudo chmod u+rwx "$base_dir/Executive"
	sudo chmod u+rwx "$base_dir/Administrative"
	sudo chmod u+rwx "$base_dir/Call Centre"
	echo "----------------------------"
	echo "Owner permissions set..."
else
	echo "ERROR: Issues setting permissions."
fi
# Set Group permissions.
if [ $? -eq 0 ]; then
	sudo chmod g+rw "$base_dir/HR"
	sudo chmod g+rw "$base_dir/IT"
	sudo chmod g+rw "$base_dir/Finance"
	sudo chmod g+rw "$base_dir/Executive"
	sudo chmod g+rw "$base_dir/Administrative"
	sudo chmod g+rw "$base_dir/Call Centre"
	echo "----------------------------"
	echo "Group permissions set..."
else
	echo "ERROR: Issues setting permissions."
fi
# Set other permissions.
if [ $? -eq 0 ]; then
	sudo chmod o+ "$base_dir/HR"
	sudo chmod o+r "$base_dir/IT"
	sudo chmod o+r "$base_dir/Finance"
	sudo chmod o+ "$base_dir/Executive"
	sudo chmod o+r "$base_dir/Administrative"
	sudo chmod o+r "$base_dir/Call Centre"
	echo "-----------------------------"
	echo "Others permission set..."
else
	echo "ERROR: Issues setting permissions."
fi
# Set Group ownership to folder path.
if [ $? -eq 0 ]; then
	sudo chgrp -R "IT" "$base_dir/IT"
	sudo chgrp -R "HR" "$base_dir/HR"
	sudo chgrp -R "Finance" "$base_dir/Finance"
	sudo chgrp -R "Executive" "$base_dir/Executive"
	sudo chgrp -R "Administrative" "$base_dir/Administrative"
	sudo chgrp -R "CallCentre" "$base_dir/Call Centre"
	echo "------------------------------"
	echo "Group ownership paths set..." 
else
	echo "ERROR: Issues setting ownership path"
fi
echo "Folders Created: $folderCount"
echo "...END OF SCRIPT..."
echo "---------------------------------"
