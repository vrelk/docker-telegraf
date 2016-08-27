#!/bin/bash

echo "Configured inputs:"
echo "Kafka:           $INPUT_KAFKA_ENABLED"
echo "CPU:             $INPUT_CPU_ENABLED"
echo "Disk:            $INPUT_DISK_ENABLED"
echo "Disk I/O:        $INPUT_DISKIO_ENABLED"
echo "Kernel:          $INPUT_KERNEL_ENABLED"
echo "Memory:          $INPUT_MEM_ENABLED"
echo "Process:         $INPUT_PROCESS_ENABLED"
echo "Swap:            $INPUT_SWAP_ENABLED"
echo "System:          $INPUT_SYSTEM_ENABLED"
echo "Netstat:         $INPUT_NETSTAT_ENABLED"
echo "TCP server:      $INPUT_LISTENER_ENABLED"
echo "Docker:          $INPUT_DOCKER_ENABLED"

echo "Configured outputs:"
echo "InfluxDB:       $OUTPUT_INFLUXDB_ENABLED ($INFLUXDB_URL)"
echo "Cloudwatch:     $OUTPUT_CLOUDWATCH_ENABLED"
echo "Kafka:          $OUTPUT_KAFKA_ENABLED (${OUTPUT_KAFKA_RETRIES:-3} retries)"
echo "File:           $OUTPUT_FILE_ENABLED ($OUTPUT_FILE_PATH)"

if [[ -f /etc/telegraf/telegraf.conf.tpl ]] ; then
    echo "Generating /etc/telegraf/telegraf.conf from template..."
    envtpl /etc/telegraf/telegraf.conf.tpl
else
    if [[ -f /etc/telegraf/telegraf.conf ]] ; then
        echo "/etc/telegraf/telegraf.conf already exists. Nothing to do."
    else
        echo "ERROR: No template or configuration file found: /etc/telegraf/telegraf.conf"
    fi
fi

mode="single"
timer=""
while getopts ":m:r:" opt; do
  case $opt in
    r)
      timer=$((RANDOM % $OPTARG)) 
      echo "INFO - requested timer before telegraf start ($timer)"
      ;;
    m)
      mode=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
if [[ -n "$timer" ]]; then
  sleep $timer
fi
CMD="/bin/telegraf"
CMDARGS="-config /etc/telegraf/telegraf.conf"
if [[ "$mode" = "restart" ]]; then
  echo "WARNING - restart option is for debug only"
  i=0
  while [[ $i -lt 30 ]]; do
    "$CMD" $CMDARGS
    ((i++))
    sleep 1
  done
else
  exec "$CMD" $CMDARGS
fi
