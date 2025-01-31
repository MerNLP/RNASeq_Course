#!/bin/bash
#SBATCH --job-name=generate_tsv
#SBATCH --output=/data/users/mlawrence/rnaseq_course/reads/generate_tsv.out
#SBATCH --error=/data/users/mlawrence/rnaseq_course/reads/generate_tsv.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --time=06:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mail-type=BEGIN,END,FAIL 
#SBATCH --mail-user=merlyne.lawrence@students.unibe.ch

# ---------------------
# SAMPLE LIST GENERATION
# ---------------------

# Specify the output TSV file
TSV_FILE="/data/users/mlawrence/rnaseq_course/reads/sample_list.tsv"
DATA_DIR="/data/users/mlawrence/rnaseq_course/reads"

# Write the header to the TSV file
echo -e "Sample_Name\tRead1_Path\tRead2_Path" > $TSV_FILE

# Loop through the data directory and write the TSV file
for file in $DATA_DIR/*_R1.fastq.gz; do
    # Extract the sample name from the filename
    sample_name=$(basename "$file" | cut -d '_' -f 1)

    # Paths for Read 1 and Read 2
    read1_path=$file
    read2_path=${file/_R1.fastq.gz/_R2.fastq.gz}

    # Ensure both Read 1 and Read 2 exist
    if [[ -f $read1_path && -f $read2_path ]]; then
        # Append the sample information to the TSV file
        echo -e "$sample_name\t$read1_path\t$read2_path" >> $TSV_FILE
    fi
done

