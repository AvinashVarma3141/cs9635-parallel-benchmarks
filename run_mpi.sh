#!/bin/bash
# CS9635 — MPI Benchmark Runner (NPB 3.4.2, Class S)
# Processes: 4

NPB_DIR="${NPB_DIR:-$HOME/NPB3.4.2/NPB3.4-MPI}"
NP=4
RUNS=5

echo "============================================"
echo " CS9635 MPI Benchmarks — NPB 3.4.2 Class S"
echo " Platform: gpu1.gaul.csd.uwo.ca"
echo " MPI processes: $NP"
echo " Date: $(date)"
echo "============================================"

run_npb() {
    local name=$1
    local binary="$NPB_DIR/bin/${name}.S.${NP}"

    if [ ! -f "$binary" ]; then
        echo ""
        echo "--- $name: binary not found, attempting build ---"
        cd "$NPB_DIR" && make "$name" CLASS=S NPROCS=$NP
    fi

    echo ""
    echo "--- $name (Class S, $NP processes) ---"
    for i in $(seq 1 $RUNS); do
        echo "Run $i:"
        mpirun -np $NP "$binary" 2>&1 | grep -E "Mop/s|Time in seconds|SUCCESSFUL"
    done
}

for bench in ft lu mg cg ep is; do
    run_npb "$bench"
done

echo ""
echo "Done."