awk 'BEGIN{OFS="\t"}
  /^##/ { print; next }                                   # pass meta
  /^#CHROM/ {                                             # rename samples
    for (i=10; i<=NF; i++) {
      n=split($i,a,"_"); $i=a[n]
    }
    print; next
  }
  { print }                                               # body
' All_taxa_merged_sorted_tworules.vcf > renamed_samples_1489_merged_sorted_tworules.vcf
