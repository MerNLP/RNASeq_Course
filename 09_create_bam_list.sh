#!/bin/bash
#SBATCH --job-name=generate_BAM_tsv
#SBATCH --output=/data/users/mlawrence/rnaseq_course/reads/mapping/samtools_output/generate_BAM_tsv.out
#SBATCH --error=/data/users/mlawrence/rnaseq_course/reads/mapping/samtools_output/generate_BAM_tsv.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --time=2:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=merlyne.lawrence@students.unibe.ch

# --------------------------------
# CREATE TSV FILE WITH BAM FILES
# --------------------------------

# Specify the output TSV file and data directory
TSV_FILE="/data/users/mlawrence/rnaseq_course/reads/mapping/BAM_list.tsv"
DATA_DIR="/data/users/mlawrence/rnaseq_course/reads/mapping/samtools_bam_files"

# Ensure the output directory exists
output_dir=$(dirname "$TSV_FILE")
if [ ! -d "$output_dir" ]; then
    echo "Creating output directory: $output_dir"
    mkdir -p "$output_dir"
fi

# Check if TSV file already exists
if [ -e "$TSV_FILE" ]; then
    echo "Error: TSV file '$TSV_FILE' already exists. Please remove or rename it."
    exit 1
fi

# Write the header to the TSV file
echo -e "Sample_Name\tBAM_File_Path" > "$TSV_FILE"

# Ensure the data directory exists
if [ ! -d "$DATA_DIR" ]; then
    echo "Error: Data directory '$DATA_DIR' does not exist."
    exit 1
fi

# Loop through the data directory and write the TSV file
bam_count=0
for file in "$DATA_DIR"/*.bam; do
    if [[ -f "$file" ]]; then
        # Extract sample name from the filename
        sample_name=$(basename "$file" | cut -d '_' -f 1)

        # Append the sample name and BAM file path to the TSV file
        echo -e "$sample_name\t$file" >> "$TSV_FILE"
        bam_count=$((bam_count + 1))
    fi
done

# Check if any BAM files were found
if [[ $bam_count -eq 0 ]]; then
    echo "Warning: No BAM files found in $DATA_DIR."
else
    echo "Successfully generated TSV file with $bam_count BAM files: $TSV_FILE"
fi

