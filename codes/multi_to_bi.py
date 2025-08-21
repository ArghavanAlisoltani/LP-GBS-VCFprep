#!/usr/bin/env python3
from collections import Counter
import sys

def parse_genotypes(allele_strs):
    """Convert genotype string to list of alleles, e.g. '0/1' => ['0', '1']."""
    return allele_strs.replace("|", "/").split("/") if "." not in allele_strs else []

def extract_alleles(ref, alt):
    """Return list of alleles where 0=ref, 1=first alt, etc."""
    return [ref] + alt.split(",")

def get_allele_counts(geno_list):
    """Count all allele occurrences from list of genotype strings."""
    counts = Counter()
    for g in geno_list:
        if g.startswith("./.") or "." in g:
            continue
        alleles = parse_genotypes(g.split(":")[0])
        for a in alleles:
            counts[a] += 1
    return counts

def filter_to_top_two(line):
    cols = line.strip().split("\t")
    ref = cols[3]
    alt = cols[4]
    all_alleles = extract_alleles(ref, alt)

    sample_data = cols[9:]
    counts = get_allele_counts(sample_data)

    if len(all_alleles) <= 2:
        return line  # Already biallelic

    # Convert numeric allele index back to nucleotide (e.g., '0' -> 'T', '1' -> 'A')
    top_two = [x[0] for x in counts.most_common(2)]

    if '0' not in top_two:
        top_two.append('0')  # Always preserve reference allele
        if len(top_two) > 2:
            # drop the least frequent if > 2 again
            least = min(top_two, key=lambda k: counts.get(k, 0))
            top_two.remove(least)

    # Rewrite genotypes with ./.
    format_fields = cols[8].split(":")
    gt_idx = format_fields.index("GT")

    new_samples = []
    for s in sample_data:
        parts = s.split(":")
        if len(parts) <= gt_idx:
            new_samples.append(s)
            continue
        alleles = parse_genotypes(parts[gt_idx])
        if not alleles or any(a not in top_two for a in alleles):
            parts[gt_idx] = "./."
        new_samples.append(":".join(parts))

    # Rewrite ALT field to only include the top alt allele
    alt_indices = [int(i) for i in top_two if i != '0']
    new_alt = ",".join([alt.split(",")[i - 1] for i in sorted(alt_indices)]) if alt_indices else "."
    cols[4] = new_alt
    cols[9:] = new_samples
    return "\t".join(cols) + "\n"

if __name__ == "__main__":
    vcf_in, vcf_out = sys.argv[1:3]
    with open(vcf_in) as fin, open(vcf_out, "w") as fout:
        for line in fin:
            if line.startswith("#"):
                fout.write(line)
            else:
                fout.write(filter_to_top_two(line))

