#########################################################################################
#Sample QC
#########################################################################################
#---------------------------------------------------------------------------------------#
#0. Compress to bgzip'd VCF
module load bcftools/1.8
bcftools view -Oz -o renamed_1ab_samples_1489_merged_sorted_tworules.vcf.gz \
  renamed_1ab_samples_1489_merged_sorted_tworules.vcf

# (optional but smart) ensure position-sorted before indexing
bcftools sort -Oz -o renamed_1ab_samples_1489_merged_sorted_tworules.vcf.gz \
  renamed_1ab_samples_1489_merged_sorted_tworules.vcf

# 1) CSI indexes (not TBI)
module load bcftools/1.8
bcftools index -c -f renamed_1ab_samples_1489_merged_sorted_tworules.vcf.gz
#or
bcftools index -c renamed_1ab_samples_1489_merged_sorted_tworules.vcf.gz
#or
#samtools index -c alignments.bam (BAM).
# 2) Make a CSI index (works with long scaffolds)
bcftools index -f -c renamed_1ab_samples_1489_merged_sorted_tworules.vcf.gz

# 3) Sanity check
bcftools idxstats renamed_1ab_samples_1489_merged_sorted_tworules.vcf.gz | head

#---------------------------------------------------------------------------------------#
#1_Missingness_per_individual
module load vcftools/0.1.16
vcftools --gzvcf renamed_samples_1489_merged_sorted_tworules.sorted.vcf.gz --missing-indv

#---------------------------------------------------------------------------------------#
#2_Depth_per_individual
vcftools --gzvcf renamed_samples_1489_merged_sorted_tworules.sorted.vcf.gz --depth

#---------------------------------------------------------------------------------------#
#3_Heterozygosity_outliers 
#(paralogs/contamination)
vcftools --gzvcf renamed_samples_1489_merged_sorted_tworules.sorted.vcf.gz --het

#---------------------------------------------------------------------------------------#
#4_Duplicates_close_relatives & swaps (optional but useful)
plink2 --vcf step1.vcf.gz --allow-extra-chr --make-bed --out tmp
plink2 --bfile tmp --genome gz --out related

#########################################################################################
#Site-level hard filters (repeats/paralogs are the enemy)
#########################################################################################
# keep only polymorphics
bcftools view -i 'AC>0 && AC<AN' -Oz -o poly_s100_All_1a1b_renamed.vcf.gz s100_All_1a1b_renamed.vcf.gz

#index
bcftools index -c poly_s100_All_1a1b_renamed.vcf.gz

#5_Site-level_snapshot
bcftools query -f '%CHROM\t%POS\t%QUAL\t%INFO/DP\t%INFO/NS\t%INFO/MQ\t%INFO/AN\t%INFO/AC\t%INFO/AF\n' ../All_1a1b_renamed.vcf.gz

bcftools query -f '%CHROM\t%POS[\t%DP]\n' ../All_1a1b_renamed.vcf.gz

#---------------------------------------------------------------------------------------#
#6_Normalize & split multi-allelics, keep biallelic SNPs
bcftools norm -f reference.fa -m-any ../All_1a1b_renamed.vcf.gz -Oz -o step2.norm.vcf.gz
bcftools view -v snps -m2 -M2 -Oz -o step2.snps.vcf.gz step2.norm.vcf.gz
bcftools index -c step2.snps.vcf.gz

















