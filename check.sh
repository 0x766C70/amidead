#!/bin/bash

d1="date1"
d2="date2"
ecart=$d1-$d2
pitch="30"
$myMail="thomas@criscione.fr"
$SOmail="thomas@criscione.fr"
$url="dead.00011100.org"

if [ "$d1" == "ko3" ]; then
	echo "Subject:SOS MAIL: ROOT PASSWD of $myMail \n$(cat ./message)" | msmtp #SOmail
elif [ "$d1" == "ko2" ]; then
	echo echo "Subject: Are you alive \nGo to $url to say that you are alive ! THIS IS THE LAST CALL" | msmtp $myMail
	echo "ko3" >> ./log
elif [ "$d1" == "ko" ]; then
        echo echo "Subject: Are you alive \nGo to $url to say that you are alive ! This is the 2nd reminder" | msmtp $myMail
	echo "ko2" >> ./log
else 
	if [ "$ecart" > "$pitch"]; then
		echo echo "Subject: Are you alive \nGo to $url to say that you are alive !" | msmtp $myMail
		echo "ko" >> ./log
	fi
fi
