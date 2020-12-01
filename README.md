# MicroserviceAccelerationProject

Authors: Charlie DiLorenzo, Quintin Degroot, Tyler Haden

## Instructions 

### Pre

```
echo 0>/proc/sys/kernel/perf_event_paranoid
```

### Start Media Microservices Containers

```
cd ~/MicroserviceAccelerationProject/DeathStarBench/mediaMicroservices/
sudo docker-compose up
```

### Start Workload

```
./wrk -D exp -L \
  --threads 10 \
  --connections 50 \
  --duration 120 \
  --rate 100 \
  --script ./scripts/media-microservices/compose-review.lua \
  http://localhost:8080/wrk2-api/review/compose 
```

### Run Vtune Data Collector

| `-collect` options |
| ---------------- |
| performance-snapshot |
| hotspots |
| anomaly-detection |
| memory-consumption |
| uarch-exploration |
| memory-access |
| threading |
| hpc-performance |
| io |
| gpu-offload |
| gpu-hotspots |
| fpga-interaction |
| system-overview |
| throttling |
| platform-profiler |
| graphics-rendering |
| cpugpu-concurrency |
| tsx-exploration |
| tsx-hotspots |
| sgx-hotspots |


```
sudo vtune -collect hotspots \
    -knob sampling-mode=hw \
    -analyze-system \
    -d 60 
```

or

```
sudo vtune -collect memory-access \
    -analyze-system \
    -d 60 
```

#### Target Specific Container

```
sudo docker ps
sudo docker top <container name>
sudo vtune -collect memory-consumption \
    -knob sampling-mode=hw \
    -analyze-system \
    -d 60 \
    -target-pid 22785
```

### Copy To Local Machine

```
DATA=r003macc

USERNAME=
REMOTE_PATH=~/profiler_work

scp -r $USERNAME@:portal.cs.virginia.edu/$REMOTE_PATH/$DATA .
```

Then import to a Vtune GUI project.