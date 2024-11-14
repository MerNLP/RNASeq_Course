#!/bin/bash 
#SBATCH --job-name=fastqc 
#SBATCH --output=/data/users/mlawrence/rnaseq_course/reads/fastqc_output/fastqc.out 
#SBATCH --error=/data/users/mlawrence/rnaseq_course/reads/fastqc_output/fastqc.err 
#SBATCH --ntasks=1 
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G 
#SBATCH --time=10:00:00 
#SBATCH --partition=pibu_el8

#--------- 
# FASTQC 
# -------- 

# Load the module 
module load FastQC/0.11.9-Java-11

# Specify the directory containing read samples 
INPUT_DIR="/data/users/mlawrence/rnaseq_course/reads" 
OUTPUT_DIR="/data/users/mlawrence/rnaseq_course/reads/fastqc_results" 

for file in $INPUT_DIR/*.fastq.gz; do
  fastqc -o $OUTPUT_DIR $file 
done

