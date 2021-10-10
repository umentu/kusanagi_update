#!/bin/sh

#データを残す日数
SPAN=7

BASE_DIR=$(cd $(dirname $0); pwd)

# productionごと
for d in `ls /home/kusanagi|grep -v kusanagi_update`; do

	cd /home/kusanagi/$d/DocumentRoot;

    # データのバックアップ
    if [ ! -e $BASE_DIR/backup/$d ]; then
        mkdir $BASE_DIR/backup/$d;
    fi

    db_name=`cat wp-config.php|grep DB_NAME|cut -d"'" -f4`
    db_user=`cat wp-config.php|grep DB_USER|cut -d"'" -f4`
    db_host=`cat wp-config.php|grep DB_HOST|cut -d"'" -f4`
    db_password=`cat wp-config.php|grep DB_PASSWORD|cut -d"'" -f4`

    cd $BASE_DIR/backup/$d
    dt=`date '+%Y%m%d'`
    mysqldump -u$db_user -p$db_password -h$db_host $db_name > $dt.dump
    tar -jcvf $dt.tar.bz2 $BASE_DIR/$d
    
    # データを残す期間以上に残していたら一番古いものを削除
    if [ `ls $BASE_DIR/backup/$d| wc -l` -ge $SPAN ]; then
        rm -f $BASE_DIR/backup/$d/`ls $BASE_DIR/backup/$d|head -1`;
    fi

    # update
	/usr/local/bin/wp core update && /usr/local/bin/wp plugin update --all && /usr/local/bin/wp theme update --all && /usr/local/bin/wp core language update;

done
