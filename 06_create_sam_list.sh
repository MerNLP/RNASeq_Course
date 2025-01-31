#!/bin/bash
#SBATCH --job-name=generate_SAM_tsv
#SBATCH --output=/data/users/mlawrence/rnaseq_course/reads/mapping/samtools_output/generate_tsv.out
#SBATCH --error=/data/users/mlawrence/rnaseq_course/reads/mapping/samtools_output/generate_tsv.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --time=4:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=merlyne.lawrence@students.unibe.ch

# -------------------------------
# CREATE TSV FILE WITH SAM FILES
# -------------------------------

# Paths
TSV_FILE="/data/users/mlawrence/rnaseq_course/reads/mapping/SAM_list.tsv"
DATA_DIR="/data/users/mlawrence/rnaseq_course/reads/mapping/hisat2_sam_files"

# Check if the output directory exists for the TSV file
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
echo -e "Sample_Name\tSAM_File_Path" > "$TSV_FILE"

# Loop through the data directory and write the TSV file
found_files=false
for file in "$DATA_DIR"/*.sam; do
    if [[ -f "$file" ]]; then
        found_files=true
        # Extract sample name from the filename
        sample_name=$(basename "$file" | cut -d '_' -f 1)

        # Append the sample name and SAM file path to the TSV file
        echo -e "$sample_name\t$file" >> "$TSV_FILE"
    fi
done

# Handle case where no SAM files are found
if ! $found_files; then
    echo "Warning: No SAM files found in $DATA_DIR."
    exit 1
fi

# Confirm completion
echo "TSV file generated successfully: $TSV_FILE"

