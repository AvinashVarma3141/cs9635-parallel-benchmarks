# CS9635 — Parallel Computing Benchmarks
## Performance Comparison: OpenMP, MPI, and CUDA

**Course:** CS9635 — Parallel Computing  
**Student:** Avinash Varma G
---

## Benchmark Suites

- **Rodinia 3.1** — used for OpenMP vs. CUDA comparison
  - Source: https://rodinia.cs.virginia.edu
- **NAS Parallel Benchmarks (NPB) 3.4.2** — used for MPI
  - Source: https://www.nas.nasa.gov/software/npb.html

---



## Running the Benchmarks

### CUDA (Rodinia)
```bash
bash rodinia/run_cuda.sh
```

### OpenMP (Rodinia)
```bash
bash rodinia/run_openmp.sh
```

### MPI (NPB Class S — 4 processes)
```bash
bash npb/run_mpi.sh
```

### MPI Process Scaling (CG benchmark)
```bash
bash npb/run_mpi_scaling.sh
```

### OpenMP CPU Utilization Profiling
```bash
bash profiling/run_perf_stat.sh
```

---

## Key Results Summary

### CUDA vs OpenMP (Rodinia, Class S inputs)

| Benchmark | CUDA (s) | OpenMP (s) | OpenMP Faster |
|-----------|----------|------------|----------------|
| backprop  | 58.05    | 0.011      | 5277x          |
| nw        | 10.18    | 0.011      | 925x           |
| pathfinder| 59.77    | 0.124      | 482x           |
| srad      | 48.24    | 0.008      | 6030x          |

### MPI Throughput (NPB Class S, 4 processes)

| Benchmark | Mop/s   | Time (s) |
|-----------|---------|----------|
| FT        | 6999.29 | 0.03     |
| LU        | 2829.93 | 0.04     |
| MG        | 827.02  | 0.01     |
| CG        | 812.81  | 0.08     |
| EP        | 384.62  | 0.09     |
| IS        | 117.59  | 0.01     |

### OpenMP Thread Scaling (NW, 4096x4096)

| Threads | Time (s) | Speedup | Parallel Efficiency |
|---------|----------|---------|---------------------|
| 1       | 0.248    | 1.00x   | 1.00                |
| 2       | 0.166    | 1.49x   | 0.75                |
| 4       | 0.131    | 1.89x   | 0.47                |
| 8       | 0.127    | 1.95x   | 0.24                |
| 16      | 0.127    | 1.95x   | 0.12                |

### OpenMP CPU Utilization (perf stat)

| Benchmark  | CPUs Utilized / 16 | Efficiency |
|------------|---------------------|------------|
| srad       | 6.79               | 42%        |
| nw         | 5.93               | 37%        |
| pathfinder | 1.69               | 11%        |
| backprop   | 1.99               | 12%        |
| hotspot    | 1.07               | 7%         |

---

## Notes

- All timings are wall-clock time using the Linux bash `time` built-in, averaged over 5–10 runs.
- Nsight Compute was attempted for GPU profiling but returned `ERR_NVGPUCTRPERM` on gpu1 — hardware performance counters require elevated permissions on the shared HPC server.
- CUDA hotspot and myocyte exceeded 5 minutes per run due to GPU contention on the shared server and were excluded from timing comparisons.