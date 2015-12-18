#!/bin/bash

. ./directories_backup.config

mkdir --parents --verbose $BACKUP_DIR

for dir in "${DIRECTORIES[@]}"
  do
    echo "++ $dir"
    new_dir_name=`echo "$dir" | rev | cut -d/ -f1 | rev`
    mkdir --parents --verbose "$BACKUP_DIR/$new_dir_name"
    cd $BACKUP_DIR/$new_dir_name
    number=`ls -l $BACKUP_DIR/$new_dir_name | grep -v ^l | wc -l`
    
    if [ $((number-1)) -gt $ROTATION_FILO_LENGTH ] ; then
      oldest_file_name=`find -type f -printf "%T+%p\n"  | sort | head -n 1 | cut -d '/' -f 2`
      echo "DELETING: " $oldest_file_name
      rm -f $oldest_file_name
    fi
       
    tarball_name="$CURRENT_DATE""_backup."$new_dir_name".tar.gz"
    `/bin/tar -zcf "$tarball_name" "$dir"`
    echo "COMPRESSING $tarball_name"
  done 

echo "DONE"
