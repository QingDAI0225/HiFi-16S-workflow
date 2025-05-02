#!/usr/bin/env bash
# DESCRIPTION: Wrapper script for running database download and conda environment settings for HiFi 16S workflow

#-----------------------------------------------------------
# Run the following to run this script:
#   sbatch -A chsi -p chsi -c8 --mem 20G database_conda_env_download.sh
#-----------------------------------------------------------

# Pre-set default settings
# SCRIPT_DIR="$(dirname "$(realpath "$0")")" # capture the path of this script
set -eo pipefail
set -u

#-----------------------------------------------------------
export NFX_TEMP="/scratch"
WORKDIR="/work/qd33/pipeline_result/HiFi-16S-workflow"
#-----------------------------------------------------------
# mamba activate nextflow
cd $WORKDIR
module load Java/11.0.8
mkdir -p ${WORKDIR}/conda
# conda shell.bash activate snakemake
# mkdir -p $WORKDIR; cd $WORKDIR

mamba env create -p ${WORKDIR}/conda/pb-16s-pbtools -y --file ${WORKDIR}/env/pb-16s-pbtools.yml
mamba env create -p ${WORKDIR}/conda/pb-16s-vis -y --file ${WORKDIR}/env/pb-16s-vis-conda.yml
mamba env create -p ${WORKDIR}/conda/qiime2-amplicon-2024.10-py310-ubuntu-conda -y --file ${WORKDIR}/env/qiime2-amplicon-2024.10-py310-ubuntu-conda.yml

nextflow run main.nf --download_db

exit 0
