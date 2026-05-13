#!/bin/bash
# OpenMP Thread Scaling Study

RODINIA_DIR="${RODINIA_DIR:-$HOME/rodinia_3.1}"
RUNS=5

echo "============================================"
echo " CS9635 OpenMP Thread Scaling — NW"
echo " Input: 4096x4096, penalty=10"
echo " Date: $(date)"
echo "============================================"

cd "$RODINIA_DIR/openmp/nw" || { echo "ERROR: nw directory not found"; exit 1; }

for THREADS in 1 2 4 8 16; do
    export OMP_NUM_THREADS=$THREADS
    echo ""
    echo "--- OMP_NUM_THREADS=$THREADS ---"
    for i in $(seq 1 $RUNS); do
        echo "Run $i:"
        { time ./nw 4096 10 ; } 2>&1 | grep real
    done
done

echo ""
echo "Done."