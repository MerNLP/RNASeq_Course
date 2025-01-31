#!/bin/bash
#SBATCH --job-name=index_bam
#SBATCH --output=/data/users/mlawrence/rnaseq_course/reads/mapping/samtools_output/index_bam_%A_%a.out
#SBATCH --error=/data/users/mlawrence/rnaseq_course/reads/mapping/samtools_output/index_bam_%A_%a.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=6G
#SBATCH --time=2:00:00
#SBATCH --partition=pibu_el8
#SBATCH --array=1-12
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=merlyne.lawrence@students.unibe.ch

# ---------------------------------
# SAMTOOLS (INDEX SORTED BAM FILES)
# ---------------------------------

# Load the correct version of samtools
module load SAMtools/1.13-GCC-10.3.0

# Full path to the TSV file
BAM_LIST="/data/users/mlawrence/rnaseq_course/reads/mapping/sorted_BAM_list.tsv"

# Check if the TSV file exists
if [[ ! -f "$BAM_LIST" ]]; then
    echo "Error: TSV file '$BAM_LIST' does not exist."
    exit 1
fi

# Extract information from the TSV file (adjust for header line)
sample_name=$(awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line+1{print $1; exit}' $BAM_LIST)
sorted_bam_path=$(awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line+1{print $2; exit}' $BAM_LIST)

# Validate that the extracted BAM file path exists
if [[ ! -f "$sorted_bam_path" ]]; then
    echo "Error: Sorted BAM file '$sorted_bam_path' for sample '$sample_name' does not exist."
    exit 1
fi

# Index the sorted BAM file
echo "Indexing sorted BAM file '${sorted_bam_path}' for sample '${sample_name}' at $(date)"
samtools index "$sorted_bam_path"

# Validate indexing success
if [[ $? -ne 0 ]]; then
    echo "Error: Indexing failed for sorted BAM file '${sorted_bam_path}' for sample '${sample_name}'."
    exit 1
else
    echo "Successfully indexed sorted BAM file '${sorted_bam_path}' for sample '${sample_name}' at $(date)"
fi

