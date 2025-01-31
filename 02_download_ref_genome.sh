#!/bin/bash 
#SBATCH --job-name=ref_gene_download 
#SBATCH --ntasks=1 
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G 
#SBATCH --time=01:00:00 
#SBATCH --partition=pibu_el8
#SBATCH --mail-type=BEGIN,END,FAIL 
#SBATCH --mail-user=merlyne.lawrence@students.unibe.ch
#----------------------------------
# REFERENCE GENOME AND ANNOTATION
# ---------------------------------

# Download latest reference genome 
wget -P /data/users/mlawrence/rnaseq_course/reads/reference https://ftp.ensembl.org/pub/release-113/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz

# Download the associated annotation
wget -P /data/users/mlawrence/rnaseq_course/reads/reference https://ftp.ensembl.org/pub/release-113/gtf/homo_sapiens/Homo_sapiens.GRCh38.113.gtf.gz



