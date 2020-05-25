# amidead

##Doc

###Requirements

	apache2 php 7.x dateutils

###encrypt your message

	echo "My root password is: my_p4ssw0Rd ! So Long, and Thanks for All the Fish !)" | gpg -ear 'yourSO@alive.org') > ./message

###config SO

	echo yourSO@alive.org > config
