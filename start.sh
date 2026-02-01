#! /bin/bash

cd ~ || exit
echo "Infra Interface: $OT_INFRA_IF"
echo "Thread Interface: $OT_THREAD_IF"
echo "Radio URL: $OT_RCP_DEVICE"
echo "Log Level: $OT_LOG_LEVEL"
mdnsd -i "$OT_INFRA_IF"
otbr-agent -d "$OT_LOG_LEVEL" -v -I "$OT_THREAD_IF" -B "$OT_INFRA_IF" "$OT_RCP_DEVICE"
