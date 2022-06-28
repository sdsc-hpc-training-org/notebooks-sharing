#!/bin/bash
# pack.sh creates a packed Conda environment from a Conda environment.yml file on Expanse
#
# Usage: pack.sh --account <account_number> --conda-env <name_of_conda_environment>  --conda-yml <path_to_environment.yml_file>"
# 
#
# Read in command-line options and assign input variables to local
# variables.
while (("${#}" > 0)); do
  case "${1}" in
    -A | --account )
      account="${2}"
      shift 2
      ;;
    --conda-env )
      conda_env="${2}"
      shift 2
      ;;
    --conda-yml )
      conda_yml="${2}"
      shift 2
      ;;
    *)
      echo "Command-line option ${1} not recognized or not supported."
      return 1
  esac
done

echo "pack --account ${account} --conda-env ${conda_env} --conda-yml ${conda_yml}"

# create sbatch script

sbatch <<EOT
#!/bin/bash

#SBATCH --job-name=pack
#SBATCH --account="${account}"
#SBATCH --reservation=ciml2022cpu
#SBATCH -p shared
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=8G
#SBATCH -t 00:30:00
#SBATCH -o pack.%j.%N.out
#SBATCH -e pack.%j.%N.err
#SBATCH --export=None

# setup shell environment for CPU jobs
module purge
module load cpu
module load slurm

# download miniconds3
if [ ! -f "Miniconda3-latest-Linux-x86_64.sh" ]; then
   wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
   chmod +x Miniconda3-latest-Linux-x86_64.sh
fi

# path to node-local scratch directory (environment variable can be accessed in notebook)
export LOCAL_SCRATCH_DIR="/scratch/\${USER}/job_\${SLURM_JOB_ID}"

# install miniconda3 on node-local disk
export CONDA_INSTALL_PATH="\${LOCAL_SCRATCH_DIR}/miniconda3"
export CONDA_ENVS_PATH="\${CONDA_INSTALL_PATH}/envs"
export CONDA_PKGS_DIRS="\${CONDA_INSTALL_PATH}/pkgs"
./Miniconda3-latest-Linux-x86_64.sh -b -p "\${CONDA_INSTALL_PATH}"
source "\${CONDA_INSTALL_PATH}/etc/profile.d/conda.sh"

# create conda environment using mamba
conda install mamba -n base -c conda-forge
conda install conda-pack -n base -c conda-forge
mamba env create -f "${conda_yml}"

conda activate "${conda_env}"

# create packed conda environment
conda pack --force

exit 0
EOT
