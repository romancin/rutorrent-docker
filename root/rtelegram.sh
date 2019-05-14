#!/bin/bash  

echo "rtelegram started at: $(date +%Y.%m.%d-%T)"
  /rtelegram/rtelegram "$RT_TOKEN" "$PARAMS"


exit 0
