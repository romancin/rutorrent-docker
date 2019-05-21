#!/bin/bash  

echo "rtelegram started at: $(date +%Y.%m.%d-%T)"
  /rtelegram/rtelegram "$RT_TOKEN" -masters="$MASTER" -url='local_scgi' -completed-torrents-logfile='/logs/completed.log'


exit 0
