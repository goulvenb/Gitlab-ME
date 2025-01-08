#!/bin/bash

## Initial Variables

PATH_BACKUPS_DIR='/backups'               # 'Backups' Root Directory
PATH_RESTORE_DIR='/restore'               # 'Restore' Root Directory
PATH_LOGS_DIR="$PATH_RESTORE_DIR/logs"    # 'Logs' Directory
PATH_ARCH_DIR="$PATH_RESTORE_DIR/archive" # 'Archive' Directory
PATH_IP_DIR="$PATH_RESTORE_DIR/.progress" # 'In Progress' Directory

## Verifications

files=$(ls -p "$PATH_RESTORE_DIR" | grep -v '/')

# We check that only 1 file
# Is in `/restore`
if [ $(echo "$files" | wc -l) -ne 1 ]; then
    exit 0
fi
file=$files

# We check that the file
# Is a `tar` archive
#if ! file "$PATH_RESTORE_DIR/$file" | grep -q 'POSIX tar archive'; then
if ! tar tf "$PATH_RESTORE_DIR/$file" &> /dev/null; then
    exit 0
fi
tar=$file

# We check that there is
# No file being treated
#
# WARNING: can cause problems if the container
# stopped abruptly during last restore
# (but then there is bigger problems, like corrupted db)
if [ $(ls "$PATH_IP_DIR" | wc -l) -ne 0 ]; then
    exit 0
fi

## Standardised Variables

datetime=$(date '+%Y%m%d%H%M%S')
original_tar_file="$PATH_RESTORE_DIR/$tar"
log_file="$PATH_LOGS_DIR/$datetime.log"
in_progress_file="$PATH_IP_DIR/$datetime.tar"
archive_file="$PATH_ARCH_DIR/$datetime.tar"
backup_name=".restore_$datetime"
backup_symlink="$PATH_BACKUPS_DIR/$backup_name""_gitlab_backup.tar"

## Runtime

# We move the archive
# To mark it as 'in treatment'
mv "$original_tar_file" "$in_progress_file"

# Creating a symlink
# inside `/backups` as gitlab
# can only restore files inside the
# backups directory
ln -s "$in_progress_file" "$backup_symlink"

# We run the restoration steps
# specified on the website
# url: https://docs.gitlab.com/ee/administration/backup_restore/restore_gitlab.html#restore-for-docker-image-installations
#      https://docs.gitlab.com/ee/administration/backup_restore/restore_gitlab.html#restore-for-linux-package-installations
(
    echo "Backup name:"
    echo "  $tar"
    echo ""
    echo "###############################"
    echo "###  Stopping the Services  ###"
    echo "###############################"
    gitlab-ctl stop puma
    gitlab-ctl stop sidekiq
    echo "###############################"
    echo "###  Getting Gitlab Status  ###"
    echo "###############################"
    gitlab-ctl status
    echo "###############################"
    echo "###   Restoring the Backup  ###"
    echo "###############################"
    gitlab-backup restore BACKUP="$backup_name" force=yes
    echo "###############################"
    echo "### Restarting the Servcies ###"
    echo "###############################"
    gitlab-ctl restart
    echo "###############################"
    echo "###  Getting Gitlab Status  ###"
    echo "###############################"
    gitlab-rake gitlab:check SANITIZE=true
) > "$log_file" 2>&1

# We remove the symlink
rm "$backup_symlink"

# We archive the restored file
mv "$in_progress_file" "$archive_file"