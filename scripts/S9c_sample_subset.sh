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
' /path/to/All_merged_sorted_tworules.vcf > All_taxa_merged_sorted_tworules.vcf
