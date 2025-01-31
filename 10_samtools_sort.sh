#!/bin/bash

#SBATCH --job-name=sort_bam
#SBATCH --output=/data/users/mlawrence/rnaseq_course/reads/mapping/samtools_output/sort_bam_%A_%a.out
#SBATCH --error=/data/users/mlawrence/rnaseq_course/reads/mapping/samtools_output/sort_bam_%A_%a.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=60G
#SBATCH --time=24:00:00
#SBATCH --partition=pibu_el8
#SBATCH --array=1-12
#SBATCH --mail-type=BEGIN,END,FAIL 
#SBATCH --mail-user=merlyne.lawrence@students.unibe.ch

# ----------------------------------
# SAMTOOLS (SORT BAM BY COORDINATES)
# ----------------------------------

# Load the samtools module
module load SAMtools/1.13-GCC-10.3.0

# Path to the TSV file
BAM_LIST="/data/users/mlawrence/rnaseq_course/reads/mapping/BAM_list.tsv"

# Validate that the TSV file exists
if [[ ! -f "$BAM_LIST" ]]; then
    echo "Error: BAM list file $BAM_LIST does not exist."
    exit 1
fi

# Extract sample information from the TSV file using awk
IFS=$'\t' read -r sample_name bam_path < <(awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line+1' "$BAM_LIST")

# Validate that sample name and BAM path are not empty
if [[ -z "$sample_name" || -z "$bam_path" ]]; then
    echo "Error: Could not extract sample information from line $SLURM_ARRAY_TASK_ID in $BAM_LIST."
    exit 1
fi

# Validate that the BAM file exists
if [[ ! -f "$bam_path" ]]; then
    echo "Error: BAM file $bam_path for sample $sample_name does not exist."
    exit 1
fi

# Define output path for the sorted BAM file
OUTPUT_DIR="/data/users/mlawrence/rnaseq_course/reads/mapping/samtools_sorted_bam"
mkdir -p "$OUTPUT_DIR"
OUTPUT_SORTED_BAM="${OUTPUT_DIR}/${sample_name}_sorted.bam"

# Define the path of the directory where temporary files will be stored during sorting
TEMP_DIR="/data/users/mlawrence/rnaseq_course/reads/mapping/temp_sorting"
mkdir -p "$TEMP_DIR"

# Sort the BAM file by genomic coordinates
echo "Sorting BAM file ${sample_name} at $(date)"
samtools sort -@ 8 -o "$OUTPUT_SORTED_BAM" -T "$TEMP_DIR/${sample_name}_temp" "$bam_path"

# Validate success of the sorting process
if [[ $? -ne 0 ]]; then
    echo "Error: Sorting failed for $sample_name."
    exit 1
else
    echo "Finished sorting BAM file ${sample_name} successfully at $(date)"
    echo "Output sorted BAM file: $OUTPUT_SORTED_BAM"
fi

