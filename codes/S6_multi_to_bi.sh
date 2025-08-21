#!/usr/bin/env bash
# S6_multi_to_bi.sh
# Convert multi-allelic VCF records to biallelic by keeping the two most
# frequent alleles per site. Processes multiple VCF files in parallel using
# GNU parallel.
# Usage: S6_multi_to_bi.sh file1.vcf file2.vcf ...
# Output files are written to biallelic_vcfs/<basename>_biallelic.vcf

set -euo pipefail

SCRIPT_DIR=$(dirname "$0")
mkdir -p biallelic_vcfs

parallel -j 16 \
  "python3 $SCRIPT_DIR/multi_to_bi.py {} biallelic_vcfs/{/.}_biallelic.vcf" \
  ::: "$@"
