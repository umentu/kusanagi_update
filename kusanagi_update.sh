#!/bin/bash

#データを残す日数
SPAN=7

# wpのalias
alias wp='sudo -u kusanagi /usr/local/bin/wp'

# productionごと
for d in `ls /home/kusanagi`; do

	cd /home/kusanagi/$d/DocumentRoot;

    # データのバックアップ
    if [ ! -e backup/$d ]; then
        mkdir backup/$d;
    fi 
    
    db_name=`cat wp-config.php|grep DB_NAME|cut -d"'" -f4`
    db_user=`cat wp-config.php|grep DB_USER|cut -d"'" -f4`
    db_host=`cat wp-config.php|grep DB_HOST|cut -d"'" -f4`
    db_password=`cat wp-config.php|grep DB_PASSWORD|cut -d"'" -f4`

    dt=`date '+%Y%m%d'`
    mysqldump -u$db_user -p$db_password -h$db_host $db_name > $db_name_dump_$dt.dump

    # データを残す期間以上に残していたら一番古いものを削除
    if [ `ls backup/$d| wc -l` -ge $SPAN ]; then
        rm -f backup/$d/`ls backup/$d|head -1`;
    fi

    # update
	wp core update && wp plugin update --all && wp theme update --all && wp core language update;

done