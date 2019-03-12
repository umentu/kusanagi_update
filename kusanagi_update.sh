#!/bin/bash

alias wp='sudo -u kusanagi /usr/local/bin/wp'
for d in `ls -d /home/kusanagi/*/DocumentRoot`; do
    echo $d;
	cd $d;
	wp core update && wp plugin update --all && wp theme update --all && wp core language update;
	echo -e  "$d OK \n";
done