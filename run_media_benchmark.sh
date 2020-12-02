#!/bin/bash

##################################################
# Setup
##################################################

# constants
# seconds to run workload before and after vtune
CUSHION=10
RESULT_DIR=/bigtemp/$(logname)

# default arguments
DURATION=60
THREADS=10
CONNECTIONS=50
RATE=100
RESULT_NAME=""

# parse arguments
for var in "$@"; do
  case $var in
  -duration=*)
    DURATION="${var#*=}"
    ;;
  -threads=*)
    THREADS="${var#*=}"
    ;;
  -connections=*)
    CONNECTIONS="${var#*=}"
    ;;
  -rate=*)
    RATE="${var#*=}"
    ;;
  -name=*)
    RESULT_NAME="${var#*=}"
    ;;
  *)
    echo "Run Media Benchmark - Usage:
sudo ./run_media_benchmark.sh -duration=60 -threads=10 -rate=100 -RESULT_DIR=/bigtemp/\$(logname)/vtune -name=bob"
    exit 0
    ;;
  esac
done

if [ -z "${RESULT_NAME}" ]; then
  RESULT_NAME="vtune_result_$(date +%s)_duration$DURATION"
fi

if [[ ! -d "$RESULT_DIR" ]]; then
  echo "The result directory ($RESULT_DIR) doesn't yet exist, creating it now"
  mkdir -p "$RESULT_DIR"
fi

# Ensure writability
sudo chmod a+w "$RESULT_DIR"

# This enables perf to run without drivers
echo 0>/proc/sys/kernel/perf_event_paranoid


##################################################
# Start Media Services
##################################################

cd DeathStarBench/mediaMicroservices || exit 1
echo "[1] Starting services ..."
sudo docker-compose up -d
sudo docker-compose logs -f -t >> "$RESULT_DIR/${RESULT_NAME}_application.log" &


##################################################
# Start Workload
##################################################

echo "[2] Starting workload ..."
cd wrk2
./wrk -D exp -L \
  --threads "$THREADS" \
  --connections "$CONNECTIONS" \
  --duration "$((DURATION + (CUSHION * 2)))" \
  --rate "$RATE" \
  --script ./scripts/media-microservices/compose-review.lua \
  http://localhost:8080/wrk2-api/review/compose >> "$RESULT_DIR/${RESULT_NAME}_workload.log" &
cd ..

# Offset data collection
sleep $CUSHION


##################################################
# Start Data Collection
##################################################

echo "[3] Starting data collection ..."
sudo vtune -collect memory-access \
  -analyze-system \
  -d "$DURATION" \
  -result-dir="$RESULT_DIR/$RESULT_NAME"


##################################################
# Clean Up
##################################################

echo "[4] DONE! Stopping services"
sudo docker-compose down