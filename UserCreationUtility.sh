#!/bin/bash
# Utility Script for User directory Creation.

# Create Directory with checks of doubled inputs from file.

while IFS=',' read -r FirstName LastName Department; do
	firstname=$(echo "${FirstName,}" | cut -c 1) 
	username=$(echo "$firstname${LastName,}")
	if grep -r "$username" "$Home";
	then
		echo "Username already exists."
	else
		if grep -q "$Department" /etc/group;
		then
			echo "Group already in directory."
			sudo useradd -m $username -g $Department
		else
			sudo groupadd $Department
			echo "Created Group: {$Department}"
			sudo useradd -m $username -g $Department
			echo "Created username: {$username}"
		fi
	fi
echo "Program Completed"
done < EmployeeNames.csv

