#!/bin/bash

# This enables perf to run without drivers
# echo 0>/proc/sys/kernel/perf_event_paranoid

##################################################
# Defaults and script arguments
##################################################
# seconds to run workload before and after vtune
CUSHION=10

# vtune 
VTUNE_COMMANDS="-collect io -analyze-system"
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
  -vtune-commands=*)
    VTUNE_COMMANDS="${var#*=}"
    ;;
  *)
    echo "Run Media Benchmark - Usage:
sudo ./run_media_benchmark.sh -duration=60 -threads=10 -rate=100  -name=bob"
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
# sudo chmod a+w "$RESULT_DIR"


##################################################
# Start Media Services
##################################################

cd DeathStarBench/socialNetwork || exit 1
echo "[1] Starting services ..."
sudo docker-compose up -d
# sudo docker-compose logs -f -t

# wait for containers to all initialize
sleep $(( $CUSHION * 3 ))
python3 scripts/init_social_graph.py


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
  --script ./scripts/social-network/compose-post.lua \
http://localhost:8080/wrk2-api/post/compose >> "$RESULT_DIR/${RESULT_NAME}_workload.log" &
cd ..

# Offset data collection
sleep $CUSHION


##################################################
# Start Data Collection
##################################################

echo "[3] Starting data collection ..."
sudo vtune $VTUNE_COMMANDS \
  -d "$DURATION" \
  -result-dir="$RESULT_DIR/$RESULT_NAME"


##################################################
# Clean Up
##################################################

echo "[4] DONE! Stopping services"
sudo docker-compose down
