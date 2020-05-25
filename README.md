# amidead

##Doc

###Requirements

	apache2 php 7.x dateutils

###Install

 * Mettre le repo derrière une web auth
 * Donnez les droits au repo à www-data pour log
 * Faire un cron du script ./check.sh en @monthly 
 * Mettre le contact d'urgence dans ./config
 * Mettre le message de sos dans ./message. Le chiffrer si necessaire:

	echo "My root password is: my_p4ssw0Rd ! So Long, and Thanks for All the Fish !)" | gpg -ear 'yourSO@alive.org') > ./message
