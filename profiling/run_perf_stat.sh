#!/bin/bash
# OpenMP CPU Utilization Profiling

RODINIA_DIR="${RODINIA_DIR:-$HOME/rodinia_3.1}"
export OMP_NUM_THREADS=16

echo "============================================"
echo " CS9635 OpenMP CPU Utilization — perf stat"
echo " OMP_NUM_THREADS=$OMP_NUM_THREADS"
echo " Date: $(date)"
echo "============================================"

profile_bench() {
    local name=$1
    local dir=$2
    local cmd=$3

    echo ""
    echo "--- $name ---"
    cd "$RODINIA_DIR/openmp/$dir" || { echo "ERROR: cannot find $dir"; return; }
    echo "perf stat output (3 runs):"
    for i in 1 2 3; do
        perf stat -e task-clock eval "$cmd" 2>&1 | \
            grep -E "CPUs utilized|task-clock"
    done
}

profile_bench "backprop"   "backprop"   "./backprop 4096"
profile_bench "hotspot"    "hotspot"    "./hotspot 512 512 2 2 ../../data/hotspot/temp_512 ../../data/hotspot/power_512 output.out"
profile_bench "nw"         "nw"         "./nw 4096 10"
profile_bench "pathfinder" "pathfinder" "./pathfinder 100000 100 20"
profile_bench "srad"       "srad"       "./srad 100 0.5 502 458"

echo ""
echo "Done."