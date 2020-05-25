# amidead

##Doc

###Requirements

	apache2 php 7.x dateutils jq

###Install

 * Mettre le repo derrière une web auth
 * Donnez les droits au repo à www-data pour log
 * Faire un cron du script ./check.sh en accord avec votre situation: monthly, daily, hourly... 
 * Mettre le contact d'urgence et le délai avant envoie mail d'urgence dans ./config
 * Il faut que le cron du check et le délai soient cohérent.
 * Mettre le message de sos dans ./message. Le chiffrer si necessaire:

	echo "My root password is: my_p4ssw0Rd ! So Long, and Thanks for All the Fish !)" | gpg -ear 'yourSO@alive.org') > ./message

 * Il est possible d'automatiser le signe de vie en mettant un cron sur le laptop avec la commande:

	curl -s --user user:passwd https://dead.yoursite.org/ >> /dev/null

####Usage

 * 
