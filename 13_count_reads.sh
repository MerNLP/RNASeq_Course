#!/bin/bash
#SBATCH --job-name=featureCounts
#SBATCH --output=/data/users/mlawrence/rnaseq_course/counts/subread_output/featureCounts.out
#SBATCH --error=/data/users/mlawrence/rnaseq_course/counts/subread_output/featureCounts.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=8G
#SBATCH --time=20:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=merlyne.lawrence@students.unibe.ch

#-------------------------------------
# FEATURECOUNTS (COUNT READS PER GENE)
# ------------------------------------

# Load required module
module load Subread/2.0.3-GCC-10.3.0

# Create output directories if they don't exist
mkdir -p /data/users/mlawrence/rnaseq_course/counts
mkdir -p /data/users/mlawrence/rnaseq_course/counts/subread_output

# Paths
SORTED_BAM="/data/users/mlawrence/rnaseq_course/reads/mapping/samtools_sorted_bam"
ANNOTATION_FILE="/data/users/mlawrence/rnaseq_course/reads/reference/Homo_sapiens.GRCh38.113.gtf.gz"
OUTPUT_DIR="/data/users/mlawrence/rnaseq_course/counts"

# Run FeatureCounts
featureCounts -p -t exon -g gene_id -a $ANNOTATION_FILE -o $OUTPUT_DIR/featurecounts.txt $SORTED_BAM/*.bam

