# !/bin/bash
#Internet Blocker w/ exception for IT Department.
echo "INTERNET BLOCKER SCRIPT"
echo "-----------------------"
echo "...START OF SCRIPT..."
# Script Variables
inputFile="EmployeeNames.csv"
dos2unix "$inputFile"
# File check
if [ $? -ne 0 ]; then
	echo "ERROR:...File not located..."
	echo ".................."
else
	echo "File Found!"
fi
ITcount=0
# Show list of IT department.
# While loop to iterate CSV File row by row to view users in IT Department.
echo "____________________"
echo "IT Department Users"
while IFS=',' read -r FirstName LastName Department; do
	firstname=$(echo "${FirstName,}" | cut -c 1)
	lastname=$(echo "${LastName::7}" | tr '[:upper:]'  '[:lower:]') 
	username=$(echo "$firstname$lastname")
	lineCount=$(sudo iptables -L | cat | grep -c "$username")
# Checks if user is in IT.
	if getent passwd "$username" >  /dev/null;
	then
		if [ $Department = "IT" ];
		then
			if [ $lineCount -eq 1 ];
			then
				echo "_____________________"
				echo "Username: $username"
				echo "User already has Exception...skip..."
			else
				echo "_____________________"
				echo "Username: $username"
				((ITcount+=1))
				sudo iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner $username -j ACCEPT # Make exception for IT Dept. User. 
				if [ $? -ne 0 ]; then
					echo "ERROR:...SKIP..."
					echo ".................."
				else
					echo "Exception HTTP ACCEPT Created Successfully!"
					echo ".................."
				fi
			fi
		fi
	else 
		echo "User doesn't exist"
	fi
done < <(tail -n +2 $inputFile)
# Create exception for non-IT Dept. employees.
HTTPcount=$(sudo iptables -L | cat | grep -c "192.168.2.3")
echo ".................."
if [ $HTTPcount -eq 0 ]; then
	sudo iptables -A OUTPUT -p tcp --dport 443 -d 192.168.2.3 -j ACCEPT
	echo "Accept Local IP...."
	echo ".................."
else
	echo "Exception already made for local IP..."
	echo ".................."
fi
# Block HTTP connections to all other non-local servers w/ duplicate catching.
PT8003count=$(sudo iptables -L | cat | grep -c "dpt:8003")
PT1979count=$(sudo iptables -L | cat | grep -c "dpt:1979")
if [ $PT8003count -eq 0 ]; then
	sudo iptables -t filter -A OUTPUT -p tcp --dport 8003 -j DROP
	echo "ADDED HTTP BLOCK"
	echo ".................."
else
	echo "HTTP BLOCK ALREADY CREATED..."
	echo ".................."
fi
if [ $PT8003count -eq 0 ]; then
	sudo iptables -t filter -A OUTPUT -p tcp --dport 1979 -j DROP
	echo "ADDED HTTP BLOCK"
	echo "..................."
else
	echo "HTTP BLOCK ALREADY CREATED..."
	echo ".................."
fi
echo "User exceptions created: $ITcount"
echo "...END OF SCRIPT..."
