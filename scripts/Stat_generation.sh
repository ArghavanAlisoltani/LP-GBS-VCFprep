#########################################################################################
#Sample QC
#########################################################################################
#---------------------------------------------------------------------------------------#
#0. CSI indexes (not TBI)
module load bcftools/1.8
bcftools index -c -f All_1a1b_renamed.vcf.gz
#or
bcftools index -c All_1a1b_renamed.vcf.gz
#or
#samtools index -c alignments.bam (BAM).

#---------------------------------------------------------------------------------------#
#1_Missingness_per_individual
module load vcftools/0.1.16
vcftools --gzvcf ../All_1a1b_renamed.vcf.gz --missing-indv

#---------------------------------------------------------------------------------------#
#2_Depth_per_individual
vcftools --gzvcf ../All_1a1b_renamed.vcf.gz --depth


#---------------------------------------------------------------------------------------#
#3_Heterozygosity_outliers 
#(paralogs/contamination)
vcftools --gzvcf ../All_1a1b_renamed.vcf.gz --het

#---------------------------------------------------------------------------------------#
#4_Duplicates_close_relatives & swaps (optional but useful)
plink2 --vcf step1.vcf.gz --allow-extra-chr --make-bed --out tmp
plink2 --bfile tmp --genome gz --out related

#########################################################################################
#Site-level hard filters (repeats/paralogs are the enemy)
#########################################################################################
#5_Site-level_snapshot
bcftools query -f '%CHROM\t%POS\t%QUAL\t%INFO/DP\t%INFO/NS\t%INFO/MQ\t%INFO/AN\t%INFO/AC\t%INFO/AF\n' ../All_1a1b_renamed.vcf.gz

bcftools query -f '%CHROM\t%POS[\t%DP]\n' ../All_1a1b_renamed.vcf.gz

#---------------------------------------------------------------------------------------#
#6_Normalize & split multi-allelics, keep biallelic SNPs
bcftools norm -f reference.fa -m-any ../All_1a1b_renamed.vcf.gz -Oz -o step2.norm.vcf.gz
bcftools view -v snps -m2 -M2 -Oz -o step2.snps.vcf.gz step2.norm.vcf.gz
bcftools index -c step2.snps.vcf.gz

















