# Writing and Sharing Computational Analyses in Jupyter Notebooks

This repository demonstrates the ["Ten Simple Rules for Reproducible Research in Jupyter Notebook"](https://arxiv.org/abs/1810.08055) rules for a simple machine learning problem and is based on this ["ten-rules-jupyter"](https://github.com/jupyter-guide/ten-rules-jupyter) GitHub repository. It was developed for the [CIML Summer Institute 2021](https://github.com/ciml-org/ciml-summer-institute-2021).

The workflow is broken down into four independent steps, with a notebook for each step
* Create a dataset [1-CreateDataset.ipynb](notebooks/1-CreateDataset.ipynb) 
* Calculate features [2-CalculateFeatures.ipynb](notebooks/2-CalculateFeatures.ipynb) 
* Fit a model [3-FitModel.ipynb](notebooks/3-FitModel.ipynb) 
* Make a prediction [4-Predict.ipynb](notebooks/4-Predict.ipynb) 

## Run Jupyter Lab in the cloud using MyBinder

The [MyBinder.org](https://mybinder.org/) service let's you run the notebooks in this repository from your web browser by simply clicking on the launch link (the launch may take a couple of minutes). 

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/sdsc-hpc-training-org/notebooks-sharing/HEAD)

## Run Jupyter Lab on a local Machine (Laptop, Desktop)
------
Prerequisites: Miniconda3 (light-weight, preferred) or Anaconda3 and Mamba

* Install [Miniconda3](https://docs.conda.io/en/latest/miniconda.html)
* Install Mamba: ```conda install mamba -n base -c conda-forge```
------

1. Clone this git repository

```
git clone https://github.com/sdsc-hpc-training-org/notebooks-sharing.git
```
2. Create CONDA environment

```
mamba env create -f notebooks-sharing/environment.yml
```
3. Activate the CONDA environment

```
conda activate notebooks-sharing
```
4. Launch Jupyter Lab

```
jupyter lab
```

5. Deactivate the CONDA environment

```
conda deactivate
```

------

> To remove the CONDA environment, run ```conda env remove -n notebooks-sharing```
------

## Run Jupyter Lab on SDSC Expanse
To launch Jupyter Lab on [Expanse](https://www.sdsc.edu/services/hpc/expanse/), use the [galyleo](https://github.com/mkandes/galyleo#galyleo) script. 

1. Clone this git repository

```
git clone https://github.com/sdsc-hpc-training-org/notebooks-sharing.git
```

2. Specify your XSEDE account number with the --account option.

```
galyleo launch --account <account_number> --partition shared --cpus 8 --memory 16 --time-limit 00:30:00 --conda-env notebooks-sharing --conda-yml "${HOME}/notebooks-sharing/environment.yml"  --mamba
```

## Create a packed Conda Environment on SDSC Expanse
If a Conda environment will be used frequently, a Conda environment can be created once and packed. A packed Conda Environment can be moved, from example from a local scratch directory on a compute node to the home directory. A regular Conda Environment cannot be moved.

Create a packed Conda environment:
```
./notebooks-sharing/pack.sh --account <account_number> --conda-env notebooks-sharing --conda-yml "${HOME}/notebooks-sharing/environment.yml"
```

This command will generate the packed Conda environment ```notebooks-sharing.tar.gz```


## Run Jupyter Lab with a packed Conda Environment on SDSC Expanse

```
galyleo launch --account <account_number> --partition shared --cpus 8 --memory 16 --time-limit 00:30:00 --conda-env notebooks-sharing --conda-pack "${HOME}/notebooks-sharing.tar.gz"
```

