#!/bin/csh -f

set LOG_FILE=$$APP_HOME$$/Rsync/Rsync.log
set FROM_APP_ACCOUNT=`eval whoami`

if  ( $FROM_APP_ACCOUNT == 'production_account' ) then
       set TO_MACHINE_NAME="bcp.xxx.com"   ##BCP
       set TO_APP_ACCOUNT="bcp_account"   ##BCP
else if ( $FROM_APP_ACCOUNT == 'bcp_account' ) then
       set TO_MACHINE_NAME="production.xxx.com"   ##PRD
       set TO_APP_ACCOUNT="production_account"   ##PRD
else 
	   echo "Rsync not available. Exiting the program." |& tee -a $LOG_FILE
       exit 0
endif


echo "now sync to $TO_MACHINE_NAME"

set rsync_common_params=' -e "ssh" -avrl --delete --stats --progress '
set rsync_exclude_phrase=' --exclude-from='$$APP_HOME$$/Rsync/exclude_me' '

echo "Starting Rsync upload folder" |& tee -a $LOG_FILE
rsync ${rsync_common_params} ${rsync_exclude_phrase} ~/upload/* ${TO_APP_ACCOUNT}@${TO_MACHINE_NAME}:~/upload/ |& tee -a $LOG_FILE
echo "Completed Rsync upload folder" |& tee -a $LOG_FILE

