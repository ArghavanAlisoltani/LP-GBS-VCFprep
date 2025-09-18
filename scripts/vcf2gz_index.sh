#!/bin/bash
#SBATCH -p batch              # check below for Different Queues
#SBATCH -t 48:00:00             # Walltime/duration of the job
#SBATCH -N 1                   # Number of Nodes
#SBATCH --mem-per-cpu=2G       # Memory per node in GB needed for a job. Also s$
#SBATCH --ntasks-per-node=8    # Number of Cores (Processors)
#SBATCH --mail-user=arghavana85@gmail.com  # Designate e$
#SBATCH --mail-type=FAIL     # Events options are job BEGIN, END, NONE, FAIL, R$
#SBATCH --output="/scratch/arghavan/LP/vcf_v1/Aria_processed/S10b_1ab/outvcf2gz.txt"  # Path for output must alread$
#SBATCH --error="/scratch/arghavan/LP/vcf_v1/Aria_processed/S10b_1ab/errvcf2gz.txt"   # Path for errors must alread$
#SBATCH --job-name="vcf_2_gz"       # Name of job

module load bcftools/1.8
bcftools view -Oz -o renamed_1ab_samples_1489_merged_sorted_tworules.vcf.gz \
  renamed_1ab_samples_1489_merged_sorted_tworules.vcf

bcftools index -c -f renamed_1ab_samples_1489_merged_sorted_tworules.vcf.gz
