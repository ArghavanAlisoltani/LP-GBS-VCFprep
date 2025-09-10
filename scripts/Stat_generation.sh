#CSI indexes (not TBI)
bcftools index -c filtered.vcf.gz
#or
#samtools index -c alignments.bam (BAM).

module load vcftools/0.1.16
