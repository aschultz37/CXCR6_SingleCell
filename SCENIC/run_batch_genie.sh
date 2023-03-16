#!/bin/sh
#SBATCH -p cpu_medium
#SBATCH -J wt_cxcr6_genie
#SBATCH -o /gpfs/home/acs9950/singlecell/2020-12-16/SCENIC/logs/wt_%x.o
#SBATCH -e /gpfs/home/acs9950/singlecell/2020-12-16/SCENIC/logs/wt_%x.e
#SBATCH -t 5-00:00:00
#SBATCH --nodes=1
#SBATCH --tasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=20G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=austin.schultz@nyulangone.org

module purge
module load miniconda3/cpu/4.9.2
conda activate scenic

cd /gpfs/home/acs9950/singlecell/2020-12-16/SCENIC/

Rscript WT_SCENIC_script_pt1.r
