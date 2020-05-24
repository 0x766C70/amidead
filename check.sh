#!/bin/bash

echo "Subject:SOS MAIL vlp 2 \n$(cat ./message)" | msmtp thomas@criscione.fr
