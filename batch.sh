#!/bin/bash
# Batch script to run Jupyter Lab on Expanse CPU node.
#SBATCH --job-name=notebooks-sharing-batch
#SBATCH --account=sds184
#SBATCH --reservation=ciml2022cpu
#SBATCH --partition=shared
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=8G
#SBATCH -t 00:15:00
#SBATCH -o notebooks-sharing.%j.%N.out
#SBATCH -e notebooks-sharing.%j.%N.err
#SBATCH --export=ALL

# setup shell environment for CPU jobs
module purge
module load cpu 
module load slurm

# name of Conda environment
CONDA_ENV=notebooks-sharing
# path to Git repository
REPO_DIR="${HOME}/notebooks-sharing"
# path to environment.yml file
CONDA_YML="${REPO_DIR}/environment.yml"
# path to notebooks directory
NOTEBOOK_DIR="${REPO_DIR}/notebooks"
# path to a directory to store the executed notebooks
RESULT_DIR="${REPO_DIR}/results"

# path to node-local scratch directory (environment variable can be accessed in notebook)
export LOCAL_SCRATCH_DIR="/scratch/${USER}/job_${SLURM_JOB_ID}"

# download miniconds3
if [ ! -f "Miniconda3-latest-Linux-x86_64.sh" ]; then
   wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
   chmod +x Miniconda3-latest-Linux-x86_64.sh
fi

# install miniconda3 on node-local disk
export CONDA_INSTALL_PATH="${LOCAL_SCRATCH_DIR}/miniconda3"
export CONDA_ENVS_PATH="${CONDA_INSTALL_PATH}/envs"
export CONDA_PKGS_DIRS="${CONDA_INSTALL_PATH}/pkgs"
./Miniconda3-latest-Linux-x86_64.sh -b -p "${CONDA_INSTALL_PATH}"
source "${CONDA_INSTALL_PATH}/etc/profile.d/conda.sh"

# use mamba (faster than conda) to create conda environment
conda install mamba -n base -c conda-forge
mamba env create -f "${CONDA_YML}"
conda activate "${CONDA_ENV}"

# run notebooks using papermill
conda install -c conda-forge papermill

cd "${NOTEBOOK_DIR}"
mkdir -p "${RESULT_DIR}"

papermill 1-CreateDataset.ipynb "${RESULT_DIR}"/1-CreateDataset.ipynb
papermill 2-CalculateFeatures.ipynb "${RESULT_DIR}"/2-CalculateFeatures.ipynb

# fit an SVM model
papermill 3-FitModel.ipynb "${RESULT_DIR}"/3-FitModel-SVM.ipynb -p ml_method "SVM"
papermill 4-Predict.ipynb "${RESULT_DIR}"/4-Predict-SVM.ipynb

# fit a LogisticRegression model
papermill 3-FitModel.ipynb "${RESULT_DIR}"/3-FitModel-LogisticRegression.ipynb -p ml_method "LogisticRegression"
papermill 4-Predict.ipynb "${RESULT_DIR}"/4-Predict-LogisticRegression.ipynb
