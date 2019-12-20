#!/bin/bash
# script created to automate backup of my containers
# run this as a cron job once a week

# create backup dir
mount /dev/sdb1 /backup
BACKUP_DIR="/backup/$(date +%Y-%m-%d)"
mkdir $BACKUP_DIR

# enter maintenance mode
docker exec --user www-data nextcloud-app php occ maintenance:mode --on
# backup nextcloud folder
rsync -Aax /var/lib/docker/volumes/docker-config_nextcloud-app/_data/ "$BACKUP_DIR/nextcloud/"
# backup mysql database
docker exec nextcloud-db mysqldump --single-transaction -u nextcloud -p[password] nextcloud-db > "$BACKUP_DIR/nextcloud-db.bak"
# leave maintenance mode
docker exec --user www-data nextcloud-app php occ maintenance:mode --off

# backup other containers
cp -R /var/lib/docker/volumes/docker-config_reverse-proxy/_data/nginx/ "$BACKUP_DIR/nginx"
cp -R /var/lib/docker/volumes/docker-config_home-assistant/_data/ "$BACKUP_DIR/home-assistant"
cp -R /var/lib/docker/volumes/docker-config_plex/_data/ "$BACKUP_DIR/plex"

# optionally compress the directory
#tar -zcf "$BACKUP_DIR.tar.gz" $BACKUP_DIR
#rm -rf $BACKUP_DIR

umount /backup
