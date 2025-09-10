#CSI indexes (not TBI)
#module load bcftools/1.8
bcftools index -c All_1a1b_renamed.vcf.gz
#or
#samtools index -c alignments.bam (BAM).

module load vcftools/0.1.16
