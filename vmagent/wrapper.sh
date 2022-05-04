#!/bin/bash

cmd1="/project/node_exporter --web.listen-address=127.0.0.1:9100 --path.procfs=/host/proc --path.rootfs=/rootfs --path.sysfs=/host/sys --collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)"
cmd2="/project/vmagent-prod -promscrape.config=./prometheus.yml -remoteWrite.tmpDataPath=/opt/vmagent/storage -remoteWrite.url=http://${MIAS_DOMAIN}:8428/api/v1/write"

$cmd1 &

# Wait 60 seconds to prevent a possible startup file lock data race in vmagent
sleep 60

# Start the second process
$cmd2 &

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?
