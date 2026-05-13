#!/bin/bash

RODINIA_DIR="${RODINIA_DIR:-$HOME/rodinia_3.1}"
RUNS=5

echo "Running CUDA benchmarks..."

run_benchmark() {
    local name=$1
    local dir=$2
    local cmd=$3

    echo ""
    echo "$name"

    cd "$RODINIA_DIR/cuda/$dir" || return

    for i in $(seq 1 $RUNS); do
        echo "Run $i"
        eval "time $cmd" 2>&1 | grep -E "real|Error|RESULT"
    done
}

run_benchmark "backprop" "backprop" "./backprop 4096"

run_benchmark "nw" "nw" "./nw 2048 10"

run_benchmark "pathfinder" "pathfinder" "./pathfinder 100000 100 20"

run_benchmark "srad" "srad/srad_v1" "./srad 100 0.5 502 458"

echo ""
echo "Done."