curl -F file=@\/home\/vof\/backups\/vof-production-db-backup-`date +"%Y"`-`date +"%m"`-`date +"%d"`.sql -F channels=#vof-db-backups -F token= https://slack.com/api/files.upload