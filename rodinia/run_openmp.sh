#!/bin/bash

RODINIA_DIR="${RODINIA_DIR:-$HOME/rodinia_3.1}"
export OMP_NUM_THREADS=16
RUNS=5

echo "Running OpenMP benchmarks..."
echo "OMP_NUM_THREADS=$OMP_NUM_THREADS"

run_benchmark() {
    local name=$1
    local dir=$2
    local cmd=$3

    echo ""
    echo "$name"

    cd "$RODINIA_DIR/openmp/$dir" || return

    for i in $(seq 1 $RUNS); do
        echo "Run $i"
        eval "time $cmd" 2>&1 | grep real
    done
}

run_benchmark "backprop" "backprop" "./backprop 4096"

run_benchmark "hotspot" "hotspot" \
"./hotspot 512 512 2 2 ../../data/hotspot/temp_512 ../../data/hotspot/power_512 output.out"

run_benchmark "nw" "nw" "./nw 4096 10"

run_benchmark "pathfinder" "pathfinder" "./pathfinder 100000 100 20"

run_benchmark "srad" "srad" "./srad 100 0.5 502 458"

run_benchmark "myocyte" "myocyte" "./myocyte 10 1 0"

echo ""
echo "Done."