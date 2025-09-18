#!/bin/bash
#SBATCH -p batch              # check below for Different Queues
#SBATCH -t 48:00:00             # Walltime/duration of the job
#SBATCH -N 1                   # Number of Nodes
#SBATCH --mem-per-cpu=2G       # Memory per node in GB needed for a job. Also s$
#SBATCH --ntasks-per-node=16    # Number of Cores (Processors)
#SBATCH --mail-user=arghavana85@gmail.com  # Designate e$
#SBATCH --mail-type=FAIL     # Events options are job BEGIN, END, NONE, FAIL, R$
#SBATCH --output="/scratch/arghavan/LP/vcf_v1/Aria_processed/S9_sort_merged1ab/out.txt"  # Path for output must alread$
#SBATCH --error="/scratch/arghavan/LP/vcf_v1/Aria_processed/S9_sort_merged1ab/err.txt"   # Path for errors must alread$
#SBATCH --job-name="vcf_sort"       # Name of job

echo "Run started at $(date +"%Y-%m-%d %H:%M:%S")"

module load gnu-parallel/20190322
module load vcftools/0.1.16

# 1) choose an output folder you can write to
out=/scratch/arghavan/LP/vcf_v1/Aria_processed/S9_sort_merged1ab/sorted
mkdir -p "$out"

# 2) run in parallel, with per-file stderr logs and a progress bar
parallel --bar -j16 \
  'vcf-sort {} > '"$out"'/{/.}.sorted.vcf 2> '"$out"'/{/.}.log' \
  ::: /scratch/arghavan/LP/vcf_v1/Aria_processed//S7_two_rules_filter/tworules_filtered/*.vcf

echo "Run1 ended at $(date +"%Y-%m-%d %H:%M:%S")"
