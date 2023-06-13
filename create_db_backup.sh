#!/bin/bash

info () {
    lgreen='\e[92m'
    nc='\033[0m'
    printf "${lgreen}[Info] ${@}${nc}\n"
}

error () {
    lgreen='\033[0;31m'
    nc='\033[0m'
    printf "${lgreen}[Error] ${@}${nc}\n"
}

#=======================================

date=$(date +%d-%m-%Y-%H-%M)
BAKUP_DATABASE_PATH="/mnt/db_backup"

create_dir () {
    mkdir $BAKUP_DATABASE_PATH      &> $log_path/tmp.log
    if [ $? -eq 0 ];
        then
                info "mkdir db_backup complete"
	else
		tail -n20 $log_path/tmp.log
		error "mkdir db_backup failed"
	exit 1
    fi    
}

backup_db () {
    mysqldump -uroot -p7602 --all-databases > $BAKUP_DATABASE_PATH/all_db_backup_$date.sql   &> $log_path/tmp.log

    if [ $? -eq 0 ];
        then
	        info "backup_db complete"
	else
	        tail -n20 $log_path/tmp.log
		error "backup_db failed"
	exit 1
    fi
}

main () {
    if [ ! -d "$BAKUP_DATABASE_PATH" ];
        then
                create_dir&&backup_db
        else        
        	backup_db
    fi
}

main
