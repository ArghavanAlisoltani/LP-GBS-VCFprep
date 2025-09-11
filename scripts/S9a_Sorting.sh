
# 1) choose an output folder you can write to
out=/path/sorted
mkdir -p "$out"

# 2) run in parallel, with per-file stderr logs and a progress bar
parallel --bar -j16 \
  'vcf-sort {} > '"$out"'/{/.}.sorted.vcf 2> '"$out"'/{/.}.log' \
  ::: /path_to/S7_two_rules_filter/tworules_filtered/*.vcf
```
