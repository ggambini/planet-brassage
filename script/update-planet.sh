#!/bin/bash

#
# Mise à jour de planet-brassage
#

# Paramètres
	confFile="planet.ini"
	logFile="/data/scripts/planet-brassage.log"
	planetDir="/data/www/planet-brassage"
	outputDir="$planetDir/www/"
	templateName="planet-brassage"

# Fonctions
	function writeLog {
		message=$1
		if [[ "$logFile" != "" ]]
		then
			now=`date +%d/%m/%y-%H:%M:%S`
                        echo "$now - $message" >> $logFile
		else
			echo $message
		fi
	}


# Mise à jour des flux RSS

	# Activer le binaire ruby qui vient du dépot SCL et appeler la commande pluto avec tous les params
	# Pas possible de séparer l'action car c'est un bash dédié qui est créé, le change directory est obligatoire pour utiliser le template custom
	debug=`/bin/scl enable rh-ruby24 "cd $planetDir; pluto build --output=$outputDir --template=$templateName --dbpath=$planetDir $planetDir/$confFile"  2>&1`
	if [[ $? -ge "1" ]]
	then
		#Cmd fail
		writeLog "FAIL scl_enable : $debug"
                exit 3
        fi

# Modif de la date de derniere MaJ

	# Le script ruby ne met pas a jour ce champs, le script bash va modifier la valeur {lastUpdate} du template
	lastUpdate=`date +"Mis à jour le %d\/%m\/%y à %H:%M"`
	debug=`/bin/sed -i "s/{lastUpdate}/$lastUpdate/g" $outputDir/*.html 2>&1`
	echo $debug
        if [[ $? -ge "1" ]]
        then
                #Cmd fail
                writeLog "FAIL sed_lastUpdate : $debug"
                exit 3
        fi



