#!/bin/bash


NPB_DIR="${NPB_DIR:-$HOME/NPB3.4.2/NPB3.4-MPI}"
RUNS=5

echo "============================================"
echo " CS9635 MPI Process Scaling — CG Class S"
echo " Platform: gpu1.gaul.csd.uwo.ca"
echo " Date: $(date)"
echo "============================================"

for NP in 1 2 4 8; do
    binary="$NPB_DIR/bin/cg.S.$NP"

    if [ ! -f "$binary" ]; then
        echo "Building CG Class S for $NP processes..."
        cd "$NPB_DIR" && make cg CLASS=S NPROCS=$NP
    fi

    echo ""
    echo "--- CG Class S: $NP process(es) ---"
    for i in $(seq 1 $RUNS); do
        echo "Run $i:"
        mpirun -np $NP --report-bindings "$binary" 2>&1 | \
            grep -E "Mop/s|Time in seconds|SUCCESSFUL|rank"
    done
done

echo ""
echo "Done."
