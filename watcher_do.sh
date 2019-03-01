#!/bin/bash
####################################
#  VARS
# Path of share to watch
sharePath=""
# Working directory for temp files
workingPath=""
# Final path for displaying .pngs
outputPath=""
#Logs,  duh
logPath=""
####################################

exec &>> $logPath

# THIS IS AN ALWAYS RUNNING LOOP
while true; do

# THIS KEEPS THE OUPUT OF THE inotifywait AS A VARIABLE NAMED watcherOut
watcherOut="$(sudo inotifywait -e modify,create,delete $sharePath  )"

#DEBUG!
#echo OUTPUT : $watcherOut

# THIS GRABS THE EVERYTHING FROM THE RIGHT OF  "(anything)[space](anything)[space]" or "/share/ CREATE "
nameFile="${watcherOut#* * }"

#DEBUG!
#echo FILENAME : $nameFile

# THIS PARSES THE  watcherOut VARIABLE FOR THE ACTION DONE TO THE FILE
# fileAction1 GRABS EVERYTHING RIGHT OF THE LAST FORWARDSLASH '/' or  "CREATE [filename.ext]"  
# fileAction GRABS THE FIRST 6 CHARACTERS OF fileAction1 STARTING FROM POSITION 1 like "CREATE" "MODIFY" "DELETE"
fileAction1="${watcherOut##*/}"
fileAction="${fileAction1:1:6}"

#DEBUG!
#echo ACTION : $fileAction

fileName1="${fileAction1##* }"
fileName="${fileName1%%.*}"

#DEBUG!
#echo $fileName

# THIS GRABS EVERYTHING FROM THE RIGHT OF THE LAST PERIOD '.' IN THE nameFile variable or "png" "pdf" "pptx"
fileExt="${nameFile##*.}"

#DEBUG!
#echo EXT: $fileExt


# START DOING LOGICAL STUFF
if [ "$fileAction" = "CREATE" ]	
	then
		echo `date` - CREATED $nameFile
		if [ "$fileExt" = "png" ]
			then
				echo `date` - COPYING $nameFile to $outputPath >> $logPath
				sudo cp $sharePath/$nameFile $outputPath/ &
		fi
		if [ "$fileExt" = "pptx" ]
			then
				echo `date` - RUNNING copy, export, purge of $nameFile in  $workingPath >> $logPath
				(sudo cp $sharePath/$nameFile $workingPath ; sudo pptx2pdf -i $workingPath/$nameFile -o $outputPath -p; sudo rm $workingPath/$fileName*; sudo rm $outputPath/$fileName.pdf; echo `date` - DONE exporting $nameFile) &
		fi
fi
if [ "$fileAction" = "MODIFY" ]
	then
		echo `date` - MODIFIED $nameFile 
		if [ "$fileExt" = "png" ]
			then
				echo `date` - OVERWRITING $nameFile in $outputPath >> $logPath
				sudo cp $sharePath/$nameFile $outputPath &
		fi
		if [ "$fileExt" = "pptx" ]
			then
				echo `date` - RUNNING copy, export, purge of $nameFile in $workingPath >> $logPath
				(sudo cp /$sharePath/$nameFile $workingPath ; sudo pptx2pdf -i $workingPath/$nameFile -o $outputPath -p; sudo rm $workingPath/$fileName*; sudo rm $outputPath/$fileName.pdf; echo `date` - DONE exporting $nameFile) &
		fi
fi
if [ "$fileAction" = "DELETE" ]
	then
		echo `date` - DELETED $nameFile
		if [ "$fileExt" = "png" ]
			then
				echo `date` - REMOVING $nameFile from $outputPath >> $logPath
				sudo rm $outputPath/$nameFile &
		fi
		if [ "$fileExt" = "pptx" ]
			then
				echo `date` - DELETING $nameFile from $outputPath >> $logPath
				sudo rm $outputPath/$fileName* &
		fi
fi
done
