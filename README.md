# MicroserviceAccelerationProject

Authors: Charlie DiLorenzo, Quintin Degroot, Tyler Haden

## Instructions 

1. ssh onto remote machine
2. run `run_media_bench.sh` script
    ```
    sudo ./run_media_benchmark.sh \
       -duration=$((60 * 5)) \
       -rate=100 \
       -connections=50 \
       -threads=10
    ```
3. sync results to local machine
    ```
    export $USERNAME=tjh8ap
    ./copy_results_to_local.sh
    ```
4. import into Vtune gui

### Notes

- The benchmark script stores the results in `/bigtemp/$USER`. It will create
this if it is not present. It will also run `chmod a+w` to make writable. To 
change, you must modify both benchmark and copy scripts.
- To change Vtune collection type, modify benchmark script.

### Vtune options

| `-collect <option>` |
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
