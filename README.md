# amidead

- english below -

## Usage

 amidead est une ligne de vie. Si au bout d'une durée définie vous ne vous êtes pas connecté à une url déterminée, le programme envoie un message à un destinataire défini.

## Cas d'utilisation

 * Déplacement en zone à risque
 * Randonnée
 * Décés

## Doc

### Requirements

 * Serveur web de votre choix + php 7.X
 * Script: datautils jq
 * Envoi email: msmtp

### Install

 * Mettre le repo derrière une web auth
 * Donnez les droits au repo: chown www-data:yourUser ./amidead -R et chmod 660 ./amidead -R
 * Faire un cron du script ./check.sh en accord avec votre situation: monthly, daily, hourly... 
 * Compléter le fichier de config
     * myself: votre email
     * units: unité des écarts de temps. La valeur doit être: S,M,H,d,m,y pour seconde, minute, heure, jour, mois, année
     * timeMail: durée à partir de laquel le programme envoie un premier message d'alerte
     * timeLastCall: durée après le premier mail pour un dernier appel
     * timeSOS: déclenche l'envoi du message de secours
     * url: Adresse où signaler que tout va bien
     * recipient: contact qui recevra la message de secours
 * Mettre le message de sos dans ./message. Le chiffrer si necessaire:

    echo "My root password is: my_p4ssw0Rd ! So Long, and Thanks for All the Fish !)" | gpg -ear 'yourSO@alive.org') > ./message

 * Il est possible d'automatiser le signe de vie en mettant un cron sur le laptop avec la commande:

    curl -s --user user:passwd https://dead.yoursite.org/ >> /dev/null

# amidead - English

## Usage

amidead is a line life. After a configured time, if no connection have been initiate, the script will send a emergency message

## use cases

 * High risk area
 * Hikking
 * Dead

## Documentation

### Requirements

 * Your favorite webserver + php 7.X
 * Script: datautils jq
 * mails: msmtp

### Install

 * Configure a web auth in front of the web repo
 * Set repo rights: chown www-data:yourUser ./amidead -R et chmod 660 ./amidead -R
 * add a cron job for check.sh. The spam should match with your use case
 * Configure the config.json file
     * myself: your email
     * units: time units. values should be: S,M,H,d,m,y for secondes, minutes, hours, days, months, years
     * timeMail: time before the first alert email
     * timeLastCall: time for the last call
     * timeSOS: time for the emergency email
     * url: iamalive url
     * recipient: recipient of your emergency mail
 * Write your emergency message in ./message. You can encrypt it::

    echo "My root password is: my_p4ssw0Rd ! So Long, and Thanks for All the Fish !)" | gpg -ear 'yourSO@alive.org') > ./message

 * You can make the iamalive ping in your laptop cron job:

    curl -s --user user:passwd https://dead.yoursite.org/ >> /dev/null

