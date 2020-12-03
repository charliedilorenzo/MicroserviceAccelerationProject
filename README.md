# MicroserviceAccelerationProject

Authors: Charlie DiLorenzo, Quintin Degroot, Tyler Haden

## Instructions 

1. ssh onto remote machine
2. run `run_media_bench.sh` script
    ```
    sudo ./run_media_benchmark.sh
    ```
    
    or
    
    ```
    sudo ./run_media_benchmark.sh \
       -duration=60 \
       -rate=100 \
       -connections=50 \
       -threads=10
    ```
3. sync results to local machine
    ```
    ./copy_results_to_local.sh
    ```
4. import into Vtune gui

### Notes

- You will need to specify you school computing id as env var `$USERNAME` on 
your local machine. The server uses `$(logname)`.
- The benchmark script stores the results in `/bigtemp/$(logname)`. It will create
this if it is not present. It will also run `chmod a+w` to make writable. To 
change, you must modify both benchmark and copy scripts.
- To change Vtune collection type, modify benchmark script.
- You plan on running many iterations of Vtune sequentially, you should leave
the application containers running the whole time and shutdown at the end.
You gotta modify the benchmark script.
- wrk2 is weird. might require link `sudo ln -s /usr/share/lua /usr/local/share` and or adding `package.cpath = package.cpath .. ";/usr/lib64/lua/5.1/?.so"`

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
