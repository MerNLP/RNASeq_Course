#!/bin/bash
#SBATCH --job-name=sam_to_bam
#SBATCH --output=/data/users/mlawrence/rnaseq_course/reads/mapping/samtools_output/sam_to_bam_%A_%a.out
#SBATCH --error=/data/users/mlawrence/rnaseq_course/reads/mapping/samtools_output/sam_to_bam_%A_%a.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=2:00:00
#SBATCH --partition=pibu_el8
#SBATCH --array=1-12
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=merlyne.lawrence@students.unibe.ch

# ----------------------------------
# SAMTOOLS (CONVERT SAM TO BAM)
# ----------------------------------

# Load the samtools module
module load SAMtools/1.13-GCC-10.3.0

# Paths
SAM_LIST="/data/users/mlawrence/rnaseq_course/reads/mapping/SAM_list.tsv"
OUTPUT_DIR="/data/users/mlawrence/rnaseq_course/reads/mapping/samtools_bam_files"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Extract sample information from the TSV file, skipping the header row
IFS=$'\t' read -r sample_name sam_path < <(awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line+1' "$SAM_LIST")

# Validate that sample name and SAM path are not empty
if [[ -z "$sample_name" || -z "$sam_path" ]]; then
    echo "Error: Could not extract sample information from line $SLURM_ARRAY_TASK_ID in $SAM_LIST."
    exit 1
fi

# Validate that the SAM file exists
if [[ ! -f "$sam_path" ]]; then
    echo "Error: SAM file $sam_path for sample $sample_name does not exist."
    exit 1
fi

# Define the output BAM file path
OUTPUT_BAM="${OUTPUT_DIR}/${sample_name}_mapped.bam"

# Convert SAM to BAM
echo "Starting SAM to BAM conversion for $sample_name at $(date)"
samtools view -hbS "$sam_path" > "$OUTPUT_BAM"

# Validate samtools success
if [[ $? -ne 0 ]]; then
    echo "Error: SAM to BAM conversion failed for $sample_name."
    exit 1
else
    echo "Finished SAM to BAM conversion for $sample_name at $(date)"
    echo "Output BAM file: $OUTPUT_BAM"
fi

