#!/usr/bin/env bash
#SBATCH --job-name=indexing_hisat2
#SBATCH --output=/data/users/mlawrence/rnaseq_course/reads/mapping/hisat2_output/indexing_hisat2.out
#SBATCH --error=/data/users/mlawrence/rnaseq_course/reads/mapping/hisat2_output/indexing_hisat2.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=14:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mail-type=BEGIN,END,FAIL 
#SBATCH --mail-user=merlyne.lawrence@students.unibe.ch

# ---------------------
# HISAT2 INDEXING STEP
# ---------------------

# Load the Biopython module for Python support
module load Biopython/1.79-foss-2021a

module load HISAT2/2.2.1-gompi-2021a

# Define paths
GENOME_FILE="/data/users/mlawrence/rnaseq_course/reads/reference/Homo_sapiens.GRCh38.dna.primary_assembly.fa"
INDEX_BASENAME="/data/users/mlawrence/rnaseq_course/reads/mapping/hisat2_human_genome_index"

# Create output directory if it doesn't exist
mkdir -p /data/users/mlawrence/rnaseq_course/reads/mapping/hisat2_output
# Run HISAT2 indexing
hisat2-build -p 16 $GENOME_FILE $INDEX_BASENAME


