#!/bin/bash
/var/ossec/bin/agent-auth -m  35.246.29.40
/etc/init.d/wazuh-agent start
STATUS_CMD="/etc/init.d/wazuh-agent status"

while true
do
  eval $STATUS_CMD > /dev/null
  if (( $? != 0 ))
  then
    CUR_TIME=`date +%s`
    # Allow ossec to not run return an ok status for up to 15 seconds
    # before worring.
    if (( (CUR_TIME - LAST_OK_DATE) > 15 ))
    then
      echo "ossec not properly running! exiting..."
      ossec_shutdown
      exit 1
    fi
  else
    LAST_OK_DATE=`date +%s`
  fi
  sleep 1
done