#!/bin/bash
#SBATCH --job-name=generate_sorted_BAM_tsv
#SBATCH --output=/data/users/mlawrence/rnaseq_course/reads/mapping/samtools_output/generate_sorted_BAM_tsv.out
#SBATCH --error=/data/users/mlawrence/rnaseq_course/reads/mapping/samtools_output/generate_sorted_BAM_tsv.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --time=2:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=merlyne.lawrence@students.unibe.ch

#---------------------------------------
# CREATE TSV FILE WITH SORTED BAM FILES
# --------------------------------------

# Specify the output TSV file
TSV_FILE="/data/users/mlawrence/rnaseq_course/reads/mapping/sorted_BAM_list.tsv"
DATA_DIR="/data/users/mlawrence/rnaseq_course/reads/mapping/samtools_sorted_bam"

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
echo -e "Sample_Name\tSorted_BAM_File_Path" > "$TSV_FILE"

# Loop through the data directory and write the TSV file
for file in "$DATA_DIR"/*.bam; do
    # Extract sample name from the filename
    sample_name=$(basename "$file" | cut -d '_' -f 1)

    # Append the sample name and sorted BAM file path to the TSV file
    echo -e "$sample_name\t$file" >> "$TSV_FILE"
done

# Confirm completion
echo "Successfully generated TSV file with sorted BAM files: $TSV_FILE"

