#!/bin/bash

#
# Mise à jour de planet-brassage
#

echo "toto"

# Paramètres
	confFile="planet.ini"
	logFile=""
	planetDir="/data/www/planet-brassage"
	outputDir="$planetDir/www/"
	templateName="planet-brassage"

# Fonctions
	function writeLog {
		message=$1
		if [[ "$logFile" != "" ]]
		then
			now=`date +%d/%m/%y-%H:%M:%S`
                        echo "$now - $message" >> $LOG_FILE
		else
			echo $message
		fi
	}


# Mise à jour des flux RSS

	# Activer le binaire ruby qui vient du dépot SCL et appeler la commande pluto avec tous les params
	# Pas possible de séparer l'action car c'est un bash dédié qui est créé
	debug=`/bin/scl enable rh-ruby24 "cd $planetDir; pluto build --output=$outputDir --template=$templateName --dbpath=$planetDir $planetDir/$confFile"  2>&1`
	echo $debug
	if [[ $? -ge "1" ]]
	then
		#Cmd fail
		writeLog "FAIL scl_enable : $debug"
                exit 3
        fi





