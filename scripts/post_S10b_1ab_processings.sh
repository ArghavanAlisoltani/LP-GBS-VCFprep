#########################################################################################
#Sample QC
#########################################################################################
#---------------------------------------------------------------------------------------#
#0. Compress to bgzip'd VCF
module load bcftools/1.8
bcftools view -Oz -o poly_s100_All_1a1b_renamed.vcf.gz \
  poly_s100_All_1a1b_renamed.vcf

# (optional but smart) ensure position-sorted before indexing
bcftools sort -Oz -o renamed_1ab_samples_1489_merged_sorted_tworules.vcf.gz \
  renamed_1ab_samples_1489_merged_sorted_tworules.vcf

# 1) CSI indexes (not TBI)
module load bcftools/1.8
bcftools index -c -f poly_s100_All_1a1b_renamed.vcf.gz
#or
bcftools index -c poly_s100_All_1a1b_renamed.vcf.gz

bcftools index -c exclude24_imputed.vcf.gz
#or
#samtools index -c alignments.bam (BAM).
# 2) Make a CSI index (works with long scaffolds)
bcftools index -f -c renamed_1ab_samples_1489_merged_sorted_tworules.vcf.gz

# 3) Sanity check
bcftools idxstats renamed_1ab_samples_1489_merged_sorted_tworules.vcf.gz | head

# 4) Is there any site in the selected region
bcftools view "/scratch/arghavan/LP/subsampling/poly_s100_All_1a1b_renamed.vcf.gz" "scaffold_2:300000000-350000000" | wc -l
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


#sub sampling for other scaffolds
bcftools view   -S 100_greedy_selected.txt   -Oz -o s100_exclude24_imputed.vcf.gz exclude24_imputed.vcf.gz

# index subsampled data
bcftools index -c s100_exclude24_imputed.vcf.gz

# drop monomorphic sites
bcftools view -i 'AC>0 && AC<AN' -Oz -o poly_s100_exclude24_imputed.vcf.gz s100_exclude24_imputed.vcf.gz


#get range of scaffolds
bcftools query -f '%CHROM\t%POS\n' poly_s100_exclude24_imputed.vcf.gz \
| awk '{
  c=$1; p=$2
  if (!(c in min) || p < min[c]) min[c] = p
  if (!(c in max) || p > max[c]) max[c] = p
  n[c]++
}
END {
  for (c in min) printf "%s\t%s\t%s\t%s\n", c, min[c], max[c], n[c]
}' | sort -k1,1V >> ranges_poly_s100_exclude24_imputed.vcf.gz.tsv











