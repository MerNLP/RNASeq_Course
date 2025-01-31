#!/bin/bash
#SBATCH --job-name=hisat2_mapping
#SBATCH --output=/data/users/mlawrence/rnaseq_course/reads/mapping/hisat2_output/mapping_hisat2_%A_%a.out
#SBATCH --error=/data/users/mlawrence/rnaseq_course/reads/mapping/hisat2_output/mapping_hisat2_%A_%a.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=24:00:00
#SBATCH --partition=pibu_el8
#SBATCH --array=1-12
#SBATCH --mail-type=BEGIN,END,FAIL 
#SBATCH --mail-user=merlyne.lawrence@students.unibe.ch

# ---------------------
# HISAT2 MAPPING STEP
# ---------------------

# Load required modules
module load Biopython/1.79-foss-2021a
module load HISAT2/2.2.1-gompi-2021a

# Paths to required files and directories
SAMPLE_LIST="/data/users/mlawrence/rnaseq_course/reads/sample_list.tsv"
HISAT2_INDEX="/data/users/mlawrence/rnaseq_course/reads/reference/hisat2_index/hisat2_human_genome_index"
OUTPUT_DIR="/data/users/mlawrence/rnaseq_course/reads/mapping/hisat2_sam_files"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Extract sample information for the current task ID
IFS=$'\t' read -r sample_name read1_path read2_path < <(awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line+1' "$SAMPLE_LIST")

# Debugging output
debug_file="${OUTPUT_DIR}/debug_${SLURM_ARRAY_TASK_ID}.out"
{
    echo "Task ID: $SLURM_ARRAY_TASK_ID"
    echo "Sample Name: $sample_name"
    echo "Read 1 Path: $read1_path"
    echo "Read 2 Path: $read2_path"
} > "$debug_file"

# Validate read file paths
if [[ ! -f "$read1_path" || ! -f "$read2_path" ]]; then
    echo "Error: One or both read files do not exist for sample $sample_name." >> "$debug_file"
    exit 1
fi

# Define the output SAM file
output_sam="${OUTPUT_DIR}/${sample_name}_mapped.sam"

# Run HISAT2
echo "Starting HISAT2 mapping for sample: $sample_name at $(date)" >> "$debug_file"
hisat2 -x "$HISAT2_INDEX" -1 "$read1_path" -2 "$read2_path" -S "$output_sam" -p 4 >> "$debug_file" 2>&1

# Check HISAT2 exit status
if [[ $? -ne 0 ]]; then
    echo "Error: HISAT2 mapping failed for sample $sample_name." >> "$debug_file"
    exit 1
else
    echo "Completed HISAT2 mapping for sample: $sample_name at $(date)" >> "$debug_file"
fi

