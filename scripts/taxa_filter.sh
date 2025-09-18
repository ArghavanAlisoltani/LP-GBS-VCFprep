#!/bin/bash
#SBATCH -p batch              # check below for Different Queues
#SBATCH -t 48:00:00             # Walltime/duration of the job
#SBATCH -N 1                   # Number of Nodes
#SBATCH --mem-per-cpu=2G       # Memory per node in GB needed for a job. Also s$
#SBATCH --ntasks-per-node=8    # Number of Cores (Processors)
#SBATCH --mail-user=arghavana85@gmail.com  # Designate e$
#SBATCH --mail-type=FAIL     # Events options are job BEGIN, END, NONE, FAIL, R$
#SBATCH --output="/scratch/arghavan/LP/vcf_v1/Aria_processed/S10b_1ab/outtaxafilt.txt"  # Path for output must alread$
#SBATCH --error="/scratch/arghavan/LP/vcf_v1/Aria_processed/S10b_1ab/errtaxafilt.txt"   # Path for errors must alread$
#SBATCH --job-name="vcf_merge"       # Name of job

awk -v keep="taxalist.txt" '
BEGIN {
    # Read in the taxa list
    while ((getline < keep) > 0) {
        samples_to_keep[$1] = 1
    }
}
/^##/ {
    print; next
}
/^#CHROM/ {
    for (i=1; i<=NF; i++) {
        if (i <= 9 || $i in samples_to_keep) {
            keep_idx[i] = 1
            col_order[++n] = i
        }
    }
    # print header
    for (i=1; i<=n; i++) {
        printf "%s%s", $(col_order[i]), (i<n ? "\t" : "\n")
    }
    next
}
{
    for (i=1; i<=n; i++) {
        printf "%s%s", $(col_order[i]), (i<n ? "\t" : "\n")
    }
}
' All_1ab_merged_sorted_tworules.vcf > All_1ab_taxa_merged_sorted_tworules.vcf


