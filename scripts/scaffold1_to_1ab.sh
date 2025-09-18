# inputs you gave (change here if needed)
IN="scaffold_1_tworules.sorted.vcf"
OUT="scaffold_1ab_tworules.sorted.vcf"

# thresholds & lengths
GAP_END=1418382258          # last base of 1a
OFFSET=1427634029           # first base of 1b (shift origin)
TOTAL_LEN=3224247808        # length of original scaffold_1

awk -v OFS="\t" \
    -v CHR="scaffold_1" -v A="scaffold_1a" -v B="scaffold_1b" \
    -v GAP_END="$GAP_END" -v OFFSET="$OFFSET" -v TOTAL_LEN="$TOTAL_LEN" '
BEGIN {
  b_len = TOTAL_LEN - OFFSET + 1     # new length of scaffold_1b
  contig_done = 0
}
# If we see the original contig header for scaffold_1, replace it with the two new ones
/^##contig=<ID=/ && $0 ~ "ID=" CHR "(,|>)" {
  printf("##contig=<ID=%s,length=%d>\n", A, GAP_END);
  printf("##contig=<ID=%s,length=%d>\n", B, b_len);
  contig_done = 1;
  next;
}
# If there was no contig line for scaffold_1, inject the two just before #CHROM
/^#CHROM/ {
  if (!contig_done) {
    printf("##contig=<ID=%s,length=%d>\n", A, GAP_END);
    printf("##contig=<ID=%s,length=%d>\n", B, b_len);
    contig_done = 1;
  }
  print; next;
}
# Other header lines: pass through
/^#/ { print; next }

# Body lines
$1 == CHR {
  pos = $2 + 0
  if (pos <= GAP_END) {
    $1 = A;                             # 1a, keep position
  } else if (pos >= OFFSET) {
    $1 = B; $2 = pos - OFFSET + 1;      # 1b, shift position
  } else {
    # Inside the gap → drop and warn
    print "WARN: Dropping variant in gap at " CHR ":" pos > "/dev/stderr"
    next;
