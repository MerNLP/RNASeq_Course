#!/bin/bash
#SBATCH --job-name=cleanup_sam_files
#SBATCH --output=/data/users/mlawrence/rnaseq_course/reads/mapping/hisat2_sam_files/cleanup_sam_files.out
#SBATCH --error=/data/users/mlawrence/rnaseq_course/reads/mapping/hisat2_sam_files/cleanup_sam_files.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --time=1:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=merlyne.lawrence@students.unibe.ch

# ---------------------
# CLEANUP SAM FILES
# ---------------------

# Path of the directory where the SAM files are stored
SAM_DIR="/data/users/mlawrence/rnaseq_course/reads/mapping/hisat2_sam_files"

# Check if there are SAM files to remove
if ls "$SAM_DIR"/*.sam 1> /dev/null 2>&1; then
    # Remove all SAM files in the directory
    echo "Removing SAM files from $SAM_DIR..."
    rm "$SAM_DIR"/*.sam

    # Check if removal was successful
    if [[ $? -eq 0 ]]; then
        echo "SAM files removed successfully."
    else
        echo "Error: Failed to remove SAM files from $SAM_DIR." >&2
        exit 1
    fi
else
    echo "No SAM files found in $SAM_DIR. Nothing to clean up."
    exit 0
fi

# Create a README file explaining the removal of SAM files
README_FILE="$SAM_DIR/README.md"
echo "Creating README file at $README_FILE..."
touch "$README_FILE"

# Add content to the README file
echo -e "Cleanup performed on: $(date)\n" > "$README_FILE"
echo -e "The following SAM files were removed after their conversion to BAM format:\n" >> "$README_FILE"
ls "$SAM_DIR"/*.sam 2>/dev/null || echo "No SAM files found (directory may have been empty)." >> "$README_FILE"
echo -e "\nThe BAM files can be found in:\n/data/users/mlawrence/rnaseq_course/reads/mapping/samtools_bam_files" >> "$README_FILE"

echo "Cleanup complete. README file created."

