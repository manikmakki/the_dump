#!/bin/bash
exec &>> /home/pi/script_logs/watcher_do.log

# THIS IS AN ALWAYS RUNNING LOOP
while true; do

# THIS KEEPS THE OUPUT OF THE inotifywait AS A VARIABLE NAMED watcherOut
watcherOut="$(sudo inotifywait -e modify,create,delete /smb_share  )"
#echo OUTPUT : $watcherOut

# THIS GRABS THE EVERYTHING FROM THE RIGHT OF  "(anything)[space](anything)[space]" or "/share/ CREATE "
nameFile="${watcherOut#* * }"
#echo FILENAME : $nameFile

# THIS PARSES THE  watcherOut VARIABLE FOR THE ACTION DONE TO THE FILE
# fileAction1 GRABS EVERYTHING RIGHT OF THE LAST FORWARDSLASH '/' or  "CREATE [filename.ext]"  
# fileAction GRABS THE FIRST 6 CHARACTERS OF fileAction1 STARTING FROM POSITION 1 like "CREATE" "MODIFY" "DELETE"
fileAction1="${watcherOut##*/}"
fileAction="${fileAction1:1:6}"
#echo ACTION : $fileAction

fileName1="${fileAction1##* }"
fileName="${fileName1%%.*}"
#echo $fileName

# THIS GRABS EVERYTHING FROM THE RIGHT OF THE LAST PERIOD '.' IN THE nameFile variable or "png" "pdf" "pptx"
fileExt="${nameFile##*.}"

#echo EXT: $fileExt


# START DOING LOGICAL STUFF
if [ "$fileAction" = "CREATE" ]	
	then
		echo `date` - CREATED $nameFile
		if [ "$fileExt" = "png" ]
			then
				echo `date` - COPYING $nameFile to /slides >> /home/pi/script_logs/watcher_do.log
				sudo cp /smb_share/$nameFile /slides/ &
		fi
		if [ "$fileExt" = "pptx" ]
			then
				echo `date` - RUNNING copy, export, purge of $nameFile in  /staging >> /home/pi/script_logs/watcher_do.log
				(sudo cp /smb_share/$nameFile /staging ; sudo pptx2pdf -i /staging/$nameFile -o /slides -p; sudo rm /staging/$fileName*; sudo rm /slides/$fileName.pdf; echo `date` - DONE exporting $nameFile) &
		fi
fi
if [ "$fileAction" = "MODIFY" ]
	then
		echo `date` - MODIFIED $nameFile 
		if [ "$fileExt" = "png" ]
			then
				echo `date` - OVERWRITING $nameFile in /slides >> /home/pi/script_logs/watcher_do.log
				sudo cp /smb_share/$nameFile /slides &
		fi
		if [ "$fileExt" = "pptx" ]
			then
				echo `date` - RUNNING copy, export, purge of $nameFile in /staging >> /home/pi/script_logs/watcher_do.log
				(sudo cp /smb_share/$nameFile /staging ; sudo pptx2pdf -i /staging/$nameFile -o /slides -p; sudo rm /staging/$fileName*; sudo rm /slides/$fileName.pdf; echo `date` - DONE exporting $nameFile) &
		fi
fi
if [ "$fileAction" = "DELETE" ]
	then
		echo `date` - DELETED $nameFile
		if [ "$fileExt" = "png" ]
			then
				echo `date` - REMOVING $nameFile from /slides >> /home/pi/script_logs/watcher_do.log
				sudo rm /slides/$nameFile &
		fi
		if [ "$fileExt" = "pptx" ]
			then
				echo `date` - DELETING $nameFile from /slides >> /home/pi/script_logs/watcher_do.log
				sudo rm /slides/$fileName* &
		fi
fi
done
