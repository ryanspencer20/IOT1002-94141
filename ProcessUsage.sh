# !/bin/bash
# Utility: kill user processes with cpu sorted. User triggered script.
# Loading function animation before termination of PID to slow down processes of kill.
loading_threedots() {
tput civis #Lock cursor during animation. 
printf "Loading"
for i in {1..3}; do
	printf "."
	sleep 0.5
done
printf " \b"
tput cnorm #Reset cursor.
}
# Log file for logging termination process for users with current date.
LOGFILE="$HOME/ReportProcessUsage-$(date).log"
# Variable for Terminated Processes Executed.
procNum=0
# Show top 5 cpu% to determine if user commands slowing down system.
topcpu=$(ps -eo lstart,pid,user,%cpu,cmd --sort=-%cpu | grep -vwE "(ps|gnome-shell|gnome-terminal|ssh|bash)" | head -n 6 | cat)
echo "$topcpu"
echo ""
# Ask user if a process termination to all user processes from the list. 
echo "Would you like to kill the following user processes?"
read -p "Type y for yes or type any key to exit then press enter: " user
if [ $user == "y" ]; then
	echo ""
	loading_threedots
	echo "...SCRIPT RUN..."
	echo ""
# While loop to get line by line of first 5 lines of top cpu tasks.
	echo "Scripted Started: $(date)" >> "$LOGFILE"
	echo "_______________________________________________" >> "$LOGFILE"
	echo "" >> "$LOGFILE"
	while IFS= read -r line; do
# Variables to get line by line info for displaying in conditions & log.
		pid=$(echo "$line" | awk '{print $6}')
		cpuUser=$(echo "$line" | awk '{print $7}')
		CMD=$(echo "$line" | awk '{print $9}')
		echo "PID: $pid, USER: $cpuUser, Process: $CMD"
# If statement to terminate process if user doesn't equal root user.
		if [ $cpuUser != "root" ]; then
			echo  "Terminating $pid in progress..."
			loading_threedots
			kill -9 "$pid"
# Catching Error if PID isn't available to kill or error occurs.  
			if [ $? -ne 0 ]; then
				echo "ERROR: Process ID-$pid...SKIP..."
				echo ""
			else
				killTime=$(date +"%H:%M:%S") # Variable for time of process kill.
				procStart=$(echo "$line" | awk '{print $1,$2,$3,$4}') # Variable of line process start time.
				printf "Process Terminated PID: $pid \n"
# Capture log for individual line to variable location log file.
				user_group=$(id -gn "$cpuUser") # Primary group Variable for log.
				echo "Process: $CMD" >> "$LOGFILE"
				echo "--------------------------------------------------" >> "$LOGFILE"
				echo "1. USERNAME: $cpuUser" >> "$LOGFILE"
				echo "2. Process Started: $procStart" >> "$LOGFILE"
				echo "3. Process Terminated: $killTime" >> "$LOGFILE"
				echo "4. Group for $cpuUser: $user_group" >> "$LOGFILE"
				echo "" >> "$LOGFILE"
				((procNum++)) # Increment number of times the process executed. 
				echo ""
			fi
# Skip line if user equals to root user.
		else
			echo "...SKIPPED..."
			echo ""
		fi
        done < <(echo "$topcpu" | tail -n +2)
	echo "______________________________________________" >> "$LOGFILE"
	echo "" >> "$LOGFILE"
	echo "Script Ended: $(date)" >> "$LOGFILE" 
else
	echo "...SCRIPT EXITED BY USER..."
fi
# End of script from the process being run.
echo "Number of Terminated Processes: $procNum"
echo "...SCRIPT COMPLETED..."
