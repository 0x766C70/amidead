#!/bin/bash

myMail=$(        cat "./config.json" | jq '.config.myself'     		| tr --delete '"')
units=$(         cat "./config.json" | jq '.config.units'     		| tr --delete '"')
timeMail=$(      cat "./config.json" | jq '.config.timeMail'   		| tr --delete '"')
timeLastCall=$(  cat "./config.json" | jq '.config.timeLastCall'    	| tr --delete '"')
timeSOS=$(       cat "./config.json" | jq '.config.timeSOS'		| tr --delete '"')
url=$( 		 cat "./config.json" | jq '.config.url' 		| tr --delete '"')
recipient=$(     cat "./config.json" | jq '.config.recipient'  		| tr --delete '"')


now=$( date +'%Y-%m-%dT%H:%M:%S' )


lastPing=$( tail -n 1 log )
previousPing=$( tail -n 2 log | head -n 1 )

if [ $lastPing == "ko" ] || [ $lastPing == "koSOS" ] || [ $lastPing == "SOS" ]; then
	diffPing=$( dateutils.ddiff $previousPing $now -f %$units )
else
	diffPing=$( dateutils.ddiff $lastPing $now -f %$units )
fi

if [ "$lastPing" == "koSOS" ] && [ "$diffPing" -ge $timeSOS ]; then
	echo -e "Subject:SOS MAIL of $myMail \n$(cat ./message)" | msmtp "$recipient"
	echo -e $now >> log
	echo -e "SOS" >> log
elif [ "$lastPing" == "ko" ] && [ "$diffPing" -ge $timeLastCall ]; then
	echo -e "Subject: Are you alive ? \nGo to $url to say that you are alive ! THIS IS THE LAST CALL" | msmtp "$myMail"
        echo -e $now >> log
	echo -e "koSOS" >> log
elif [ "$lastPing" != "SOS" ] && [ "$diffPing" -ge $timeMail ]; then
        echo -e "Subject: Are you alive ? \nGo to $url to say that you are alive !" | msmtp "$myMail"
        echo -e $now >> log
        echo -e "ko" >> log
fi
