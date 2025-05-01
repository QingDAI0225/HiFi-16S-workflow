#!/usr/bin/env bash
# DESCRIPTION: Wrapper script for running HiFi 16S workflow

#-----------------------------------------------------------
# Run the following to run this script:
#   sbatch -A chsi -p chsi -c8 --mem 20G HiFi_16S_hpc_script.sh
#-----------------------------------------------------------

# Pre-set default settings
# SCRIPT_DIR="$(dirname "$(realpath "$0")")" # capture the path of this script
set -eo pipefail
set -u

#-----------------------------------------------------------
NUM_THREADS=36
NUM_MEM="240 GB"
export NFX_TEMP="/scratch"
WORKDIR="/cwork/qd33/pipeline_result/hifi_16s/hifi_16s_692"
SAMPLE_FILE="${WORKDIR}/data_table/10837_692.tsv"
METADATA_FILE="${WORKDIR}/data_table/10837_692_metadata.tsv"
CONDA_DIR="${WORKDIR}/conda"
OUTDIR="${WORKDIR}/result"

#-----------------------------------------------------------
# FASTQ_DIR=$(dirname $FASTQ_FILE)
# mkdir -p ${DB_DIR}
#-----------------------------------------------------------
# mamba activate nextflow
cd $WORKDIR
module load Java/11.0.8
mkdir -p ${CONDA_DIR}
# mkdir -p $WORKDIR; cd $WORKDIR

mamba env create -p ${CONDA_DIR}/pb-16s-pbtools -y --file ${WORKDIR}/env/pb-16s-pbtools.yml
mamba env create -p ${CONDA_DIR}/pb-16s-vis -y --file ${WORKDIR}/env/pb-16s-vis-conda.yml
mamba env create -p ${CONDA_DIR}/qiime2-amplicon-2024.10-py310-ubuntu-conda -y --file ${WORKDIR}/env/qiime2-amplicon-2024.10-py310-ubuntu-conda.yml

nextflow run main.nf -profile conda -c ${WORKDIR}/nextflow.config \
    -process.queue "chsi" \
    -process.cpus $NUM_THREADS \
    -process.memory $NUM_MEM \
    -process.clusterOptions "-A chsi" \
    --input ${SAMPLE_FILE} \
    --metadata ${METADATA_FILE} \
    --outdir ${OUTDIR} \
    --cutadapt_cpu ${NUM_THREADS} \
    --dada2_cpu ${NUM_THREADS} \
    --vsearch_cpu ${NUM_THREADS} \
    -resume


# sing=$sing  
exit 0
