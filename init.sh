#!/bin/bash
RUN ln -sf /dev/stdout /var/ossec/logs/ossec.log
/var/ossec/bin/agent-auth -m wazuh-workers
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