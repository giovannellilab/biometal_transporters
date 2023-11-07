#!/bin/bash

#SBATCH --job-name="cr17_protFamDB"
#SBATCH --mail-type=ALL
#SBATCH --mail-user=davide.corso@unina.it
#SBATCH --time=96:00:00
#SBATCH --cpus-per-task=5
#SBATCH --mem=15G
#SBATCH --array=1-37
#SBATCH --output=/ibiscostorage/dcorso/flavia_migliaccio/metal_transporters/slurm_logs/results_proteinFamDB/slurm-%A_%a.out
#SBATCH --partition=parallel

#
# Copyright 2023 Davide Corso
#


# CAMBIARE
# --array
# --output



exp="cr17"

sample_pair="$(tail -n +$SLURM_ARRAY_TASK_ID ${exp}_samples.txt | head -n1)"

mifaser_database="/ibiscostorage/dcorso/flavia_migliaccio/metal_transporters/data_for_mifaser_db/proteinFam_as_groups"

IFS=' ' read r1 r2 sample_name <<< $sample_pair

echo "$exp  ----  $sample_name"

folder_output="/ibiscostorage/dcorso/flavia_migliaccio/metal_transporters/results_proteinFamDB/${exp}/${sample_name}/"
folder_reads="/ibiscostorage/dcorso/flavia_migliaccio/metal_transporters/reads_after_fastp/${exp}"

read_r1="${folder_reads}/${r1}"
read_r2="${folder_reads}/${r2}"

mkdir -p "${folder_output}"

singularity exec --bind ${mifaser_database}:${mifaser_database} mifaser_custom.simg mifaser \
  -d $mifaser_database \
  -l ${read_r1} ${read_r2} \
  -i /repos/mifaser/mifaser/diamond/linux \
  -t $SLURM_CPUS_PER_TASK \
  -o $folder_output

echo "$?"
echo "$exp  ----  $sample_name"

