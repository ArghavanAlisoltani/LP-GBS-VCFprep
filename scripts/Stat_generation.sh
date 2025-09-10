#########################################################################################
#Sample QC
#########################################################################################
#---------------------------------------------------------------------------------------#
#0. CSI indexes (not TBI)
module load bcftools/1.8
bcftools index -c All_1a1b_renamed.vcf.gz
#or
#samtools index -c alignments.bam (BAM).

#---------------------------------------------------------------------------------------#
#1. Missingness per individual
module load vcftools/0.1.16
vcftools --gzvcf ../All_1a1b_renamed.vcf.gz --missing-indv

#---------------------------------------------------------------------------------------#
#2. Depth per individual
vcftools --gzvcf ../All_1a1b_renamed.vcf.gz --depth


#---------------------------------------------------------------------------------------#
#3. Heterozygosity outliers (paralogs/contamination)



#---------------------------------------------------------------------------------------#


Duplicates/close relatives & swaps (optional but useful)
#########################################################################################
#Site QC
#########################################################################################
#---------------------------------------------------------------------------------------#
#3. Site-level_snapshot
bcftools query -f '%CHROM\t%POS\t%QUAL\t%INFO/DP\t%INFO/NS\t%INFO/MQ\t%INFO/AN\t%INFO/AC\t%INFO/AF\n' ../All_1a1b_renamed.vcf.gz

#---------------------------------------------------------------------------------------#
bcftools query -f '%CHROM\t%POS[\t%DP]\n' ../All_1a1b_renamed.vcf.gz


