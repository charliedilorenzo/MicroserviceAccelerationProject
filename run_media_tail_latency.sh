#!/bin/bash

THREADS=5
CONNECTIONS=10
DURATION=60

if [[ ! -d "latency_results" ]]; then
  echo "The result directory (./latency_results) doesn't yet exist, creating it now"
  mkdir latency_results
fi

./wrk -D exp -L \
      --threads "$THREADS" \
      --connections "$CONNECTIONS" \
      --duration "120" \
      --rate "500" \
      --script ./scripts/media-microservices/compose-review.lua \
      http://localhost:8080/wrk2-api/review/compose

for i in {1..5}
do
  RATE=$(( i * 10 ))
  echo "Running workload at rate=$RATE for $DURATION seconds ..."
  ./wrk -D exp -L \
      --threads "$THREADS" \
      --connections "$CONNECTIONS" \
      --duration "$DURATION" \
      --rate "$RATE" \
      --script ./scripts/media-microservices/compose-review.lua \
      http://localhost:8080/wrk2-api/review/compose > "tail_latency_results/media_r${RATE}_d${DURATION}_t${THREADS}_c${CONNECTIONS}.log"
done
