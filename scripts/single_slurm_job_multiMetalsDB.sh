#!/bin/bash

#SBATCH --job-name="multiMetDB"
#SBATCH --mail-type=ALL
#SBATCH --mail-user=davide.corso@unina.it
#SBATCH --time=96:00:00
#SBATCH --cpus-per-task=5
#SBATCH --mem=15G
#SBATCH --output=/ibiscostorage/dcorso/flavia_migliaccio/metal_transporters/slurm_logs/single_job/slurm-%A.out
#SBATCH --partition=parallel

#
# Copyright 2023 Davide Corso
#



r1=$1
r2=$2 
sample_name=$3
exp=$4

mifaser_database="/ibiscostorage/dcorso/flavia_migliaccio/metal_transporters/data_for_mifaser_db/multiple_matches_ids"


echo "$exp  ----  $sample_name  ----  multiMetDB"

folder_output="/ibiscostorage/dcorso/flavia_migliaccio/metal_transporters/results_multiMetalDB/${exp}/${sample_name}/"
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
echo "$exp  ----  $sample_name  ----  multiMetDB"

