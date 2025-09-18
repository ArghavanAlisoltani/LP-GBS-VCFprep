#!/bin/bash
#SBATCH -p batch              # check below for Different Queues
#SBATCH -t 48:00:00             # Walltime/duration of the job
#SBATCH -N 1                   # Number of Nodes
#SBATCH --mem-per-cpu=2G       # Memory per node in GB needed for a job. Also s$
#SBATCH --ntasks-per-node=8    # Number of Cores (Processors)
#SBATCH --mail-user=arghavana85@gmail.com  # Designate e$
#SBATCH --mail-type=FAIL     # Events options are job BEGIN, END, NONE, FAIL, R$
#SBATCH --output="/scratch/arghavan/LP/vcf_v1/Aria_processed/S10b_1ab/outmerged.txt"  # Path for output must alread$
#SBATCH --error="/scratch/arghavan/LP/vcf_v1/Aria_processed/S10b_1ab/errmerged.txt"   # Path for errors must alread$
#SBATCH --job-name="vcf_merge"       # Name of job

echo "Run started at $(date +"%Y-%m-%d %H:%M:%S")"

module load vcftools/0.1.16
cd sorted1ab 
vcf-concat $(cat /scratch/arghavan/LP/vcf_v1/Aria_processed/S10b_1ab/ordered_scaff_1ab.txt) > ../All_1ab_merged_sorted_tworules.vcf

echo "Run1 ended at $(date +"%Y-%m-%d %H:%M:%S")"
